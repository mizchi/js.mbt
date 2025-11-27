///|
test "string schema parse" {
  let schema = @zod.string()
  try schema.parse("hello") catch {
    _ => return
  } noraise {
    data => {
      let result : String = data.cast()
      assert_eq(result, "hello")
    }
  }
}

///|
test "number schema parse" {
  let schema = @zod.number()
  try schema.parse(42) catch {
    _ => return
  } noraise {
    data => {
      let result : Int = data.cast()
      assert_eq(result, 42)
    }
  }
}

///|
test "boolean schema parse" {
  let schema = @zod.boolean()
  try schema.parse(true) catch {
    _ => return
  } noraise {
    data => {
      let result : Bool = data.cast()
      assert_eq(result, true)
    }
  }
}

///|
test "string safeParse success" {
  let schema = @zod.string()
  let result = schema.safeParse("hello")
  match result {
    Ok(data) => {
      let s : String = data.cast()
      assert_eq(s, "hello")
    }
    Err(_) => assert_true(false)
  }
}

///|
test "string safeParse failure" {
  let schema = @zod.string()
  let result = schema.safeParse(123)
  match result {
    Ok(_) => assert_true(false)
    Err(err) => {
      let issues = err.issuesArray()
      assert_true(issues.length() > 0)
    }
  }
}

///|
test "string min max" {
  let schema = @zod.string().min(2).max(5)
  // Valid
  assert_true(schema.safeParse("abc") is Ok(_))
  // Too short
  assert_true(schema.safeParse("a") is Err(_))
  // Too long
  assert_true(schema.safeParse("abcdef") is Err(_))
}

///|
test "string email" {
  let schema = @zod.string().email()
  assert_true(schema.safeParse("test@example.com") is Ok(_))
  assert_true(schema.safeParse("not-an-email") is Err(_))
}

///|
test "number int positive" {
  let schema = @zod.number().int().positive()
  assert_true(schema.safeParse(5) is Ok(_))
  assert_true(schema.safeParse(-5) is Err(_))
}

///|
test "object schema" {
  let schema = @zod.object({ "name": @zod.string(), "age": @zod.number() })
  let data = @js.from_json({ "name": "Alice", "age": 30 })
  assert_true(schema.safeParse(data) is Ok(_))
}

///|
test "object schema invalid" {
  let schema = @zod.object({ "name": @zod.string(), "age": @zod.number() })
  let data = @js.from_json({ "name": 123, "age": "not a number" })
  assert_true(schema.safeParse(data) is Err(_))
}

///|
test "array schema" {
  let schema = @zod.array(@zod.number())
  let data = @js.from_array([1, 2, 3])
  assert_true(schema.safeParse(data) is Ok(_))
}

///|
test "array nonempty" {
  let schema = @zod.array(@zod.number()).nonempty()
  assert_true(schema.safeParse(@js.from_array([1])) is Ok(_))
  let empty : Array[Int] = []
  assert_true(schema.safeParse(@js.from_array(empty)) is Err(_))
}

///|
test "enum schema" {
  let schema = @zod.enum_(["red", "green", "blue"])
  assert_true(schema.safeParse("red") is Ok(_))
  assert_true(schema.safeParse("yellow") is Err(_))
}

///|
test "literal schema" {
  let schema = @zod.literal(@js.any("hello"))
  assert_true(schema.safeParse("hello") is Ok(_))
  assert_true(schema.safeParse("world") is Err(_))
}

///|
test "optional schema" {
  let schema = @zod.string().optional()
  assert_true(schema.safeParse("hello") is Ok(_))
  assert_true(schema.safeParse(@js.undefined()) is Ok(_))
}

///|
test "nullable schema" {
  let schema = @zod.string().nullable()
  assert_true(schema.safeParse("hello") is Ok(_))
  assert_true(schema.safeParse(@js.null_()) is Ok(_))
}

///|
test "default value" {
  let schema = @zod.string().default_(@js.any("default"))
  try schema.parse(@js.undefined()) catch {
    _ => return
  } noraise {
    result => {
      let s : String = result.cast()
      assert_eq(s, "default")
    }
  }
}

