defmodule Hipchat.Mixfile do
  use Mix.Project

  @github_url "https://github.com/ymtszw/hipchat_elixir"

  def project() do
    [
      app:             :hipchat_elixir,
      version:         "0.4.0",
      elixir:          "~> 1.3",
      build_embedded:  Mix.env == :prod,
      start_permanent: false,
      deps:            deps(),
      elixirc_paths:   paths(),
      description:     "HipChat client library for Elixir",
      source_url:      @github_url,
      package:         [
        files:       ["lib", "mix.exs", "LICENSE", "README.md", "CHANGELOG.md"],
        licenses:    ["MIT"],
        maintainers: ["Yu Matsuzawa"],
        links:       %{"GitHub" => @github_url},
      ],
    ]
  end

  defp deps() do
    [
      {:hackney    , "~> 1.6.3"},
      {:exsync     , "~> 0.1" , only: :dev         , runtime: Mix.env() == :dev },
      {:ex_doc     , "~> 0.14", only: :dev         , runtime: false             },
      {:yamerl     , "~> 0.4" , only: [:dev, :test], runtime: Mix.env() == :test},
      {:stream_data, "~> 0.4" , only: :test                                     },
      {:poison     , "~> 2.0" , only: [:dev, :test]                             },
    ]
  end

  defp paths() do
    case Mix.env() do
      :dev  -> ["lib", "generator"]
      :test -> ["lib", "generator"]
      _else -> ["lib"]
    end
  end
end
