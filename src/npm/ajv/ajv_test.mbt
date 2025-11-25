///|
test "Ajv instance creation" {
  let ajv = Ajv::new()
  @js.typeof_(ajv) |> assert_eq("object")
}

///|
test "Ajv with allErrors option" {
  let ajv = Ajv::new(all_errors=true)
  @js.typeof_(ajv) |> assert_eq("object")
}

///|
test "compile returns ValidateFunction" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "object")
  let validate = ajv.compile(schema.to_any())
  @js.typeof_(validate) |> assert_eq("function")
}

///|
test "validate valid object" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "object")
  let props = @js.Object::new()
  let foo_schema = @js.Object::new()
  foo_schema.set("type", "integer")
  props.set("foo", foo_schema)
  schema.set("properties", props)
  let validate = ajv.compile(schema.to_any())
  // Valid data
  let data = @js.Object::new()
  data.set("foo", 42)
  assert_eq(validate.validate(data.to_any()), true)
}

///|
test "validate invalid object" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "object")
  let props = @js.Object::new()
  let foo_schema = @js.Object::new()
  foo_schema.set("type", "integer")
  props.set("foo", foo_schema)
  schema.set("properties", props)
  let validate = ajv.compile(schema.to_any())
  // Invalid data - foo should be integer but is string
  let data = @js.Object::new()
  data.set("foo", "not an integer")
  assert_eq(validate.validate(data.to_any()), false)
}

///|
test "validate returns errors" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "object")
  let props = @js.Object::new()
  let foo_schema = @js.Object::new()
  foo_schema.set("type", "integer")
  props.set("foo", foo_schema)
  schema.set("properties", props)
  let validate = ajv.compile(schema.to_any())
  // Invalid data
  let data = @js.Object::new()
  data.set("foo", "not an integer")
  let _ = validate.validate(data.to_any())
  let errors = validate.errors_array()
  assert_eq(errors.length() > 0, true)
  assert_eq(errors[0].keyword, "type")
}

///|
test "validate required property" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "object")
  let props = @js.Object::new()
  let foo_schema = @js.Object::new()
  foo_schema.set("type", "string")
  props.set("foo", foo_schema)
  schema.set("properties", props)
  schema.set("required", @js.from_array(["foo"]))
  let validate = ajv.compile(schema.to_any())
  // Missing required property
  let data = @js.Object::new()
  assert_eq(validate.validate(data.to_any()), false)
  let errors = validate.errors_array()
  assert_eq(errors[0].keyword, "required")
}

///|
test "validate additionalProperties false" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "object")
  let props = @js.Object::new()
  let foo_schema = @js.Object::new()
  foo_schema.set("type", "string")
  props.set("foo", foo_schema)
  schema.set("properties", props)
  schema.set("additionalProperties", false)
  let validate = ajv.compile(schema.to_any())
  // Data with additional property
  let data = @js.Object::new()
  data.set("foo", "bar")
  data.set("extra", "not allowed")
  assert_eq(validate.validate(data.to_any()), false)
  let errors = validate.errors_array()
  assert_eq(errors[0].keyword, "additionalProperties")
}

///|
test "addSchema and getSchema" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "string")
  ajv.addSchema(schema.to_any(), key="mySchema") |> ignore
  let retrieved = ajv.getSchema("mySchema")
  guard retrieved is Some(validate)
  @js.typeof_(validate) |> assert_eq("function")
}

///|
test "getSchema returns None for unknown" {
  let ajv = Ajv::new()
  let result = ajv.getSchema("unknown")
  guard result is None
}

///|
test "validate array type" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "array")
  let items = @js.Object::new()
  items.set("type", "number")
  schema.set("items", items)
  let validate = ajv.compile(schema.to_any())
  // Valid array
  let data = @js.from_array([1, 2, 3])
  assert_eq(validate.validate(data), true)
  // Invalid array - mixed types via extern
  let data2 = make_mixed_array()
  assert_eq(validate.validate(data2), false)
}

///|
extern "js" fn make_mixed_array() -> @js.Any =
  #| () => [1, "two", 3]

///|
test "validate string with minLength" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "string")
  schema.set("minLength", 3)
  let validate = ajv.compile(schema.to_any())
  assert_eq(validate.validate(@js.any("abc")), true)
  assert_eq(validate.validate(@js.any("ab")), false)
}

///|
test "validate number with minimum" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "number")
  schema.set("minimum", 10)
  let validate = ajv.compile(schema.to_any())
  assert_eq(validate.validate(@js.any(15)), true)
  assert_eq(validate.validate(@js.any(5)), false)
}

///|
test "validate with pattern" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "string")
  schema.set("pattern", "^[a-z]+$")
  let validate = ajv.compile(schema.to_any())
  assert_eq(validate.validate(@js.any("abc")), true)
  assert_eq(validate.validate(@js.any("ABC")), false)
  assert_eq(validate.validate(@js.any("123")), false)
}

///|
test "validate enum" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("enum", @js.from_array(["red", "green", "blue"]))
  let validate = ajv.compile(schema.to_any())
  assert_eq(validate.validate(@js.any("red")), true)
  assert_eq(validate.validate(@js.any("yellow")), false)
}

///|
test "Ajv.validate direct method" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "string")
  assert_eq(ajv.validate(schema.to_any(), @js.any("hello")), true)
  assert_eq(ajv.validate(schema.to_any(), @js.any(123)), false)
}

///|
test "allErrors option collects all errors" {
  let ajv = Ajv::new(all_errors=true)
  let schema = @js.Object::new()
  schema.set("type", "object")
  let props = @js.Object::new()
  let foo_schema = @js.Object::new()
  foo_schema.set("type", "integer")
  let bar_schema = @js.Object::new()
  bar_schema.set("type", "string")
  props.set("foo", foo_schema)
  props.set("bar", bar_schema)
  schema.set("properties", props)
  let validate = ajv.compile(schema.to_any())
  // Both properties invalid
  let data = @js.Object::new()
  data.set("foo", "not integer")
  data.set("bar", 123)
  let _ = validate.validate(data.to_any())
  let errors = validate.errors_array()
  // With allErrors, should have 2 errors
  assert_eq(errors.length(), 2)
}

///|
test "schema_from_json helper" {
  let ajv = Ajv::new()
  let schema = schema_from_json("{\"type\": \"string\", \"minLength\": 1}") catch {
    _ => panic()
  }
  let validate = ajv.compile(schema)
  assert_eq(validate.validate(@js.any("hello")), true)
  assert_eq(validate.validate(@js.any("")), false)
}

///|
test "removeSchema" {
  let ajv = Ajv::new()
  let schema = @js.Object::new()
  schema.set("type", "string")
  ajv.addSchema(schema.to_any(), key="test") |> ignore
  // Verify it exists
  guard ajv.getSchema("test") is Some(_)
  // Remove it
  ajv.removeSchema("test") |> ignore
  // Verify it's gone
  guard ajv.getSchema("test") is None
}
