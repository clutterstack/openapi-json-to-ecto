defmodule FlyApi.CreateLeaseRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :description, :string
    field :ttl, :integer
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:description, :ttl])
    
  end
end
