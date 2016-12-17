defmodule Hipchat.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :hipchat_elixir,
      version:         "0.1.0",
      elixir:          "~> 1.3",
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps:            deps,
    ]
  end

  def application do
    default_apps = [
      :logger,
      :hackney,
    ]
    apps = case Mix.env do
      :dev  -> default_apps ++ [:exsync] # :yamerl is manually started in mix task
      :test -> default_apps ++ [:yamerl]
      _else -> default_apps
    end
    [applications: apps]
  end

  defp deps do
    [
      {:exsync,         "~> 0.1", only: :dev         },
      {:mix_test_watch, "~> 0.2", only: :dev         },
      {:yamerl,         "~> 0.4", only: [:dev, :test]},
      {:croma,          "~> 0.4"                     },
      {:hackney,        "~> 1.6"                     },
      {:poison,         "~> 2.2"                     },
    ]
  end
end
