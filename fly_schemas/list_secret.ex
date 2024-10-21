defmodule FlyApi.ListSecret do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :label, :string
    field :publickey, {:array, :integer}
    field :type, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:label, :publickey, :type])
    
  end
end
