defmodule FlyApi.UpdateVolumeRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :auto_backup_enabled, :boolean
    field :snapshot_retention, :integer
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:auto_backup_enabled, :snapshot_retention])
    
  end
end
