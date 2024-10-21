defmodule FlyApi.FlyMachineHTTPHeader do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :values, {:array, :string}
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:name, :values])
    
  end
end
