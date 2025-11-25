///| Codegen tests

///|
test "to_json_schema converts string schema" {
  let schema = string()
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("string"))
}

///|
test "to_json_schema converts number schema" {
  let schema = number()
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("number"))
}

///|
test "to_json_schema converts integer schema" {
  let schema = number().int()
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("integer"))
}

///|
test "to_json_schema converts boolean schema" {
  let schema = boolean()
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("boolean"))
}

///|
test "to_json_schema converts array schema" {
  let schema = array(string())
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("array"))
  guard json_schema.items() is Some(items)
  assert_eq(items.type_(), Some("string"))
}

///|
test "to_json_schema converts object schema" {
  let shape = @js.Object::new()
  shape.set("name", string())
  shape.set("age", number())
  let schema = object(shape.to_any())
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("object"))
}

///|
test "to_json_schema with string constraints" {
  let schema = string().min(1).max(100)
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("string"))
  assert_eq(json_schema.min_length(), Some(1))
  assert_eq(json_schema.max_length(), Some(100))
}

///|
test "to_json_schema with number constraints" {
  let schema = number().gte(0).lte(100)
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.type_(), Some("number"))
  assert_eq(json_schema.minimum(), Some(0.0))
  assert_eq(json_schema.maximum(), Some(100.0))
}

///|
test "to_json_schema with email format" {
  let schema = string().email()
  let json_schema = JsonSchema::from_zod(schema)
  assert_eq(json_schema.format(), Some("email"))
}

///|
test "to_json_schema with enum" {
  let schema = enum_(["red", "green", "blue"])
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
test "json_type_to_moonbit converts basic types" {
  let str_schema = JsonSchema::from_zod(string())
  assert_eq(json_type_to_moonbit(str_schema), "String")
  let num_schema = JsonSchema::from_zod(number())
  assert_eq(json_type_to_moonbit(num_schema), "Double")
  let int_schema = JsonSchema::from_zod(number().int())
  assert_eq(json_type_to_moonbit(int_schema), "Int")
  let bool_schema = JsonSchema::from_zod(boolean())
  assert_eq(json_type_to_moonbit(bool_schema), "Bool")
}

///|
test "json_type_to_moonbit converts array" {
  let arr_schema = JsonSchema::from_zod(array(string()))
  assert_eq(json_type_to_moonbit(arr_schema), "Array[String]")
}

///|
test "generate_struct creates simple struct" {
  let shape = @js.Object::new()
  shape.set("name", string())
  shape.set("age", number().int())
  let schema = object(shape.to_any())
  let json_schema = JsonSchema::from_zod(schema)
  let config = CodegenConfig::default()
  let code = generate_struct(json_schema, "User", config)
  assert_eq(code.contains("pub struct User"), true)
  assert_eq(code.contains("name : String"), true)
  assert_eq(code.contains("age : Int"), true)
}

///|
test "generate_from_zod generates struct code" {
  let shape = @js.Object::new()
  shape.set("id", number().int())
  shape.set("email", string().email())
  let schema = object(shape.to_any())
  let code = generate_from_zod(schema, "Account")
  assert_eq(code.contains("pub struct Account"), true)
  assert_eq(code.contains("#derive(ToJson, FromJson)"), true)
}

///|
test "generate_struct with optional fields" {
  let shape = @js.Object::new()
  shape.set("name", string())
  shape.set("bio", string().optional())
  let schema = object(shape.to_any())
  let json_schema = JsonSchema::from_zod(schema)
  let code = generate_struct(json_schema, "Profile", CodegenConfig::default())
  // bio should be optional
  assert_eq(code.contains("bio : String?"), true)
}

///|
test "generate_struct with nullable fields" {
  let shape = @js.Object::new()
  shape.set("name", string())
  shape.set("nickname", string().nullable())
  let schema = object(shape.to_any())
  let json_schema = JsonSchema::from_zod(schema)
  let code = generate_struct(json_schema, "Person", CodegenConfig::default())
  // nickname should be nullable (shown as optional in MoonBit)
  assert_eq(code.contains("nickname : String?"), true)
}

///|
test "generate_struct with nested array" {
  let shape = @js.Object::new()
  shape.set("tags", array(string()))
  let schema = object(shape.to_any())
  let json_schema = JsonSchema::from_zod(schema)
  let code = generate_struct(json_schema, "Post", CodegenConfig::default())
  assert_eq(code.contains("tags : Array[String]"), true)
}

///|
test "generate_struct without derive" {
  let shape = @js.Object::new()
  shape.set("id", number().int())
  let schema = object(shape.to_any())
  let json_schema = JsonSchema::from_zod(schema)
  let config : CodegenConfig = {
    type_prefix: "",
    derive_json: false,
    add_docs: false,
  }
  let code = generate_struct(json_schema, "Simple", config)
  assert_eq(code.contains("#derive"), false)
}

///|
test "generate_struct with type prefix" {
  let shape = @js.Object::new()
  shape.set("id", number().int())
  let schema = object(shape.to_any())
  let json_schema = JsonSchema::from_zod(schema)
  let config : CodegenConfig = {
    type_prefix: "Api",
    derive_json: true,
    add_docs: true,
  }
  let code = generate_struct(json_schema, "User", config)
  assert_eq(code.contains("pub struct ApiUser"), true)
}

///|
test "generate_file creates complete file" {
  let types : Array[GeneratedType] = [
    { name: "User", code: "pub struct User {\n  id : Int\n}\n" },
    { name: "Post", code: "pub struct Post {\n  title : String\n}\n" },
  ]
  let content = generate_file(types, package_doc="Generated API types")
  assert_eq(content.contains("///| Generated API types"), true)
  assert_eq(content.contains("pub struct User"), true)
  assert_eq(content.contains("pub struct Post"), true)
}

///|
test "generate complex user schema" {
  // Create a complex user schema using zod
  let address_shape = @js.Object::new()
  address_shape.set("street", string())
  address_shape.set("city", string())
  address_shape.set("zip", string())
  let user_shape = @js.Object::new()
  user_shape.set("id", number().int())
  user_shape.set("username", string().min(3).max(20))
  user_shape.set("email", string().email())
  user_shape.set("age", number().int().optional())
  user_shape.set("roles", array(string()))
  let schema = object(user_shape.to_any())
  let code = generate_from_zod(schema, "User")
  assert_eq(code.contains("pub struct User"), true)
  assert_eq(code.contains("id : Int"), true)
  assert_eq(code.contains("username : String"), true)
  assert_eq(code.contains("email : String"), true)
  assert_eq(code.contains("age : Int?"), true)
  assert_eq(code.contains("roles : Array[String]"), true)
}
