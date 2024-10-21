defmodule FlyApi.Flydv1ExecResponse do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :exit_code, :integer
    field :exit_signal, :integer
    field :stderr, :string
    field :stdout, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:exit_code, :exit_signal, :stderr, :stdout])
    
  end
end
