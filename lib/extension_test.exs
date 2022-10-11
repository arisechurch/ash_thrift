defmodule AshThrift.ExtensionTest do
  use ExUnit.Case, async: true

  describe "metadata" do
    test "it adds the correct metadata" do
      entities =
        Spark.Dsl.Extension.get_entities(TestApi.Parent, [
          :thrift
        ])

      assert entities == [
               %AshThrift.DslNamespace{module: TestApi.V0},
               %AshThrift.Struct{
                 name: "Parent",
                 fields: [
                   %AshThrift.Field{attribute: :id, id: 1, optional: nil, variant: nil},
                   %AshThrift.Field{attribute: :body, id: 2, optional: nil, variant: nil},
                   %AshThrift.Field{
                     attribute: :children,
                     id: 3,
                     optional: nil,
                     variant: "TestResource"
                   },
                   %AshThrift.Field{attribute: :created_at, id: 4, optional: nil, variant: nil},
                   %AshThrift.Field{attribute: :updated_at, id: 5, optional: nil, variant: nil}
                 ]
               }
             ]
    end
  end
end
