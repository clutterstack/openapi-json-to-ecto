defmodule FlyApi.FlyDNSConfig do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :dns_forward_rules, FlyApi.FlyDnsForwardRule
    field :hostname, :string
    field :hostname_fqdn, :string
    field :nameservers, {:array, :string}
    embeds_many :options, FlyApi.FlyDnsOption
    field :searches, {:array, :string}
    field :skip_registration, :boolean
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:hostname, :hostname_fqdn, :nameservers, :searches, :skip_registration])
        |> cast_embed(:dns_forward_rules, with: &FlyApi.FlyDnsForwardRule.changeset/2)
    |> cast_embed(:options, with: &FlyApi.FlyDnsOption.changeset/2)
  end
end
