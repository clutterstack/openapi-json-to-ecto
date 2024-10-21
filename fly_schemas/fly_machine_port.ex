defmodule FlyApi.FlyMachinePort do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :end_port, :integer
    field :force_https, :boolean
    field :handlers, {:array, :string}
    embeds_one :http_options, FlyApi.FlyHTTPOptions
    field :port, :integer
    embeds_one :proxy_proto_options, FlyApi.FlyProxyProtoOptions
    field :start_port, :integer
    embeds_one :tls_options, FlyApi.FlyTLSOptions
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:end_port, :force_https, :handlers, :port, :start_port])
        |> cast_embed(:http_options, with: &FlyApi.FlyHTTPOptions.changeset/2)
    |> cast_embed(:proxy_proto_options, with: &FlyApi.FlyProxyProtoOptions.changeset/2)
    |> cast_embed(:tls_options, with: &FlyApi.FlyTLSOptions.changeset/2)
  end
end
