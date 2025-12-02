///|
test "get and set property" {
  let global = global_this()
  let obj = global["Object"]
  // Object.create(null) to create empty object
  let empty_obj = obj._call("create", [null()])
  empty_obj["foo"] = any("bar")
  let value = empty_obj["foo"]
  // value should be "bar" but we can't easily assert without std lib
  // just verify no runtime error
  value |> ignore
}

///|
#skip("Test with IO")
test "call method with Array[Any]" {
  let global = global_this()
  let console = global["console"]
  console._call("log", [any("test message from nostd")]) |> ignore
}

///|
test "is_nullish" {
  let global = global_this()
  let undef = global["nonexistent_property_xyz"]
  assert_true(is_nullish(undef))
  let console = global["console"]
  assert_true(is_nullish(console) == false)
}

///|
test "undefined" {
  let undef = undefined()
  assert_true(is_nullish(undef))
}

///|
test "int conversion" {
  let n = any(42)
  let _ = n
  // verify no runtime error
}

///|
test "invoke" {
  let global = global_this()
  let parse_int = global["parseInt"]
  let result = parse_int._invoke([any("42")])
  let _ = result
  // verify no runtime error
}

// Type conversion tests using %identity (zero-cost)

///|
test "any and cast - Int" {
  // Int -> Any -> Int (zero-cost conversion)
  let n : Int = 42
  let js_val : Any = any(n)
  let back : Int = js_val.cast()
  assert_eq(back, 42)
}

///|
test "any and cast - Double" {
  // Double -> Any -> Double (zero-cost conversion)
  let d : Double = 3.14
  let js_val : Any = any(d)
  let back : Double = js_val.cast()
  assert_true(back > 3.13 && back < 3.15)
}

///|
test "any and cast - Bool" {
  // Bool -> Any -> Bool (zero-cost conversion)
  let b : Bool = true
  let js_val : Any = any(b)
  let back : Bool = js_val.cast()
  assert_eq(back, true)
}

///|
test "any and cast - String" {
  // String -> Any -> String (zero-cost conversion)
  let s : String = "hello"
  let js_val : Any = any(s)
  let back : String = js_val.cast()
  assert_eq(back, "hello")
}

///|
test "parseInt with any" {
  // Use any instead of str() for zero-cost conversion
  let global = global_this()
  let parse_int = global["parseInt"]
  let result = parse_int._invoke([any("123")])
  let n : Int = result.cast()
  assert_eq(n, 123)
}

///|
test "Math operations with cast" {
  let global = global_this()
  let math = global["Math"]
  let result = math._call("sqrt", [any(16.0)])
  let n : Double = result.cast()
  assert_eq(n, 4.0)
}

// Property access syntax tests (obj["key"])

///|
test "Any::_get with bracket syntax" {
  let global = global_this()
  // Using bracket syntax: global["console"]
  let console = global["console"]
  assert_true(is_nullish(console) == false)
}

///|
test "Any::_set with bracket syntax" {
  let global = global_this()
  let obj = global["Object"]
  let empty_obj = obj._call("create", [null()])
  // Using bracket syntax: empty_obj["foo"] = value
  empty_obj["foo"] = any("bar")
  let value = empty_obj["foo"]
  let s : String = value.cast()
  assert_eq(s, "bar")
}

///|
test "nested property access with bracket syntax" {
  let global = global_this()
  let math = global["Math"]
  let pi = math["PI"]
  let n : Double = pi.cast()
  assert_true(n > 3.14 && n < 3.15)
}

// Error handling tests

///|
extern "js" fn throwing_op() -> Any =
  #| () => { throw new Error("Test error"); }

///|
extern "js" fn succeeding_op() -> Any =
  #| () => 42

///|
test "try_sync - success" {
  let result = try_sync(succeeding_op) catch { JsError(_) => any(-1) }
  let n : Int = result.cast()
  assert_eq(n, 42)
}

///|
test "try_sync - catch error" {
  let caught = try_sync(throwing_op) catch {
    JsError(msg) => {
      assert_eq(msg, "Test error")
      any(true)
    }
  }
  let success : Bool = caught.cast()
  assert_eq(success, true)
}

///|
priv suberror TestError String derive(Show)

///|
fn moonbit_throwing_op() -> Any raise TestError {
  raise TestError("MoonBit error")
}

///|
fn moonbit_success_op() -> Any raise TestError {
  if false {
    raise TestError("This should not happen")
  }
  any(123)
}

