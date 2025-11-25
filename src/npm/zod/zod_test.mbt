///|
test "string schema parse" {
  let schema = string()
  let result : String = schema.parse(@js.any("hello")).cast()
  assert_eq(result, "hello")
}

///|
test "number schema parse" {
  let schema = number()
  let result : Int = schema.parse(@js.any(42)).cast()
  assert_eq(result, 42)
}

///|
test "boolean schema parse" {
  let schema = boolean()
  let result : Bool = schema.parse(@js.any(true)).cast()
  assert_eq(result, true)
}

///|
test "string safeParse success" {
  let schema = string()
  let result = schema.safeParse(@js.any("hello"))
  assert_eq(result.success(), true)
  let data : String = result.data().cast()
  assert_eq(data, "hello")
}

///|
test "string safeParse failure" {
  let schema = string()
  let result = schema.safeParse(@js.any(123))
  assert_eq(result.success(), false)
  let issues = result.error().issuesArray()
  assert_eq(issues.length() > 0, true)
}

///|
test "string min max" {
  let schema = string().min(2).max(5)
  // Valid
  let r1 = schema.safeParse(@js.any("abc"))
  assert_eq(r1.success(), true)
  // Too short
  let r2 = schema.safeParse(@js.any("a"))
  assert_eq(r2.success(), false)
  // Too long
  let r3 = schema.safeParse(@js.any("abcdef"))
  assert_eq(r3.success(), false)
}

///|
test "string email" {
  let schema = string().email()
  let r1 = schema.safeParse(@js.any("test@example.com"))
  assert_eq(r1.success(), true)
  let r2 = schema.safeParse(@js.any("not-an-email"))
  assert_eq(r2.success(), false)
}

///|
test "number int positive" {
  let schema = number().int().positive()
  let r1 = schema.safeParse(@js.any(5))
  assert_eq(r1.success(), true)
  let r2 = schema.safeParse(@js.any(-5))
  assert_eq(r2.success(), false)
}

///|
test "object schema" {
  let shape = @js.Object::new()
  shape.set("name", string())
  shape.set("age", number())
  let schema = object(shape.to_any())
  let data = @js.Object::new()
  data.set("name", "Alice")
  data.set("age", 30)
  let result = schema.safeParse(data.to_any())
  assert_eq(result.success(), true)
}

///|
test "object schema invalid" {
  let shape = @js.Object::new()
  shape.set("name", string())
  shape.set("age", number())
  let schema = object(shape.to_any())
  let data = @js.Object::new()
  data.set("name", 123) // should be string
  data.set("age", "not a number") // should be number
  let result = schema.safeParse(data.to_any())
  assert_eq(result.success(), false)
}

///|
test "array schema" {
  let schema = array(number())
  let data = @js.from_array([1, 2, 3])
  let result = schema.safeParse(data)
  assert_eq(result.success(), true)
}

///|
test "array nonempty" {
  let schema = array(number()).nonempty()
  let r1 = schema.safeParse(@js.from_array([1]))
  assert_eq(r1.success(), true)
  let empty : Array[Int] = []
  let r2 = schema.safeParse(@js.from_array(empty))
  assert_eq(r2.success(), false)
}

///|
test "enum schema" {
  let schema = enum_(["red", "green", "blue"])
  let r1 = schema.safeParse(@js.any("red"))
  assert_eq(r1.success(), true)
  let r2 = schema.safeParse(@js.any("yellow"))
  assert_eq(r2.success(), false)
}

///|
test "literal schema" {
  let schema = literal(@js.any("hello"))
  let r1 = schema.safeParse(@js.any("hello"))
  assert_eq(r1.success(), true)
  let r2 = schema.safeParse(@js.any("world"))
  assert_eq(r2.success(), false)
}

///|
test "optional schema" {
  let schema = string().optional()
  let r1 = schema.safeParse(@js.any("hello"))
  assert_eq(r1.success(), true)
  let r2 = schema.safeParse(@js.undefined())
  assert_eq(r2.success(), true)
}

///|
test "nullable schema" {
  let schema = string().nullable()
  let r1 = schema.safeParse(@js.any("hello"))
  assert_eq(r1.success(), true)
  let r2 = schema.safeParse(@js.null_())
  assert_eq(r2.success(), true)
}

