defmodule FlyApi.FlyMachineRestart do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :gpu_bid_price, :float
    field :max_retries, :integer
    field :policy, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:gpu_bid_price, :max_retries, :policy])
    
  end
end
