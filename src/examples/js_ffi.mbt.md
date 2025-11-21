# MoonBit JavaScript FFI Patterns

Practical, executable examples of JavaScript FFI patterns using `mizchi/js`.

For comprehensive documentation, see [docs/moonbit-js-ffi.md](../../docs/moonbit-js-ffi.md).

## PropertyKey - String, Int, Symbol

```moonbit
///|
test "property key types" {
  let obj = @js.Object::new()

  // String keys
  obj.set("name", "MoonBit")
  inspect(obj.get("name"), content="MoonBit")

  // Int keys (array-like)
  obj.set(0, "first")
  inspect(obj.get(0), content="first")

  // Symbol keys
  let sym = @js.symbol("custom")
  obj.set(sym, "symbol value")
  inspect(obj.get(sym), content="symbol value")
  assert_eq(@js.unsafe_cast(obj.get("name")), "MoonBit")
}
```

## Pattern: Simple FFI Function

```moonbit
///|
test "simple ffi with encodeURIComponent" {
  let text = "hello world"
  let encoded = @js.encodeURIComponent(text)
  inspect(encoded, content="hello%20world")
  let decoded = @js.decodeURIComponent(encoded)
  assert_eq(decoded, text)
}
```

## Pattern: Optional Parameters

```moonbit
///|
test "optional parameters" {
  let obj = @js.Object::new()

  // Set if Some
  let value_opt : String? = Some("exists")
  match value_opt {
    Some(v) => obj.set("field1", v)
    None => ()
  }

  // Skip if None
  let empty_opt : String? = None
  match empty_opt {
    Some(v) => obj.set("field2", v)
    None => ()
  }
  assert_eq(obj.hasOwnProperty("field1"), true)
  assert_eq(obj.hasOwnProperty("field2"), false)
}
```

## Pattern: Handling Null/Undefined

```moonbit
///|
test "unsafe_cast_option for nullable values" {
  let obj = @js.Object::new()
  obj.set("exists", "value")

  // unsafe_cast_option returns Option
  let exists : String? = @js.unsafe_cast_option(obj.get("exists"))
  let missing : String? = @js.unsafe_cast_option(obj.get("missing"))
  assert_eq(exists, Some("value"))
  assert_eq(missing, None)

  // Pattern matching
  match exists {
    Some(v) => assert_eq(v, "value")
    None => fail("Should have value")
  }
}
```

## Pattern: Object Methods and Properties

```moonbit
///|
test "object methods - keys, values, entries" {
  let obj = @js.Object::new()
  obj.set("a", 1)
  obj.set("b", 2)
  obj.set("c", 3)
  let keys = @js.Object::keys(obj)
  inspect(
    keys,
    content=(
      #|["a", "b", "c"]
    ),
  )
  assert_eq(keys.length(), 3)

  // Object freezing
  @js.Object::freeze(obj) |> ignore
  assert_eq(@js.Object::isFrozen(obj), true)
}
```

## Pattern: Method Calls with Different Arities

```moonbit
///|
test "call0, call1, call2 methods" {
  let obj = @js.Object::new()
  obj.set("name", "test")

  // call0 - no arguments
  let str_repr = obj.call0("toString")
  inspect(str_repr, content="[object Object]")

  // call1 - one argument
  let has_name : Bool = @js.unsafe_cast(obj.call1("hasOwnProperty", "name"))
  assert_eq(has_name, true)

  // call - variable arguments
  let keys = @js.Object::keys(obj)
  assert_eq(keys.length(), 1)
}
```

## Pattern: Type Conversion

```moonbit
///|
test "js() for type conversion" {
  // Convert MoonBit types to Js
  let num = @js.js(42)
  let str = @js.js("hello")
  let bool = @js.js(true)

  // Convert back
  let num_back : Int = @js.unsafe_cast(num)
  let str_back : String = @js.unsafe_cast(str)
  let bool_back : Bool = @js.unsafe_cast(bool)
  assert_eq(num_back, 42)
  assert_eq(str_back, "hello")
  assert_eq(bool_back, true)
}
```

## Pattern: Arrays

```moonbit
///|
test "javascript arrays" {
  // Create from MoonBit array
  let arr = @js.JsArray::from([1, 2, 3])

  // Add items
  arr.push(4)
  arr.push(5)

  // Check type
  assert_eq(@js.JsArray::isArray(arr), true)
  let length : Int = @js.unsafe_cast(arr.get("length"))
  assert_eq(length, 5)
}
```

## Pattern: Map to Object

```moonbit
///|
test "map to javascript object" {
  let map = Map::new()
  map.set("name", @js.js("MoonBit"))
  map.set("version", @js.js(1))
  map.set("active", @js.js(true))
  let obj = @js.from_map(map)
  assert_eq(@js.unsafe_cast(obj.get("name")), "MoonBit")
  assert_eq(@js.unsafe_cast(obj.get("version")), 1)
  assert_eq(@js.unsafe_cast(obj.get("active")), true)
}
```

## Pattern: Type Checking

```moonbit
///|
test "type checking helpers" {
  let arr = @js.JsArray::new()
  let obj = @js.Object::new()
  let undef = @js.undefined()

  // Type checks
  assert_eq(@js.is_array(arr), true)
  assert_eq(@js.is_array(obj), false)
  assert_eq(@js.is_object(obj), true)
  assert_eq(@js.is_object(arr), true) // Arrays are objects in JS
  assert_eq(@js.is_undefined(undef), true)
  assert_eq(@js.is_nullish(undef), true)
}
```

## Pattern: BigInt Operations

