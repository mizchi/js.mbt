# MoonBit JavaScript FFI Examples

Common usage patterns for the `mizchi/js` library.

## Object Operations

```moonbit
///|
test "basic object operations" {
  let obj = @core.new_object()
  obj._set("name", @core.any("MoonBit"))
  obj._set("version", @core.any(1))
  inspect(
    @js.JSON::stringify(obj),
    content=(
      #|{
      #|  "name": "MoonBit",
      #|  "version": 1
      #|}
    ),
  )

  // Property access with different key types
  obj._set("0", @core.any("first")) // String key (numeric)
  let sym = @js.symbol("custom")
  obj["symbol_key"] = @core.any("symbol value") // Bracket notation

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
  let arr = @core.any([1, 2, 3])
  arr._call("push", [4 |> @core.any]) |> ignore
  inspect(
    @js.JSON::stringify(arr),
    content=(
      #|[
      #|  1,
      #|  2,
      #|  3,
      #|  4
      #|]
    ),
  )

  // Higher-order methods
  let filtered = arr._call("filter", [
    @js.from_fn1(fn(x : @core.Any) -> Bool {
      let n : Int = @js.identity(x)
      n > 2
    }),
  ])
  inspect(filtered, content="3,4")
}
```

## Type Conversion

```moonbit
///|
test "type conversion" {
  // MoonBit -> JS
  let num_js = @core.any(42)
  let str_js = @core.any("hello")

  // JS -> MoonBit
  let num : Int = @js.identity(num_js)
  let str : String = @js.identity(str_js)
  assert_eq(num, 42)
  assert_eq(str, "hello")

  // Optional values
  let obj = @core.new_object()
  obj._set("exists", @core.any("value"))
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
  let obj = @core.new_object()
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
  let obj = @core.new_object()
  obj["name"] = "test" |> @core.any

  // Method calls
  inspect(obj._call("toString", []), content="[object Object]")
  inspect(obj._call("hasOwnProperty", ["name" |> @core.any]), content="true")

  // Variable arguments
  let result = obj._call("hasOwnProperty", ["name" |> @core.any])
  assert_eq(@js.identity(result), true)
}
```

## Function Conversion

```moonbit
///|
test "function conversion" {
  // MoonBit function -> JS function
  let fn1 = @js.from_fn1(fn(x : Int) -> Int { x * 2 })
  let result : Int = @js.identity(fn1._invoke([10 |> @core.any]))
  assert_eq(result, 20)

  // Calling JS functions
  let parseInt = @core.global_this()._get("parseInt")
  let parsed : Int = @js.identity(parseInt._invoke(["123" |> @core.any]))
  assert_eq(parsed, 123)
}
```

## Constructors

```moonbit
///|
test "constructors" {
  let array_ctor = @core.global_this()._get("Array")
  let arr = @core.new(array_ctor, [@core.any(3)])
  inspect(
    @js.JSON::stringify(arr),
    content=(
      #|[
      #|  null,
      #|  null,
      #|  null
      #|]
    ),
  )
}
```

## JSON

```moonbit
///|
test "json" {
  let obj = @core.new_object()
  obj["name"] = "Moonbit" |> @core.any
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
