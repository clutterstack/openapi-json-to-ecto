defmodule FlyApi.Volume do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :attached_alloc_id, :string
    field :attached_machine_id, :string
    field :auto_backup_enabled, :boolean
    field :block_size, :integer
    field :blocks, :integer
    field :blocks_avail, :integer
    field :blocks_free, :integer
    field :created_at, :string
    field :encrypted, :boolean
    field :fstype, :string
    field :host_status, :string
    field :id, :string
    field :name, :string
    field :region, :string
    field :size_gb, :integer
    field :snapshot_retention, :integer
    field :state, :string
    field :zone, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:attached_alloc_id, :attached_machine_id, :auto_backup_enabled, :block_size, :blocks, :blocks_avail, :blocks_free, :created_at, :encrypted, :fstype, :host_status, :id, :name, :region, :size_gb, :snapshot_retention, :state, :zone])
    
  end
end
