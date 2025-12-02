# MoonBit JavaScript FFI Examples

Common usage patterns for the `mizchi/js` library.

## Object Operations

```moonbit

///|
test "basic object operations" {
  let obj = @nostd.Object::new()
  obj.set("name", "MoonBit")
  obj.set("version", 1)
  inspect(@js.JSON::stringify(obj), content=(
    #|{
    #|  "name": "MoonBit",
    #|  "version": 1
    #|}
  ))

  // Property access with different key types
  obj.set(0, "first") // Int key
  let sym = @js.symbol("custom")
  obj.set(sym, "symbol value") // Symbol key

  // Object methods
  let _keys = @js.Object::keys(obj)
  let _values = @js.Object::values(obj)
  @js.Object::freeze(obj) |> ignore
  assert_eq(@js.Object::isFrozen(obj), true)
}
```

## Arrays

```moonbit

///|
test "array operations" {
  let arr = @nostd.any([1, 2, 3])
  arr._call("push", [4 |> @nostd.any]) |> ignore
  inspect(@js.JSON::stringify(arr), content=(
    #|[
    #|  1,
    #|  2,
    #|  3,
    #|  4
    #|]
  ))

  // Higher-order methods
  let filtered = arr.call1(
    "filter",
    @js.from_fn1(fn(x : @nostd.Any) -> Bool {
      let n : Int = @js.identity(x)
      n > 2
    }),
  )
  inspect(filtered, content="3,4")
}
```

## Type Conversion

```moonbit

///|
test "type conversion" {
  // MoonBit -> JS
  let num_js = @nostd.any(42)
  let str_js = @nostd.any("hello")

  // JS -> MoonBit
  let num : Int = @js.identity(num_js)
  let str : String = @js.identity(str_js)
  assert_eq(num, 42)
  assert_eq(str, "hello")

  // Optional values
  let obj = @nostd.Object::new()
  obj.set("exists", "value")
  let exists : String? = @js.identity_option(obj._get("exists"))
  let missing : String? = @js.identity_option(obj._get("missing"))
  assert_eq(exists, Some("value"))
  assert_eq(missing, None)
}
```

## Type Checking

```moonbit

///|
test "type checking" {
  let arr = @js.JsArray::from([1, 2, 3])
  let obj = @nostd.Object::new()
  let undef = @js.undefined()
  assert_eq(@js.is_array(arr), true)
  assert_eq(@js.is_object(obj), true)
  assert_eq(@js.is_undefined(undef), true)
  assert_eq(@js.is_nullish(undef), true)
}
```

## Method Calls

```moonbit

///|
test "method calls" {
  let obj = @nostd.Object::new()
  obj["name"] = "test" |> @nostd.any

  // Specific arities (optimized)
  inspect(obj.call0("toString"), content="[object Object]")
  inspect(obj.call1("hasOwnProperty", "name" |> @nostd.any), content="true")

  // Variable arguments
  let result = obj._call("hasOwnProperty", ["name" |> @nostd.any])
  assert_eq(@js.identity(result), true)
}
```

## Function Conversion

```moonbit

///|
test "function conversion" {
  // MoonBit function -> JS function
  let fn1 = @js.from_fn1(fn(x : Int) -> Int { x * 2 })
  let result : Int = @js.identity(fn1._invoke([10 |> @nostd.any]))
  assert_eq(result, 20)

  // Calling JS functions
  let parseInt = @nostd.global_this()._get("parseInt")
  let parsed : Int = @js.identity(parseInt._invoke(["123" |> @nostd.any]))
  assert_eq(parsed, 123)
}
```

## Constructors

```moonbit

///|
test "constructors" {
  let array_ctor = @nostd.global_this()._get("Array")
  let arr = @nostd.new(array_ctor, [@nostd.any(3)])
  inspect(@js.JSON::stringify(arr), content=(
    #|[
    #|  null,
    #|  null,
    #|  null
    #|]
  ))
}
```

## JSON

```moonbit

///|
test "json" {
  let obj = @nostd.Object::new()
  obj["name"] = "Moonbit" |> @nostd.any
  let json_str = @js.JSON::stringify(obj)
  assert_eq(json_str.contains("name"), true)
  let parsed = @js.JSON::parse(json_str) catch { _ => @js.undefined() }
  assert_eq(@js.is_object(parsed), true)
}
```

## Async / Promise

```moonbit

///|
async fn fetch_example() -> Unit {
  // Async functions return values directly (no .wait() needed by caller)
  let response = @http.fetch("https://api.example.com/data", method_="GET")
  let json = response.json()
  @js.log(json)
}

///|
async fn promise_combinators() -> Unit {
  // Create promises from async functions
  let p1 = @js.Promise::from_async(async fn() -> Int { 1 })
  let p2 = @js.Promise::from_async(async fn() -> Int { 2 })

  // Wait for all (async fn, no .wait() needed)
  let results = @js.Promise::all([p1, p2])
  @js.log(results) // [1, 2]

  // Race - first to resolve wins
  let first = @js.Promise::race([p1, p2])
  @js.log(first)
}

///|
fn callback_to_promise() -> @js.Promise[String] {
  // Convert callback-based API to Promise
  @js.Promise::new(fn(resolve, _reject) { resolve("done") })
}

///|
async fn sleep_example() -> Unit {
  @js.log("start")
  @js.sleep(1000) // Sleep 1 second
  @js.log("after 1 second")
}
```

## Global Functions

```moonbit

///|
test "global functions" {
  // URI encoding
  let encoded = @global.encode_uri_component("hello world")
  let decoded = @global.decode_uri_component(encoded)
  assert_eq(decoded, "hello world")

  // Base64
  let base64 = @global.btoa("hello")
  let original = @global.atob(base64)
  assert_eq(original, "hello")
}
```

## BigInt

```moonbit

///|
test "bigint" {
  let a = @bigint.JsBigInt::from_int(42)
  let b = @bigint.JsBigInt::from_string("123456789012345678901234567890")
  let sum = @bigint.JsBigInt::add(a, b)
  inspect(sum.to_string(), content="123456789012345678901234567932")
}
```
