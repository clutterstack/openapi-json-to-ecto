defmodule FlyApi.CheckStatus do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :output, :string
    field :status, :string
    field :updated_at, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:name, :output, :status, :updated_at])
    
  end
end
