defmodule TestApi.V0.Parent do
  @moduledoc false
  _ = "Auto-generated Thrift struct api.Parent"
  _ = "1: binary id"
  _ = "2: string body"
  _ = "3: list<api.TestResource> children"
  _ = "4: i64 created_at"
  _ = "5: i64 updated_at"
  defstruct id: nil, body: nil, children: nil, created_at: nil, updated_at: nil
  @type t :: %__MODULE__{}
  def new do
    %__MODULE__{}
  end

  defmodule BinaryProtocol do
    @moduledoc false
    def deserialize(binary) do
      deserialize(binary, %TestApi.V0.Parent{})
    end

    defp deserialize(<<0, rest::binary>>, %TestApi.V0.Parent{} = acc) do
      {acc, rest}
    end

    defp deserialize(
           <<11, 1::16-signed, string_size::32-signed, value::binary-size(string_size),
             rest::binary>>,
           acc
         ) do
      deserialize(rest, %{acc | id: value})
    end

    defp deserialize(
           <<11, 2::16-signed, string_size::32-signed, value::binary-size(string_size),
             rest::binary>>,
           acc
         ) do
      deserialize(rest, %{acc | body: value})
    end

    defp deserialize(<<15, 3::16-signed, 12, remaining::32-signed, rest::binary>>, struct) do
      deserialize__children(rest, [[], remaining, struct])
    end

    defp deserialize(<<10, 4::16-signed, value::64-signed, rest::binary>>, acc) do
      deserialize(rest, %{acc | created_at: value})
    end

    defp deserialize(<<10, 5::16-signed, value::64-signed, rest::binary>>, acc) do
      deserialize(rest, %{acc | updated_at: value})
    end

    defp deserialize(<<field_type, _id::16-signed, rest::binary>>, acc) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end

    defp deserialize(_, _) do
      :error
    end

    defp deserialize__children(<<rest::binary>>, [list, 0, struct]) do
      deserialize(rest, %{struct | children: Enum.reverse(list)})
    end

    defp deserialize__children(<<rest::binary>>, [list, remaining | stack]) do
      case TestApi.V0.TestResource.BinaryProtocol.deserialize(rest) do
        {element, rest} -> deserialize__children(rest, [[element | list], remaining - 1 | stack])
        :error -> :error
      end
    end

    defp deserialize__children(_, _) do
      :error
    end

    def serialize(%TestApi.V0.Parent{
          id: id,
          body: body,
          children: children,
          created_at: created_at,
          updated_at: updated_at
        }) do
      [
        case id do
          nil ->
            raise Thrift.InvalidValueError,
                  "Required field :id on TestApi.V0.Parent must not be nil"

          _ ->
            [<<11, 1::16-signed, byte_size(id)::32-signed>> | id]
        end,
        case body do
          nil ->
            raise Thrift.InvalidValueError,
                  "Required field :body on TestApi.V0.Parent must not be nil"

          _ ->
            [<<11, 2::16-signed, byte_size(body)::32-signed>> | body]
        end,
        case children do
          nil ->
            <<>>

          _ ->
            [
              <<15, 3::16-signed, 12, length(children)::32-signed>>
              | for e <- children do
                  TestApi.V0.TestResource.serialize(e)
                end
            ]
        end,
        case created_at do
          nil ->
            raise Thrift.InvalidValueError,
                  "Required field :created_at on TestApi.V0.Parent must not be nil"

          _ ->
            <<10, 4::16-signed, created_at::64-signed>>
        end,
        case updated_at do
          nil ->
            raise Thrift.InvalidValueError,
                  "Required field :updated_at on TestApi.V0.Parent must not be nil"

          _ ->
            <<10, 5::16-signed, updated_at::64-signed>>
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