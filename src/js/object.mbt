///|
#external
pub type Object

///|
impl ToJs for Object with to_js(self) -> Value {
  self |> identity
}

///|
pub fn to_value(self : Object) -> Value {
  self |> identity
}

///|
#alias("_[_]=_")
pub extern "js" fn Object::set(self : Self, k : String, v : Value) -> Unit =
  #| (obj, k, v) => { obj[k] = v; }

///|
#alias("_[_]")
pub extern "js" fn Object::get(self : Self, k : String) -> Unit =
  #| (obj, k, v) => obj[k]

///|
pub extern "js" fn Object::keys(v : Value) -> Array[String] =
  #| (obj) => Object.keys(obj)

pub fn Object::assign(a : Value, b : Value) -> Value {
  ffi_object_assign(a, b)
}

///|
pub extern "js" fn Object::is_(v : Value, other : Value) -> Bool =
  #| (obj, other) => Object.is(obj, other)

///|
/// wip
pub extern "js" fn Object::values(v : Value) -> Array[Value] =
  #| (obj) => Object.values(obj)

///|
pub fn Object::from(m : Map[String, &ToJs]) -> Object {
  let obj = Object::new()
  for k, v in m {
    obj.set(k, v.to_js())
  }
  obj
}

///|
pub extern "js" fn Object::new() -> Object =
  #| () => ({})

///|
test "Object::new" {
  let obj = Object::new()
  obj.set("a", 1 |> identity)
  let v : Int = obj.get("a") |> identity
  assert_eq(v, 1)
  let keys : Array[String] = Object::keys(obj |> identity)
  assert_eq(keys, ["a"])
  let values : Array[Value] = Object::values(obj |> identity)
  assert_eq(values.length(), 1)
  let v0 : Int = values.at(0) |> identity
  assert_eq(v0, 1)
}

///|
test "Object::assign" {
  let obj1 = Object::from({ "x": 10, "y": 20 })
  let obj2 = Object::from({ "y": 30, "z": 40 })
  let merged = Object::assign(obj1 |> identity, obj2 |> identity)
  let x : Int = merged.get("x") |> identity
  let y : Int = merged.get("y") |> identity
  let z : Int = merged.get("z") |> identity
  assert_eq(x, 10)
  assert_eq(y, 30)
  assert_eq(z, 40)
}

///|
test "Object::from" {
  let m : Map[String, &ToJs] = {
    "x": 10,
    "y": "hello",
    "nested": Object::from({ "a": 1, "b": 2 }),
  }
  let obj = Object::from(m)
  let x : Int = obj.get("x") |> identity
  let y : String = obj.get("y") |> identity
  assert_eq(x, 10)
  assert_eq(y, "hello")
  let nested : Object = obj.get("nested") |> identity
  let a : Int = nested.get("a") |> identity
  let b : Int = nested.get("b") |> identity
  assert_eq(a, 1)
  assert_eq(b, 2)
}
