defmodule Mix.Tasks.BuildSchemas do
  use Mix.Task
  @impl Mix.Task
  @moduledoc """
  Usage example:
  mix build_schemas "spec.json" "fly_schemas"
  """

  def run(args) do
    [infile, outdir] = args
    IO.inspect(args, label: "args")
    MachinesApiToEcto.convert(infile, outdir)
  end
end
