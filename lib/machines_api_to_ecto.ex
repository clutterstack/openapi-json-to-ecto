defmodule MachinesApiToEcto do

  def convert(input_file, output_dir) do
    File.mkdir_p(output_dir)
    spec = input_file |> File.read!() |> Jason.decode!()

    all_schemas = get_in(spec, ["components", "schemas"])

    all_schemas
    |> Enum.each(fn {name, schema} ->
      content = create_schema(sanitize_name(name), schema, all_schemas)
      file_path = Path.join(output_dir, "#{Macro.underscore(sanitize_name(name))}.ex")
      File.write!(file_path, content)
    end)
  end

  defp create_schema(name, schema, all_schemas) do
    fields = get_fields(schema, all_schemas)
    changeset = get_changeset(schema, all_schemas)

    """
    defmodule FlyApi.#{name} do
      use Ecto.Schema
      import Ecto.Changeset

      @primary_key false
      embedded_schema do
        #{fields}
      end

      def changeset(schema, attrs) do
        schema
            |> cast(attrs, [#{get_field_atoms(schema, all_schemas)}])
        #{changeset}
      end
    end
    """
  end

  # The OpenAPI spec seems to have four main ways to insert refs to other schemas:
  # - simply transclude the keys and values inside a field
  # - inside an additionalProperties field (so you could have several properties of this type in that object)
  # - inside allOf (add all the keys and values of that schema to this schema)
  # - as the value of "type" for a field (so you could again have several instances)
  # All the refs need either embeds_many or embeds_one in the schema; everything else can be a field

  defp get_fields(schema, all_schemas) do
    properties = get_properties(schema, all_schemas)
    properties
    |> Enum.map(fn {name, prop} ->
      type = get_type(prop, all_schemas) # |> IO.inspect(label: "Name is #{name}. is the type a normal type or a schema??")
      cond do
        is_additional_properties_ref?(prop) ->
          value_type = get_type(prop["additionalProperties"], all_schemas)
          "embeds_many :#{sanitize_field_name(name)}, #{value_type}"
        is_ref?(prop) ->
          "embeds_one :#{sanitize_field_name(name)}, #{type}"
        is_array_of_refs?(prop) ->
          ref_type = get_module_name(prop["items"]["$ref"])
          "embeds_many :#{sanitize_field_name(name)}, #{ref_type}"
        true ->
          "field :#{sanitize_field_name(name)}, #{type}"
      end
    end)
    |> Enum.join("\n    ")
  end

  defp is_additional_properties_ref?(prop) do
    prop["type"] == "object" &&
    Map.has_key?(prop, "additionalProperties") &&
    is_ref?(prop["additionalProperties"])
  end

  defp is_ref?(prop) do
    Map.has_key?(prop, "$ref") || (Map.has_key?(prop, "allOf") && hd(prop["allOf"]) |> Map.has_key?("$ref"))
  end

  defp is_array_of_refs?(%{"type" => "array", "items" => %{"$ref" => _}}), do: true
  defp is_array_of_refs?(_), do: false

  defp get_properties(%{"allOf" => [%{"$ref" => ref}]}, all_schemas) do
    get_ref_schema(ref, all_schemas)
    |> get_properties(all_schemas)
  end
  defp get_properties(schema, all_schemas) do
    case schema do
      %{"properties" => props} -> props
      %{"allOf" => schemas} ->
        schemas
        |> Enum.flat_map(fn s ->
          case s do
            %{"$ref" => ref} -> get_properties(get_ref_schema(ref, all_schemas), all_schemas)
            %{"properties" => props} -> Map.to_list(props)
            _ -> []
          end
        end)
        |> Map.new()
      _ -> %{}
    end
  end

  defp get_type(%{"allOf" => [%{"$ref" => ref}]}, _all_schemas) do
    "#{get_module_name(ref)}"
  end

  defp get_type(%{"$ref" => ref}, all_schemas) do
    case get_ref_schema(ref, all_schemas) do
      nil -> ":no_schema_found"  # or another appropriate default
      _ -> "#{get_module_name(ref)}"
    end
  end

  defp get_type(prop, all_schemas) do
    cond do
      Map.has_key?(prop, "$ref") ->
        ref = prop["$ref"]
        module_name = get_module_name(ref)
        "#{module_name}"
      Map.has_key?(prop, "type") ->
        case prop["type"] do
          "object" ->
            cond do
              Map.has_key?(prop, "additionalProperties") ->
                additional_prop_type = get_type(prop["additionalProperties"], all_schemas)
                "{:map, #{additional_prop_type}}"
              Map.has_key?(prop, "properties") ->
                ":map"
              true ->
                ":map"
            end
          "string" -> ":string"
          "integer" -> ":integer"
          "number" -> ":float"
          "boolean" -> ":boolean"
          "array" -> "{:array, #{get_type(prop["items"], all_schemas)}}"
          _ -> ":string" # if type is unknown
        end
      true -> ":map" # if there's no such key. Could change this to string I suppose, or error?
    end
  end

  defp get_field_atoms(schema, all_schemas) do
    get_properties(schema, all_schemas)
    |> Enum.reject(fn {_name, prop} -> is_embed?(prop) end)
    |> Enum.map(fn {name, _} -> ":#{sanitize_field_name(name)}" end)
    |> Enum.join(", ")
  end

  defp is_embed?(prop) do
    cond do
      Map.has_key?(prop, "$ref") -> true
      Map.has_key?(prop, "allOf") -> true
      is_array_of_refs?(prop) -> true
      Map.has_key?(prop, "type") && prop["type"] == "object" -> true
      true -> false
    end
  end

  defp get_changeset(schema, all_schemas) do
    validations = [
      get_required_validation(schema, all_schemas),
      get_nested_validations(schema, all_schemas)
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n    ")

    if validations == "", do: "", else: "    #{validations}"
  end

  ## Not sure if this function is solid since at the time of writing there's only
  ## one schema that bothers with a `"required"` field to indicate which properties
  ## are compulsory (`fly.Static`)
  defp get_required_validation(schema, all_schemas) do
    required =
      case schema do
        %{"required" => req} -> req
        %{"allOf" => schemas} ->
          schemas
          |> Enum.flat_map(fn s ->
            case s do
              %{"$ref" => ref} ->
                IO.inspect(ref, label: "a ref in allOf")
                get_required_validation(get_ref_schema(ref, all_schemas), all_schemas)
              %{"required" => req} -> req
              _ -> []
            end
          end)
        _ -> []
      end

    if Enum.empty?(required) do
      nil
    else
      fields = required |> Enum.map(&":#{sanitize_field_name(&1)}") |> Enum.join(", ")
      "|> validate_required([#{fields}])"
    end
  end

  defp get_nested_validations(schema, all_schemas) do
    get_properties(schema, all_schemas)
    |> Enum.map(fn {name, prop} -> get_nested_validation(name, prop, all_schemas) end)
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n    ")
  end

  defp get_nested_validation(name, %{"allOf" => [%{"$ref" => ref}]}, _all_schemas) do
    module_name = get_module_name(ref)
    "|> cast_embed(:#{sanitize_field_name(name)}, with: &#{module_name}.changeset/2)"
  end
  defp get_nested_validation(name, %{"$ref" => ref}, _all_schemas) do
    module_name = get_module_name(ref)
    "|> cast_embed(:#{sanitize_field_name(name)}, with: &#{module_name}.changeset/2)"
  end
  defp get_nested_validation(name, %{"type" => "array", "items" => %{"$ref" => ref}}, _all_schemas) do
    module_name = get_module_name(ref)
    "|> cast_embed(:#{sanitize_field_name(name)}, with: &#{module_name}.changeset/2)"
  end
  defp get_nested_validation(name, %{"type" => "object", "$ref" => ref}, _all_schemas) do
    module_name = get_module_name(ref)
    "|> cast_embed(:#{sanitize_field_name(name)}, with: &#{module_name}.changeset/2)"
  end
  defp get_nested_validation(_, _, _), do: nil

  # defp get_ref_schema(ref, all_schemas) do
  #   name = ref |> String.replace("#/components/schemas/", "")
  #   Map.get(all_schemas, name, %{})
  # end

## Claude suggested this then adapting all other functions
## (like get_type) to
## handle the case where the reference doesn't exist?
## Not sure.
  defp get_ref_schema(ref, all_schemas) do
    name = ref |> String.replace("#/components/schemas/", "")
    Map.get(all_schemas, name)
  end

  defp get_module_name(ref) when is_binary(ref) do
    ref
    |> String.replace("#/components/schemas/", "")
    |> sanitize_name()
    |> (fn name -> "FlyApi.#{name}" end).()
  end
  defp get_module_name(_), do: "UnknownSchema"

  defp sanitize_name(name) do
    name
    |> String.split(".")
    |> Enum.map(&Macro.camelize/1)
    |> Enum.join("")
  end

  defp sanitize_field_name(name) do
    name
    |> String.split(".")
    |> Enum.map(&Macro.underscore/1)
    |> Enum.join("_")
  end

end
