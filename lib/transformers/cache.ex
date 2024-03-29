defmodule AshThrift.Transformers.Cache do
  use Spark.Dsl.Transformer

  alias Spark.Dsl.Transformer

  @impl true
  def transform(dsl_state) do
    dsl_state
    |> Transformer.persist(:thrift, structs(dsl_state))
    |> then(&{:ok, &1})
  end

  @impl true
  def after?(_), do: true

  defp structs(dsl) do
    attributes =
      Transformer.get_entities(dsl, [:attributes])
      |> Enum.reduce(%{}, fn a, acc -> Map.put(acc, a.name, a) end)

    attributes =
      Transformer.get_entities(dsl, [:relationships])
      |> Enum.reduce(attributes, fn a, acc -> Map.put(acc, a.name, a) end)

    Transformer.get_entities(dsl, [:thrift])
    |> Enum.reduce(%{}, fn
      %AshThrift.Struct{name: name, fields: fields}, acc ->
        Map.put(acc, name, fields(attributes, fields))

      _, acc ->
        acc
    end)
  end

  defp fields(attributes, fields) do
    Enum.reduce(fields, [], fn
      %AshThrift.Field{attribute: attr} = field, acc ->
        case Map.get(attributes, attr) do
          nil -> acc
          attr -> [{field, attr} | acc]
        end

      _, acc ->
        acc
    end)
    |> Enum.reverse()
  end
end
