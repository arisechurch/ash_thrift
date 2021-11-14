defmodule AshThrift.ConversionTest do
  use ExUnit.Case, async: true

  alias AshThrift.Conversion

  @now DateTime.utc_now()
  @now_seconds DateTime.to_unix(@now, :second)
  @now_microseconds DateTime.to_unix(@now, :microsecond)

  @now_second_precision DateTime.from_unix!(@now_seconds, :second)

  @uuid Ecto.UUID.generate()
  @uuid_raw Ecto.UUID.dump!(@uuid)

  @cases [
    %{
      type: Ash.Type.Atom,
      type_output: "string",
      input: :hello,
      output: "hello"
    },
    %{
      type: Ash.Type.String,
      type_output: "string",
      input: "hello",
      output: "hello"
    },
    %{
      type: Ash.Type.Integer,
      type_output: "i64",
      input: 123,
      output: 123
    },
    %{
      type: Ash.Type.Float,
      type_output: "double",
      input: 1.23,
      output: 1.23
    },
    %{
      type: Ash.Type.UtcDatetime,
      type_output: "i64",
      input: @now_second_precision,
      output: @now_seconds
    },
    %{
      type: Ash.Type.UtcDatetimeUsec,
      type_output: "i64",
      input: @now,
      output: @now_microseconds
    },
    %{
      type: Ash.Type.Boolean,
      type_output: "bool",
      input: true,
      output: true
    },
    %{
      type: Ash.Type.UUID,
      type_output: "binary",
      input: @uuid,
      output: @uuid_raw
    },
    %{
      type: Ash.Type.Binary,
      type_output: "binary",
      input: <<1, 2, 3>>,
      output: <<1, 2, 3>>
    }
  ]

  for %{type: type, type_output: type_output, input: input, output: output} <- @cases do
    escaped_input = Macro.escape(input)
    escaped_output = Macro.escape(output)

    test "type #{type}" do
      assert Conversion.type(unquote(type)) == unquote(type_output)
    end

    test "value #{type}" do
      assert Conversion.value(unquote(type), unquote(escaped_input)) == unquote(escaped_output)
    end

    test "parse #{type}" do
      assert Conversion.parse(unquote(type), unquote(escaped_output)) == unquote(escaped_input)
    end
  end
end
