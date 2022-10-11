defmodule AshThrift.Extension do
  @field_schema [
    id: [
      type: :integer,
      required: true,
      doc: "The field id number"
    ],
    attribute: [
      type: :atom,
      required: true,
      doc: "The resource attribute to use for this field"
    ],
    optional: [
      type: :boolean,
      required: false,
      doc: "If true, it over-rides the attributes allow_nil?"
    ],
    variant: [
      type: :string,
      required: false,
      doc: "For relationships, specify the thrift struct to use"
    ]
  ]

  @field %Spark.Dsl.Entity{
    name: :field,
    describe: "Maps a resource field to a thrift field",
    examples: [
      "field 1, :name"
    ],
    target: AshThrift.Field,
    args: [:id, :attribute],
    schema: @field_schema
  }

  @struct %Spark.Dsl.Entity{
    name: :thrift_struct,
    describe: "Maps fields to a thrift struct",
    examples: [
      """
      struct "Person" do
        field 1, :name
      end
      """
    ],
    target: AshThrift.Struct,
    entities: [fields: @field],
    args: [:name],
    schema: [
      name: [
        type: :string,
        doc: "Set the struct name",
        required: true
      ]
    ]
  }

  @namespace %Spark.Dsl.Entity{
    name: :namespace,
    describe: "Module namespace for the generated structs",
    examples: [
      """
      thrift do
        namespace MyApi.V0
      end
      """
    ],
    target: AshThrift.DslNamespace,
    args: [:module],
    schema: [
      module: [
        type: :atom,
        doc: "Set the namespace module",
        required: true
      ]
    ]
  }

  @thrift %Spark.Dsl.Section{
    name: :thrift,
    describe: """
    Configure the generated thrift files.
    """,
    entities: [@namespace, @struct],
    schema: []
  }

  use Spark.Dsl.Extension,
    sections: [@thrift],
    transformers: [AshThrift.Transformers.Cache]
end
