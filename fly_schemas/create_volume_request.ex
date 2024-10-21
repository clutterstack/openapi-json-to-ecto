defmodule FlyApi.CreateVolumeRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_one :compute, FlyApi.FlyMachineGuest
    field :compute_image, :string
    field :encrypted, :boolean
    field :fstype, :string
    field :name, :string
    field :region, :string
    field :require_unique_zone, :boolean
    field :size_gb, :integer
    field :snapshot_id, :string
    field :snapshot_retention, :integer
    field :source_volume_id, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:compute_image, :encrypted, :fstype, :name, :region, :require_unique_zone, :size_gb, :snapshot_id, :snapshot_retention, :source_volume_id])
        |> cast_embed(:compute, with: &FlyApi.FlyMachineGuest.changeset/2)
  end
end
