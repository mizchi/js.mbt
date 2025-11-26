///| Codegen tests

///|
test "to_json_schema converts string schema" {
  let schema = @zod.string()
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("string"))
}

///|
test "to_json_schema converts number schema" {
  let schema = @zod.number()
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("number"))
}

///|
test "to_json_schema converts integer schema" {
  let schema = @zod.number().int()
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("integer"))
}

///|
test "to_json_schema converts boolean schema" {
  let schema = @zod.boolean()
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("boolean"))
}

///|
test "to_json_schema converts array schema" {
  let schema = @zod.array(@zod.string())
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("array"))
  guard json_schema.items() is Some(items)
  assert_eq(items.type_(), Some("string"))
}

///|
test "to_json_schema converts object schema" {
  let schema = @zod.object({ "name": @zod.string(), "age": @zod.number() })
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("object"))
}

///|
test "to_json_schema with string constraints" {
  let schema = @zod.string().min(1).max(100)
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("string"))
  assert_eq(json_schema.min_length(), Some(1))
  assert_eq(json_schema.max_length(), Some(100))
}

///|
test "to_json_schema with number constraints" {
  let schema = @zod.number().gte(0).lte(100)
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("number"))
  assert_eq(json_schema.minimum(), Some(0.0))
  assert_eq(json_schema.maximum(), Some(100.0))
}

///|
test "to_json_schema with email format" {
  let schema = @zod.string().email()
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.format(), Some("email"))
}

///|
test "to_json_schema with enum" {
  let schema = @zod.enum_(["red", "green", "blue"])
  let json_schema = JsonSchema::from_zod(schema)
  guard json_schema.enum_values() is Some(values)
  assert_eq(values.length(), 3)
  assert_eq(values[0], "red")
}

///|
test "to_snake_case converts camelCase" {
  assert_eq(to_snake_case("userName"), "user_name")
  assert_eq(to_snake_case("firstName"), "first_name")
  assert_eq(to_snake_case("id"), "id")
}

///|
test "to_snake_case converts PascalCase" {
  assert_eq(to_snake_case("UserName"), "user_name")
  assert_eq(to_snake_case("FirstName"), "first_name")
}

///|
test "generate_struct creates simple struct" {
  let schema = @zod.object({ "name": @zod.string(), "age": @zod.number().int() })
  let json_schema = JsonSchema::from_zod(schema)
  let code = generate_struct(json_schema, "User")
  inspect(
    code,
    content=(
      #|pub struct User {
      #|  name : String
      #|  age : Int
      #|}
      #|
    ),
  )
}

///|
test "generate_from_zod generates struct code" {
  let schema = @zod.object({
    "id": @zod.number().int(),
    "email": @zod.string().email(),
  })
  let code = generate_from_zod(schema, "Account")
  inspect(
    code,
    content=(
      #|pub struct Account {
      #|  id : Int
      #|  email : String
      #|}
      #|
    ),
  )
}

///|
test "generate_struct with optional fields" {
  let schema = @zod.object({
    "name": @zod.string(),
    "bio": @zod.string().optional(),
  })
  let json_schema = JsonSchema::from_zod(schema)
  let code = generate_struct(json_schema, "Profile")
  inspect(
    code,
    content=(
      #|pub struct Profile {
      #|  name : String
      #|  bio : String?
      #|}
      #|
    ),
  )
}

///|
test "generate_struct with nullable fields" {
  let schema = @zod.object({
    "name": @zod.string(),
    "nickname": @zod.string().nullable(),
  })
  let json_schema = JsonSchema::from_zod(schema)
  let code = generate_struct(json_schema, "Person")
  inspect(
    code,
    content=(
      #|pub struct Person {
      #|  name : String
      #|  nickname : String?
      #|}
      #|
    ),
  )
}

///|
test "generate_struct with nested array" {
  let schema = @zod.object({ "tags": @zod.array(@zod.string()) })
  let json_schema = JsonSchema::from_zod(schema)
  let code = generate_struct(json_schema, "Post")
  inspect(
    code,
    content=(
      #|pub struct Post {
      #|  tags : Array[String]
      #|}
      #|
    ),
  )
}

///|
test "generate_struct with postfix" {
  let schema = @zod.object({ "id": @zod.number().int() })
  let json_schema = JsonSchema::from_zod(schema)
  let code = generate_struct(
    json_schema,
    "Simple",
    struct_postfix="derive(ToJson, @json.FromJson)",
    add_docs=false,
  )
  inspect(
    code,
    content=(
      #|pub struct Simple {
      #|  id : Int
      #|} derive(ToJson, @json.FromJson)
      #|
    ),
  )
}

///|
test "generate_struct with type prefix" {
  let schema = @zod.object({ "id": @zod.number().int() })
  let json_schema = JsonSchema::from_zod(schema)
  let code = generate_struct(json_schema, "User", type_prefix="Api")
  inspect(
    code,
    content=(
      #|pub struct ApiUser {
      #|  id : Int
      #|}
      #|
    ),
  )
}

