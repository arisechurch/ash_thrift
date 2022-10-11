defmodule TestApi do
  defmodule Parent do
    use Ash.Resource,
      extensions: [AshThrift.Extension],
      data_layer: Ash.DataLayer.Ets

    attributes do
      uuid_primary_key :id

      attribute :body, :string, allow_nil?: false

      create_timestamp :created_at
      update_timestamp :updated_at
    end

    actions do
      defaults [:create, :read, :update, :destroy]
    end

    relationships do
      has_many :children, TestApi.TestResource
    end

    thrift do
      namespace(TestApi.V0)

      thrift_struct "Parent" do
        field(1, :id)
        field(2, :body)
        field(3, :children, variant: "TestResource")
        field(4, :created_at)
        field(5, :updated_at)
      end
    end
  end

  defmodule TestResource do
    use Ash.Resource,
      extensions: [AshThrift.Extension],
      data_layer: Ash.DataLayer.Ets

    attributes do
      uuid_primary_key :id

      attribute :count, :integer
      attribute :body, :string, allow_nil?: false
      attribute :active, :boolean, allow_nil?: false, default: false

      create_timestamp :created_at
      update_timestamp :updated_at
    end

    relationships do
      belongs_to :parent, Parent
    end

    actions do
      defaults [:create, :read, :update, :destroy]
    end

    thrift do
      namespace(TestApi.V0)

      thrift_struct "TestResource" do
        field(1, :id)
        field(2, :count)
        field(3, :body)
        field(4, :active)
        field(5, :parent)
        field(6, :created_at)
        field(7, :updated_at)
      end

      thrift_struct "PartialResource" do
        field(1, :body)
      end
    end
  end

  defmodule Api do
    use Ash.Api

    defmodule Registry do
      use Ash.Registry,
        extensions: [Ash.Registry.ResourceValidations]

      entries do
        entry Parent
        entry TestResource
      end
    end

    resources do
      registry Registry
    end
  end

  def build!(:parent) do
    parent =
      Ash.Changeset.new(Parent, %{
        body: "content"
      })

    Api.create!(parent)
  end

  def build!(:test_resource) do
    parent = build!(:parent)

    Ash.Changeset.new(TestResource, %{
      body: "test",
      active: true
    })
    |> Ash.Changeset.manage_relationship(:parent, parent, type: :append_and_remove)
    |> Api.create!()
  end
end