```moonbit
///|
test "bigint arithmetic" {
  let big1 = @js.JsBigInt::from_int(100)
  let big2 = @js.JsBigInt::from_int(50)

  // Arithmetic
  let sum = @js.JsBigInt::add(big1, big2)
  let diff = @js.JsBigInt::sub(big1, big2)
  let product = @js.JsBigInt::mul(big1, big2)
  let expected_sum = @js.JsBigInt::from_int(150)
  let expected_diff = @js.JsBigInt::from_int(50)
  let expected_product = @js.JsBigInt::from_int(5000)
  assert_eq(@js.JsBigInt::equal(sum, expected_sum), true)
  assert_eq(@js.JsBigInt::equal(diff, expected_diff), true)
  assert_eq(@js.JsBigInt::equal(product, expected_product), true)

  // String conversion
  inspect(sum.to_string(), content="150")
  inspect(product.to_string_radix(16), content="1388")
}
```

## Pattern: JSON Operations

```moonbit
///|
test "json stringify and parse" {
  let obj = @js.Object::new()
  obj.set("name", "MoonBit")
  obj.set("value", 42)

  // Stringify
  let json_str = @js.JSON::stringify(obj.to_js())
  let expected_json =
    #|{"name":"MoonBit","value":42}
  inspect(
    json_str,
    content=(
      #|{
      #|  "name": "MoonBit",
      #|  "value": 42
      #|}
    ),
  )

  // Parse
  let parsed = @js.JSON::parse(json_str) catch { _ => @js.undefined() }
  assert_eq(@js.is_object(parsed), true)
  assert_eq(@js.unsafe_cast(parsed.get("name")), "MoonBit")
}
```

## Pattern: Symbols

```moonbit
///|
test "symbol operations" {
  let obj = @js.Object::new()

  // Custom symbol
  let custom_sym = @js.symbol("mySymbol")
  obj.set(custom_sym, "secret")

  // Well-known symbols
  let iter_sym = @js.Symbol::iterator()
  let _async_iter = @js.Symbol::asyncIterator()

  // Symbol as property key
  let secret : String = @js.unsafe_cast(obj.get(custom_sym))
  assert_eq(secret, "secret")

  // Symbols don't appear in Object.keys
  let keys = @js.Object::keys(obj)
  assert_eq(keys.length(), 0)
}
```

## Pattern: Global Functions

```moonbit
///|
test "global javascript functions" {
  // Base64 encoding
  let base64 = @js.btoa("hello")
  let decoded = @js.atob(base64)
  inspect(base64, content="aGVsbG8=")
  assert_eq(decoded, "hello")

  // URI encoding
  let uri = "hello world"
  let encoded_uri = @js.encodeURI(uri)
  let decoded_uri = @js.decodeURI(encoded_uri)
  assert_eq(decoded_uri, uri)

  // Check NaN
  let nan_val = @js.globalThis().get("NaN")
  assert_eq(@js.isNaN(nan_val), true)
  assert_eq(@js.isNaN(42), false)
}
```

## Pattern: Constructors with new_

```moonbit
///|
test "constructor with new operator" {
  // Using new_ helper
  let array_constructor = @js.globalThis().get("Array")
  let arr = @js.new_(array_constructor, [3])
  assert_eq(@js.is_object(arr), true)

  // Object constructor
  let object_constructor = @js.globalThis().get("Object")
  let obj = @js.new_(object_constructor, [])
  assert_eq(@js.is_object(obj), true)
}
```

## Pattern: Function Calls with call_self

```moonbit
///|
test "call_self for direct function calls" {
  // parseInt is a function
  let parseInt = @js.globalThis().get("parseInt")

  // Call it directly with arguments
  let result : Int = @js.unsafe_cast(parseInt.call_self(["42"]))
  assert_eq(result, 42)

  // With radix
  let hex_result : Int = @js.unsafe_cast(parseInt.call_self(["ff", 16]))
  assert_eq(hex_result, 255)
}
```

## Pattern: Object Seal and Freeze

```moonbit
///|
test "object immutability" {
  let obj = @js.Object::new()
  obj.set("x", 1)

  // Seal prevents adding new properties
  @js.Object::seal(obj) |> ignore
  assert_eq(@js.Object::isSealed(obj), true)
  let obj2 = @js.Object::new()
  obj2.set("y", 2)

  // Freeze prevents all modifications
  @js.Object::freeze(obj2) |> ignore
  assert_eq(@js.Object::isFrozen(obj2), true)
}
```

## Pattern: Property Delete

```moonbit
///|
test "delete property" {
  let obj = @js.Object::new()
  obj.set("temp", "value")
  assert_eq(obj.hasOwnProperty("temp"), true)
  obj.delete("temp")
  assert_eq(obj.hasOwnProperty("temp"), false)
}
```

## Pattern: instanceOf and typeOf

```moonbit
///|
test "instanceof and typeof" {
  let arr = @js.JsArray::new()
  let array_constructor = @js.globalThis().get("Array")

  // instanceof check
  assert_eq(@js.instanceof_(arr.to_js(), array_constructor), true)

  // typeof check
  let type_str = @js.typeof_(arr)
  inspect(type_str, content="object")
  let num = @js.js(42)
  let num_type = @js.typeof_(num)
  inspect(num_type, content="number")
}
```

## Summary

These patterns demonstrate:
- Type conversions between MoonBit and JavaScript
- Property access with different key types
- Method calls with various arities
- Optional and null handling
- Object manipulation
- BigInt operations
- Symbol usage
- Global JavaScript APIs

For more details, see [docs/moonbit-js-ffi.md](../../docs/moonbit-js-ffi.md).
