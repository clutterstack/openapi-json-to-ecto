defmodule FlyApi.ImageRef do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :digest, :string
    field :labels, {:map, :string}
    field :registry, :string
    field :repository, :string
    field :tag, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:digest, :registry, :repository, :tag])
    
  end
end
