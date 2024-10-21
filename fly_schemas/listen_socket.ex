defmodule FlyApi.ListenSocket do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :address, :string
    field :proto, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:address, :proto])
    
  end
end
