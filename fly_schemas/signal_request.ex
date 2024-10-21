defmodule FlyApi.SignalRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :signal, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:signal])
    
  end
end
