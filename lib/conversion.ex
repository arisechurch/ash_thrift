defmodule AshThrift.Conversion do
  @spec type(atom()) :: String.t()
  def type(type)
  def type(Ash.Type.Atom), do: "string"
  def type(Ash.Type.String), do: "string"
  def type(Ash.Type.Integer), do: "i64"
  def type(Ash.Type.Float), do: "double"
  def type(Ash.Type.UtcDatetime), do: "i64"
  def type(Ash.Type.UtcDatetimeUsec), do: "i64"
  def type(Ash.Type.Boolean), do: "bool"
  def type(Ash.Type.UUID), do: "binary"
  def type(Ash.Type.Binary), do: "binary"
  def type({:array, t}), do: "list<#{type(t)}>"
  def type(type), do: raise("unsupported type #{type}")

  @spec value(atom(), any()) :: any()
  def value(type, value)
  def value(_, nil), do: nil
  def value(Ash.Type.Atom, v), do: Atom.to_string(v)
  def value(Ash.Type.String, v), do: v
  def value(Ash.Type.Integer, v), do: v
  def value(Ash.Type.Float, v), do: v
  def value(Ash.Type.UtcDatetime, v), do: DateTime.to_unix(v, :second)
  def value(Ash.Type.UtcDatetimeUsec, v), do: DateTime.to_unix(v, :microsecond)
  def value(Ash.Type.Boolean, v), do: v
  def value(Ash.Type.UUID, v), do: Ecto.UUID.dump!(v)
  def value(Ash.Type.Binary, v), do: v
  def value({:array, t}, v), do: Enum.map(v, &value(t, &1))
  def value(type, _), do: raise("unsupported type, #{type}")

  @spec parse(atom(), any()) :: any()
  def parse(type, thrift_value)
  def parse(_, nil), do: nil
  def parse(Ash.Type.Atom, v), do: :"#{v}"
  def parse(Ash.Type.String, v), do: v
  def parse(Ash.Type.Integer, v), do: v
  def parse(Ash.Type.Float, v), do: v
  def parse(Ash.Type.UtcDatetime, v), do: DateTime.from_unix!(v, :second)
  def parse(Ash.Type.UtcDatetimeUsec, v), do: DateTime.from_unix!(v, :microsecond)
  def parse(Ash.Type.Boolean, v), do: v
  def parse(Ash.Type.UUID, v), do: Ecto.UUID.cast!(v)
  def parse(Ash.Type.Binary, v), do: v
  def parse({:array, t}, v), do: Enum.map(v, &parse(t, &1))
  def parse(type, _), do: raise("unsupported type #{type}")
end