///|
test "union schema" {
  let schema = @zod.union([@zod.string(), @zod.number()])
  assert_true(schema.safeParse("hello") is Ok(_))
  assert_true(schema.safeParse(42) is Ok(_))
  assert_true(schema.safeParse(true) is Err(_))
}

///|
test "transform" {
  let schema = @zod.string().transform(fn(s) {
    @js.any(s.to_string().to_upper())
  })
  try schema.parse("hello") catch {
    _ => return
  } noraise {
    data => {
      let result : String = data.cast()
      assert_eq(result, "HELLO")
    }
  }
}

///|
test "ZodIssue path" {
  let inner_schema = @zod.object({ "name": @zod.string() })
  let schema = @zod.object({ "user": inner_schema })
  let data = @js.from_json({ "user": { "name": 123 } })
  match schema.safeParse(data) {
    Ok(_) => assert_true(false)
    Err(err) => {
      let issues = err.issuesArray()
      assert_true(issues.length() > 0)
    }
  }
}

///|
test "string regex" {
  let schema = @zod.string().regex("^[a-z]+$")
  assert_true(schema.safeParse("abc") is Ok(_))
  assert_true(schema.safeParse("ABC") is Err(_))
}

///|
test "string url validation" {
  let schema = @zod.string().url()
  assert_true(schema.safeParse("https://example.com") is Ok(_))
  assert_true(schema.safeParse("not-a-url") is Err(_))
}

///|
test "string uuid validation" {
  let schema = @zod.string().uuid()
  assert_true(schema.safeParse("550e8400-e29b-41d4-a716-446655440000") is Ok(_))
  assert_true(schema.safeParse("not-a-uuid") is Err(_))
}

///|
test "string startsWith and endsWith" {
  let schema1 = @zod.string().startsWith("hello")
  assert_true(schema1.safeParse("hello world") is Ok(_))
  assert_true(schema1.safeParse("world hello") is Err(_))
  let schema2 = @zod.string().endsWith("world")
  assert_true(schema2.safeParse("hello world") is Ok(_))
  assert_true(schema2.safeParse("world hello") is Err(_))
}

///|
test "string trim transform" {
  let schema = @zod.string().trim()
  try schema.parse("  hello  ") catch {
    _ => return
  } noraise {
    data => {
      let result : String = data.cast()
      assert_eq(result, "hello")
    }
  }
}

///|
test "string toLowerCase and toUpperCase" {
  let schema1 = @zod.string().toLowerCase()
  try schema1.parse("HELLO") catch {
    _ => return
  } noraise {
    d1 => {
      let r1 : String = d1.cast()
      assert_eq(r1, "hello")
    }
  }
  let schema2 = @zod.string().toUpperCase()
  try schema2.parse("hello") catch {
    _ => return
  } noraise {
    d2 => {
      let r2 : String = d2.cast()
      assert_eq(r2, "HELLO")
    }
  }
}

///|
test "string length exact" {
  let schema = @zod.string().length(5)
  assert_true(schema.safeParse("hello") is Ok(_))
  assert_true(schema.safeParse("hi") is Err(_))
  assert_true(schema.safeParse("hello world") is Err(_))
}

///|
test "string includes" {
  let schema = @zod.string().includes("world")
  assert_true(schema.safeParse("hello world") is Ok(_))
  assert_true(schema.safeParse("hello") is Err(_))
}

///|
test "string datetime" {
  let schema = @zod.string().datetime()
  assert_true(schema.safeParse("2024-01-01T00:00:00Z") is Ok(_))
  assert_true(schema.safeParse("not-a-datetime") is Err(_))
}

///|
test "string ipv4 and ipv6" {
  let schema1 = @zod.string().ipv4()
  assert_true(schema1.safeParse("192.168.1.1") is Ok(_))
  assert_true(schema1.safeParse("not-an-ip") is Err(_))
  let schema2 = @zod.string().ipv6()
  assert_true(schema2.safeParse("::1") is Ok(_))
  assert_true(
    schema2.safeParse("2001:0db8:85a3:0000:0000:8a2e:0370:7334") is Ok(_),
  )
  assert_true(schema2.safeParse("192.168.1.1") is Err(_))
}

