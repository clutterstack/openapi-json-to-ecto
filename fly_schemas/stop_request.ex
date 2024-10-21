defmodule FlyApi.StopRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :signal, :string
    embeds_one :timeout, FlyApi.FlyDuration
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:signal])
        |> cast_embed(:timeout, with: &FlyApi.FlyDuration.changeset/2)
  end
end
