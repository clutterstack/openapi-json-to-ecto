defmodule FlyApi.FlyDnsForwardRule do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :addr, :string
    field :basename, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:addr, :basename])
    
  end
end
