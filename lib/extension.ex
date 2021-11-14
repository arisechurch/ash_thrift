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
    ]
  ]

  @field %Ash.Dsl.Entity{
    name: :field,
    describe: "Maps a resource field to a thrift field",
    examples: [
      "field 1, :name"
    ],
    target: AshThrift.Field,
    args: [:id, :attribute],
    schema: @field_schema
  }

  @thrift %Ash.Dsl.Section{
    name: :thrift,
    describe: """
    Configure the generated thrift files.
    """,
    entities: [@field],
    schema: [
      struct_name: [
        type: :string,
        doc: "Override the thrift struct name"
      ]
    ]
  }

  use Ash.Dsl.Extension,
    sections: [@thrift],
    transformers: [AshThrift.Transformers.CacheFieldAttributes]
end
