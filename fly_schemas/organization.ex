defmodule FlyApi.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :slug, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:name, :slug])
    
  end
end
