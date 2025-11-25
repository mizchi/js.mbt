///| DSL Tests - Testing all Schema variants and rules using convenience functions

///|
test "DSL: String convenience functions" {
  let schema1 = str_min(2).build()
  assert_eq(schema1.safeParse(@js.any("ab")).success(), true)
  assert_eq(schema1.safeParse(@js.any("a")).success(), false)
  let schema2 = str_max(3).build()
  assert_eq(schema2.safeParse(@js.any("abc")).success(), true)
  assert_eq(schema2.safeParse(@js.any("abcd")).success(), false)
  let schema3 = str_length(3).build()
  assert_eq(schema3.safeParse(@js.any("abc")).success(), true)
  assert_eq(schema3.safeParse(@js.any("ab")).success(), false)
  let schema4 = str_regex("^[a-z]+$").build()
  assert_eq(schema4.safeParse(@js.any("abc")).success(), true)
  assert_eq(schema4.safeParse(@js.any("ABC")).success(), false)
  let schema5 = str_starts_with("hello").build()
  assert_eq(schema5.safeParse(@js.any("hello world")).success(), true)
  assert_eq(schema5.safeParse(@js.any("world hello")).success(), false)
  let schema6 = str_ends_with("world").build()
  assert_eq(schema6.safeParse(@js.any("hello world")).success(), true)
  assert_eq(schema6.safeParse(@js.any("world hello")).success(), false)

  // Transform functions
  let schema7 = str_trim().build()
  let result7 : String = schema7.parse(@js.any("  hello  ")).cast()
  assert_eq(result7, "hello")
  let schema8 = str_lower().build()
  let result8 : String = schema8.parse(@js.any("HELLO")).cast()
  assert_eq(result8, "hello")
  let schema9 = str_upper().build()
  let result9 : String = schema9.parse(@js.any("hello")).cast()
  assert_eq(result9, "HELLO")
}

///|
test "DSL: Number convenience functions" {
  let schema1 = num_gt(5).build()
  assert_eq(schema1.safeParse(@js.any(6)).success(), true)
  assert_eq(schema1.safeParse(@js.any(5)).success(), false)
  let schema2 = num_gte(5).build()
  assert_eq(schema2.safeParse(@js.any(5)).success(), true)
  assert_eq(schema2.safeParse(@js.any(4)).success(), false)
  let schema3 = num_lt(5).build()
  assert_eq(schema3.safeParse(@js.any(4)).success(), true)
  assert_eq(schema3.safeParse(@js.any(5)).success(), false)
  let schema4 = num_lte(5).build()
  assert_eq(schema4.safeParse(@js.any(5)).success(), true)
  assert_eq(schema4.safeParse(@js.any(6)).success(), false)
  let schema5 = num_negative().build()
  assert_eq(schema5.safeParse(@js.any(-1)).success(), true)
  assert_eq(schema5.safeParse(@js.any(1)).success(), false)
  let schema6 = num_nonpositive().build()
  assert_eq(schema6.safeParse(@js.any(0)).success(), true)
  assert_eq(schema6.safeParse(@js.any(1)).success(), false)
  let schema7 = num_finite().build()
  assert_eq(schema7.safeParse(@js.any(100)).success(), true)
}

///|
test "DSL: Array convenience functions" {
  let schema1 = arr_min(num(), 2).build()
  assert_eq(schema1.safeParse(@js.from_array([1, 2])).success(), true)
  assert_eq(schema1.safeParse(@js.from_array([1])).success(), false)
  let schema2 = arr_max(num(), 2).build()
  assert_eq(schema2.safeParse(@js.from_array([1, 2])).success(), true)
  assert_eq(schema2.safeParse(@js.from_array([1, 2, 3])).success(), false)
  let schema3 = arr_length(num(), 2).build()
  assert_eq(schema3.safeParse(@js.from_array([1, 2])).success(), true)
  assert_eq(schema3.safeParse(@js.from_array([1])).success(), false)
  let schema4 = arr_nonempty(num()).build()
  assert_eq(schema4.safeParse(@js.from_array([1])).success(), true)
  let empty : Array[Int] = []
  assert_eq(schema4.safeParse(@js.from_array(empty)).success(), false)
}

///|
test "DSL: Object convenience functions" {
  let fields : Array[(String, Schema)] = [("name", str())]
  let schema1 = obj_strict(fields).build()
  let data1 = @js.Object::new()
  data1.set("name", "test")
  assert_eq(schema1.safeParse(data1.to_any()).success(), true)
  let data2 = @js.Object::new()
  data2.set("name", "test")
  data2.set("extra", "field")
  assert_eq(schema1.safeParse(data2.to_any()).success(), false)
  let schema2 = obj_passthrough(fields).build()
  let data3 = @js.Object::new()
  data3.set("name", "test")
  data3.set("extra", "field")
  assert_eq(schema2.safeParse(data3.to_any()).success(), true)
  let schema3 = obj_strip(fields).build()
  let data4 = @js.Object::new()
  data4.set("name", "test")
  data4.set("extra", "field")
  assert_eq(schema3.safeParse(data4.to_any()).success(), true)
  let schema4 = obj_partial(fields).build()
  let data5 = @js.Object::new()
  assert_eq(schema4.safeParse(data5.to_any()).success(), true)
}

///|
test "DSL: Complex type convenience functions" {
  // BigInt
  let schema1 = bigint_().build()
  assert_false(@js.is_undefined(schema1.to_any()))

  // Date
  let schema2 = date_().build()
  assert_false(@js.is_undefined(schema2.to_any()))

  // Record
  let schema3 = record_(str(), num()).build()
  let data = @js.Object::new()
  data.set("a", 1)
  data.set("b", 2)
  assert_eq(schema3.safeParse(data.to_any()).success(), true)

  // Tuple
  let schema4 = tuple_([str(), num()]).build()
  let tuple_data = @js.from_array([@js.any("hello"), @js.any(42)])
  assert_eq(schema4.safeParse(tuple_data).success(), true)

  // Union
  let schema5 = union_([str(), num()]).build()
  assert_eq(schema5.safeParse(@js.any("hello")).success(), true)
  assert_eq(schema5.safeParse(@js.any(42)).success(), true)

  // Enum
  let schema6 = enum__(["a", "b", "c"]).build()
  assert_eq(schema6.safeParse(@js.any("a")).success(), true)
  assert_eq(schema6.safeParse(@js.any("d")).success(), false)

  // Literal
  let schema7 = literal_(@js.any("exact")).build()
  assert_eq(schema7.safeParse(@js.any("exact")).success(), true)
  assert_eq(schema7.safeParse(@js.any("other")).success(), false)
}

///|
test "DSL: Special type convenience functions" {
  // Any
  let schema1 = any__().build()
  assert_eq(schema1.safeParse(@js.any("anything")).success(), true)
  assert_eq(schema1.safeParse(@js.any(123)).success(), true)

  // Unknown
  let schema2 = unknown_().build()
  assert_eq(schema2.safeParse(@js.any("anything")).success(), true)

  // Never - always fails
  let schema3 = never_().build()
  assert_eq(schema3.safeParse(@js.any("anything")).success(), false)

  // Null
  let schema4 = null__().build()
  assert_eq(schema4.safeParse(@js.null_()).success(), true)
  assert_eq(schema4.safeParse(@js.any("not null")).success(), false)

  // Undefined
  let schema5 = undefined__().build()
  assert_eq(schema5.safeParse(@js.undefined()).success(), true)
  assert_eq(schema5.safeParse(@js.any("not undefined")).success(), false)
}