///|
test "generate_file creates complete file" {
  let types : Array[GeneratedType] = [
    { name: "User", path: [], code: "pub struct User {\n  id : Int\n}\n" },
    { name: "Post", path: [], code: "pub struct Post {\n  title : String\n}\n" },
  ]
  let content = generate_file(types, package_doc="Generated API types")
  inspect(
    content,
    content=(
      #|///| Generated API types
      #|
      #|///|
      #|pub struct User {
      #|  id : Int
      #|}
      #|
      #|///|
      #|pub struct Post {
      #|  title : String
      #|}
      #|
      #|
    ),
  )
}

///|
test "generate complex user schema" {
  let schema = @zod.object({
    "id": @zod.number().int(),
    "username": @zod.string().min(3).max(20),
    "email": @zod.string().email(),
    "age": @zod.number().int().optional(),
    "roles": @zod.array(@zod.string()),
  })
  let code = generate_from_zod(schema, "User")
  inspect(
    code,
    content=(
      #|pub struct User {
      #|  id : Int
      #|  username : String
      #|  email : String
      #|  age : Int?
      #|  roles : Array[String]
      #|}
      #|
    ),
  )
}

///|
test "build_type_name creates underscore-separated names" {
  assert_eq(build_type_name("User", []), "User")
  assert_eq(build_type_name("User", ["address"]), "User_address")
  assert_eq(build_type_name("User", ["address", "city"]), "User_address_city")
  assert_eq(
    build_type_name("Event", ["location", "coord"]),
    "Event_location_coord",
  )
}

///|
test "generate_from_zod_nested with nested object" {
  let address_schema = @zod.object({
    "street": @zod.string(),
    "city": @zod.string(),
    "zipCode": @zod.string(),
  })
  let schema = @zod.object({
    "id": @zod.number().int(),
    "name": @zod.string(),
    "address": address_schema,
  })
  let types = generate_from_zod_nested(schema, "User")
  // Should generate 2 types: User_address and User
  assert_eq(types.length(), 2)
  // First type should be the nested address
  assert_eq(types[0].name, "User_address")
  assert_eq(types[0].path, ["address"])
  inspect(
    types[0].code,
    content=(
      #|pub struct User_address {
      #|  street : String
      #|  city : String
      #|  zip_code : String
      #|}
      #|
    ),
  )
  // Second type should be the root User
  assert_eq(types[1].name, "User")
  assert_eq(types[1].path, [])
  inspect(
    types[1].code,
    content=(
      #|pub struct User {
      #|  id : Int
      #|  name : String
      #|  address : User_address
      #|}
      #|
    ),
  )
}

///|
test "generate_from_zod_nested with deeply nested objects" {
  let coord_schema = @zod.object({ "lat": @zod.number(), "lng": @zod.number() })
  let location_schema = @zod.object({
    "name": @zod.string(),
    "coord": coord_schema,
  })
  let schema = @zod.object({
    "title": @zod.string(),
    "location": location_schema,
  })
  let types = generate_from_zod_nested(schema, "Event")
  // Should generate 3 types: Event_location_coord, Event_location, Event
  assert_eq(types.length(), 3)
  assert_eq(types[0].name, "Event_location_coord")
  assert_eq(types[0].path, ["location", "coord"])
  assert_eq(types[1].name, "Event_location")
  assert_eq(types[1].path, ["location"])
  assert_eq(types[2].name, "Event")
  assert_eq(types[2].path, [])
}

///|
test "generate_from_zod_nested with optional nested object" {
  let meta_schema = @zod.object({ "version": @zod.string() })
  let schema = @zod.object({
    "id": @zod.number().int(),
    "meta": meta_schema.optional(),
  })
  let types = generate_from_zod_nested(schema, "Item")
  assert_eq(types.length(), 2)
  assert_eq(types[0].name, "Item_meta")
  assert_eq(types[0].path, ["meta"])
  inspect(
    types[1].code,
    content=(
      #|pub struct Item {
      #|  id : Int
      #|  meta : Item_meta?
      #|}
      #|
    ),
  )
}

///|
/// Generate MoonBit code and output to snapshot file for type checking
test "generate types snapshot" (t : @test.Test) {
  // Complex schema with nested objects, arrays, optional fields
  let address_schema = @zod.object({
    "street": @zod.string(),
    "city": @zod.string(),
    "zipCode": @zod.string(),
    "country": @zod.string().optional(),
  })
  let user_schema = @zod.object({
    "id": @zod.number().int(),
    "name": @zod.string(),
    "email": @zod.string().email(),
    "age": @zod.number().int().optional(),
    "roles": @zod.array(@zod.string()),
    "address": address_schema,
    "tags": @zod.array(@zod.string()).optional(),
  })
  let types = generate_from_zod_nested(
    user_schema,
    "User",
    struct_prefix="pub(all) ",
    add_docs=false,
  )
  let code = generate_file(
    types,
    package_doc="Generated types for type checking",
  )
  t.writeln(code)
  t.snapshot(filename="_generated_test.mbt")
}
