defmodule FlyApi.FlyDnsOption do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :value, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:name, :value])
    
  end
end
