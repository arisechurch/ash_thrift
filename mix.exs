defmodule AshThrift.MixProject do
  use Mix.Project

  def project do
    [
      app: :ash_thrift,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_paths: ["lib"],
      ash_thrift: [
        namespaces: [
          rb: "TestApi.V0",
          ex: "TestApi.V0"
        ],
        resources: [
          TestApi.Parent,
          TestApi.TestResource
        ]
      ]
    ]
  end

  defp package,
    do: [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Tim Smart"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/arisechurch/ash_thrift"}
    ]

  defp description do
    """
    Thrift extension for the Ash framework.
    """
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ash, "~> 1.50"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
