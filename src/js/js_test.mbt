///|
using @js {type Value, type Promise, trait ToJs, log}

///|
test "moonbit to js value" {
  let obj = @js.new_object()
  obj
  ..set("key2", "y")
  ..set("key1", 123.0)
  ..set("key3", true)
  ..set("key4", @js.js_null())
  let nested = @js.new_object()
  nested.set("nkey5", "nested value")
  obj.set("nested", nested)
  let arr = @js.new_array()
  arr..push("item1")..push(2.0)..push(false)
  obj.set("array", arr)
  obj
  |> @js.stringify(indent=2)
  |> inspect(
    content=(
      #|{
      #|  "key2": "y",
      #|  "key1": 123,
      #|  "key3": true,
      #|  "key4": null,
      #|  "nested": {
      #|    "nkey5": "nested value"
      #|  },
      #|  "array": [
      #|    "item1",
      #|    2,
      #|    false
      #|  ]
      #|}
    ),
  )
  assert_eq(obj.get("key1").cast(), 123)
  obj.get("key1") |> Value::is_number |> assert_true
  obj.get("key1") |> Value::is_nan |> assert_false
  assert_eq(obj.get("key2").cast(), "y")
  assert_eq(obj.get("key3").cast(), true)
}

///|
priv struct ParamsToCast {
  x : Int
  events : Map[String, () -> Unit]
}

///|
impl ToJs for ParamsToCast with to_js(self) -> @js.Value {
  let obj = @js.new_object()
  obj.set("x", self.x)
  for k, v in self.events {
    let h = fn() {
      v()
      @js.js_undefined()
    }
    obj.set(k, to_js(h))
  }
  obj
}

///|
test "handlers in js value" {
  let mut called = 0
  let events : Map[String, () -> Unit] = {
    "click": fn() { called = called + 1 },
    "hover": fn() { called = called + 1 },
  }
  let p = ParamsToCast::{ x: 123, events }
  let js_val : @js.Value = p.to_js()
  assert_eq(js_val.get("x").cast(), 123)
  let x = js_val.get("hover")
  x.is_function() |> assert_true
  let _ = x.call([])
  let v : Int = js_val.get("x").cast()
  assert_eq(v, 123)
  assert_eq(called, 1)
}

///|
test "Value::from" {
  let v = @js.Object::from({ "key1": 123, "key2": "str", "key3": true })
  v
  |> identity
  |> stringify(indent=2)
  |> inspect(
    content=(
      #|{
      #|  "key1": 123,
      #|  "key2": "str",
      #|  "key3": true
      #|}
    ),
  )
}

///|
test {
  let f = fn() {
    let (promise, resolve, _reject) = Promise::deferred()
    run_async(() => {
      @js.sleep(10)
      resolve(42)
    })
    promise
  }
  run_async(() => {
    @js.sleep(10)
    let v : Int = f().wait() catch { _ => 0 }
    guard v == 42
    let v2 = f().then(v => v.to_string() |> Promise::resolve).wait() catch {
      _ => "error"
    }
    guard v2 == "42"
  })
}

///|
test "error call" {
  let v = global_this().get("none")
  assert_true(v.is_undefined())
  let r = v.safe_call([])
  assert_true(r is Err(_))
  let rv : Int? = global_this().get("___").to_option()
  assert_true(rv is None)
  try {
    let rv2 : Int? = global_this().get("___").cast_option()
    fail("Expected to fail casting undefined to Int, but got \{rv2}")
  } catch {
    _e => assert_true(true)
  }
}

///|
test "equal" {
  // object equal
  let v1 = @js.new_object()
  let v2 = v1
  let v3 = @js.new_object()
  assert_true(v1 == v2)
  assert_false(v1 == v3)

  // primitive equal
  let v4 : Value = 123 |> to_js()
  let v5 : Value = 123 |> to_js()
  assert_true(v4 == v5)
}

///|
test "to_string" {
  let v : Value = 123 |> to_js()
  assert_eq(v.to_string(), "123")
  let s : Value = "hello" |> to_js()
  assert_eq(s.to_string(), "hello")
}
