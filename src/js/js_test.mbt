using @js {
  type Value,
  type JsError,
  type Promise,
  trait ToJs,
  // identity,
}
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
  obj |> @js.stringify(indent=2)
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
priv struct Params {
  x : Int
  events : Map[String, () -> Unit]
}

///|
impl ToJs for Params with to_js(self) -> @js.Value {
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
  let p = Params::{ x: 123, events }
  let js_val: @js.Value = p.to_js()
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
  |> @js.identity
  v |> @js.stringify(indent=2)
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
extern "js" fn test_no_error_fn() -> Value = "() => () => 1"

///|
extern "js" fn test_error_thrower_fn() -> Value = "() => () => { throw new TypeError('This is a test TypeError'); }"

///|
test {
  let test_fn = test_no_error_fn()
  let args : Array[Value] = []
  let r : Result[Int, JsError] = try? test_fn.try_call(args)
  match r {
    Ok(v) => log("Function call succeeded with value: \{v}")
    _ => fail("Function call was expected to succeed")
  }
}

///|
test {
  let test_fn = test_error_thrower_fn()
  let args : Array[Value] = []
  let r : Result[Int, JsError] = try? test_fn.try_call(args)
  match r {
    Err(_e) => assert_true(true)
    _ => fail("Function call was expected to fail")
  }
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
    println("Got value from promise: \{v}")
    let v2 = f().then(v => v.to_string() |> Promise::resolve).wait() catch {
      _ => "error"
    }
    println("Got value from promise then: \{v2}")
  })
}
