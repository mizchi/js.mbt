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
