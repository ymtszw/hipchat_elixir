defmodule Mix.Tasks.ExHipchat.Generate do
  use Mix.Task

  @shortdoc "Generate modules from spec yaml"

  def run(_args) do
    Application.ensure_started(:yamerl)
    ExHipchat.Generator.generate
  end
end