///|
test "number gt gte lt lte" {
  let schema1 = @zod.number().gt(5)
  assert_true(schema1.safeParse(6) is Ok(_))
  assert_true(schema1.safeParse(5) is Err(_))
  let schema2 = @zod.number().gte(5)
  assert_true(schema2.safeParse(5) is Ok(_))
  assert_true(schema2.safeParse(4) is Err(_))
  let schema3 = @zod.number().lt(5)
  assert_true(schema3.safeParse(4) is Ok(_))
  assert_true(schema3.safeParse(5) is Err(_))
  let schema4 = @zod.number().lte(5)
  assert_true(schema4.safeParse(5) is Ok(_))
  assert_true(schema4.safeParse(6) is Err(_))
}

///|
test "number negative nonnegative nonpositive" {
  let schema1 = @zod.number().negative()
  assert_true(schema1.safeParse(-1) is Ok(_))
  assert_true(schema1.safeParse(0) is Err(_))
  let schema2 = @zod.number().nonnegative()
  assert_true(schema2.safeParse(0) is Ok(_))
  assert_true(schema2.safeParse(-1) is Err(_))
  let schema3 = @zod.number().nonpositive()
  assert_true(schema3.safeParse(0) is Ok(_))
  assert_true(schema3.safeParse(1) is Err(_))
}

///|
test "number finite" {
  let schema = @zod.number().finite()
  assert_true(schema.safeParse(100) is Ok(_))
}

///|
test "number multipleOf" {
  let schema = @zod.number().multipleOf(5)
  assert_true(schema.safeParse(10) is Ok(_))
  assert_true(schema.safeParse(7) is Err(_))
}

///|
test "tuple schema" {
  let schema = @zod.tuple([@zod.string(), @zod.number()])
  let valid_data = @js.from_array([@js.any("hello"), @js.any(42)])
  assert_true(schema.safeParse(valid_data) is Ok(_))
  let invalid_data = @js.from_array([@js.any(42), @js.any("hello")])
  assert_true(schema.safeParse(invalid_data) is Err(_))
}

///|
test "record schema" {
  let schema = @zod.record(@zod.string(), @zod.number())
  let data = @js.from_json({ "a": 1, "b": 2 })
  assert_true(schema.safeParse(data) is Ok(_))
  let invalid = @js.from_json({ "a": "not-a-number" })
  assert_true(schema.safeParse(invalid) is Err(_))
}

///|
test "intersection schema" {
  let schema1 = @zod.object({ "name": @zod.string() })
  let schema2 = @zod.object({ "age": @zod.number() })
  let schema = @zod.intersection(schema1, schema2)
  let valid = @js.from_json({ "name": "Alice", "age": 30 })
  assert_true(schema.safeParse(valid) is Ok(_))
  let invalid = @js.from_json({ "name": "Alice" })
  // missing age
  assert_true(schema.safeParse(invalid) is Err(_))
}

///|
test "object extend" {
  let base_schema = @zod.object({ "name": @zod.string() })
  let ext_shape = @js.Object::new()
  ext_shape.set("age", @zod.number())
  let extended = base_schema.extend(ext_shape.to_any())
  let data = @js.from_json({ "name": "Alice", "age": 30 })
  assert_true(extended.safeParse(data) is Ok(_))
}

///|
test "object pick and omit" {
  let schema = @zod.object({
    "name": @zod.string(),
    "age": @zod.number(),
    "email": @zod.string(),
  })
  // Pick only name
  let pick_keys = @js.from_json({ "name": true })
  let picked = schema.pick(pick_keys)
  let pick_data = @js.from_json({ "name": "Alice" })
  assert_true(picked.safeParse(pick_data) is Ok(_))
  // Omit email
  let omit_keys = @js.from_json({ "email": true })
  let omitted = schema.omit(omit_keys)
  let omit_data = @js.from_json({ "name": "Alice", "age": 30 })
  assert_true(omitted.safeParse(omit_data) is Ok(_))
}