///|
test "default value" {
  let schema = string().default_(@js.any("default"))
  let result = schema.parse(@js.undefined())
  let s : String = result.cast()
  assert_eq(s, "default")
}

///|
test "union schema" {
  let schema = union([string(), number()])
  let r1 = schema.safeParse(@js.any("hello"))
  assert_eq(r1.success(), true)
  let r2 = schema.safeParse(@js.any(42))
  assert_eq(r2.success(), true)
  let r3 = schema.safeParse(@js.any(true))
  assert_eq(r3.success(), false)
}

///|
test "transform" {
  let schema = string().transform(fn(s) { @js.any(s.to_string().to_upper()) })
  let result : String = schema.parse(@js.any("hello")).cast()
  assert_eq(result, "HELLO")
}

///|
test "ZodIssue path" {
  let shape = @js.Object::new()
  shape.set(
    "user",
    object(
      {
        let inner = @js.Object::new()
        inner.set("name", string())
        inner.to_any()
      },
    ),
  )
  let schema = object(shape.to_any())
  let data = @js.Object::new()
  let user = @js.Object::new()
  user.set("name", 123) // should be string
  data.set("user", user)
  let result = schema.safeParse(data.to_any())
  assert_eq(result.success(), false)
  let issues = result.error().issuesArray()
  assert_eq(issues.length() > 0, true)
}

///|
test "string regex" {
  let schema = string().regex("^[a-z]+$")
  let r1 = schema.safeParse(@js.any("abc"))
  assert_eq(r1.success(), true)
  let r2 = schema.safeParse(@js.any("ABC"))
  assert_eq(r2.success(), false)
}

///|
test "string url validation" {
  let schema = string().url()
  let r1 = schema.safeParse(@js.any("https://example.com"))
  assert_eq(r1.success(), true)
  let r2 = schema.safeParse(@js.any("not-a-url"))
  assert_eq(r2.success(), false)
}

///|
test "string uuid validation" {
  let schema = string().uuid()
  let r1 = schema.safeParse(@js.any("550e8400-e29b-41d4-a716-446655440000"))
  assert_eq(r1.success(), true)
  let r2 = schema.safeParse(@js.any("not-a-uuid"))
  assert_eq(r2.success(), false)
}

///|
test "string startsWith and endsWith" {
  let schema1 = string().startsWith("hello")
  assert_eq(schema1.safeParse(@js.any("hello world")).success(), true)
  assert_eq(schema1.safeParse(@js.any("world hello")).success(), false)
  let schema2 = string().endsWith("world")
  assert_eq(schema2.safeParse(@js.any("hello world")).success(), true)
  assert_eq(schema2.safeParse(@js.any("world hello")).success(), false)
}

///|
test "string trim transform" {
  let schema = string().trim()
  let result : String = schema.parse(@js.any("  hello  ")).cast()
  assert_eq(result, "hello")
}

///|
test "string toLowerCase and toUpperCase" {
  let schema1 = string().toLowerCase()
  let r1 : String = schema1.parse(@js.any("HELLO")).cast()
  assert_eq(r1, "hello")
  let schema2 = string().toUpperCase()
  let r2 : String = schema2.parse(@js.any("hello")).cast()
  assert_eq(r2, "HELLO")
}

///|
test "string length exact" {
  let schema = string().length(5)
  assert_eq(schema.safeParse(@js.any("hello")).success(), true)
  assert_eq(schema.safeParse(@js.any("hi")).success(), false)
  assert_eq(schema.safeParse(@js.any("hello world")).success(), false)
}

///|
test "string includes" {
  let schema = string().includes("world")
  assert_eq(schema.safeParse(@js.any("hello world")).success(), true)
  assert_eq(schema.safeParse(@js.any("hello")).success(), false)
}

///|
test "string datetime" {
  let schema = string().datetime()
  assert_eq(schema.safeParse(@js.any("2024-01-01T00:00:00Z")).success(), true)
  assert_eq(schema.safeParse(@js.any("not-a-datetime")).success(), false)
}

