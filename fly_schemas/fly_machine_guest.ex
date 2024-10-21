defmodule FlyApi.FlyMachineGuest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :cpu_kind, :string
    field :cpus, :integer
    field :gpu_kind, :string
    field :gpus, :integer
    field :host_dedication_id, :string
    field :kernel_args, {:array, :string}
    field :memory_mb, :integer
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:cpu_kind, :cpus, :gpu_kind, :gpus, :host_dedication_id, :kernel_args, :memory_mb])
    
  end
end
