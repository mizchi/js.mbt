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
