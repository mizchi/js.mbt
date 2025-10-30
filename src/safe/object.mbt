///|
#external
pub type SafeObject

///|
pub impl ToJs for SafeObject with to_js(self) -> Value {
  self |> identity
}

///|
#alias("_[_]=_")
pub extern "js" fn SafeObject::set(self : Self, k : String, v : Value) -> Unit =
  #| (obj, k, v) => { obj[k] = v; }

///|
#alias("_[_]")
pub extern "js" fn SafeObject::get(self : Self, k : String) -> SafeValue? =
  #| (obj, k, v) => obj[k]

///|
pub fn SafeObject::from(m : Map[String, &ToJs]) -> SafeObject {
  let obj = SafeObject::new()
  for k, v in m {
    obj.set(k, v.to_js())
  }
  obj
}

///|
pub extern "js" fn SafeObject::new() -> SafeObject =
  #| () => ({})

///|
test "Object::new" {
  let obj = SafeObject::new()
  obj.set("a", 1 |> identity)
  let v : Int = obj.get("a") |> identity
  assert_eq(v, 1)
}
