defmodule TestApi.V0.PartialResource do
  @moduledoc false
  _ = "Auto-generated Thrift struct api.PartialResource"
  _ = "1: string body"
  defstruct body: nil
  @type t :: %__MODULE__{}
  def new do
    %__MODULE__{}
  end

  defmodule BinaryProtocol do
    @moduledoc false
    def deserialize(binary) do
      deserialize(binary, %TestApi.V0.PartialResource{})
    end

    defp deserialize(<<0, rest::binary>>, %TestApi.V0.PartialResource{} = acc) do
      {acc, rest}
    end

    defp deserialize(
           <<11, 1::16-signed, string_size::32-signed, value::binary-size(string_size),
             rest::binary>>,
           acc
         ) do
      deserialize(rest, %{acc | body: value})
    end

    defp deserialize(<<field_type, _id::16-signed, rest::binary>>, acc) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end

    defp deserialize(_, _) do
      :error
    end

    def serialize(%TestApi.V0.PartialResource{body: body}) do
      [
        case body do
          nil ->
            raise Thrift.InvalidValueError,
                  "Required field :body on TestApi.V0.PartialResource must not be nil"

          _ ->
            [<<11, 1::16-signed, byte_size(body)::32-signed>> | body]
        end
        | "\0"
      ]
    end
  end

  def serialize(struct) do
    BinaryProtocol.serialize(struct)
  end

  def serialize(struct, :binary) do
    BinaryProtocol.serialize(struct)
  end

  def deserialize(binary) do
    BinaryProtocol.deserialize(binary)
  end
end