// Tests for Nullish[T] and Nullable[T] types in nostd
// Main concern: When null (not undefined) comes in as struct field or callback,
// using identity directly could result in Some(null)

///|
extern "js" fn create_object_with_null_field() -> @core.Any =
  #| () => ({ value: null })

///|
extern "js" fn create_object_with_undefined_field() -> @core.Any =
  #| () => ({ value: undefined })

///|
extern "js" fn create_object_with_value() -> @core.Any =
  #| () => ({ value: 42 })

///|
extern "js" fn create_object_with_missing_field() -> @core.Any =
  #| () => ({})

///|
extern "js" fn get_null_callback() -> @core.Any =
  #| () => null

///|
extern "js" fn get_valid_callback() -> @core.Any =
  #| () => (() => 42)

// Test Nullish[T] type behavior

///|
test "Nullish[T]::to_option with null value" {
  let obj = create_object_with_null_field()
  let field : Nullish[Int] = obj["value"].cast()
  let opt = field.to_option()
  // null should become None
  assert_true(opt is None)
}

///|
test "Nullish[T]::to_option with undefined value" {
  let obj = create_object_with_undefined_field()
  let field : Nullish[Int] = obj["value"].cast()
  let opt = field.to_option()
  // undefined should become None
  assert_true(opt is None)
}

///|
test "Nullish[T]::to_option with actual value" {
  let obj = create_object_with_value()
  let field : Nullish[Int] = obj["value"].cast()
  let opt = field.to_option()
  // actual value should become Some
  assert_true(not(opt is None))
  match opt {
    Some(v) => assert_eq(v, 42)
    None => assert_true(false)
  }
}

///|
test "Nullish[T]::to_option with missing field (undefined)" {
  let obj = create_object_with_missing_field()
  let field : Nullish[Int] = obj["value"].cast()
  let opt = field.to_option()
  // missing field (undefined) should become None
  assert_true(opt is None)
}

// Test Nullable[T] type behavior

///|
test "Nullable[T]::to_option with null value" {
  let obj = create_object_with_null_field()
  let field : Nullable[Int] = obj["value"].cast()
  let opt = field.to_option()
  // null should become None
  assert_true(opt is None)
}

///|
test "Nullable[T]::to_option with undefined value" {
  let obj = create_object_with_undefined_field()
  // Note: Nullable only checks for null, not undefined
  // When T=JsValue, undefined becomes Some(undefined)
  // But when T=Int, we get Some(NaN) which is problematic
  // For JsValue, we can verify it works correctly:
  let field : Nullable[Any] = obj["value"].cast()
  let opt = field.to_option()
  // undefined is NOT null, so Nullable should return Some(undefined)
  assert_true(not(opt is None))
  // The value inside is undefined (nullish but not null)
  match opt {
    Some(v) => assert_true(is_undefined(v))
    None => assert_true(false)
  }
}

///|
test "Nullable[T]::to_option with actual value" {
  let obj = create_object_with_value()
  let field : Nullable[Int] = obj["value"].cast()
  let opt = field.to_option()
  // actual value should become Some
  assert_true(not(opt is None))
  match opt {
    Some(v) => assert_eq(v, 42)
    None => assert_true(false)
  }
}

// Test callback scenarios (null callback vs valid callback)

///|
test "null callback with Nullish[T]" {
  let callback : Nullish[Any] = get_null_callback().cast()
  let opt = callback.to_option()
  // null callback should become None
  assert_true(opt is None)
}

///|
test "valid callback with Nullish[T]" {
  let callback : Nullish[@core.Any] = get_valid_callback().cast()
  let opt = callback.to_option()
  // valid callback should become Some
  assert_true(not(opt is None))
}

///|
test "null callback with Nullable[T]" {
  let callback : Nullable[@core.Any] = get_null_callback().cast()
  let opt = callback.to_option()
  // null callback should become None
  assert_true(opt is None)
}

// ============================================================================
// Struct field tests - the main concern
// Test that casting from JS object to MoonBit struct with Nullish[T] fields
// correctly handles null values
// ============================================================================

///|
priv struct MyStruct {
  foo : Nullish[Int]
}

///|
extern "js" fn create_struct_with_null_foo() -> Any =
  #| () => ({ foo: null })

///|
extern "js" fn create_struct_with_undefined_foo() -> Any =
  #| () => ({ foo: undefined })

///|
extern "js" fn create_struct_with_value_foo() -> @core.Any =
  #| () => ({ foo: 123 })

///|
test "struct field Nullish[Int] with null - should be None" {
  let js_obj = create_struct_with_null_foo()
  let s : MyStruct = js_obj.cast()
  let opt = s.foo.to_option()
  // null should become None, NOT Some(null)
  assert_true(opt is None)
}

///|
test "struct field Nullish[Int] with undefined - should be None" {
  let js_obj = create_struct_with_undefined_foo()
  let s : MyStruct = js_obj.cast()
  let opt = s.foo.to_option()
  // undefined should become None
  assert_true(opt is None)
}

