///| Global Objects

///|
test "globalThis" {
  let global = globalThis()
  assert_true(@js.is_object(global))
  assert_false(@js.is_null(global))
}

///| Type Checking

///|
test "global isNaN" {
  let nan_val = @js.js(0.0 / 0.0)
  assert_true(@js.isNaN(nan_val))
  assert_false(@js.isNaN(42))
  assert_false(@js.isNaN(3.14))
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

///| JSON

///|
test "JSON::stringify" {
  let arr : Array[Int] = [1] |> unsafe_cast
  arr |> inspect(content="[1]")
  JSON::stringify(arr |> from_array, space=2)
  |> inspect(
    content=(
      #|[
      #|  1
      #|]
    ),
  )
  let v = from_map({ "key1": 123 |> js, "key2": 456 |> js, "key3": 789 |> js })
  JSON::stringify(v, space=2)
  |> inspect(
    content=(
      #|{
      #|  "key1": 123,
      #|  "key2": 456,
      #|  "key3": 789
      #|}
    ),
  )
}

///| Timers

///|
test "setTimeout and clearTimeout" {
  let timer = setTimeout(fn() { () }, 100)
  clearTimeout(timer)
  // Timer created and cleared successfully
}

///|
test "setInterval and clearInterval" {
  let timer = setInterval(fn() { () }, 100)
  defer clearInterval(timer)
  // Interval created and cleared successfully
}

///|
test "atob - throws on invalid base64" {
  let result = try? atob("not valid base64!!!")
  match result {
    Err(_) => assert_true(true)
    Ok(_) => fail("Expected atob to throw on invalid base64")
  }
}

///|
test "btoa - throws on invalid characters" {
  let result = try? btoa("Hello 世界")
  match result {
    Err(_) => assert_true(true)
    Ok(_) => fail("Expected btoa to throw on non-Latin1 characters")
  }
}

///| Microtasks

///|
async test "queueMicrotask - can be called" {
  let mut called = false
  // Queue a microtask - it will execute after current task
  queueMicrotask(fn() { called = true })
  @js.sleep(16)
  // Just verify the function can be called without error
  assert_true(called)
}
