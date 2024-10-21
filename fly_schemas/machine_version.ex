defmodule FlyApi.MachineVersion do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_one :user_config, FlyApi.FlyMachineConfig
    field :version, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:version])
        |> cast_embed(:user_config, with: &FlyApi.FlyMachineConfig.changeset/2)
  end
end
