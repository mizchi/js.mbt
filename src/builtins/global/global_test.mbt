///| Global Objects

///|
test "global_this" {
  let global = global_this()
  assert_false(@core.is_null(global))
}

///| Type Checking

///|
test "is_nan" {
  let nan_val : @core.Any = @core.any(0.0 / 0.0)
  assert_true(is_nan(nan_val))
  assert_false(is_nan(@core.any(42)))
  assert_false(is_nan(@core.any(3.14)))
}

///|
test "is_finite" {
  assert_true(is_finite(3.14))
  assert_true(is_finite(0.0))
  assert_false(is_finite(1.0 / 0.0)) // Infinity
  assert_false(is_finite(0.0 / 0.0)) // NaN
}

///| Number Parsing

///|
test "parse_int" {
  // Basic parsing
  assert_eq(parse_int("42"), Some(42))
  assert_eq(parse_int("-123"), Some(-123))
  assert_eq(parse_int("0"), Some(0))

  // With radix
  assert_eq(parse_int("ff", radix=16), Some(255))
  assert_eq(parse_int("FF", radix=16), Some(255))
  assert_eq(parse_int("1010", radix=2), Some(10))
  assert_eq(parse_int("77", radix=8), Some(63))

  // Invalid input
  assert_eq(parse_int("hello"), None)
  assert_eq(parse_int(""), None)
}

///|
test "parse_float" {
  // Basic parsing
  assert_eq(parse_float("3.14"), Some(3.14))
  assert_eq(parse_float("-2.5"), Some(-2.5))
  assert_eq(parse_float("0.0"), Some(0.0))
  assert_eq(parse_float("42"), Some(42.0))

  // Invalid input
  assert_eq(parse_float("hello"), None)
  assert_eq(parse_float(""), None)
}

///| String Encoding (Base64)

///|
test "btoa encodes string to base64" {
  let encoded = btoa("Hello World")
  assert_eq(encoded, "SGVsbG8gV29ybGQ=")
}

///|
test "atob decodes base64 to string" {
  let decoded = atob("SGVsbG8gV29ybGQ=")
  assert_eq(decoded, "Hello World")
}

///|
test "btoa and atob round trip" {
  let original = "MoonBit is great!"
  let encoded = btoa(original)
  let decoded = atob(encoded)
  assert_eq(decoded, original)
}

///| URI Encoding

///|
test "encode_uri and decode_uri" {
  // Encode complete URI
  let uri = encodeURI("https://example.com/path?name=John Doe")
  assert_eq(uri, "https://example.com/path?name=John%20Doe")

  // Decode URI
  let decoded = decodeURI("https://example.com/path?name=John%20Doe")
  assert_eq(decoded, "https://example.com/path?name=John Doe")

  // Round trip
  let original_uri = "https://example.com/path with spaces?query=value"
  let encoded_uri = encodeURI(original_uri)
  let decoded_uri = decodeURI(encoded_uri)
  assert_eq(decoded_uri, original_uri)
}

///|
test "encode_uri_component and decode_uri_component" {
  // Encode URI component
  let encoded = encodeURIComponent("Hello World & Friends")
  assert_eq(encoded, "Hello%20World%20%26%20Friends")

  // Decode URI component
  let decoded = decodeURIComponent("Hello%20World%20%26%20Friends")
  assert_eq(decoded, "Hello World & Friends")

  // Special characters
  let special = encodeURIComponent("key=value&foo=bar")
  assert_eq(special, "key%3Dvalue%26foo%3Dbar")
  let decoded_special = decodeURIComponent("key%3Dvalue%26foo%3Dbar")
  assert_eq(decoded_special, "key=value&foo=bar")

  // Round trip with various characters
  let original = "Test: @#$%^&*()+={}[]|\\:;\"'<>,.?/"
  let encoded_component = encodeURIComponent(original)
  let decoded_component = decodeURIComponent(encoded_component)
  assert_eq(decoded_component, original)
}

///| Object Cloning

///|
test "structured_clone clones simple object" {
  let obj = @core.new_object()
  obj["name"] = @core.any("Alice")
  obj["age"] = @core.any(30)
  let cloned = @global.structuredClone(obj)
  assert_eq(@core.identity(cloned._get("name")), "Alice")
  assert_eq(@core.identity(cloned._get("age")), 30)
}

///|
test "structured_clone creates independent copy" {
  let obj = @core.new_object()
  obj["value"] = @core.any(42)
  let cloned = @global.structuredClone(obj)
  // Modify original
  obj["value"] = @core.any(100)
  // Cloned object should remain unchanged
  assert_eq(@core.identity(cloned._get("value")), 42)
  assert_eq(@core.identity(obj._get("value")), 100)
}

///|
test "structured_clone clones nested objects" {
  let obj = @core.new_object()
  let nested = @core.new_object()
  nested["x"] = @core.any(10)
  nested["y"] = @core.any(20)
  obj["nested"] = nested
  let cloned = @global.structuredClone(obj)
  let cloned_nested = cloned._get("nested")
  assert_eq(@core.identity(cloned_nested._get("x")), 10)
  assert_eq(@core.identity(cloned_nested._get("y")), 20)
}

///|
test "structured_clone clones arrays" {
  let arr : Array[@core.Any] = [@core.any(1), @core.any(2), @core.any(3)]
  let cloned = @global.structuredClone(@core.any(arr))
  assert_eq(@core.identity(cloned._get_by_index(0)), 1)
  assert_eq(@core.identity(cloned._get_by_index(1)), 2)
  assert_eq(@core.identity(cloned._get_by_index(2)), 3)
}

///| Timers

///|
test "set_timeout and clear_timeout" {
  let timer = set_timeout(fn() { () }, 100)
  defer clear_timeout(timer)
  // Timer created and cleared successfully
}

///|
test "set_interval and clear_interval" {
  let timer = set_interval(fn() { () }, 100)
  defer clear_interval(timer)
  // Interval created and cleared successfully
}

///| Microtasks

///|
test "queue_microtask - can be called" {
  // Just verify the function can be called without error
  queue_microtask(fn() { () })
}

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

///| Type Checking

///|
test "global isNaN" {
  let nan_val = @core.any(0.0 / 0.0)
  assert_true(@global.is_nan(nan_val))
  assert_false(@global.is_nan(@core.any(42)))
  assert_false(@global.is_nan(@core.any(3.14)))
}
