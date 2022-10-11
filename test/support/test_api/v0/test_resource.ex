defmodule TestApi.V0.TestResource do
  @moduledoc false
  _ = "Auto-generated Thrift struct api.TestResource"
  _ = "1: binary id"
  _ = "2: i64 count"
  _ = "3: string body"
  _ = "4: bool active"
  _ = "5: api.Parent parent"
  _ = "6: i64 created_at"
  _ = "7: i64 updated_at"

  defstruct id: nil,
            count: nil,
            body: nil,
            active: nil,
            parent: nil,
            created_at: nil,
            updated_at: nil

  @type t :: %__MODULE__{}
  def new do
    %__MODULE__{}
  end

  defmodule BinaryProtocol do
    @moduledoc false
    def deserialize(binary) do
      deserialize(binary, %TestApi.V0.TestResource{})
    end

    defp deserialize(<<0, rest::binary>>, %TestApi.V0.TestResource{} = acc) do
      {acc, rest}
    end

    defp deserialize(
           <<11, 1::16-signed, string_size::32-signed, value::binary-size(string_size),
             rest::binary>>,
           acc
         ) do
      deserialize(rest, %{acc | id: value})
    end

    defp deserialize(<<10, 2::16-signed, value::64-signed, rest::binary>>, acc) do
      deserialize(rest, %{acc | count: value})
    end

    defp deserialize(
           <<11, 3::16-signed, string_size::32-signed, value::binary-size(string_size),
             rest::binary>>,
           acc
         ) do
      deserialize(rest, %{acc | body: value})
    end

    defp deserialize(<<2, 4::16-signed, 1, rest::binary>>, acc) do
      deserialize(rest, %{acc | active: true})
    end

    defp deserialize(<<2, 4::16-signed, 0, rest::binary>>, acc) do
      deserialize(rest, %{acc | active: false})
    end

    defp deserialize(<<12, 5::16-signed, rest::binary>>, acc) do
      case TestApi.V0.Parent.BinaryProtocol.deserialize(rest) do
        {value, rest} -> deserialize(rest, %{acc | parent: value})
        :error -> :error
      end
    end

    defp deserialize(<<10, 6::16-signed, value::64-signed, rest::binary>>, acc) do
      deserialize(rest, %{acc | created_at: value})
    end

    defp deserialize(<<10, 7::16-signed, value::64-signed, rest::binary>>, acc) do
      deserialize(rest, %{acc | updated_at: value})
    end

    defp deserialize(<<field_type, _id::16-signed, rest::binary>>, acc) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end

    defp deserialize(_, _) do
      :error
    end

    def serialize(%TestApi.V0.TestResource{
          id: id,
          count: count,
          body: body,
          active: active,
          parent: parent,
          created_at: created_at,
          updated_at: updated_at
        }) do
      [
        case id do
          nil ->
            raise Thrift.InvalidValueError,
                  "Required field :id on TestApi.V0.TestResource must not be nil"

          _ ->
            [<<11, 1::16-signed, byte_size(id)::32-signed>> | id]
        end,
        case count do
          nil -> <<>>
          _ -> <<10, 2::16-signed, count::64-signed>>
        end,
        case body do
          nil ->
            raise Thrift.InvalidValueError,
                  "Required field :body on TestApi.V0.TestResource must not be nil"

          _ ->
            [<<11, 3::16-signed, byte_size(body)::32-signed>> | body]
        end,
        case active do
          false ->
            <<2, 4::16-signed, 0>>

          true ->
            <<2, 4::16-signed, 1>>

          _ ->
            raise Thrift.InvalidValueError,
                  "Required boolean field :active on TestApi.V0.TestResource must be true or false"
        end,
        case parent do
          nil -> <<>>
          _ -> [<<12, 5::16-signed>> | TestApi.V0.Parent.serialize(parent)]
        end,
        case created_at do
          nil ->
            raise Thrift.InvalidValueError,
                  "Required field :created_at on TestApi.V0.TestResource must not be nil"

          _ ->
            <<10, 6::16-signed, created_at::64-signed>>
        end,
        case updated_at do
          nil ->
            raise Thrift.InvalidValueError,
                  "Required field :updated_at on TestApi.V0.TestResource must not be nil"

          _ ->
            <<10, 7::16-signed, updated_at::64-signed>>
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