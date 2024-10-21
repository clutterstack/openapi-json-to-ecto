defmodule FlyApi.ProcessStat do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :command, :string
    field :cpu, :integer
    field :directory, :string
    embeds_many :listen_sockets, FlyApi.ListenSocket
    field :pid, :integer
    field :rss, :integer
    field :rtime, :integer
    field :stime, :integer
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:command, :cpu, :directory, :pid, :rss, :rtime, :stime])
        |> cast_embed(:listen_sockets, with: &FlyApi.ListenSocket.changeset/2)
  end
end
