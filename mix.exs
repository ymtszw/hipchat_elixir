defmodule Hipchat.Mixfile do
  use Mix.Project

  @github_url "https://github.com/ymtszw/hipchat_elixir"

  def project do
    [
      app:             :hipchat_elixir,
      version:         "0.1.0",
      elixir:          "~> 1.3",
      build_embedded:  Mix.env == :prod,
      start_permanent: false,
      deps:            deps,
      elixirc_paths:   paths,
      description:     "HiChat client library for Elixir",
      source_url:      @github_url,
      package:         [
        files:       ["lib", "mix.exs", "LICENSE", "README.md"],
        licenses:    ["MIT"],
        maintainers: ["Yu Matsuzawa"],
        links:       %{"GitHub" => @github_url},
      ],
    ]
  end

  def application do
    apps = case Mix.env do
      :dev  -> [:hackney, :exsync] # :yamerl is manually started in mix task
      :test -> [:hackney, :yamerl]
      _else -> [:hackney]
    end
    [applications: apps]
  end

  defp deps do
    [
      {:hackney       , "1.6.3"                       },
      {:exsync        , "~> 0.1" , only: :dev         },
      {:ex_doc        , "~> 0.14", only: :dev         },
      {:mix_test_watch, "~> 0.2" , only: :dev         },
      {:yamerl        , "~> 0.4" , only: [:dev, :test]},
    ]
  end

  defp paths do
    case Mix.env do
      :dev  -> ["lib", "generator"]
      :test -> ["lib", "generator"]
      _else -> ["lib"]
    end
  end
end
