# MoonBit JavaScript FFI Examples

This document demonstrates common usage patterns for the `mizchi/js` library.

## Basic Object Operations

Creating and manipulating JavaScript objects:

```moonbit
///|
test "basic object operations" {
  let obj = @js.Object::new()
  obj.set("name", "MoonBit")
  obj.set("version", 1)
  inspect(
    obj.to_js(),
    content=(
      #|{"name":"MoonBit","version":1}
    ),
  )
  inspect(obj.get("name"), content="MoonBit")
  assert_eq(obj.hasOwnProperty("name"), true)
  assert_eq(obj.hasOwnProperty("nothing"), false)
}
```

## PropertyKey - String, Int, and Symbol Access

Properties can be accessed with different key types:

```moonbit
///|
test "property keys - string, int, symbol" {
  let obj = @js.Object::new()

  // String keys
  obj.set("name", "value")

  // Int keys (array-like access)
  obj.set(0, "first")
  obj.set(1, "second")

  // Symbol keys
  let sym = @js.symbol("custom")
  obj.set(sym, "symbol value")
  inspect(obj.get("name"), content="value")
  inspect(obj.get(0), content="first")
  inspect(obj.get(sym), content="symbol value")
  assert_eq(@js.unsafe_cast(obj.get("name")), "value")
  assert_eq(@js.unsafe_cast(obj.get(0)), "first")
}
```

## Arrays

Working with JavaScript arrays:

```moonbit
///|
test "array operations" {
  // Create from MoonBit array
  let arr = @js.JsArray::from([1, 2, 3])

  // Add items
  arr.push(4)
  arr.push(5)
  inspect(arr.to_js(), content="[1,2,3,4,5]")
  inspect(arr.get("length"), content="5")
  assert_eq(@js.JsArray::isArray(arr), true)
}
```

## Method Calls with Different Arities

Calling JavaScript methods with specific number of arguments:

```moonbit
///|
test "method call arities" {
  let obj = @js.Object::new()
  obj.set("name", "test")

  // hasOwnProperty via call1
  let result : Bool = @js.unsafe_cast(obj.call1("hasOwnProperty", "name"))
  assert_eq(result, true)

  // call0, call1, call2 for specific argument counts
  inspect(obj.call0("toString"), content="[object Object]")
  inspect(obj.call1("hasOwnProperty", "name"), content="true")

  // call for variable arguments
  let keys = @js.Object::keys(obj)
  inspect(
    keys,
    content=(
      #|["name"]
    ),
  )
}
```

## Object Helper Methods

Using Object static methods:

```moonbit
///|
test "object helper methods" {
  let obj = @js.Object::new()
  obj.set("a", 1)
  obj.set("b", 2)
  obj.set("c", 3)

  // Get keys, values, entries
  let keys = @js.Object::keys(obj)
  let values = @js.Object::values(obj)
  let entries = @js.Object::entries(obj)
  inspect(
    keys,
    content=(
      #|["a", "b", "c"]
    ),
  )
  inspect(values, content="[1, 2, 3]")
  inspect(
    entries,
    content=(
      #|[("a", 1), ("b", 2), ("c", 3)]
    ),
  )
  assert_eq(keys.length(), 3)

  // Object freezing
  @js.Object::freeze(obj) |> ignore
  assert_eq(@js.Object::isFrozen(obj), true)
}
```

## Type Conversion

Converting between MoonBit and JavaScript types:

```moonbit
///|
test "type conversion" {
  // JsImpl is implemented for basic types
  let num_js = @js.js(42)
  let str_js = @js.js("hello")
  let bool_js = @js.js(true)
  inspect(num_js, content="42")
  inspect(str_js, content="hello")
  inspect(bool_js, content="true")

  // Convert back using unsafe_cast
  let num : Int = @js.unsafe_cast(num_js)
  let str : String = @js.unsafe_cast(str_js)
  let bool : Bool = @js.unsafe_cast(bool_js)
  assert_eq(num, 42)
  assert_eq(str, "hello")
  assert_eq(bool, true)
}
```

## Working with Maps

Converting MoonBit Maps to JavaScript objects:

```moonbit
///|
test "map to object conversion" {
  let map = Map::new()
  map.set("name", @js.js("MoonBit"))
  map.set("version", @js.js(1))
  map.set("active", @js.js(true))
  let obj = @js.from_map(map)
  inspect(
    obj,
    content=(
      #|{"name":"MoonBit","version":1,"active":true}
    ),
  )
  assert_eq(@js.unsafe_cast(obj.get("name")), "MoonBit")
  assert_eq(@js.unsafe_cast(obj.get("version")), 1)
}
```

## Handling Null and Undefined

Safe handling of nullable JavaScript values:

```moonbit
///|
test "optional values with unsafe_cast_option" {
  let obj = @js.Object::new()
  obj.set("exists", "value")

  // Using unsafe_cast_option
  let exists : String? = @js.unsafe_cast_option(obj.get("exists"))
  let missing : String? = @js.unsafe_cast_option(obj.get("missing"))
  inspect(
    exists,
    content=(
      #|Some("value")
    ),
  )
  inspect(missing, content="None")
  assert_eq(exists, Some("value"))
  assert_eq(missing, None)
}
```

## Setting Optional Properties

