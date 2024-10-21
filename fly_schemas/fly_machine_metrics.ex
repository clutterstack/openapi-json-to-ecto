defmodule FlyApi.FlyMachineMetrics do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :path, :string
    field :port, :integer
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:path, :port])
    
  end
end
