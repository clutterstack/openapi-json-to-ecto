defmodule FlyApi.CreateAppRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :app_name, :string
    field :enable_subdomains, :boolean
    field :network, :string
    field :org_slug, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:app_name, :enable_subdomains, :network, :org_slug])
    
  end
end
