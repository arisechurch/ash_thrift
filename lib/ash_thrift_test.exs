defmodule AshThriftTest do
  use ExUnit.Case, async: true

  describe "into" do
    test "it correctly builds a resource from a struct" do
      uuid = Ecto.UUID.generate()
      now = DateTime.utc_now()

      r =
        %TestApi.V0.Parent{
          id: Ecto.UUID.dump!(uuid),
          body: "content",
          created_at: DateTime.to_unix(now, :microsecond),
          updated_at: DateTime.to_unix(now, :microsecond)
        }
        |> AshThrift.into(TestApi.Parent, "Parent")

      assert %TestApi.Parent{
               id: uuid,
               body: "content",
               created_at: now,
               updated_at: now
             } = r
    end
  end

  describe "dump" do
    test "it correctly dumps a resource into a struct" do
      uuid = Ecto.UUID.generate()
      now = DateTime.utc_now()

      r =
        %TestApi.Parent{
          id: uuid,
          body: "content",
          created_at: now,
          updated_at: now
        }
        |> AshThrift.dump("Parent")

      assert r == %TestApi.V0.Parent{
               id: Ecto.UUID.dump!(uuid),
               body: "content",
               created_at: DateTime.to_unix(now, :microsecond),
               updated_at: DateTime.to_unix(now, :microsecond)
             }
    end

    test "it dumps relationships" do
      test_resource = TestApi.build!(:test_resource)

      assert AshThrift.dump(test_resource, "TestResource") == %TestApi.V0.TestResource{
               id: Ecto.UUID.dump!(test_resource.id),
               active: true,
               body: "test",
               count: nil,
               parent: %TestApi.V0.Parent{
                 id: Ecto.UUID.dump!(test_resource.parent.id),
                 body: "content",
                 children: nil,
                 created_at: DateTime.to_unix(test_resource.parent.created_at, :microsecond),
                 updated_at: DateTime.to_unix(test_resource.parent.updated_at, :microsecond)
               },
               created_at: DateTime.to_unix(test_resource.created_at, :microsecond),
               updated_at: DateTime.to_unix(test_resource.updated_at, :microsecond)
             }
    end

    test "it correctly dumps a partial resource" do
      test_resource = TestApi.build!(:test_resource)

      assert AshThrift.dump(test_resource, "PartialResource") == %TestApi.V0.PartialResource{
               body: "test"
             }
    end
  end
end