Using `set_if_exists` for optional values:

```moonbit
///|
test "set_if_exists for optional properties" {
  let obj = @js.Object::new()

  // Only sets if value is Some
  let name_opt : String? = Some("MoonBit")
  let version_opt : String? = None
  @js.set_if_exists(obj, "name", name_opt)
  @js.set_if_exists(obj, "version", version_opt)
  inspect(
    obj.to_js(),
    content=(
      #|{"name":"MoonBit"}
    ),
  )
  assert_eq(obj.hasOwnProperty("name"), true)
  assert_eq(obj.hasOwnProperty("version"), false)
}
```

## Type Checking

Checking JavaScript value types:

```moonbit
///|
test "javascript type checking" {
  let arr = @js.JsArray::from([1, 2, 3])
  let obj = @js.Object::new()
  let undef = @js.undefined()
  inspect(@js.is_array(arr), content="true")
  inspect(@js.is_object(obj), content="true")
  inspect(@js.is_undefined(undef), content="true")
  assert_eq(@js.is_array(arr), true)
  assert_eq(@js.is_array(obj), false)
  assert_eq(@js.is_object(obj), true)
  assert_eq(@js.is_undefined(undef), true)
  assert_eq(@js.is_nullish(undef), true)
}
```

## Symbols

Working with JavaScript Symbols:

```moonbit
///|
test "symbol operations" {
  let obj = @js.Object::new()

  // Custom symbol
  let custom_sym = @js.symbol("custom")
  obj.set(custom_sym, "custom value")

  // Well-known symbols
  let _iter_sym = @js.Symbol::iterator()
  let _to_string_tag = @js.Symbol::toStringTag()
  inspect(obj.get(custom_sym), content="custom value")
  assert_eq(@js.unsafe_cast(obj.get(custom_sym)), "custom value")
}
```

## BigInt Operations

Working with arbitrary precision integers:

```moonbit
///|
test "bigint arithmetic operations" {
  let big1 = @js.JsBigInt::from_int(42)
  let big2 = @js.JsBigInt::from_string("123456789012345678901234567890")
  let sum = @js.JsBigInt::add(big1, big2)
  let product = @js.JsBigInt::mul(big1, big2)
  inspect(sum.to_string(), content="123456789012345678901234567932")
  inspect(product.to_string(), content="5185185138518518513851851851380")
  inspect(sum.to_string_radix(16), content="18ee90ff6c373e0ee4e3f0afc")
  let a = @js.JsBigInt::from_int(10)
  let b = @js.JsBigInt::from_int(20)
  let result = @js.JsBigInt::add(a, b)
  let expected = @js.JsBigInt::from_int(30)
  assert_eq(@js.JsBigInt::equal(result, expected), true)
}
```

## Global Functions

Using global JavaScript functions:

```moonbit
///|
test "global encoding functions" {
  // URI encoding
  let text = "hello world"
  let encoded = @js.encodeURIComponent(text)
  let decoded = @js.decodeURIComponent(encoded)
  inspect(encoded, content="hello%20world")
  inspect(decoded, content="hello world")
  assert_eq(decoded, text)

  // Base64
  let base64 = @js.btoa("hello")
  let original = @js.atob(base64)
  inspect(base64, content="aGVsbG8=")
  inspect(original, content="hello")
  assert_eq(original, "hello")
}
```

## JSON Operations

Working with JSON:

```moonbit
///|
test "json stringify and parse" {
  let obj = @js.Object::new()
  obj.set("name", "MoonBit")
  obj.set("version", 1)

  // Stringify
  let json_str = @js.JSON::stringify(obj.to_js())
  inspect(
    json_str,
    content=(
      #|{
      #|  "name": "MoonBit",
      #|  "version": 1
      #|}
    ),
  )
  assert_eq(json_str.contains("name"), true)

  // Parse (with error handling)
  let parsed = @js.JSON::parse(json_str) catch {
    e => {
      inspect(e)
      @js.undefined()
    }
  }
  inspect(
    parsed,
    content=(
      #|{"name":"MoonBit","version":1}
    ),
  )
  assert_eq(@js.is_object(parsed), true)
}
```

## Calling Functions Directly

Calling JavaScript values as functions:

```moonbit
///|
test "call_self for direct function calls" {
  // Get a JavaScript function
  let parseInt = @js.globalThis().get("parseInt")

  // Call it directly
  let result : Int = @js.unsafe_cast(parseInt.call_self(["123"]))
  inspect(result, content="123")
  assert_eq(result, 123)

  // call_self0 for no arguments - using Math.PI
  let math = @js.globalThis().get("Math")
  let pi : Double = @js.unsafe_cast(math.get("PI"))
  inspect(pi, content="3.141592653589793")
}
```

## Constructors with `new_`

Creating instances with the `new` operator:

```moonbit
///|
test "constructor with new_" {
  // Get constructor
  let object_constructor = @js.globalThis().get("Object")

  // Call with new
  let obj = @js.new_(object_constructor, [])
  inspect(obj, content="{}")
  assert_eq(@js.is_object(obj), true)

  // Array constructor example
  let array_constructor = @js.globalThis().get("Array")
  let arr = @js.new_(array_constructor, [3])
  inspect(arr, content="[null,null,null]")
}
```
