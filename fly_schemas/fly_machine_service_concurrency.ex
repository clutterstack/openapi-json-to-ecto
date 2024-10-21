defmodule FlyApi.FlyMachineServiceConcurrency do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :hard_limit, :integer
    field :soft_limit, :integer
    field :type, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:hard_limit, :soft_limit, :type])
    
  end
end
