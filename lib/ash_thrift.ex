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
            attribute: atom()
          }

    defstruct [:id, :attribute]
  end

  @doc """
  Builds an Ash resource from a thrift struct
  """
  @spec into(struct(), resource :: struct()) :: term()
  def into(data, resource) do
    Ash.Dsl.Extension.get_persisted(resource.__struct__, :thrift_fields, [])
    |> Enum.reduce(resource, fn {_field,
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
  @spec dump(resource :: struct(), thrift_struct :: struct()) :: struct()
  def dump(resource, dest) do
    Ash.Dsl.Extension.get_persisted(resource.__struct__, :thrift_fields, [])
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
