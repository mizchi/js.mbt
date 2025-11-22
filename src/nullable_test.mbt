///| Nullable[T] type tests
/// Tests for the Nullable[T] type which handles explicit null values in FFI

///|
extern "js" fn create_null() -> @js.Js =
  #|() => null

///|
extern "js" fn create_value(v : Int) -> @js.Js =
  #|(v) => v

///|
extern "js" fn create_undefined() -> @js.Js =
  #|() => undefined

///|
extern "js" fn create_object_with_null_field() -> @js.Js =
  #|() => ({ value: null })

///|
extern "js" fn create_object_with_value_field(v : Int) -> @js.Js =
  #|(v) => ({ value: v })

///|
test "Nullable[Int]::to_option() - null value returns None" {
  let nullable : Nullable[Int] = create_null() |> unsafe_cast
  match nullable.to_option() {
    Some(_) => fail("Expected None for null value")
    None => ()
  }
}

///|
test "Nullable[Int]::to_option() - actual value returns Some" {
  let nullable : Nullable[Int] = create_value(42) |> unsafe_cast
  match nullable.to_option() {
    Some(v) => assert_eq(v, 42)
    None => fail("Expected Some(42) for actual value")
  }
}

///|
test "Nullable[Int]::to_option() - undefined behavior" {
  let nullable : Nullable[Int] = create_undefined() |> unsafe_cast
  // Note: The actual behavior of undefined with Nullable may vary
  // This test documents the current behavior
  match nullable.to_option() {
    Some(_) => () // undefined might be treated as Some
    None => () // or it might be treated as None - both are acceptable
  }
}

///|
test "Nullable[Int]::is_null() - null returns true" {
  let nullable : Nullable[Int] = create_null() |> unsafe_cast
  assert_true(nullable.is_null())
}

///|
test "Nullable[Int]::is_null() - value returns false" {
  let nullable : Nullable[Int] = create_value(42) |> unsafe_cast
  assert_false(nullable.is_null())
}

///|
test "Nullable[Int]::is_null() - undefined behavior" {
  let nullable : Nullable[Int] = create_undefined() |> unsafe_cast
  // The behavior of is_null() with undefined may vary
  // This test documents that we don't make assumptions about it
  let _ = nullable.is_null()
   // Just call it, don't assert
}

///|
test "Nullable[String] - null value" {
  let nullable : Nullable[String] = create_null() |> unsafe_cast
  assert_true(nullable.is_null())
  match nullable.to_option() {
    Some(_) => fail("Expected None for null string")
    None => ()
  }
}

///|
test "Nullable[String] - actual value" {
  let js_str : @js.Js = @js.unsafe_cast("hello")
  let nullable : Nullable[String] = js_str |> unsafe_cast
  assert_false(nullable.is_null())
  match nullable.to_option() {
    Some(s) => assert_eq(s, "hello")
    None => fail("Expected Some for actual string")
  }
}

///|
test "Nullable[Bool] - null value" {
  let nullable : Nullable[Bool] = create_null() |> unsafe_cast
  assert_true(nullable.is_null())
}

///|
test "Nullable[Bool] - false value is not null" {
  let js_false : @js.Js = @js.unsafe_cast(false)
  let nullable : Nullable[Bool] = js_false |> unsafe_cast
  assert_false(nullable.is_null())
  match nullable.to_option() {
    Some(b) => assert_false(b)
    None => fail("Expected Some(false)")
  }
}

///|
test "Nullable[Bool] - true value" {
  let js_true : @js.Js = @js.unsafe_cast(true)
  let nullable : Nullable[Bool] = js_true |> unsafe_cast
  assert_false(nullable.is_null())
  match nullable.to_option() {
    Some(b) => assert_true(b)
    None => fail("Expected Some(true)")
  }
}

///|
test "Nullable[Double] - null value" {
  let nullable : Nullable[Double] = create_null() |> unsafe_cast
  assert_true(nullable.is_null())
}

///|
test "Nullable[Double] - zero is not null" {
  let js_zero : @js.Js = @js.unsafe_cast(0.0)
  let nullable : Nullable[Double] = js_zero |> unsafe_cast
  assert_false(nullable.is_null())
  match nullable.to_option() {
    Some(v) => assert_eq(v, 0.0)
    None => fail("Expected Some(0.0)")
  }
}

///|
test "Nullable[Double] - actual value" {
  let js_val : @js.Js = @js.unsafe_cast(3.14)
  let nullable : Nullable[Double] = js_val |> unsafe_cast
  match nullable.to_option() {
    Some(v) => assert_eq(v, 3.14)
    None => fail("Expected Some(3.14)")
  }
}

///|
/// Test struct with Nullable field
pub(all) struct TestRecord {
  value : Nullable[Int]
}

///|
pub impl JsImpl for TestRecord

///|
test "struct with Nullable field - null value" {
  let obj = create_object_with_null_field()
  let record : TestRecord = obj |> unsafe_cast
  assert_true(record.value.is_null())
  match record.value.to_option() {
    Some(_) => fail("Expected None for null field")
    None => ()
  }
}

///|
test "struct with Nullable field - actual value" {
  let obj = create_object_with_value_field(99)
  let record : TestRecord = obj |> unsafe_cast
  assert_false(record.value.is_null())
  match record.value.to_option() {
    Some(v) => assert_eq(v, 99)
    None => fail("Expected Some(99)")
  }
}

///|
/// Test multiple Nullable fields
pub(all) struct MultiNullableRecord {
  str_field : Nullable[String]
  int_field : Nullable[Int]
  bool_field : Nullable[Bool]
}

///|
pub impl JsImpl for MultiNullableRecord

///|
extern "js" fn create_multi_nullable(
  str_null : Bool,
  int_null : Bool,
  bool_null : Bool,
) -> @js.Js =
  #|(str_null, int_null, bool_null) => ({
  #|  str_field: str_null ? null : "test",
  #|  int_field: int_null ? null : 123,
  #|  bool_field: bool_null ? null : true
  #|})

///|
test "multiple Nullable fields - all null" {
  let obj = create_multi_nullable(true, true, true)
  let record : MultiNullableRecord = obj |> unsafe_cast
  assert_true(record.str_field.is_null())
  assert_true(record.int_field.is_null())
  assert_true(record.bool_field.is_null())
}

///|
test "multiple Nullable fields - all non-null" {
  let obj = create_multi_nullable(false, false, false)
  let record : MultiNullableRecord = obj |> unsafe_cast
  assert_false(record.str_field.is_null())
  assert_false(record.int_field.is_null())
  assert_false(record.bool_field.is_null())
  match record.str_field.to_option() {
    Some(s) => assert_eq(s, "test")
    None => fail("Expected Some for string")
  }
  match record.int_field.to_option() {
    Some(i) => assert_eq(i, 123)
    None => fail("Expected Some for int")
  }
  match record.bool_field.to_option() {
    Some(b) => assert_true(b)
    None => fail("Expected Some for bool")
  }
}

///|
test "multiple Nullable fields - mixed null and non-null" {
  let obj = create_multi_nullable(true, false, true)
  let record : MultiNullableRecord = obj |> unsafe_cast
  assert_true(record.str_field.is_null())
  assert_false(record.int_field.is_null())
  assert_true(record.bool_field.is_null())
}
