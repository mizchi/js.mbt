///|
priv enum TestEnum {
  A(value~ : Int)
} derive(Eq, Show)

///|
fn TestEnum::from_js(v : @js.Any) -> Self raise {
  let tag : String = @js.identity(v.get("tag"))
  match tag {
    "A" => {
      let value = v.get("value")
      guard @js.typeof_(value) == "number"
      A(value=@js.identity(value))
    }
    _ => fail("unknown tag: " + tag)
  }
}

///|
impl JsImpl for TestEnum with to_js(self) {
  match self {
    A(value~) => {
      let obj = @js.Object::new()
      obj.set("tag", "A")
      obj.set("value", value)
      obj.to_js()
    }
  }
}

///|
priv enum TestConstantEnum {
  NotFound = 404
}

///|
test "identity converts between Any and MoonBit types" {
  assert_eq(js(42), js(42))
  let v1 = js(42)
  let v2 = js(42)
  assert_eq(v1, v2)
  assert_eq(@js.identity(TestConstantEnum::NotFound), js(404))
  let s1 : String? = js("hello") |> @js.identity_option()
  assert_eq(s1, Some("hello"))
  let s2 : String? = undefined() |> @js.identity_option()
  assert_eq(s2, None)
}

///|
test "identity converts struct to Any object" {
  struct Point {
    x : Int
    y : Int
  } derive(Eq, Show)
  let p = Point::{ x: 10, y: 20 }
  let v : @js.Any = @js.identity(p)
  assert_eq(@js.identity(v.get("x")), 10)
  assert_eq(@js.identity(v.get("y")), 20)
  let casted : Point = @js.identity(v)
  assert_eq(casted, p)
}

///|
test "JsImpl trait converts enum to Any and back" {
  let v : TestEnum = A(value=123)
  let v : @js.Any = v.to_js()
  assert_eq(@js.identity(v.get("tag")), "A")
  assert_eq(@js.identity(v.get("value")), 123)
  let recovered : TestEnum = TestEnum::from_js(v)
  assert_eq(recovered, A(value=123))
}

///|
test "JsImpl::to_string" {
  assert_eq(js(42).to_string(), "42")
  assert_eq(null_().to_string(), "null")
  assert_eq(js(true).to_string(), "true")
  assert_eq(js("hello").to_string(), "hello")
  assert_true(@js.is_undefined(undefined()))
  assert_true(@js.is_null(null_()))
  assert_eq(@js.Object::new().to_string(), "{}")
  assert_eq(@js.JsArray::new().to_string(), "[]")
  from_array([1, 2, 3]).to_string() |> assert_eq("[1,2,3]")
  let expected =
    #|{"a":1,"b":2}
  from_map({ "a": 1 |> js, "b": 2 |> js }).to_string() |> assert_eq(expected)
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
  assert_false(@js.is_null(js(42)))

  // Test is_undefined
  assert_true(@js.is_undefined(undefined()))
  assert_false(@js.is_undefined(null_()))
  assert_false(@js.is_undefined(js(42)))

  // Test is_some and is_none
  assert_false(js(42) |> @js.is_nullish())
  assert_true(undefined() |> @js.is_nullish())
  assert_false(js(42) |> @js.is_nullish())
  assert_true(undefined() |> @js.is_nullish())
  assert_true(null_() |> @js.is_nullish())
}

///|
test "Js typeof_" {
  assert_eq(@js.typeof_(js(42)), "number")
  assert_eq(@js.typeof_(js(3.14)), "number")
  assert_eq(@js.typeof_(js("hello")), "string")
  assert_eq(@js.typeof_(js(true)), "boolean")
  assert_eq(@js.typeof_(undefined()), "undefined")
  assert_eq(@js.typeof_(Object::new()), "object")
  assert_eq(@js.typeof_(JsArray::new()), "object")
  assert_eq(@js.typeof_(null_()), "object") // JavaScript quirk
}

///|
test "JsImpl get/set" {
  let obj = @js.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)
  obj.set("active", true)
  assert_eq(@js.identity(obj.get("name")), "Alice")
  assert_eq(@js.identity(obj.get("age")), 30)
  assert_eq(@js.identity(obj.get("active")), true)

  // Test nested objects
  let nested = @js.Object::new()
  nested.set("inner", "value")
  obj.set("nested", nested)
  assert_eq(@js.identity(obj.get("nested").get("inner")), "value")
}

///|
test "JsImpl::delete and hasOwnProperty" {
  let obj = @js.Object::new()
  obj.set("key1", "value1")
  obj.set("key2", "value2")
  assert_true(obj.hasOwnProperty("key1"))
  assert_true(obj.hasOwnProperty("key2"))
  assert_false(obj.hasOwnProperty("key3"))
  obj.delete("key1")
  assert_false(obj.hasOwnProperty("key1"))
  assert_true(obj.hasOwnProperty("key2"))
}

