defmodule AshThrift.Generator do
  alias Ash.Resource.Attribute
  alias AshThrift.Conversion
  alias AshThrift.Field
  alias Spark.Dsl.Extension

  def resource(resource) do
    Extension.get_persisted(resource, :thrift)
    |> Enum.map(&thrift_struct/1)
  end

  def namespace({language, namespace}),
    do: """
    namespace #{language} #{namespace}
    """

  def thrift_struct({name, fields}) do
    fields = Enum.map(fields, &field/1)

    """
    struct #{name} {
    #{fields}\
    }
    """
  end

  def field(
        {%Field{id: id, optional: optional},
         %Attribute{
           name: name,
           type: type,
           allow_nil?: allow_nil?
         }}
      ) do
    optional_or_required =
      if optional or allow_nil? do
        "optional"
      else
        "required"
      end

    thrift_type = Conversion.type(type)

    thrift_name = name(name)

    """
    #{id}: #{optional_or_required} #{thrift_type} #{thrift_name};
    """
  end

  def name(name) do
    Macro.camelize(Atom.to_string(name))
    |> then(fn <<first::utf8, rest::binary>> ->
      String.downcase(<<first::utf8>>) <> rest
    end)
  end
end
