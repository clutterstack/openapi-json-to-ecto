defmodule FlyApi.FlyFile do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :guest_path, :string
    field :mode, :integer
    field :raw_value, :string
    field :secret_name, :string
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:guest_path, :mode, :raw_value, :secret_name])
    
  end
end
