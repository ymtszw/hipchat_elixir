defmodule Mix.Tasks.Hipchat.Generate do
  @moduledoc """
  Generate API modules from spec YAML.

  This task does not need to be run on user side at all.
  Latest API should be generated by the library maintainers and published in Hex.
  """

  use Mix.Task

  @shortdoc "Generate modules from spec yaml"

  def run(_args) do
    Application.ensure_started(:yamerl)
    Hipchat.Generator.generate()
  end
end
