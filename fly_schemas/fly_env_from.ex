defmodule FlyApi.FlyEnvFrom do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :env_var, :string
    field :field_ref, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:env_var, :field_ref])
    
  end
end
