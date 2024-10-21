defmodule FlyApi.CreateSecretRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :value, {:array, :integer}
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:value])
    
  end
end