///|
test "JsImpl::equal" {
  // Same values should be equal
  assert_eq(js(42), js(42))
  assert_eq(js("hello"), js("hello"))
  assert_eq(js(true), js(true))

  // Different values should not be equal
  assert_false(js(42) == js(43))
  assert_false(js("hello") == js("world"))

  // Special values
  assert_eq(null_(), null_())
  assert_eq(undefined(), undefined())
  assert_false(null_() == undefined())
}

///|
test "Js with arrays" {
  let arr = from_array([1, 2, 3])
  assert_true(@js.is_array(arr))
  assert_eq(@js.identity(arr.get(0)), 1)
  assert_eq(@js.identity(arr.get(1)), 2)
  assert_eq(@js.identity(arr.get(2)), 3)

  // Modify array
  arr.set(1, 10)
  assert_eq(@js.identity(arr.get(1)), 10)
}

///|
test "Js with nested structures" {
  let root = @js.Object::new()
  let user = @js.Object::new()
  user.set("name", "Alice")
  user.set("age", 30)
  let address = @js.Object::new()
  address.set("city", "Tokyo")
  address.set("country", "Japan")
  user.set("address", address)
  root.set("user", user)

  // Access nested values
  assert_eq(@js.identity(root.get("user").get("name")), "Alice")
  assert_eq(@js.identity(root.get("user").get("age")), 30)
  assert_eq(@js.identity(root.get("user").get("address").get("city")), "Tokyo")
  assert_eq(
    @js.identity(root.get("user").get("address").get("country")),
    "Japan",
  )
}

///|
test "Val Show trait" {
  assert_eq(js(42).to_string(), "42")
  assert_eq(js(3.14).to_string(), "3.14")
  assert_eq(js("hello").to_string(), "hello")
  assert_eq(js(true).to_string(), "true")
  assert_eq(js(false).to_string(), "false")
  assert_eq(null_().to_string(), "null")
  assert_eq(Object::new().to_js().to_string(), "{}")
  assert_eq(JsArray::new().to_js().to_string(), "[]")
}

///|
test "Val with mixed types in object" {
  let obj = @js.Object::new()
  obj.set("string", "text")
  obj.set("number", 42)
  obj.set("float", 3.14)
  obj.set("boolean", true)
  obj.set("null", null_())
  obj.set("array", from_array([1, 2, 3]))
  obj.set("object", Object::new())
  assert_eq(@js.typeof_(obj.get("string")), "string")
  assert_eq(@js.typeof_(obj.get("number")), "number")
  assert_eq(@js.typeof_(obj.get("float")), "number")
  assert_eq(@js.typeof_(obj.get("boolean")), "boolean")
  assert_eq(@js.typeof_(obj.get("null")), "object")
  assert_true(@js.is_array(obj.get("array")))
  assert_true(@js.is_object(obj.get("object")))
}

///|
test "Js trait for primitives" {
  // String
  let str_js : @js.Any = JsImpl::to_js("hello")
  assert_eq(@js.identity(str_js), "hello")

  // Int
  let int_js : @js.Any = JsImpl::to_js(42)
  assert_eq(@js.identity(int_js), 42)

  // Double
  let double_js : @js.Any = JsImpl::to_js(3.14)
  assert_eq(@js.identity(double_js), 3.14)

  // Bool
  let bool_js : @js.Any = JsImpl::to_js(true)
  assert_eq(@js.identity(bool_js), true)

  // Val (identity)
  let val = @js.js(100)
  let val_js : @js.Any = JsImpl::to_js(val)
  assert_eq(val_js, val)
}

///|
test "JsImpl for Array[&JsImpl]" {
  let arr : Array[&JsImpl] = ["hello", 42, 3.14, true]
  let val = JsImpl::to_js(arr)
  assert_true(@js.is_array(val))
  assert_eq(@js.identity(val.get(0)), "hello")
  assert_eq(@js.identity(val.get(1)), 42)
  assert_eq(@js.identity(val.get(2)), 3.14)
  assert_eq(@js.identity(val.get(3)), true)
}

///|
test "JsImpl for Option[T]" {
  // Some value
  let some_val : Int? = Some(42)
  let some_js = JsImpl::to_js(some_val)
  assert_eq(@js.identity(some_js), 42)

  // None value - represented as undefined in MoonBit
  let none_val : Int? = None
  let none_js = JsImpl::to_js(none_val)
  assert_true(@js.is_undefined(none_js))
}

///|
test "Js numeric edge cases" {
  // Large integers
  let large = js(1000000)
  assert_eq(@js.identity(large), 1000000)

  // Negative numbers
  let negative = js(-42)
  assert_eq(@js.identity(negative), -42)

  // Very small float
  let small = js(0.0001)
  assert_eq(@js.identity(small), 0.0001)
}

///|
test "Js Show trait" {
  let obj = @js.Object::new()
  obj.set("name", "test")
  let str = obj.to_js().to_string()
  assert_true(str.contains("Object") || str.length() > 0)
}

///| Global Functions Tests

///|
test "parseInt - parse decimal integers" {
  assert_eq(parseInt("42"), Some(42))
  assert_eq(parseInt("0"), Some(0))
  assert_eq(parseInt("-123"), Some(-123))
  assert_eq(parseInt("  456  "), Some(456)) // Leading/trailing whitespace
}

