defmodule FlyApi.App do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :id, :string
    field :name, :string
    embeds_one :organization, FlyApi.Organization
    field :status, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:id, :name, :status])
        |> cast_embed(:organization, with: &FlyApi.Organization.changeset/2)
  end
end