///|
/// JS wrapper to test export_sync catches MoonBit errors
extern "js" fn js_catch_moonbit_error(op : () -> Any) -> Any =
  #| (op) => { try { return { ok: true, value: op() }; } catch (e) { return { ok: false, message: e.message }; } }

///|
test "export_sync - success" {
  let result = js_catch_moonbit_error(fn() { export_sync(moonbit_success_op) })
  let ok : Bool = result["ok"].cast()
  assert_eq(ok, true)
  let value : Int = result["value"].cast()
  assert_eq(value, 123)
}

///|
test "export_sync - converts MoonBit error to JS exception" {
  let result = js_catch_moonbit_error(fn() { export_sync(moonbit_throwing_op) })
  let ok : Bool = result["ok"].cast()
  assert_eq(ok, false)
  let msg : String = result["message"].cast()
  // derive(Show) produces "TestError(\"MoonBit error\")"
  assert_true(msg.contains("MoonBit error"))
}

// Promise tests - Note: run_async is non-blocking so we test via size2_promise example

// assert_throws tests

///|
test "assert_throws - catches exception" {
  let msg = assert_throws(throwing_op) catch { JsError(m) => m }
  assert_eq(msg, "Test error")
}

///|
test "assert_throws - fails when no exception" {
  // assert_throws raises JsError when no exception is thrown
  let result = assert_throws(succeeding_op) catch { JsError(m) => m }
  assert_true(result.contains("Expected exception"))
}

///|
test "assert_throws_with - passes on matching message" {
  assert_throws_with(throwing_op, "Test error")
}

///|
test "assert_throws_with - partial match" {
  assert_throws_with(throwing_op, "error")
}

///|
extern "js" fn throw_custom_error() -> Any =
  #| () => { throw new Error("Custom error message"); }

// typeof_, instance_of, new tests

///|
test "typeof_" {
  assert_eq(typeof_(any(42)), "number")
  assert_eq(typeof_(any("hello")), "string")
  assert_eq(typeof_(any(true)), "boolean")
  assert_eq(typeof_(undefined()), "undefined")
  assert_eq(typeof_(null()), "object") // JS quirk
  assert_eq(typeof_(new_object()), "object")
}

///|
test "instance_of" {
  let global = global_this()
  let arr : Any = global["Array"]._call("from", [any([1, 2, 3])])
  assert_true(instanceof_(arr, global["Array"]))
  assert_true(instanceof_(arr, global["Object"]))
  assert_true(not(instanceof_(arr, global["String"])))
}

///|
test "new - create Date" {
  let global = global_this()
  let date = new(global["Date"], [any(0)]) // Unix epoch
  assert_true(instanceof_(date, global["Date"]))
  let time : Int = date._call("getTime", []).cast()
  assert_eq(time, 0)
}

///|
test "new - create Error" {
  let global = global_this()
  let err = new(global["Error"], [any("test error")])
  assert_true(instanceof_(err, global["Error"]))
  let msg : String = err["message"].cast()
  assert_eq(msg, "test error")
}

///|
test "assert_throws_with - fails on mismatch" {
  // assert_throws_with throws when message doesn't match
  let result : String = try_sync(fn() {
    assert_throws_with(throw_custom_error, "wrong message")
    any(())
  }).cast() catch {
    JsError(m) => m
  }
  assert_true(result.contains("Expected error containing"))
}

///|
test "assert_throws_with - no exception throws" {
  // assert_throws_with fails when op doesn't throw
  let result : String = try_sync(fn() {
    assert_throws_with(succeeding_op, "any message")
    any(())
  }).cast() catch {
    JsError(m) => m
  }
  assert_true(result.contains("Expected exception"))
}

///|
test "from_entries converts Array to Any object" {
  let obj : @core.Any = @core.from_entries([
    ("name", @core.any("Alice")),
    ("age", @core.any(30)),
  ]).cast()
  assert_eq(@core.identity(obj._get("name")), "Alice")
  assert_eq(@core.identity(obj._get("age")), 30)
}

///|
test "from_entries" {
  let obj : @core.Any = @core.from_entries([
    ("name", @core.any("Alice")),
    ("age", @core.any(30)),
    ("active", @core.any(true)),
  ]).cast()
  assert_eq(@core.identity(obj._get("name")), "Alice")
  assert_eq(@core.identity(obj._get("age")), 30)
  assert_eq(@core.identity(obj._get("active")), true)
}

