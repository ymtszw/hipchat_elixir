defmodule Mix.Tasks.Hipchat.Generate do
  use Mix.Task

  @shortdoc "Generate modules from spec yaml"

  def run(_args) do
    Application.ensure_started(:yamerl)
    Hipchat.Generator.generate
  end
end
