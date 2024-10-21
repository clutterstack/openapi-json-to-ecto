defmodule FlyApi.ErrorResponse do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :details, :map
    field :error, :string
    embeds_one :status, FlyApi.MainStatusCode
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:error])
        |> cast_embed(:status, with: &FlyApi.MainStatusCode.changeset/2)
  end
end