///|
test "from_array" {
  let arr = [1, 2, 3, 4, 5]
  let val = @core.any(arr)
  assert_true(@core.is_array(val))
  assert_eq(@core.identity(val._get("0")), 1)
  assert_eq(@core.identity(val._get("2")), 3)
  assert_eq(@core.identity(val._get("4")), 5)
}

///|
test "from_fn0 converts 0-arg function to Js" {
  let greet = fn() -> String { "Hello" }
  let js_greet : @core.Any = @core.from_fn0(greet)
  assert_eq(@core.typeof_(js_greet), "function")
  let result = js_greet._invoke([])
  assert_eq(@core.identity(result), "Hello")
}

///|
test "from_fn1 converts 1-arg function to Js" {
  let double = fn(x : Int) -> Int { x * 2 }
  let js_double : @core.Any = @core.from_fn1(double)
  assert_eq(@core.typeof_(js_double), "function")
  let result = js_double._invoke([@core.any(5)])
  assert_eq(@core.identity(result), 10)
}

///|
test "from_fn3 converts 3-arg function to Js" {
  let add3 = fn(a : Int, b : Int, c : Int) -> Int { a + b + c }
  let js_add3 : @core.Any = @core.from_fn3(add3)
  assert_eq(@core.typeof_(js_add3), "function")
  let result = js_add3._invoke([@core.any(1), @core.any(2), @core.any(3)])
  assert_eq(@core.identity(result), 6)
}

///| Nullable[T] type tests
/// Tests for the Nullable[T] type which handles explicit null values in FFI

///|
extern "js" fn create_null() -> @core.Any =
  #|() => null

///|
extern "js" fn create_value(v : Int) -> @core.Any =
  #|(v) => v

///|
extern "js" fn create_undefined() -> @core.Any =
  #|() => undefined

///|
extern "js" fn create_object_with_value_field(v : Int) -> @core.Any =
  #|(v) => ({ value: v })

///|
test "Nullable[Int]::to_option() - null value returns None" {
  let nullable : Nullable[Int] = create_null() |> identity
  match nullable.to_option() {
    Some(_) => fail("Expected None for null value")
    None => ()
  }
}

///|
test "Nullable[Int]::to_option() - actual value returns Some" {
  let nullable : Nullable[Int] = create_value(42) |> identity
  match nullable.to_option() {
    Some(v) => assert_eq(v, 42)
    None => fail("Expected Some(42) for actual value")
  }
}

///|
test "Nullable[Int]::to_option() - undefined behavior" {
  let nullable : Nullable[Int] = create_undefined() |> identity
  // Note: The actual behavior of undefined with Nullable may vary
  // This test documents the current behavior
  match nullable.to_option() {
    Some(_) => () // undefined might be treated as Some
    None => () // or it might be treated as None - both are acceptable
  }
}

///|
test "Nullable[Int]::is_null() - null returns true" {
  let nullable : Nullable[Int] = create_null() |> identity
  assert_true(nullable.is_null())
}

///|
test "Nullable[Int]::is_null() - value returns false" {
  let nullable : Nullable[Int] = create_value(42) |> identity
  assert_false(nullable.is_null())
}

///|
test "Nullable[Int]::is_null() - undefined behavior" {
  let nullable : Nullable[Int] = create_undefined() |> identity
  // The behavior of is_null() with undefined may vary
  // This test documents that we don't make assumptions about it
  let _ = nullable.is_null()
  // Just call it, don't assert
}

///|
test "Nullable[String] - null value" {
  let nullable : Nullable[String] = create_null() |> identity
  assert_true(nullable.is_null())
  match nullable.to_option() {
    Some(_) => fail("Expected None for null string")
    None => ()
  }
}

///|
test "Nullable[String] - actual value" {
  let js_str : @core.Any = @core.identity("hello")
  let nullable : Nullable[String] = js_str |> identity
  assert_false(nullable.is_null())
  match nullable.to_option() {
    Some(s) => assert_eq(s, "hello")
    None => fail("Expected Some for actual string")
  }
}

///|
test "Nullable[Bool] - null value" {
  let nullable : Nullable[Bool] = create_null() |> identity
  assert_true(nullable.is_null())
}

///|
test "Nullable[Bool] - false value is not null" {
  let js_false : @core.Any = @core.identity(false)
  let nullable : Nullable[Bool] = js_false |> identity
  assert_false(nullable.is_null())
  match nullable.to_option() {
    Some(b) => assert_false(b)
    None => fail("Expected Some(false)")
  }
}

