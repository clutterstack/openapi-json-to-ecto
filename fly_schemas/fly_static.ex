defmodule FlyApi.FlyStatic do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :guest_path, :string
    field :index_document, :string
    field :tigris_bucket, :string
    field :url_prefix, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:guest_path, :index_document, :tigris_bucket, :url_prefix])
        |> validate_required([:guest_path, :url_prefix])
    
  end
end
