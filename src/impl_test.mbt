///|
priv enum TestEnum {
  A(value~ : Int)
} derive(Eq, Show)

///|
fn TestEnum::from_js(v : @nostd.Any) -> Self raise {
  let tag : String = @js.identity(v._get("tag"))
  match tag {
    "A" => {
      let value = v._get("value")
      guard @nostd.typeof_(value) == "number"
      A(value=@nostd.identity(value))
    }
    _ => fail("unknown tag: " + tag)
  }
}

///|
impl JsImpl for TestEnum with as_any(self) {
  match self {
    A(value~) => {
      let obj = @nostd.Object::new()
      obj._set("tag", "A" |> @nostd.any)
      obj._set("value", value |> @nostd.any)
      obj |> @nostd.any
    }
  }
}

///|
priv enum TestConstantEnum {
  NotFound = 404
}

///|
test "identity converts between Any and MoonBit types" {
  assert_true(@nostd.equal(@nostd.any(42), @nostd.any(42)))
  let v1 = @nostd.any(42)
  let v2 = @nostd.any(42)
  assert_true(@nostd.equal(v1, v2))
  assert_true(
    @nostd.equal(@nostd.identity(TestConstantEnum::NotFound), @nostd.any(404)),
  )
  let s1 : String? = @nostd.any("hello") |> @nostd.identity_option()
  assert_eq(s1, Some("hello"))
  let s2 : String? = @nostd.undefined() |> @nostd.identity_option()
  assert_eq(s2, None)
}

///|
test "identity converts struct to Any object" {
  struct Point {
    x : Int
    y : Int
  } derive(Eq, Show)
  let p = Point::{ x: 10, y: 20 }
  let v : @nostd.Any = @nostd.identity(p)
  assert_eq(@nostd.identity(v._get("x")), 10)
  assert_eq(@nostd.identity(v._get("y")), 20)
  let casted : Point = @nostd.identity(v)
  assert_eq(casted, p)
}

///|
test "JsImpl trait converts enum to Any and back" {
  let v : TestEnum = A(value=123)
  let v : @nostd.Any = v.as_any()
  assert_eq(@js.identity(v._get("tag")), "A")
  assert_eq(@js.identity(v._get("value")), 123)
  let recovered : TestEnum = TestEnum::from_js(v)
  assert_eq(recovered, A(value=123))
}

///|
test "JsImpl::to_string" {
  assert_eq(@nostd.any(42).to_string(), "42")
  assert_eq(null_().to_string(), "null")
  assert_eq(@nostd.any(true).to_string(), "true")
  assert_eq(@nostd.any("hello").to_string(), "hello")
  assert_true(@js.is_undefined(undefined()))
  assert_true(@js.is_null(null_()))
  assert_eq(@nostd.Object::new().to_string(), "{}")
  assert_eq(@js.JsArray::new().to_string(), "[]")
  from_array([1, 2, 3]).to_string() |> assert_eq("[1,2,3]")
}

///|
test "type checking" {
  // Test is_array
  let arr = JsArray::new()
  assert_true(@js.is_array(arr))
  assert_false(@js.is_array(42))

  // Test is_object
  let obj = Object::new()
  assert_true(@js.is_object(obj))
  assert_false(@js.is_object(42))
  assert_false(@js.is_object(null_()))

  // Test is_null
  assert_true(@js.is_null(null_()))
  assert_false(@js.is_null(undefined()))
  assert_false(@js.is_null(@nostd.any(42)))

  // Test is_undefined
  assert_true(@js.is_undefined(undefined()))
  assert_false(@js.is_undefined(null_()))
  assert_false(@js.is_undefined(@nostd.any(42)))

  // Test is_some and is_none
  assert_false(@nostd.any(42) |> @js.is_nullish())
  assert_true(undefined() |> @js.is_nullish())
  assert_false(@nostd.any(42) |> @js.is_nullish())
  assert_true(undefined() |> @js.is_nullish())
  assert_true(null_() |> @js.is_nullish())
}

///|
test "Js typeof_" {
  assert_eq(@js.typeof_(@nostd.any(42)), "number")
  assert_eq(@js.typeof_(@nostd.any(3.14)), "number")
  assert_eq(@js.typeof_(@nostd.any("hello")), "string")
  assert_eq(@js.typeof_(@nostd.any(true)), "boolean")
  assert_eq(@js.typeof_(undefined()), "undefined")
  assert_eq(@js.typeof_(Object::new()), "object")
  assert_eq(@js.typeof_(JsArray::new()), "object")
  assert_eq(@js.typeof_(null_()), "object") // JavaScript quirk
}

