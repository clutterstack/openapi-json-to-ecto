defmodule FlyApi.VolumeSnapshot do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :created_at, :string
    field :digest, :string
    field :id, :string
    field :retention_days, :integer
    field :size, :integer
    field :status, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:created_at, :digest, :id, :retention_days, :size, :status])
    
  end
end
