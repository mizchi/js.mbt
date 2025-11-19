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
test "from_builtin_json converts builtin Json to Js object" {
  inspect(
    from_builtin_json({
      "value": null,
      "items": [1, 2, 3],
      "nested": { "key": "value" },
    }),
    content=(
      #|{"value":null,"items":[1,2,3],"nested":{"key":"value"}}
    ),
  )
  inspect(
    from_builtin_json({ "age": 30, "name": "Alice" }),
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
