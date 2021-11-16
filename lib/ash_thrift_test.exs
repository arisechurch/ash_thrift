defmodule AshThriftTest do
  use ExUnit.Case, async: true

  defmodule ThriftStruct do
    defstruct [
      :id,
      :body,
      :parent,
      :created_at,
      :updated_at
    ]
  end

  defmodule TestStruct do
    defstruct [
      :id,
      :count,
      :body,
      :active,
      :parent,
      :created_at,
      :updated_at
    ]
  end

  describe "into" do
    test "it correctly builds a resource from a struct" do
      uuid = Ecto.UUID.generate()
      now = DateTime.utc_now()

      r =
        %ThriftStruct{
          id: Ecto.UUID.dump!(uuid),
          body: "content",
          created_at: DateTime.to_unix(now, :microsecond),
          updated_at: DateTime.to_unix(now, :microsecond)
        }
        |> AshThrift.into(TestApi.Parent, "Parent")

      assert r == %TestApi.Parent{
               id: uuid,
               body: "content",
               created_at: now,
               updated_at: now
             }
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
        |> AshThrift.dump("Parent", %ThriftStruct{})

      assert r == %ThriftStruct{
               id: Ecto.UUID.dump!(uuid),
               body: "content",
               created_at: DateTime.to_unix(now, :microsecond),
               updated_at: DateTime.to_unix(now, :microsecond)
             }
    end

    test "it ignores relationships" do
      test_resource = TestApi.build!(:test_resource)

      assert AshThrift.dump(test_resource, "TestResource", %TestStruct{}) == %TestStruct{
               id: Ecto.UUID.dump!(test_resource.id),
               active: true,
               body: "test",
               count: nil,
               created_at: DateTime.to_unix(test_resource.created_at, :microsecond),
               updated_at: DateTime.to_unix(test_resource.updated_at, :microsecond)
             }
    end

    test "it correctly dumps a partial resource" do
      test_resource = TestApi.build!(:test_resource)
      assert AshThrift.dump(test_resource, "PartialResource") == %{body: "test"}
    end
  end
end
