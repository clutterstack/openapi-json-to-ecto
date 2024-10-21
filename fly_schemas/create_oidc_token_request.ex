defmodule FlyApi.CreateOIDCTokenRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :aud, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:aud])
    
  end
end