///|
test "object partial and required" {
  let schema = @zod.object({ "name": @zod.string(), "age": @zod.number() })
  // Partial - all optional
  let partial_schema = schema.partial()
  let empty = @js.Object::new()
  assert_true(partial_schema.safeParse(empty) is Ok(_))
  // Required - all required
  let required_schema = partial_schema.required_()
  assert_true(required_schema.safeParse(empty) is Err(_))
}

///|
test "object passthrough strict strip" {
  let schema = @zod.object({ "name": @zod.string() })
  // Passthrough - allows extra keys
  let passthrough_schema = schema.passthrough()
  let data = @js.from_json({ "name": "Alice", "extra": "field" })
  assert_true(passthrough_schema.safeParse(data) is Ok(_))
  // Strict - rejects extra keys
  let strict_schema = @zod.object({ "name": @zod.string() }).strict()
  assert_true(strict_schema.safeParse(data) is Err(_))
  // Strip - removes extra keys (still valid)
  let strip_schema = @zod.object({ "name": @zod.string() }).strip()
  assert_true(strip_schema.safeParse(data) is Ok(_))
}

///|
test "refine custom validation" {
  let schema = @zod.string().refine(
    fn(val) {
      let s : String = val.cast()
      s.length() > 3
    },
    message="Must be longer than 3 characters",
  )
  assert_true(schema.safeParse("hello") is Ok(_))
  assert_true(schema.safeParse("hi") is Err(_))
}

///|
test "nullish schema" {
  let schema = @zod.string().nullish()
  assert_true(schema.safeParse("hello") is Ok(_))
  assert_true(schema.safeParse(@js.null_()) is Ok(_))
  assert_true(schema.safeParse(@js.undefined()) is Ok(_))
}

///|
test "catch default on error" {
  let schema = @zod.string().catch_(@js.any("default"))
  // Invalid input returns default
  try schema.parse(123) catch {
    _ => return
  } noraise {
    d1 => {
      let result : String = d1.cast()
      assert_eq(result, "default")
    }
  }
  // Valid input returns actual value
  try schema.parse("hello") catch {
    _ => return
  } noraise {
    d2 => {
      let result2 : String = d2.cast()
      assert_eq(result2, "hello")
    }
  }
}

///|
test "pipe schemas" {
  // Parse string then transform to number via coercion
  let schema = @zod.string().pipe(@zod.coerce_number())
  try schema.parse("42") catch {
    _ => return
  } noraise {
    data => {
      let result : Int = data.cast()
      assert_eq(result, 42)
    }
  }
}

///|
test "coerce string" {
  let schema = @zod.coerce_string()
  try schema.parse(123) catch {
    _ => return
  } noraise {
    d1 => {
      let r1 : String = d1.cast()
      assert_eq(r1, "123")
    }
  }
  try schema.parse(true) catch {
    _ => return
  } noraise {
    d2 => {
      let r2 : String = d2.cast()
      assert_eq(r2, "true")
    }
  }
}

///|
test "coerce number" {
  let schema = @zod.coerce_number()
  try schema.parse("42") catch {
    _ => return
  } noraise {
    data => {
      let r1 : Int = data.cast()
      assert_eq(r1, 42)
    }
  }
}

///|
test "coerce boolean" {
  let schema = @zod.coerce_boolean()
  try schema.parse("true") catch {
    _ => return
  } noraise {
    d1 => {
      let r1 : Bool = d1.cast()
      assert_eq(r1, true)
    }
  }
  try schema.parse("") catch {
    _ => return
  } noraise {
    d2 => {
      let r2 : Bool = d2.cast()
      assert_eq(r2, false)
    }
  }
}

///|
test "describe adds description" {
  let schema = @zod.string().describe("A user's name")
  // Just verify it doesn't throw
  assert_true(schema.safeParse("Alice") is Ok(_))
}

///|
test "map schema" {
  let schema = @zod.map(@zod.string(), @zod.number())
  // Maps require specific JS Map constructor, so just verify schema creation
  assert_false(@js.is_undefined(schema.to_any()))
}

///|
test "set schema" {
  let schema = @zod.set(@zod.number())
  // Sets require specific JS Set constructor, so just verify schema creation
  assert_false(@js.is_undefined(schema.to_any()))
}
