///|
test "JsImpl::to_js converts builtin Json to Js" {
  let j : Json = { "items": [1, 2, 3], "nested": { "key": "value" } }
  let v : Js = JsImpl::to_js(j)
  assert_eq(unsafe_cast(v.get("items").get(0)), 1)
  assert_eq(unsafe_cast(v.get("nested").get("key")), "value")
}

///|
test "is_builtin_trait detects MoonBit builtin traits" {
  let show : &Show = "hello"
  let v : Js = unsafe_cast(show)
  assert_true(is_builtin_trait(v))
}

///|
test "from_json converts MoonBit Json to Js object" {
  inspect(
    from_json({
      "value": null,
      "items": [1, 2, 3],
      "nested": { "key": "value" },
    }),
    content=(
      #|{"value":null,"items":[1,2,3],"nested":{"key":"value"}}
    ),
  )
  inspect(
    from_json({ "age": 30, "name": "Alice" }),
    content=(
      #|{"age":30,"name":"Alice"}
    ),
  )
}

///|
priv struct Point {
  x : Int
  y : Int
} derive(Show)

///|
fn Point::x2(self : Self) -> Int {
  self.x * 2
}

///|
impl JsImpl for Point

///|
extern "js" fn ffi_point_new(x : Int, y : Int) -> Js =
  #|(x, y) => ({ x: x, y: y })

///|
test "from builtin struct" {
  let p = Point::{ x: 10, y: 20 }
  let v : Js = JsImpl::to_js(p)
  assert_eq(unsafe_cast(v.get("x")), 10)
  assert_eq(unsafe_cast(v.get("y")), 20)
  inspect(p, content="{x: 10, y: 20}")
}

///|
test "unsafe_cast to struct" {
  let v : Js = ffi_point_new(5, 15)
  let p : Point = unsafe_cast(v)
  assert_eq(p.x, 5)
  assert_eq(p.y, 15)
  assert_eq(p.x2(), 10)
  inspect(p, content="{x: 5, y: 15}")
}

///|
test "from_map converts MoonBit Map to Js object" {
  let map : Map[String, Js] = { "name": js("Alice"), "age": js(30) }
  let obj : Js = from_map(map)
  assert_eq(unsafe_cast(obj.get("name")), "Alice")
  assert_eq(unsafe_cast(obj.get("age")), 30)
}

///|
test "from_map and to_string" {
  let map : Map[String, Js] = { "name": js("Alice"), "age": js(30) }
  let obj : Js = from_map(map)
  inspect(
    obj.to_string(),
    content=(
      #|{"name":"Alice","age":30}
    ),
  )
}

///|
test "from_map" {
  let map : Map[String, Js] = {
    "name": js("Alice"),
    "age": js(30),
    "active": js(true),
  }
  let obj = from_map(map)
  assert_eq(unsafe_cast(obj.get("name")), "Alice")
  assert_eq(unsafe_cast(obj.get("age")), 30)
  assert_eq(unsafe_cast(obj.get("active")), true)
}

///|
test "from_array" {
  let arr = [1, 2, 3, 4, 5]
  let val = from_array(arr)
  assert_true(@js.is_array(val))
  assert_eq(unsafe_cast(val.get(0)), 1)
  assert_eq(unsafe_cast(val.get(2)), 3)
  assert_eq(unsafe_cast(val.get(4)), 5)
}

///|
test "from_fn2 converts 2-arg function to Js" {
  let add = fn(a : Int, b : Int) -> Int { a + b }
  let js_add : Js = from_fn2(add)
  assert_eq(@js.typeof_(js_add), "function")
  let result = js_add.call_self([js(5), js(3)])
  assert_eq(unsafe_cast(result), 8)
}

///|
test "from_entries converts tuple array to Js object" {
  let entries : Array[(String, &JsImpl)] = [
    ("name", "Alice"),
    ("age", 30),
    ("active", true),
  ]
  let obj = from_entries(entries)
  assert_eq(unsafe_cast(obj.get("name")), "Alice")
  assert_eq(unsafe_cast(obj.get("age")), 30)
  assert_eq(unsafe_cast(obj.get("active")), true)
}

///|
test "from_entries with mixed types" {
  let entries : Array[(String, &JsImpl)] = [
    ("str", "hello"),
    ("num", 42),
    ("bool", false),
    ("float", 3.14),
  ]
  let obj = from_entries(entries)
  assert_eq(unsafe_cast(obj.get("str")), "hello")
  assert_eq(unsafe_cast(obj.get("num")), 42)
  assert_eq(unsafe_cast(obj.get("bool")), false)
  assert_eq(unsafe_cast(obj.get("float")), 3.14)
}

///|
test "from_entries with empty array" {
  let entries : Array[(String, &JsImpl)] = []
  let obj = from_entries(entries)
  inspect(obj.to_string(), content="{}")
}

///|
test "from_entries_option filters None values" {
  let entries : Array[(String, &JsImpl?)] = [
    ("name", Some("Alice")),
    ("age", Some(30)),
    ("email", None),
    ("active", Some(true)),
    ("address", None),
  ]
  let obj = from_entries_option(entries)
  assert_eq(unsafe_cast(obj.get("name")), "Alice")
  assert_eq(unsafe_cast(obj.get("age")), 30)
  assert_eq(unsafe_cast(obj.get("active")), true)
  // None values should not be set
  assert_true(is_undefined(obj.get("email")))
  assert_true(is_undefined(obj.get("address")))
}

///|
test "from_entries_option with all Some" {
  let entries : Array[(String, &JsImpl?)] = [
    ("a", Some(1)),
    ("b", Some(2)),
    ("c", Some(3)),
  ]
  let obj = from_entries_option(entries)
  assert_eq(unsafe_cast(obj.get("a")), 1)
  assert_eq(unsafe_cast(obj.get("b")), 2)
  assert_eq(unsafe_cast(obj.get("c")), 3)
}

///|
test "from_entries_option with all None" {
  let entries : Array[(String, &JsImpl?)] = [
    ("a", None),
    ("b", None),
    ("c", None),
  ]
  let obj = from_entries_option(entries)
  inspect(obj.to_string(), content="{}")
}

///|
test "from_entries_option with empty array" {
  let entries : Array[(String, &JsImpl?)] = []
  let obj = from_entries_option(entries)
  inspect(obj.to_string(), content="{}")
}

///|
test "from_entries with direct array (type inference)" {
  // 直接配列を渡した場合、型推論が効くかテスト
  let obj = from_entries([("name", "Bob"), ("age", 25)])
  assert_eq(unsafe_cast(obj.get("name")), "Bob")
  assert_eq(unsafe_cast(obj.get("age")), 25)
}

///|
test "from_entries_option with direct array (type inference)" {
  // 直接配列を渡した場合、型推論が効くかテスト
  let obj = from_entries_option([
    ("name", Some("Charlie")),
    ("age", Some(40)),
    ("email", None),
  ])
  assert_eq(unsafe_cast(obj.get("name")), "Charlie")
  assert_eq(unsafe_cast(obj.get("age")), 40)
  assert_true(is_undefined(obj.get("email")))
}

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
