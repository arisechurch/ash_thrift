defmodule AshThrift.Transformers.CacheFieldAttributes do
  use Ash.Dsl.Transformer

  alias Ash.Dsl.Transformer

  @impl true
  def transform(resource, dsl_state) do
    dsl_state
    |> Transformer.persist(:thrift_fields, fields(dsl_state))
    |> Transformer.set_option(
      [:thrift],
      :struct_name,
      struct_name(resource, dsl_state)
    )
    |> then(&{:ok, &1})
  end

  @impl true
  def after?(_), do: true

  defp fields(dsl) do
    attributes =
      Transformer.get_entities(dsl, [:attributes])
      |> Enum.reduce(%{}, fn a, acc -> Map.put(acc, a.name, a) end)

    Transformer.get_entities(dsl, [:thrift])
    |> Enum.reduce([], fn
      %AshThrift.Field{attribute: attr} = field, acc ->
        case Map.get(attributes, attr) do
          nil -> acc
          attr -> [{field, attr} | acc]
        end

      _, acc ->
        acc
    end)
  end

  defp struct_name(resource, dsl) do
    Transformer.get_option(dsl, [:thrift], :struct_name)
    |> case do
      nil ->
        Atom.to_string(resource)
        |> String.split(".")
        |> List.last()

      name ->
        name
    end
  end
end
