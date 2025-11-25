# MoonBit JavaScript FFI Examples

Common usage patterns for the `mizchi/js` library.

## Object Operations

```moonbit
///|
test "basic object operations" {
  let obj = @js.Object::new()
  obj.set("name", "MoonBit")
  obj.set("version", 1)
  inspect(obj.to_any(), content="{\"name\":\"MoonBit\",\"version\":1}")

  // Property access with different key types
  obj.set(0, "first")  // Int key
  let sym = @js.symbol("custom")
  obj.set(sym, "symbol value")  // Symbol key

  // Object methods
  let keys = @js.Object::keys(obj)
  let values = @js.Object::values(obj)
  @js.Object::freeze(obj) |> ignore
  assert_eq(@js.Object::isFrozen(obj), true)
}
```

## Arrays

```moonbit
///|
test "array operations" {
  let arr = @js.JsArray::from([1, 2, 3])
  arr.push(4)
  inspect(arr.to_any(), content="[1,2,3,4]")

  // Higher-order methods
  let filtered = arr.call1("filter", @js.from_fn1(fn(x : @js.Any) -> Bool {
    let n : Int = @js.identity(x)
    n > 2
  }))
  inspect(filtered, content="[3,4]")
}
```

## Type Conversion

```moonbit
///|
test "type conversion" {
  // MoonBit -> JS
  let num_js = @js.any(42)
  let str_js = @js.any("hello")

  // JS -> MoonBit
  let num : Int = @js.identity(num_js)
  let str : String = @js.identity(str_js)
  assert_eq(num, 42)
  assert_eq(str, "hello")

  // Optional values
  let obj = @js.Object::new()
  obj.set("exists", "value")
  let exists : String? = @js.identity_option(obj.get("exists"))
  let missing : String? = @js.identity_option(obj.get("missing"))
  assert_eq(exists, Some("value"))
  assert_eq(missing, None)
}
```

## Type Checking

```moonbit
///|
test "type checking" {
  let arr = @js.JsArray::from([1, 2, 3])
  let obj = @js.Object::new()
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
  let obj = @js.Object::new()
  obj.set("name", "test")

  // Specific arities (optimized)
  inspect(obj.call0("toString"), content="[object Object]")
  inspect(obj.call1("hasOwnProperty", "name"), content="true")

  // Variable arguments
  let result = obj.call("hasOwnProperty", ["name"])
  assert_eq(@js.identity(result), true)
}
```

## Function Conversion

```moonbit
///|
test "function conversion" {
  // MoonBit function -> JS function
  let fn1 = @js.from_fn1(fn(x : Int) -> Int { x * 2 })
  let result : Int = @js.identity(fn1.call_self([10]))
  assert_eq(result, 20)

  // Calling JS functions
  let parseInt = @js.globalThis().get("parseInt")
  let parsed : Int = @js.identity(parseInt.call_self(["123"]))
  assert_eq(parsed, 123)
}
```

## Constructors

```moonbit
///|
test "constructors" {
  let array_ctor = @js.globalThis().get("Array")
  let arr = @js.new_(array_ctor, [3])
  inspect(arr, content="[null,null,null]")
}
```

## Symbols

```moonbit
///|
test "symbols" {
  let obj = @js.Object::new()
  let sym = @js.symbol("custom")
  obj.set(sym, "symbol value")
  assert_eq(@js.identity(obj.get(sym)), "symbol value")

  // Well-known symbols
  let _iter = @js.Symbol::iterator()
  let _tag = @js.Symbol::toStringTag()
}
```

## JSON

```moonbit
///|
test "json" {
  let obj = @js.Object::new()
  obj.set("name", "MoonBit")

  let json_str = @js.JSON::stringify(obj.to_any())
  assert_eq(json_str.contains("name"), true)

  let parsed = @js.JSON::parse(json_str) catch { _ => @js.undefined() }
  assert_eq(@js.is_object(parsed), true)
}
```

## Global Functions

```moonbit
///|
test "global functions" {
  // URI encoding
  let encoded = @js.encodeURIComponent("hello world")
  let decoded = @js.decodeURIComponent(encoded)
  assert_eq(decoded, "hello world")

  // Base64
  let base64 = @js.btoa("hello")
  let original = @js.atob(base64)
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
