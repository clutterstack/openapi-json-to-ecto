defmodule FlyApi.ExtendVolumeResponse do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :needs_restart, :boolean
    embeds_one :volume, FlyApi.Volume
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:needs_restart])
        |> cast_embed(:volume, with: &FlyApi.Volume.changeset/2)
  end
end
