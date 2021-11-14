defmodule AshThrift.ExtensionTest do
  use ExUnit.Case, async: true

  describe "metadata" do
    test "it adds the correct metadata" do
      entities =
        Ash.Dsl.Extension.get_entities(TestApi.Parent, [
          :thrift
        ])

      grouped = Enum.group_by(entities, &Map.get(&1, :__struct__))

      assert grouped == %{
               AshThrift.Field => [
                 %AshThrift.Field{attribute: :id, id: 1},
                 %AshThrift.Field{attribute: :body, id: 2},
                 %AshThrift.Field{attribute: :created_at, id: 3},
                 %AshThrift.Field{attribute: :updated_at, id: 4}
               ]
             }
    end
  end
end