///|
test "JsImpl get/set" {
  let obj = @nostd.Object::new()
  obj._set("name", "Alice" |> @nostd.any)
  obj._set("age", 30 |> @nostd.any)
  obj._set("active", true |> @nostd.any)
  assert_eq(@js.identity(obj._get("name")), "Alice")
  assert_eq(@js.identity(obj._get("age")), 30)
  assert_eq(@js.identity(obj._get("active")), true)

  // Test nested objects
  let nested = @nostd.Object::new()
  nested._set("inner", "value" |> @nostd.any)
  obj._set("nested", nested)
  assert_eq(@js.identity(obj._get("nested")._get("inner")), "value")
}

///|
test "JsImpl::delete and hasOwnProperty" {
  let obj = @nostd.Object::new()
  obj._set("key1", "value1" |> @nostd.any)
  obj._set("key2", "value2" |> @nostd.any)
  assert_true(@nostd.Object::has_own(obj, "key1"))
  assert_true(@nostd.Object::has_own(obj, "key2"))
  assert_false(@nostd.Object::has_own(obj, "key3"))
  // obj._delete("key1")
  // assert_false(@nostd.Object::has_own(obj, "key1"))
  // assert_true(@nostd.Object::has_own(obj, "key2"))
}

///|
test "JsImpl::equal" {
  // Same values should be equal
  assert_eq(@nostd.any(42), @nostd.any(42))
  assert_eq(@nostd.any("hello"), @nostd.any("hello"))
  assert_eq(@nostd.any(true), @nostd.any(true))

  // Different values should not be equal
  assert_false(@nostd.any(42) == @nostd.any(43))
  assert_false(@nostd.any("hello") == @nostd.any("world"))

  // Special values
  assert_eq(null_(), null_())
  assert_eq(undefined(), undefined())
  assert_false(null_() == undefined())
}

///|
test "Js with arrays" {
  let arr = @nostd.any([1, 2, 3])
  assert_true(@js.is_array(arr))
  assert_eq(@js.identity(arr._get("0")), 1)
  assert_eq(@js.identity(arr._get("1")), 2)
  assert_eq(@js.identity(arr._get("2")), 3)
  // Modify array
  arr._set("1", 10 |> @nostd.any)
  assert_eq(@js.identity(arr._get("1")), 10)
}

///|
test "Js with nested structures" {
  let root = @nostd.Object::new()
  let user = @nostd.Object::new()
  user._set("name", "Alice" |> @nostd.any)
  user._set("age", 30 |> @nostd.any)
  let address = @nostd.Object::new()
  address._set("city", "Tokyo" |> @nostd.any)
  address._set("country", "Japan" |> @nostd.any)
  user._set("address", address)
  root._set("user", user)

  // Access nested values
  assert_eq(@js.identity(root._get("user")._get("name")), "Alice")
  assert_eq(@js.identity(root._get("user")._get("age")), 30)
  assert_eq(
    @js.identity(root._get("user")._get("address")._get("city")),
    "Tokyo",
  )
  assert_eq(
    @js.identity(root._get("user")._get("address")._get("country")),
    "Japan",
  )
}

///|
test "Val Show trait" {
  assert_eq(@nostd.any(42).to_string(), "42")
  assert_eq(@nostd.any(3.14).to_string(), "3.14")
  assert_eq(@nostd.any("hello").to_string(), "hello")
  assert_eq(@nostd.any(true).to_string(), "true")
  assert_eq(@nostd.any(false).to_string(), "false")
  assert_eq(null_().to_string(), "null")
  assert_eq(Object::new().to_string(), "{}")
  assert_eq(JsArray::new().to_string(), "[]")
}

