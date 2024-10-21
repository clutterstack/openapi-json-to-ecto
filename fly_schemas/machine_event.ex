defmodule FlyApi.MachineEvent do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :id, :string
    field :request, :map
    field :source, :string
    field :status, :string
    field :timestamp, :integer
    field :type, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:id, :source, :status, :timestamp, :type])
    
  end
end