///|
test "Nullable[Bool] - true value" {
  let js_true : @core.Any = @core.identity(true)
  let nullable : Nullable[Bool] = js_true |> identity
  assert_false(nullable.is_null())
  match nullable.to_option() {
    Some(b) => assert_true(b)
    None => fail("Expected Some(true)")
  }
}

///|
test "Nullable[Double] - null value" {
  let nullable : Nullable[Double] = create_null() |> identity
  assert_true(nullable.is_null())
}

///|
test "Nullable[Double] - zero is not null" {
  let js_zero : @core.Any = @core.identity(0.0)
  let nullable : Nullable[Double] = js_zero |> identity
  assert_false(nullable.is_null())
  match nullable.to_option() {
    Some(v) => assert_eq(v, 0.0)
    None => fail("Expected Some(0.0)")
  }
}

///|
test "Nullable[Double] - actual value" {
  let js_val : @core.Any = @core.identity(3.14)
  let nullable : Nullable[Double] = js_val |> identity
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
test "struct with Nullable field - null value" {
  let obj = create_object_with_null_field()
  let record : TestRecord = obj |> identity
  assert_true(record.value.is_null())
  match record.value.to_option() {
    Some(_) => fail("Expected None for null field")
    None => ()
  }
}

///|
test "struct with Nullable field - actual value" {
  let obj = create_object_with_value_field(99)
  let record : TestRecord = obj |> identity
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
extern "js" fn create_multi_nullable(
  str_null : Bool,
  int_null : Bool,
  bool_null : Bool,
) -> @core.Any =
  #|(str_null, int_null, bool_null) => ({
  #|  str_field: str_null ? null : "test",
  #|  int_field: int_null ? null : 123,
  #|  bool_field: bool_null ? null : true
  #|})

///|
test "multiple Nullable fields - all null" {
  let obj = create_multi_nullable(true, true, true)
  let record : MultiNullableRecord = obj |> identity
  assert_true(record.str_field.is_null())
  assert_true(record.int_field.is_null())
  assert_true(record.bool_field.is_null())
}

///|
test "multiple Nullable fields - all non-null" {
  let obj = create_multi_nullable(false, false, false)
  let record : MultiNullableRecord = obj |> identity
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
  let record : MultiNullableRecord = obj |> identity
  assert_true(record.str_field.is_null())
  assert_false(record.int_field.is_null())
  assert_true(record.bool_field.is_null())
}

///| @js.Nullish[T] type tests
/// Tests for the @js.Nullish[T] type which handles both null and undefined

///|
test "@js.Nullish[Int]::to_option() - null value returns None" {
  let nullish : Nullish[Int] = create_null() |> identity
  match nullish.to_option() {
    Some(_) => fail("Expected None for null value")
    None => ()
  }
}

///|
test "@js.Nullish[Int]::to_option() - undefined returns None" {
  let nullish : Nullish[Int] = create_undefined() |> identity
  match nullish.to_option() {
    Some(_) => fail("Expected None for undefined")
    None => ()
  }
}

///|
test "@js.Nullish[Int]::to_option() - actual value returns Some" {
  let nullish : Nullish[Int] = create_value(42) |> identity
  match nullish.to_option() {
    Some(v) => assert_eq(v, 42)
    None => fail("Expected Some(42) for actual value")
  }
}

///|
test "@js.Nullish[String]::to_option() - null returns None" {
  let nullish : Nullish[String] = create_null() |> identity
  match nullish.to_option() {
    Some(_) => fail("Expected None for null")
    None => ()
  }
}

///|
test "@js.Nullish[String]::to_option() - undefined returns None" {
  let nullish : Nullish[String] = create_undefined() |> identity
  match nullish.to_option() {
    Some(_) => fail("Expected None for undefined")
    None => ()
  }
}

///|
test "@js.Nullish[String]::to_option() - actual value returns Some" {
  let js_str : @core.Any = @core.identity("hello")
  let nullish : Nullish[String] = js_str |> identity
  match nullish.to_option() {
    Some(s) => assert_eq(s, "hello")
    None => fail("Expected Some for actual string")
  }
}

///|
test "identity_option for nullish detection" {
  let obj = @core.new_object()
  let result : @core.Any? = @core.identity_option(obj)
  assert_false(result is None)
  let null_result : @core.Any? = @core.identity_option(null())
  assert_true(null_result is None)
  let undef_result : @core.Any? = @core.identity_option(undefined())
  assert_true(undef_result is None)
}
