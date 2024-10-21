defmodule FlyApi.FlyMachineConfig do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :auto_destroy, :boolean
    embeds_many :checks, FlyApi.FlyMachineCheck
    field :disable_machine_autostart, :boolean
    embeds_one :dns, FlyApi.FlyDNSConfig
    field :env, {:map, :string}
    embeds_many :files, FlyApi.FlyFile
    embeds_one :guest, FlyApi.FlyMachineGuest
    field :image, :string
    embeds_one :init, FlyApi.FlyMachineInit
    field :metadata, {:map, :string}
    embeds_one :metrics, FlyApi.FlyMachineMetrics
    embeds_many :mounts, FlyApi.FlyMachineMount
    embeds_many :processes, FlyApi.FlyMachineProcess
    embeds_one :restart, FlyApi.FlyMachineRestart
    field :schedule, :string
    embeds_many :services, FlyApi.FlyMachineService
    field :size, :string
    field :standbys, {:array, :string}
    embeds_many :statics, FlyApi.FlyStatic
    embeds_one :stop_config, FlyApi.FlyStopConfig
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:auto_destroy, :disable_machine_autostart, :image, :schedule, :size, :standbys])
        |> cast_embed(:dns, with: &FlyApi.FlyDNSConfig.changeset/2)
    |> cast_embed(:files, with: &FlyApi.FlyFile.changeset/2)
    |> cast_embed(:guest, with: &FlyApi.FlyMachineGuest.changeset/2)
    |> cast_embed(:init, with: &FlyApi.FlyMachineInit.changeset/2)
    |> cast_embed(:metrics, with: &FlyApi.FlyMachineMetrics.changeset/2)
    |> cast_embed(:mounts, with: &FlyApi.FlyMachineMount.changeset/2)
    |> cast_embed(:processes, with: &FlyApi.FlyMachineProcess.changeset/2)
    |> cast_embed(:restart, with: &FlyApi.FlyMachineRestart.changeset/2)
    |> cast_embed(:services, with: &FlyApi.FlyMachineService.changeset/2)
    |> cast_embed(:statics, with: &FlyApi.FlyStatic.changeset/2)
    |> cast_embed(:stop_config, with: &FlyApi.FlyStopConfig.changeset/2)
  end
end
