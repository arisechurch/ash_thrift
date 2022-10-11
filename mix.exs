defmodule AshThrift.MixProject do
  use Mix.Project

  def project do
    [
      app: :ash_thrift,
      version: "0.2.0-rc.4",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_paths: ["lib"],
      ash_thrift: [
        namespaces: [
          elixir: "TestApi.V0",
          rb: "TestApi.V0"
        ],
        resources: [
          TestApi.Parent,
          TestApi.TestResource
        ],
        output_file: "test/support/api.thrift"
      ],
      thrift: [
        files: ["test/support/api.thrift"],
        output_path: "test/support"
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
      {:ash, "~> 2.0.0-rc.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:thrift, github: "pinterest/elixir-thrift", only: :test, runtime: false}
    ]
  end
end