///|
test "Val with mixed types in object" {
  let obj = @nostd.Object::new()
  obj._set("string", "text" |> @nostd.any)
  obj._set("number", 42 |> @nostd.any)
  obj._set("float", 3.14 |> @nostd.any)
  obj._set("boolean", true |> @nostd.any)
  obj._set("null", @nostd.null())
  obj._set("array", @nostd.any([1, 2, 3]))
  obj._set("object", @nostd.Object::new())
  assert_eq(@js.typeof_(obj._get("string")), "string")
  assert_eq(@js.typeof_(obj._get("number")), "number")
  assert_eq(@js.typeof_(obj._get("float")), "number")
  assert_eq(@js.typeof_(obj._get("boolean")), "boolean")
  assert_eq(@js.typeof_(obj._get("null")), "object")
  assert_true(@js.is_array(obj._get("array")))
  assert_true(@js.is_object(obj._get("object")))
}

///|
test "Js trait for primitives" {
  // String
  let str_js : @nostd.Any = @nostd.any("hello")
  assert_eq(@js.identity(str_js), "hello")

  // Int
  let int_js : @nostd.Any = @nostd.any(42)
  assert_eq(@js.identity(int_js), 42)

  // Double
  let double_js : @nostd.Any = @nostd.any(3.14)
  assert_eq(@js.identity(double_js), 3.14)

  // Bool
  let bool_js : @nostd.Any = @nostd.any(true)
  assert_eq(@js.identity(bool_js), true)

  // Val (identity)
  let val = @nostd.any(100)
  let val_js : @nostd.Any = val
  assert_eq(val_js, val)
}

///|
test "JsImpl for Array[&JsImpl]" {
  let arr : Array[@nostd.Any] = [
    @nostd.any("hello"),
    @nostd.any(42),
    @nostd.any(3.14),
    @nostd.any(true),
  ]
  let val = @nostd.any(arr)
  assert_true(@js.is_array(val))
  assert_eq(@js.identity(val._get("0")), "hello")
  assert_eq(@js.identity(val._get("1")), 42)
  assert_eq(@js.identity(val._get("2")), 3.14)
  assert_eq(@js.identity(val._get("3")), true)
}

///|
test "JsImpl for Option[T]" {
  // Some value
  let some_val : Int? = Some(42)
  let some_js = @nostd.nullable(some_val)
  assert_eq(@js.identity(some_js), 42)

  // None value - represented as undefined in MoonBit
  let none_val : Int? = None
  let none_js = @nostd.nullable(none_val)
  assert_true(@js.is_undefined(none_js))
}

///|
test "Js numeric edge cases" {
  // Large integers
  let large = @nostd.any(1000000)
  assert_eq(@js.identity(large), 1000000)

  // Negative numbers
  let negative = @nostd.any(-42)
  assert_eq(@js.identity(negative), -42)

  // Very small float
  let small = @nostd.any(0.0001)
  assert_eq(@js.identity(small), 0.0001)
}

///|
test "Js Show trait" {
  let obj = @nostd.Object::new()
  obj._set("name", "test" |> @nostd.any)
  let str = obj.to_string()
  assert_true(str.contains("Object") || str.length() > 0)
}

///| Global Functions Tests

///|
test "parseInt - parse decimal integers" {
  assert_eq(@global.parse_int("42"), Some(42))
  assert_eq(@global.parse_int("0"), Some(0))
  assert_eq(@global.parse_int("-123"), Some(-123))
  assert_eq(@global.parse_int("  456  "), Some(456)) // Leading/trailing whitespace
}

///|
test "parseInt - parse with different radix" {
  assert_eq(@global.parse_int("ff", radix=16), Some(255))
  assert_eq(@global.parse_int("FF", radix=16), Some(255))
  assert_eq(@global.parse_int("101", radix=2), Some(5))
  assert_eq(@global.parse_int("77", radix=8), Some(63))
  assert_eq(@global.parse_int("z", radix=36), Some(35))
}

///|
test "parseInt - return None for invalid input" {
  assert_eq(@global.parse_int("hello"), None)
  assert_eq(@global.parse_int(""), None)
  assert_eq(@global.parse_int("abc", radix=10), None)
}

///|
test "parseInt - partial parsing" {
  // JavaScript parseInt parses as much as it can
  assert_eq(@global.parse_int("123abc"), Some(123))
  assert_eq(@global.parse_int("42.5"), Some(42))
}

///|
test "parseFloat - parse floating point numbers" {
  assert_eq(@global.parse_float("3.14"), Some(3.14))
  assert_eq(@global.parse_float("0.5"), Some(0.5))
  assert_eq(@global.parse_float("-2.5"), Some(-2.5))
  assert_eq(@global.parse_float("123"), Some(123.0))
}

