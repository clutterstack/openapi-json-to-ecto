defmodule FlyApi.MainStatusCode do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    
  end

  def changeset(schema, attrs) do
    schema
        |> cast(attrs, [])
    
  end
end
