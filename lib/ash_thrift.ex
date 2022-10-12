defmodule AshThrift do
  defmodule Namespace do
    @type t :: %__MODULE__{
            language: atom(),
            name: String.t()
          }

    defstruct [:language, :name]
  end

  defmodule DslNamespace do
    @type t :: %__MODULE__{
            module: atom()
          }

    defstruct [:module]
  end

  defmodule Field do
    @type t :: %__MODULE__{
            id: non_neg_integer(),
            attribute: atom(),
            optional: boolean(),
            variant: String.t() | nil
          }

    defstruct [:id, :attribute, :optional, :variant]
  end

  defmodule Struct do
    @type t :: %__MODULE__{
            name: String.t(),
            fields: Field.t()
          }

    defstruct [:name, :fields]
  end

  @doc """
  Builds an Ash resource from a thrift struct
  """
  @spec into(
          data :: map(),
          resource :: module(),
          variant :: String.t() | nil,
          dest :: resource_t | nil
        ) :: resource_t
        when resource_t: term()
  def into(data, resource, variant, dest \\ nil)

  def into(data, resource, nil, dest) do
    into(data, resource, relationship_variant(resource, nil), dest)
  end

  def into(data, resource, variant, nil),
    do: into(data, resource, variant, struct(resource))

  def into(data, resource, variant, dest) do
    nil_or_map = case Map.has_key?(dest, :__struct__) do
      true -> nil
      _ -> %{}
    end

    Spark.Dsl.Extension.get_persisted(resource, :thrift, %{})
    |> Map.get(variant, [])
    |> Enum.reduce(dest, fn
      {_field,
       %Ash.Resource.Attribute{
         name: name,
         type: type
       }},
      acc ->
        value = AshThrift.Conversion.parse(type, Map.get(data, name))
        Map.put(acc, name, value)

      {%Field{variant: variant},
       %{
         name: name,
         destination: destination,
         cardinality: cardinality
       }},
      acc ->
        value =
          case {Map.get(data, name), cardinality} do
            {nil, _} ->
              nil

            {data, :one} ->
              into(data, destination, variant, nil_or_map)

            {data, :many} ->
              data
              |> Enum.map(&into(&1, destination, variant, nil_or_map))
          end

        Map.put(acc, name, value)
    end)
  end

  @doc """
  Dumps an Ash resource to a thrift struct
  """
  @spec dump(
          resource :: resource_t,
          variant :: String.t() | nil,
          thrift_struct :: map() | nil
        ) ::
          resource_t
        when resource_t: struct()
  def dump(resource, variant \\ nil, dest \\ nil)

  def dump(resource, nil, dest) do
    dump(resource, relationship_variant(resource.__struct__, nil), dest)
  end

  def dump(resource, variant, nil) do
    dest = struct(variant_module(resource.__struct__, variant))
    dump(resource, variant, dest)
  end

  def dump(resource, variant, dest) do
    Spark.Dsl.Extension.get_persisted(resource.__struct__, :thrift, %{})
    |> Map.get(variant, [])
    |> Enum.reduce(dest, fn
      {_field,
       %Ash.Resource.Attribute{
         name: name,
         type: type
       }},
      acc ->
        value = AshThrift.Conversion.value(type, Map.get(resource, name))
        Map.put(acc, name, value)

      {%Field{variant: variant},
       %{
         name: name,
         cardinality: cardinality
       }},
      acc ->
        value =
          case {Map.get(resource, name), cardinality} do
            {nil, _} ->
              nil

            {%Ash.NotLoaded{}, _} ->
              nil

            {data, :one} ->
              dump(data, variant)

            {data, :many} ->
              data
              |> Enum.map(&dump(&1, variant))
          end

        Map.put(acc, name, value)
    end)
  end

  @spec relationship_variant(resource :: module(), variant :: String.t() | nil) :: String.t()
  def relationship_variant(resource, nil) do
    Spark.Dsl.Extension.get_persisted(resource, :thrift, %{})
    |> Map.keys()
    |> List.first()
  end

  def relationship_variant(_, variant), do: variant

  @spec variant_module(resource :: module(), variant :: String.t() | nil) :: module()
  def variant_module(resource, nil) do
    variant_module(resource, relationship_variant(resource, nil))
  end

  def variant_module(resource, variant) do
    namespace =
      Spark.Dsl.Extension.get_entities(resource, [:thrift])
      |> Enum.filter(fn
        %DslNamespace{} -> true
        _ -> false
      end)
      |> List.first()

    case namespace do
      nil ->
        String.to_existing_atom("Elixir.#{variant}")

      %DslNamespace{module: module} ->
        Module.safe_concat(module, variant)
    end
  end
end