///|
test "struct field Nullish[Int] with value - should be Some(123)" {
  let js_obj = create_struct_with_value_foo()
  let s : MyStruct = js_obj.cast()
  let opt = s.foo.to_option()
  // actual value should become Some(123)
  assert_true(not(opt is None))
  match opt {
    Some(v) => assert_eq(v, 123)
    None => assert_true(false)
  }
}

// ============================================================================
// Struct with Nullable[T] field
// ============================================================================

///|
priv struct MyStructNullable {
  bar : Nullable[Int]
}

// ============================================================================
// Nested struct tests
// Test that casting from JS object to MoonBit struct with nested structs works
// ============================================================================

///|
priv struct Inner {
  x : Int
  y : String
}

///|
priv struct Outer {
  inner : Nullish[Inner]
  name : String
}

///|
extern "js" fn create_outer_with_inner() -> @core.Any =
  #| () => ({ inner: { x: 10, y: "hello" }, name: "outer" })

///|
extern "js" fn create_outer_with_null_inner() -> @core.Any =
  #| () => ({ inner: null, name: "outer-null" })

///|
extern "js" fn create_outer_with_undefined_inner() -> @core.Any =
  #| () => ({ inner: undefined, name: "outer-undef" })

///|
test "nested struct - inner present" {
  let js_obj = create_outer_with_inner()
  let outer : Outer = js_obj.cast()
  assert_eq(outer.name, "outer")
  match outer.inner.to_option() {
    Some(inner) => {
      assert_eq(inner.x, 10)
      assert_eq(inner.y, "hello")
    }
    None => assert_true(false) // Should not be None
  }
}

///|
test "nested struct - inner is null" {
  let js_obj = create_outer_with_null_inner()
  let outer : Outer = js_obj.cast()
  assert_eq(outer.name, "outer-null")
  // inner is null, should become None
  assert_true(outer.inner.to_option() is None)
}

///|
test "nested struct - inner is undefined" {
  let js_obj = create_outer_with_undefined_inner()
  let outer : Outer = js_obj.cast()
  assert_eq(outer.name, "outer-undef")
  // inner is undefined, should become None
  assert_true(outer.inner.to_option() is None)
}

// ============================================================================
// Deeply nested struct tests
// ============================================================================

///|
priv struct Level3 {
  value : Int
}

///|
priv struct Level2 {
  level3 : Nullish[Level3]
}

///|
priv struct Level1 {
  level2 : Nullish[Level2]
}

///|
extern "js" fn create_deeply_nested() -> @core.Any =
  #| () => ({ level2: { level3: { value: 42 } } })

///|
extern "js" fn create_deeply_nested_with_null_level3() -> @core.Any =
  #| () => ({ level2: { level3: null } })

///|
extern "js" fn create_deeply_nested_with_null_level2() -> @core.Any =
  #| () => ({ level2: null })

///|
test "deeply nested struct - all present" {
  let js_obj = create_deeply_nested()
  let l1 : Level1 = js_obj.cast()
  match l1.level2.to_option() {
    Some(l2) =>
      match l2.level3.to_option() {
        Some(l3) => assert_eq(l3.value, 42)
        None => assert_true(false)
      }
    None => assert_true(false)
  }
}

///|
test "deeply nested struct - level3 is null" {
  let js_obj = create_deeply_nested_with_null_level3()
  let l1 : Level1 = js_obj.cast()
  match l1.level2.to_option() {
    Some(l2) =>
      // level3 is null, should be None
      assert_true(l2.level3.to_option() is None)
    None => assert_true(false)
  }
}

///|
test "deeply nested struct - level2 is null" {
  let js_obj = create_deeply_nested_with_null_level2()
  let l1 : Level1 = js_obj.cast()
  // level2 is null, should be None
  assert_true(l1.level2.to_option() is None)
}

// ============================================================================
// Generic struct tests
// Test that casting from JS object to MoonBit generic struct works
// ============================================================================

///|
priv struct Container[T] {
  value : T
  label : String
}

///|
priv struct NullishContainer[T] {
  data : Nullish[T]
  id : Int
}

///|
extern "js" fn create_container_int() -> @core.Any =
  #| () => ({ value: 100, label: "int-container" })

///|
extern "js" fn create_container_string() -> @core.Any =
  #| () => ({ value: "hello world", label: "string-container" })

///|
extern "js" fn create_container_nested() -> @core.Any =
  #| () => ({ value: { x: 1, y: 2 }, label: "nested-container" })

///|
priv struct Point {
  x : Int
  y : Int
}

///|
test "generic struct Container[Int]" {
  let js_obj = create_container_int()
  let c : Container[Int] = js_obj.cast()
  assert_eq(c.value, 100)
  assert_eq(c.label, "int-container")
}

///|
test "generic struct Container[String]" {
  let js_obj = create_container_string()
  let c : Container[String] = js_obj.cast()
  assert_eq(c.value, "hello world")
  assert_eq(c.label, "string-container")
}

