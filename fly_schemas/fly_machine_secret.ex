defmodule FlyApi.FlyMachineSecret do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :env_var, :string
    field :name, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:env_var, :name])
    
  end
end