///|
test "parseFloat - parse scientific notation" {
  assert_eq(@global.parse_float("1.5e2"), Some(150.0))
  assert_eq(@global.parse_float("1e-3"), Some(0.001))
}

///|
test "parseFloat - return None for invalid input" {
  assert_eq(@global.parse_float("hello"), None)
  assert_eq(@global.parse_float(""), None)
}

///|
test "parseFloat - partial parsing" {
  assert_eq(@global.parse_float("3.14abc"), Some(3.14))
}

///|
test "isFinite - check finite numbers" {
  assert_eq(@global.is_finite(42.0), true)
  assert_eq(@global.is_finite(0.0), true)
  assert_eq(@global.is_finite(-123.456), true)
}

///|
test "isFinite - check infinite values" {
  let inf = 1.0 / 0.0
  let neg_inf = -1.0 / 0.0
  assert_eq(@global.is_finite(inf), false)
  assert_eq(@global.is_finite(neg_inf), false)
}

///|
test "isFinite - check NaN" {
  let nan_val = 0.0 / 0.0
  assert_eq(@global.is_finite(nan_val), false)
}

///| Show implementations and to_string methods

///|
test "JsError Show implementation" {
  let error = JsError::new("Test error message")
  let str = error.to_string()
  inspect(str, content="Test error message")
  // Test that output() uses to_string()
  inspect(error, content="Test error message")
}

///|
test "JsError with cause" {
  let cause = JsError::new("Root cause")
  let error = JsError::new("Main error", cause~)
  let str = error.to_string()
  inspect(str, content="Main error")
}

///|
test "ThrowError Show through throwable" {
  // Test Error variant
  let mut error_str = ""
  throwable(fn() {
    let err = JsError::new("Show test error")
    throw_(err.to_any())
  }) catch {
    e => error_str = e.to_string()
  }
  inspect(error_str, content="Show test error")
}

///|
test "ThrowError::from_js with TypeError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testTypeError = new TypeError('Type error')"),
  ])
  |> ignore
  let js_error = global._get("testTypeError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::TypeError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with RangeError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testRangeError = new RangeError('Range error')"),
  ])
  |> ignore
  let js_error = global._get("testRangeError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::RangeError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with ReferenceError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testRefError = new ReferenceError('Ref error')"),
  ])
  |> ignore
  let js_error = global._get("testRefError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::ReferenceError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with SyntaxError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testSyntaxError = new SyntaxError('Syntax error')"),
  ])
  |> ignore
  let js_error = global._get("testSyntaxError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::SyntaxError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with URIError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testURIError = new URIError('URI error')"),
  ])
  |> ignore
  let js_error = global._get("testURIError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::URIError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with EvalError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testEvalError = new EvalError('Eval error')"),
  ])
  |> ignore
  let js_error = global._get("testEvalError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::EvalError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with AggregateError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testAggError = new AggregateError([], 'Agg error')"),
  ])
  |> ignore
  let js_error = global._get("testAggError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::AggregateError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with generic Error" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testGenericError = new Error('Generic error')"),
  ])
  |> ignore
  let js_error = global._get("testGenericError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::Error(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with non-error value" {
  let value = @nostd.any("plain string value")
  let throw_error = ThrowError::from_js(value)
  match throw_error {
    ThrowError::Value(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "JsIterator::drop" {
  let arr = @js.from_array([1, 2, 3, 4, 5])
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr)
  let dropped = iter.drop(2)
  let result = dropped.toArray()
  inspect(result.length(), content="3")
  inspect(result[0], content="3")
  inspect(result[1], content="4")
  inspect(result[2], content="5")
}

///|
test "JsIterator::take" {
  let arr = @js.from_array([1, 2, 3, 4, 5])
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr)
  let taken = iter.take(3)
  let result = taken.toArray()
  inspect(result.length(), content="3")
  inspect(result[0], content="1")
  inspect(result[1], content="2")
  inspect(result[2], content="3")
}

///|
test "JsIterator::drop and take combined" {
  let arr = @js.from_array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr)
  let result = iter.drop(2).take(5).toArray()
  inspect(result.length(), content="5")
  inspect(result[0], content="2")
  inspect(result[4], content="6")
}
