///| DSL tests

///|
test "DSL str() builds string schema" {
  let schema = str().build()
  let result = schema.safeParse(@js.any("hello"))
  assert_eq(result.success(), true)
}

///|
test "DSL String with rules" {
  let schema = Schema::String([StringRule::Min(2), StringRule::Max(5)]).build()
  assert_eq(schema.safeParse(@js.any("abc")).success(), true)
  assert_eq(schema.safeParse(@js.any("a")).success(), false)
  assert_eq(schema.safeParse(@js.any("abcdef")).success(), false)
}

///|
test "DSL email() shorthand" {
  let schema = email().build()
  assert_eq(schema.safeParse(@js.any("test@example.com")).success(), true)
  assert_eq(schema.safeParse(@js.any("invalid")).success(), false)
}

///|
test "DSL num() builds number schema" {
  let schema = num().build()
  assert_eq(schema.safeParse(@js.any(42)).success(), true)
  assert_eq(schema.safeParse(@js.any("not a number")).success(), false)
}

///|
test "DSL Number with rules" {
  let schema = Schema::Number([NumberRule::Int, NumberRule::Positive]).build()
  assert_eq(schema.safeParse(@js.any(5)).success(), true)
  assert_eq(schema.safeParse(@js.any(-5)).success(), false)
}

///|
test "DSL positive_int() shorthand" {
  let schema = positive_int().build()
  assert_eq(schema.safeParse(@js.any(10)).success(), true)
  assert_eq(schema.safeParse(@js.any(-10)).success(), false)
}

///|
test "DSL bool() builds boolean schema" {
  let schema = bool().build()
  assert_eq(schema.safeParse(@js.any(true)).success(), true)
  assert_eq(schema.safeParse(@js.any(false)).success(), true)
  assert_eq(schema.safeParse(@js.any("true")).success(), false)
}

///|
test "DSL Array schema" {
  let schema = Schema::Array(num(), []).build()
  assert_eq(schema.safeParse(@js.from_array([1, 2, 3])).success(), true)
}

///|
test "DSL Array with nonempty rule" {
  let schema = Schema::Array(str(), [ArrayRule::Nonempty]).build()
  assert_eq(schema.safeParse(@js.from_array(["a"])).success(), true)
  let empty : Array[String] = []
  assert_eq(schema.safeParse(@js.from_array(empty)).success(), false)
}

///|
test "DSL Object schema" {
  let schema = Schema::Object([("name", str()), ("age", num())], []).build()
  let data = @js.Object::new()
  data.set("name", "Alice")
  data.set("age", 30)
  assert_eq(schema.safeParse(data.to_any()).success(), true)
}

///|
test "DSL Object with strict rule" {
  let schema = Schema::Object([("name", str())], [ObjectRule::Strict]).build()
  let data = @js.Object::new()
  data.set("name", "Alice")
  data.set("extra", "not allowed")
  assert_eq(schema.safeParse(data.to_any()).success(), false)
}

///|
test "DSL nested Object" {
  let schema = Schema::Object(
    [
      ("user", Schema::Object([("name", str()), ("email", email())], [])),
      ("active", bool()),
    ],
    [],
  ).build()
  let user = @js.Object::new()
  user.set("name", "Alice")
  user.set("email", "alice@example.com")
  let data = @js.Object::new()
  data.set("user", user)
  data.set("active", true)
  assert_eq(schema.safeParse(data.to_any()).success(), true)
}

///|
test "DSL Union schema" {
  let schema = Schema::Union([str(), num()]).build()
  assert_eq(schema.safeParse(@js.any("hello")).success(), true)
  assert_eq(schema.safeParse(@js.any(42)).success(), true)
  assert_eq(schema.safeParse(@js.any(true)).success(), false)
}

///|
test "DSL Enum schema" {
  let schema = Schema::Enum(["red", "green", "blue"]).build()
  assert_eq(schema.safeParse(@js.any("red")).success(), true)
  assert_eq(schema.safeParse(@js.any("yellow")).success(), false)
}

///|
test "DSL Literal schema" {
  let schema = Schema::Literal(@js.any("hello")).build()
  assert_eq(schema.safeParse(@js.any("hello")).success(), true)
  assert_eq(schema.safeParse(@js.any("world")).success(), false)
}

///|
test "DSL optional modifier" {
  let schema = optional(str()).build()
  assert_eq(schema.safeParse(@js.any("hello")).success(), true)
  assert_eq(schema.safeParse(@js.undefined()).success(), true)
}

///|
test "DSL nullable modifier" {
  let schema = nullable(str()).build()
  assert_eq(schema.safeParse(@js.any("hello")).success(), true)
  assert_eq(schema.safeParse(@js.null_()).success(), true)
}

///|
test "DSL nullish modifier" {
  let schema = nullish(str()).build()
  assert_eq(schema.safeParse(@js.any("hello")).success(), true)
  assert_eq(schema.safeParse(@js.null_()).success(), true)
  assert_eq(schema.safeParse(@js.undefined()).success(), true)
}

///|
test "DSL with_default modifier" {
  let schema = with_default(str(), @js.any("default")).build()
  let result : String = schema.parse(@js.undefined()).cast()
  assert_eq(result, "default")
}

///|
test "DSL validate helper" {
  let schema = Schema::Object([("name", str()), ("age", positive_int())], [])
  let data = @js.Object::new()
  data.set("name", "Bob")
  data.set("age", 25)
  let result = validate(schema, data.to_any())
  assert_eq(result.success(), true)
}

///|
test "DSL Tuple schema" {
  let schema = Schema::Tuple([str(), num(), bool()]).build()
  let data = make_tuple_data()
  assert_eq(schema.safeParse(data).success(), true)
}

///|
extern "js" fn make_tuple_data() -> @js.Any =
  #| () => ["hello", 42, true]

///|
test "DSL Record schema" {
  let schema = Schema::Record(Schema::Any, num()).build()
  let data = @js.Object::new()
  data.set("a", 1)
  data.set("b", 2)
  assert_eq(schema.safeParse(data.to_any()).success(), true)
}

///|
test "DSL complex user schema" {
  // Define a complete user schema using DSL
  let user_schema = Schema::Object(
    [
      ("id", positive_int()),
      ("username", Schema::String([StringRule::Min(3), StringRule::Max(20)])),
      ("email", email()),
      (
        "age",
        optional(
          Schema::Number([
            NumberRule::Int,
            NumberRule::Gte(0),
            NumberRule::Lte(150),
          ]),
        ),
      ),
      (
        "roles",
        Schema::Array(Schema::Enum(["admin", "user", "guest"]), [
          ArrayRule::Nonempty,
        ]),
      ),
      (
        "profile",
        optional(
          Schema::Object(
            [
              ("bio", optional(Schema::String([StringRule::Max(500)]))),
              ("avatar", optional(url_string())),
            ],
            [],
          ),
        ),
      ),
    ],
    [ObjectRule::Strict],
  )
  // Valid user data
  let roles = @js.from_array(["admin", "user"])
  let profile = @js.Object::new()
  profile.set("bio", "Hello world")
  let user = @js.Object::new()
  user.set("id", 1)
  user.set("username", "alice")
  user.set("email", "alice@example.com")
  user.set("age", 30)
  user.set("roles", roles)
  user.set("profile", profile)
  let result = validate(user_schema, user.to_any())
  assert_eq(result.success(), true)
}
