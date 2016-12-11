defmodule ExHipchat.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :ex_hipchat,
      version:         "0.1.1",
      elixir:          "~> 1.3",
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps:            deps(),
    ]
  end

  def application do
    default_apps = [
      :logger,
      :hackney,
    ]
    apps = if Mix.env == :dev, do: default_apps ++ dev_only_apps, else: default_apps
    [applications: apps]
  end

  defp dev_only_apps do
    [
      :exsync,
    ]
  end

  defp deps do
    [
      {:exsync,  "~> 0.1", only: :dev},
      {:croma,   "~> 0.4"            },
      {:hackney, "~> 1.6"            },
      {:poison,  "~> 2.2"            },
    ]
  end
end
