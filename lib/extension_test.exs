defmodule AshThrift.ExtensionTest do
  use ExUnit.Case, async: true

  describe "metadata" do
    test "it adds the correct metadata" do
      entities =
        Spark.Dsl.Extension.get_entities(TestApi.Parent, [
          :thrift
        ])

      assert entities == [
               %AshThrift.Struct{
                 name: "Parent",
                 fields: [
                   %AshThrift.Field{attribute: :id, id: 1, optional: false},
                   %AshThrift.Field{attribute: :body, id: 2, optional: false},
                   %AshThrift.Field{attribute: :created_at, id: 3, optional: false},
                   %AshThrift.Field{attribute: :updated_at, id: 4, optional: false}
                 ]
               }
             ]
    end
  end
end
