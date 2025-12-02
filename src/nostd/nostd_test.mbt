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

// type_of, instance_of, new tests

///|
test "type_of" {
  assert_eq(type_of(any(42)), "number")
  assert_eq(type_of(any("hello")), "string")
  assert_eq(type_of(any(true)), "boolean")
  assert_eq(type_of(undefined()), "undefined")
  assert_eq(type_of(null()), "object") // JS quirk
  assert_eq(type_of(Object::new()), "object")
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
  let obj : @nostd.Any = @nostd.from_entries([
    ("name", @nostd.any("Alice")),
    ("age", @nostd.any(30)),
  ]).cast()
  assert_eq(@nostd.identity(obj._get("name")), "Alice")
  assert_eq(@nostd.identity(obj._get("age")), 30)
}

///|
test "from_entries" {
  let obj : @nostd.Any = @nostd.from_entries([
    ("name", @nostd.any("Alice")),
    ("age", @nostd.any(30)),
    ("active", @nostd.any(true)),
  ]).cast()
  assert_eq(@nostd.identity(obj._get("name")), "Alice")
  assert_eq(@nostd.identity(obj._get("age")), 30)
  assert_eq(@nostd.identity(obj._get("active")), true)
}

///|
test "from_array" {
  let arr = [1, 2, 3, 4, 5]
  let val = @nostd.any(arr)
  assert_true(@nostd.is_array(val))
  assert_eq(@nostd.identity(val._get("0")), 1)
  assert_eq(@nostd.identity(val._get("2")), 3)
  assert_eq(@nostd.identity(val._get("4")), 5)
}
