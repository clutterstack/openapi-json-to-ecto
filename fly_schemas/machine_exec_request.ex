defmodule FlyApi.MachineExecRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :cmd, :string
    field :command, {:array, :string}
    field :timeout, :integer
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:cmd, :command, :timeout])
    
  end
end