///|
test "string ipv4 and ipv6" {
  let schema1 = string().ipv4()
  assert_eq(schema1.safeParse(@js.any("192.168.1.1")).success(), true)
  assert_eq(schema1.safeParse(@js.any("not-an-ip")).success(), false)
  let schema2 = string().ipv6()
  assert_eq(schema2.safeParse(@js.any("::1")).success(), true)
  assert_eq(
    schema2
    .safeParse(@js.any("2001:0db8:85a3:0000:0000:8a2e:0370:7334"))
    .success(),
    true,
  )
  assert_eq(schema2.safeParse(@js.any("192.168.1.1")).success(), false)
}

///|
test "number gt gte lt lte" {
  let schema1 = number().gt(5)
  assert_eq(schema1.safeParse(@js.any(6)).success(), true)
  assert_eq(schema1.safeParse(@js.any(5)).success(), false)
  let schema2 = number().gte(5)
  assert_eq(schema2.safeParse(@js.any(5)).success(), true)
  assert_eq(schema2.safeParse(@js.any(4)).success(), false)
  let schema3 = number().lt(5)
  assert_eq(schema3.safeParse(@js.any(4)).success(), true)
  assert_eq(schema3.safeParse(@js.any(5)).success(), false)
  let schema4 = number().lte(5)
  assert_eq(schema4.safeParse(@js.any(5)).success(), true)
  assert_eq(schema4.safeParse(@js.any(6)).success(), false)
}

///|
test "number negative nonnegative nonpositive" {
  let schema1 = number().negative()
  assert_eq(schema1.safeParse(@js.any(-1)).success(), true)
  assert_eq(schema1.safeParse(@js.any(0)).success(), false)
  let schema2 = number().nonnegative()
  assert_eq(schema2.safeParse(@js.any(0)).success(), true)
  assert_eq(schema2.safeParse(@js.any(-1)).success(), false)
  let schema3 = number().nonpositive()
  assert_eq(schema3.safeParse(@js.any(0)).success(), true)
  assert_eq(schema3.safeParse(@js.any(1)).success(), false)
}

///|
test "number finite" {
  let schema = number().finite()
  assert_eq(schema.safeParse(@js.any(100)).success(), true)
}

///|
test "number multipleOf" {
  let schema = number().multipleOf(5)
  assert_eq(schema.safeParse(@js.any(10)).success(), true)
  assert_eq(schema.safeParse(@js.any(7)).success(), false)
}

///|
test "tuple schema" {
  let schema = tuple([string(), number()])
  let valid_data = @js.from_array([@js.any("hello"), @js.any(42)])
  assert_eq(schema.safeParse(valid_data).success(), true)
  let invalid_data = @js.from_array([@js.any(42), @js.any("hello")])
  assert_eq(schema.safeParse(invalid_data).success(), false)
}

///|
test "record schema" {
  let schema = record(string(), number())
  let data = @js.Object::new()
  data.set("a", 1)
  data.set("b", 2)
  assert_eq(schema.safeParse(data.to_any()).success(), true)
  let invalid = @js.Object::new()
  invalid.set("a", "not-a-number")
  assert_eq(schema.safeParse(invalid.to_any()).success(), false)
}

///|
test "intersection schema" {
  let shape1 = @js.Object::new()
  shape1.set("name", string())
  let shape2 = @js.Object::new()
  shape2.set("age", number())
  let schema = intersection(object(shape1.to_any()), object(shape2.to_any()))
  let valid = @js.Object::new()
  valid.set("name", "Alice")
  valid.set("age", 30)
  assert_eq(schema.safeParse(valid.to_any()).success(), true)
  let invalid = @js.Object::new()
  invalid.set("name", "Alice")
  // missing age
  assert_eq(schema.safeParse(invalid.to_any()).success(), false)
}

///|
test "object extend" {
  let shape = @js.Object::new()
  shape.set("name", string())
  let base_schema = object(shape.to_any())
  let ext_shape = @js.Object::new()
  ext_shape.set("age", number())
  let extended = base_schema.extend(ext_shape.to_any())
  let data = @js.Object::new()
  data.set("name", "Alice")
  data.set("age", 30)
  assert_eq(extended.safeParse(data.to_any()).success(), true)
}

