defmodule FlyApi.ListAppsResponse do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :apps, FlyApi.ListApp
    field :total_apps, :integer
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:total_apps])
        |> cast_embed(:apps, with: &FlyApi.ListApp.changeset/2)
  end
end
