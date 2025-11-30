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
  let schema = @js.from_json({ "type": "object" })
  let validate = ajv.compile(schema)
  @js.typeof_(validate) |> assert_eq("function")
}

///|
test "validate valid object" {
  let ajv = Ajv::new()
  let schema = @js.from_json({
    "type": "object",
    "properties": { "foo": { "type": "integer" } },
  })
  let validate = ajv.compile(schema)
  // Valid data
  let data = @js.from_json({ "foo": 42 })
  assert_eq(validate.validate(data), true)
}

///|
test "validate invalid object" {
  let ajv = Ajv::new()
  let schema = @js.from_json({
    "type": "object",
    "properties": { "foo": { "type": "integer" } },
  })
  let validate = ajv.compile(schema)
  // Invalid data - foo should be integer but is string
  let data = @js.from_json({ "foo": "not an integer" })
  assert_eq(validate.validate(data), false)
}

///|
test "validate returns errors" {
  let ajv = Ajv::new()
  let schema = @js.from_json({
    "type": "object",
    "properties": { "foo": { "type": "integer" } },
  })
  let validate = ajv.compile(schema)
  // Invalid data
  let data = @js.from_json({ "foo": "not an integer" })
  let _ = validate.validate(data)
  let errors = validate.errors_array()
  assert_eq(errors.length() > 0, true)
  assert_eq(errors[0].keyword, "type")
}

///|
test "validate required property" {
  let ajv = Ajv::new()
  let schema = @js.from_json({
    "type": "object",
    "properties": { "foo": { "type": "string" } },
    "required": ["foo"],
  })
  let validate = ajv.compile(schema)
  // Missing required property
  let data = @js.Object::new()
  assert_eq(validate.validate(data.as_any()), false)
  let errors = validate.errors_array()
  assert_eq(errors[0].keyword, "required")
}

///|
test "validate additionalProperties false" {
  let ajv = Ajv::new()
  let schema = @js.from_json({
    "type": "object",
    "properties": { "foo": { "type": "string" } },
    "additionalProperties": false,
  })
  let validate = ajv.compile(schema)
  // Data with additional property
  let data = @js.from_json({ "foo": "bar", "extra": "not allowed" })
  assert_eq(validate.validate(data), false)
  let errors = validate.errors_array()
  assert_eq(errors[0].keyword, "additionalProperties")
}

///|
test "addSchema and getSchema" {
  let ajv = Ajv::new()
  let schema = @js.from_json({ "type": "string" })
  ajv.addSchema(schema, key="mySchema") |> ignore
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
  let schema = @js.from_json({ "type": "array", "items": { "type": "number" } })
  let validate = ajv.compile(schema)
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
  let schema = @js.from_json({ "type": "string", "minLength": 3 })
  let validate = ajv.compile(schema)
  assert_eq(validate.validate(@js.any("abc")), true)
  assert_eq(validate.validate(@js.any("ab")), false)
}

///|
test "validate number with minimum" {
  let ajv = Ajv::new()
  let schema = @js.from_json({ "type": "number", "minimum": 10 })
  let validate = ajv.compile(schema)
  assert_eq(validate.validate(@js.any(15)), true)
  assert_eq(validate.validate(@js.any(5)), false)
}

///|
test "validate with pattern" {
  let ajv = Ajv::new()
  let schema = @js.from_json({ "type": "string", "pattern": "^[a-z]+$" })
  let validate = ajv.compile(schema)
  assert_eq(validate.validate(@js.any("abc")), true)
  assert_eq(validate.validate(@js.any("ABC")), false)
  assert_eq(validate.validate(@js.any("123")), false)
}

///|
test "validate enum" {
  let ajv = Ajv::new()
  let schema = @js.from_json({ "enum": ["red", "green", "blue"] })
  let validate = ajv.compile(schema)
  assert_eq(validate.validate(@js.any("red")), true)
  assert_eq(validate.validate(@js.any("yellow")), false)
}

///|
test "Ajv.validate direct method" {
  let ajv = Ajv::new()
  let schema = @js.from_json({ "type": "string" })
  assert_eq(ajv.validate(schema, @js.any("hello")), true)
  assert_eq(ajv.validate(schema, @js.any(123)), false)
}

///|
test "allErrors option collects all errors" {
  let ajv = Ajv::new(all_errors=true)
  let schema = @js.from_json({
    "type": "object",
    "properties": { "foo": { "type": "integer" }, "bar": { "type": "string" } },
  })
  let validate = ajv.compile(schema)
  // Both properties invalid
  let data = @js.from_json({ "foo": "not integer", "bar": 123 })
  let _ = validate.validate(data)
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
  let schema = @js.from_json({ "type": "string" })
  ajv.addSchema(schema, key="test") |> ignore
  // Verify it exists
  guard ajv.getSchema("test") is Some(_)
  // Remove it
  ajv.removeSchema("test") |> ignore
  // Verify it's gone
  guard ajv.getSchema("test") is None
}
