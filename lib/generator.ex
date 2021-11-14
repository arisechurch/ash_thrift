defmodule AshThrift.Generator do
  alias Ash.Dsl.Extension
  alias Ash.Resource.Attribute
  alias AshThrift.Conversion
  alias AshThrift.Field

  def namespace({language, namespace}),
    do: """
    namespace #{language} #{namespace}
    """

  def struct(resource) do
    name = Extension.get_opt(resource, [:thrift], :struct_name, "")

    fields =
      Extension.get_persisted(resource, :thrift_fields)
      |> Enum.reverse()
      |> Enum.map(&field/1)

    """
    struct #{name} {
    #{fields}\
    }
    """
  end

  def field(
        {%Field{id: id},
         %Attribute{
           name: name,
           type: type,
           allow_nil?: allow_nil?
         }}
      ) do
    optional_or_required =
      if allow_nil? do
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
