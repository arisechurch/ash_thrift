namespace elixir TestApi.V0
namespace rb TestApi.V0


struct Parent {
1: required binary id;
2: required string body;
3: optional list<TestResource> children;
4: required i64 createdAt;
5: required i64 updatedAt;
}
struct PartialResource {
1: required string body;
}
struct TestResource {
1: required binary id;
2: optional i64 count;
3: required string body;
4: required bool active;
5: optional Parent parent;
6: required i64 createdAt;
7: required i64 updatedAt;
}

