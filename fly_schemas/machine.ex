defmodule FlyApi.Machine do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :checks, FlyApi.CheckStatus
    embeds_one :config, FlyApi.FlyMachineConfig
    field :created_at, :string
    embeds_many :events, FlyApi.MachineEvent
    field :host_status, :string
    field :id, :string
    embeds_one :image_ref, FlyApi.ImageRef
    embeds_one :incomplete_config, FlyApi.FlyMachineConfig
    field :instance_id, :string
    field :name, :string
    field :nonce, :string
    field :private_ip, :string
    field :region, :string
    field :state, :string
    field :updated_at, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:created_at, :host_status, :id, :instance_id, :name, :nonce, :private_ip, :region, :state, :updated_at])
        |> cast_embed(:checks, with: &FlyApi.CheckStatus.changeset/2)
    |> cast_embed(:config, with: &FlyApi.FlyMachineConfig.changeset/2)
    |> cast_embed(:events, with: &FlyApi.MachineEvent.changeset/2)
    |> cast_embed(:image_ref, with: &FlyApi.ImageRef.changeset/2)
    |> cast_embed(:incomplete_config, with: &FlyApi.FlyMachineConfig.changeset/2)
  end
end
