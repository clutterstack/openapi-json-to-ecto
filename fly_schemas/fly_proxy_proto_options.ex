defmodule FlyApi.FlyProxyProtoOptions do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :version, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:version])
    
  end
end
