defmodule FlyApi.FlyTLSOptions do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :alpn, {:array, :string}
    field :default_self_signed, :boolean
    field :versions, {:array, :string}
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:alpn, :default_self_signed, :versions])
    
  end
end
