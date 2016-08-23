defmodule CREST.Mixfile do
  use Mix.Project

  def project do
    [app: :crest,
     version: "0.0.1-dev",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "A client for EVE Online's CREST API",
     package: package(),
     deps: deps(),
     source_url: "https://github.com/EVE-Tools/crest",
     homepage_url: "https://github.com/EVE-Tools/crest",
     docs: [extras: ["README.md", "CHANGELOG.md"]]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpotion],
     mod: {CREST.App, []}]
  end

  defp package do
    [name: :crest,
     maintainers: ["zweizeichen"],
     licenses: ["BSD New"],
     links: %{"GitHub" => "https://github.com/EVE-Tools/crest"}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpotion, "~> 3.0"},
      {:jiffy, "~> 0.14"},
      {:ex_doc, "~> 0.12", only: :dev},
      {:dialyxir, "~> 0.3", only: :dev},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:inch_ex, "~> 0.5", only: [:dev, :test]},
    ]
  end
end
