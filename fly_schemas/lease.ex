defmodule FlyApi.Lease do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :description, :string
    field :expires_at, :integer
    field :nonce, :string
    field :owner, :string
    field :version, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:description, :expires_at, :nonce, :owner, :version])
    
  end
end
