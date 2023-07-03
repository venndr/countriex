defmodule Countriex.Mixfile do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      app: :countriex,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      description:
        "All sorts of useful information about every country. A pure elixir port of the ruby Countries gem",
      docs: [extras: ["README.md"]],
      elixir: "~> 1.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      homepage_url: "https://github.com/navinpeiris/countriex",
      name: "Countriex",
      package: package(),
      source_url: "https://github.com/navinpeiris/countriex",
      start_permanent: Mix.env() == :prod,
      version: "1.0.2",
      xref: [exclude: [YamlElixir]]
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp aliases,
    do: [
      update: [
        "countriex.generate_data",
        "format lib/countriex/data.ex"
      ]
    ]

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Music Glue"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/venndr/countriex"}
    ]
  end

  defp elixirc_paths(:dev), do: ["lib", "tasks"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev},
      {:httpoison, "~> 1.8", only: :dev},
      {:memoize, "~> 1.4", only: :dev},
      {:poison, "~> 3.0", only: :dev},
      {:yaml_elixir, "~> 2.9.0", only: :dev},
      {:morphix, "~> 0.8.0"},
      {:ex_unit_notifier, "~> 0.1", only: :test}
    ]
  end
end