///|
test "generic struct Container[Point] - nested struct in generic" {
  let js_obj = create_container_nested()
  let c : Container[Point] = js_obj.cast()
  assert_eq(c.label, "nested-container")
  assert_eq(c.value.x, 1)
  assert_eq(c.value.y, 2)
}

// Test generic struct with Nullish[T] field

///|
extern "js" fn create_nullish_container_with_value() -> @core.Any =
  #| () => ({ data: 42, id: 1 })

///|
extern "js" fn create_nullish_container_with_null() -> @core.Any =
  #| () => ({ data: null, id: 2 })

///|
extern "js" fn create_nullish_container_with_nested() -> @core.Any =
  #| () => ({ data: { x: 10, y: 20 }, id: 3 })

///|
extern "js" fn create_nullish_container_with_null_nested() -> @core.Any =
  #| () => ({ data: null, id: 4 })

///|
test "generic struct NullishContainer[Int] with value" {
  let js_obj = create_nullish_container_with_value()
  let c : NullishContainer[Int] = js_obj.cast()
  assert_eq(c.id, 1)
  match c.data.to_option() {
    Some(v) => assert_eq(v, 42)
    None => assert_true(false)
  }
}

///|
test "generic struct NullishContainer[Int] with null" {
  let js_obj = create_nullish_container_with_null()
  let c : NullishContainer[Int] = js_obj.cast()
  assert_eq(c.id, 2)
  assert_true(c.data.to_option() is None)
}

///|
test "generic struct NullishContainer[Point] with nested value" {
  let js_obj = create_nullish_container_with_nested()
  let c : NullishContainer[Point] = js_obj.cast()
  assert_eq(c.id, 3)
  match c.data.to_option() {
    Some(p) => {
      assert_eq(p.x, 10)
      assert_eq(p.y, 20)
    }
    None => assert_true(false)
  }
}

///|
test "generic struct NullishContainer[Point] with null" {
  let js_obj = create_nullish_container_with_null_nested()
  let c : NullishContainer[Point] = js_obj.cast()
  assert_eq(c.id, 4)
  assert_true(c.data.to_option() is None)
}

// ============================================================================
// Generic struct with multiple type parameters
// ============================================================================

///|
priv struct Pair[A, B] {
  first : Nullish[A]
  second : Nullish[B]
}

///|
extern "js" fn create_pair_both_present() -> @core.Any =
  #| () => ({ first: 123, second: "abc" })

///|
extern "js" fn create_pair_first_null() -> @core.Any =
  #| () => ({ first: null, second: "abc" })

///|
extern "js" fn create_pair_second_null() -> @core.Any =
  #| () => ({ first: 123, second: null })

///|
extern "js" fn create_pair_both_null() -> @core.Any =
  #| () => ({ first: null, second: null })

///|
test "generic struct Pair[Int, String] - both present" {
  let js_obj = create_pair_both_present()
  let p : Pair[Int, String] = js_obj.cast()
  match (p.first.to_option(), p.second.to_option()) {
    (Some(a), Some(b)) => {
      assert_eq(a, 123)
      assert_eq(b, "abc")
    }
    _ => assert_true(false)
  }
}

///|
test "generic struct Pair[Int, String] - first null" {
  let js_obj = create_pair_first_null()
  let p : Pair[Int, String] = js_obj.cast()
  assert_true(p.first.to_option() is None)
  match p.second.to_option() {
    Some(b) => assert_eq(b, "abc")
    None => assert_true(false)
  }
}

///|
test "generic struct Pair[Int, String] - second null" {
  let js_obj = create_pair_second_null()
  let p : Pair[Int, String] = js_obj.cast()
  match p.first.to_option() {
    Some(a) => assert_eq(a, 123)
    None => assert_true(false)
  }
  assert_true(p.second.to_option() is None)
}

///|
test "generic struct Pair[Int, String] - both null" {
  let js_obj = create_pair_both_null()
  let p : Pair[Int, String] = js_obj.cast()
  assert_true(p.first.to_option() is None)
  assert_true(p.second.to_option() is None)
}

///|
extern "js" fn create_struct_with_null_bar() -> @core.Any =
  #| () => ({ bar: null })

///|
extern "js" fn create_struct_with_value_bar() -> @core.Any =
  #| () => ({ bar: 456 })

///|
test "struct field Nullable[Int] with null bar - should be None" {
  let js_obj = create_struct_with_null_bar()
  let s : MyStructNullable = js_obj.cast()
  let opt = s.bar.to_option()
  // null should become None
  assert_true(opt is None)
}

///|
test "struct field Nullable[Int] with value bar - should be Some(456)" {
  let js_obj = create_struct_with_value_bar()
  let s : MyStructNullable = js_obj.cast()
  let opt = s.bar.to_option()
  // actual value should become Some(456)
  assert_true(not(opt is None))
  match opt {
    Some(v) => assert_eq(v, 456)
    None => assert_true(false)
  }
}
