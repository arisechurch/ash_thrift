defmodule Mix.Tasks.Compile.AshThrift do
  use Mix.Task.Compiler

  alias AshThrift.Generator

  @requirements ["app.config"]

  @impl true
  def run(_) do
    namespaces =
      namespaces()
      |> Enum.map(&Generator.namespace/1)

    structs =
      resources()
      |> Enum.map(&Generator.resource/1)

    output = """
    #{namespaces}

    #{structs}
    """

    Path.dirname(output_file())
    |> File.mkdir_p!()

    File.write!(output_file(), output)

    :ok
  end

  defp config do
    Mix.Project.config()
    |> Keyword.get(:ash_thrift, [])
  end

  defp namespaces do
    Keyword.get(config(), :namespaces, [])
  end

  defp resources do
    Keyword.get(config(), :resources, [])
  end

  defp output_file do
    Keyword.get(config(), :output_file, "out.thrift")
  end
end
