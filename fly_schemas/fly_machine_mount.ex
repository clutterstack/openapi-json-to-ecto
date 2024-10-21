defmodule FlyApi.FlyMachineMount do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :add_size_gb, :integer
    field :encrypted, :boolean
    field :extend_threshold_percent, :integer
    field :name, :string
    field :path, :string
    field :size_gb, :integer
    field :size_gb_limit, :integer
    field :volume, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:add_size_gb, :encrypted, :extend_threshold_percent, :name, :path, :size_gb, :size_gb_limit, :volume])
    
  end
end