///|
test "object pick and omit" {
  let shape = @js.Object::new()
  shape.set("name", string())
  shape.set("age", number())
  shape.set("email", string())
  let schema = object(shape.to_any())
  // Pick only name
  let pick_keys = @js.Object::new()
  pick_keys.set("name", @js.any(true))
  let picked = schema.pick(pick_keys.to_any())
  let pick_data = @js.Object::new()
  pick_data.set("name", "Alice")
  assert_eq(picked.safeParse(pick_data.to_any()).success(), true)
  // Omit email
  let omit_keys = @js.Object::new()
  omit_keys.set("email", @js.any(true))
  let omitted = schema.omit(omit_keys.to_any())
  let omit_data = @js.Object::new()
  omit_data.set("name", "Alice")
  omit_data.set("age", 30)
  assert_eq(omitted.safeParse(omit_data.to_any()).success(), true)
}

///|
test "object partial and required" {
  let shape = @js.Object::new()
  shape.set("name", string())
  shape.set("age", number())
  let schema = object(shape.to_any())
  // Partial - all optional
  let partial_schema = schema.partial()
  let empty = @js.Object::new()
  assert_eq(partial_schema.safeParse(empty.to_any()).success(), true)
  // Required - all required
  let required_schema = partial_schema.required_()
  assert_eq(required_schema.safeParse(empty.to_any()).success(), false)
}

///|
test "object passthrough strict strip" {
  let shape = @js.Object::new()
  shape.set("name", string())
  // Passthrough - allows extra keys
  let passthrough_schema = object(shape.to_any()).passthrough()
  let data = @js.Object::new()
  data.set("name", "Alice")
  data.set("extra", "field")
  assert_eq(passthrough_schema.safeParse(data.to_any()).success(), true)
  // Strict - rejects extra keys
  let strict_schema = object(shape.to_any()).strict()
  assert_eq(strict_schema.safeParse(data.to_any()).success(), false)
  // Strip - removes extra keys (still valid)
  let strip_schema = object(shape.to_any()).strip()
  assert_eq(strip_schema.safeParse(data.to_any()).success(), true)
}

///|
test "refine custom validation" {
  let schema = string().refine(
    fn(val) {
      let s : String = val.cast()
      s.length() > 3
    },
    message="Must be longer than 3 characters",
  )
  assert_eq(schema.safeParse(@js.any("hello")).success(), true)
  assert_eq(schema.safeParse(@js.any("hi")).success(), false)
}

///|
test "nullish schema" {
  let schema = string().nullish()
  assert_eq(schema.safeParse(@js.any("hello")).success(), true)
  assert_eq(schema.safeParse(@js.null_()).success(), true)
  assert_eq(schema.safeParse(@js.undefined()).success(), true)
}

///|
test "catch default on error" {
  let schema = string().catch_(@js.any("default"))
  // Invalid input returns default
  let result : String = schema.parse(@js.any(123)).cast()
  assert_eq(result, "default")
  // Valid input returns actual value
  let result2 : String = schema.parse(@js.any("hello")).cast()
  assert_eq(result2, "hello")
}

///|
test "pipe schemas" {
  // Parse string then transform to number via coercion
  let schema = string().pipe(coerce_number())
  let result : Int = schema.parse(@js.any("42")).cast()
  assert_eq(result, 42)
}

///|
test "coerce string" {
  let schema = coerce_string()
  let r1 : String = schema.parse(@js.any(123)).cast()
  assert_eq(r1, "123")
  let r2 : String = schema.parse(@js.any(true)).cast()
  assert_eq(r2, "true")
}

///|
test "coerce number" {
  let schema = coerce_number()
  let r1 : Int = schema.parse(@js.any("42")).cast()
  assert_eq(r1, 42)
}

///|
test "coerce boolean" {
  let schema = coerce_boolean()
  let r1 : Bool = schema.parse(@js.any("true")).cast()
  assert_eq(r1, true)
  let r2 : Bool = schema.parse(@js.any("")).cast()
  assert_eq(r2, false)
}

///|
test "describe adds description" {
  let schema = string().describe("A user's name")
  // Just verify it doesn't throw
  assert_eq(schema.safeParse(@js.any("Alice")).success(), true)
}

///|
test "map schema" {
  let schema = map(string(), number())
  // Maps require specific JS Map constructor, so just verify schema creation
  assert_false(@js.is_undefined(schema.to_any()))
}

///|
test "set schema" {
  let schema = set(number())
  // Sets require specific JS Set constructor, so just verify schema creation
  assert_false(@js.is_undefined(schema.to_any()))
}
