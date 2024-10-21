defmodule FlyApi.ExtendVolumeRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :size_gb, :integer
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:size_gb])
    
  end
end