///|
test "parseInt - parse with different radix" {
  assert_eq(parseInt("ff", radix=16), Some(255))
  assert_eq(parseInt("FF", radix=16), Some(255))
  assert_eq(parseInt("101", radix=2), Some(5))
  assert_eq(parseInt("77", radix=8), Some(63))
  assert_eq(parseInt("z", radix=36), Some(35))
}

///|
test "parseInt - return None for invalid input" {
  assert_eq(parseInt("hello"), None)
  assert_eq(parseInt(""), None)
  assert_eq(parseInt("abc", radix=10), None)
}

///|
test "parseInt - partial parsing" {
  // JavaScript parseInt parses as much as it can
  assert_eq(parseInt("123abc"), Some(123))
  assert_eq(parseInt("42.5"), Some(42))
}

///|
test "parseFloat - parse floating point numbers" {
  assert_eq(parseFloat("3.14"), Some(3.14))
  assert_eq(parseFloat("0.5"), Some(0.5))
  assert_eq(parseFloat("-2.5"), Some(-2.5))
  assert_eq(parseFloat("123"), Some(123.0))
}

///|
test "parseFloat - parse scientific notation" {
  assert_eq(parseFloat("1.5e2"), Some(150.0))
  assert_eq(parseFloat("1e-3"), Some(0.001))
}

///|
test "parseFloat - return None for invalid input" {
  assert_eq(parseFloat("hello"), None)
  assert_eq(parseFloat(""), None)
}

///|
test "parseFloat - partial parsing" {
  assert_eq(parseFloat("3.14abc"), Some(3.14))
}

///|
test "isFinite - check finite numbers" {
  assert_eq(isFinite(42.0), true)
  assert_eq(isFinite(0.0), true)
  assert_eq(isFinite(-123.456), true)
}

///|
test "isFinite - check infinite values" {
  let inf = 1.0 / 0.0
  let neg_inf = -1.0 / 0.0
  assert_eq(isFinite(inf), false)
  assert_eq(isFinite(neg_inf), false)
}

///|
test "isFinite - check NaN" {
  let nan_val = 0.0 / 0.0
  assert_eq(isFinite(nan_val), false)
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
    throw_(err)
  }) catch {
    e => error_str = e.to_string()
  }
  inspect(error_str, content="Show test error")
}

///|
test "ThrowError::from_js with TypeError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testTypeError = new TypeError('Type error')"),
  ])
  |> ignore
  let js_error = global.get("testTypeError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::TypeError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with RangeError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testRangeError = new RangeError('Range error')"),
  ])
  |> ignore
  let js_error = global.get("testRangeError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::RangeError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with ReferenceError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testRefError = new ReferenceError('Ref error')"),
  ])
  |> ignore
  let js_error = global.get("testRefError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::ReferenceError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with SyntaxError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testSyntaxError = new SyntaxError('Syntax error')"),
  ])
  |> ignore
  let js_error = global.get("testSyntaxError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::SyntaxError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with URIError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testURIError = new URIError('URI error')"),
  ])
  |> ignore
  let js_error = global.get("testURIError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::URIError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with EvalError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testEvalError = new EvalError('Eval error')"),
  ])
  |> ignore
  let js_error = global.get("testEvalError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::EvalError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with AggregateError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testAggError = new AggregateError([], 'Agg error')"),
  ])
  |> ignore
  let js_error = global.get("testAggError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::AggregateError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with generic Error" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testGenericError = new Error('Generic error')"),
  ])
  |> ignore
  let js_error = global.get("testGenericError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::Error(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with non-error value" {
  let value = @js.js("plain string value")
  let throw_error = ThrowError::from_js(value)
  match throw_error {
    ThrowError::Value(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "JsIterator::drop" {
  let arr = @js.JsArray::new()
  arr.push(1)
  arr.push(2)
  arr.push(3)
  arr.push(4)
  arr.push(5)
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr.to_js())
  let dropped = iter.drop(2)
  let result = dropped.toArray()
  inspect(result.length(), content="3")
  inspect(result[0], content="3")
  inspect(result[1], content="4")
  inspect(result[2], content="5")
}

///|
test "JsIterator::take" {
  let arr = @js.JsArray::new()
  arr.push(1)
  arr.push(2)
  arr.push(3)
  arr.push(4)
  arr.push(5)
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr.to_js())
  let taken = iter.take(3)
  let result = taken.toArray()
  inspect(result.length(), content="3")
  inspect(result[0], content="1")
  inspect(result[1], content="2")
  inspect(result[2], content="3")
}

///|
test "JsIterator::drop and take combined" {
  let arr = @js.JsArray::new()
  for i = 0; i < 10; i = i + 1 {
    arr.push(i)
  }
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr.to_js())
  let result = iter.drop(2).take(5).toArray()
  inspect(result.length(), content="5")
  inspect(result[0], content="2")
  inspect(result[4], content="6")
}
