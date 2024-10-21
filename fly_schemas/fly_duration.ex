defmodule FlyApi.FlyDuration do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :time_duration, :integer
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [:time_duration])
    
  end
end
