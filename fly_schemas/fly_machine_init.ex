defmodule FlyApi.FlyMachineInit do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :cmd, {:array, :string}
    field :entrypoint, {:array, :string}
    field :exec, {:array, :string}
    field :kernel_args, {:array, :string}
    field :swap_size_mb, :integer
    field :tty, :boolean
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:cmd, :entrypoint, :exec, :kernel_args, :swap_size_mb, :tty])
    
  end
end
