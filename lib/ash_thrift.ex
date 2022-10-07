defmodule AshThrift do
  defmodule Namespace do
    @type t :: %__MODULE__{
            language: atom(),
            name: String.t()
          }

    defstruct [:language, :name]
  end

  defmodule Field do
    @type t :: %__MODULE__{
            id: non_neg_integer(),
            attribute: atom(),
            optional: boolean()
          }

    defstruct [:id, :attribute, :optional]
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
          variant :: String.t(),
          dest :: resource_t | nil
        ) :: resource_t
        when resource_t: term()
  def into(data, resource, variant, dest \\ nil)

  def into(data, resource, variant, nil),
    do: into(data, resource, variant, struct(resource))

  def into(data, resource, variant, dest) do
    Spark.Dsl.Extension.get_persisted(resource, :thrift, %{})
    |> Map.get(variant, [])
    |> Enum.reduce(dest, fn {_field,
                             %Ash.Resource.Attribute{
                               name: name,
                               type: type
                             }},
                            acc ->
      value = AshThrift.Conversion.parse(type, Map.get(data, name))
      Map.put(acc, name, value)
    end)
  end

  @doc """
  Dumps an Ash resource to a thrift struct
  """
  @spec dump(resource :: resource_t, variant :: String.t(), thrift_struct :: map()) :: resource_t
        when resource_t: struct()
  def dump(resource, variant, dest \\ %{}) do
    Spark.Dsl.Extension.get_persisted(resource.__struct__, :thrift, %{})
    |> Map.get(variant, [])
    |> Enum.reduce(dest, fn {_field,
                             %Ash.Resource.Attribute{
                               name: name,
                               type: type
                             }},
                            acc ->
      value = AshThrift.Conversion.value(type, Map.get(resource, name))
      Map.put(acc, name, value)
    end)
  end
end
