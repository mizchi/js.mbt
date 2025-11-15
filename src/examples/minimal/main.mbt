///|
#external
pub type JsValue

///|
pub fn[T] JsValue::cast(self : JsValue) -> T = "%identity"

///|
pub fn[A, B] unsafe_cast(a : A) -> B = "%identity"

///|
pub fn[A] js(a : A) -> JsValue = "%identity"

///|
extern "js" fn object_is(a : JsValue, b : JsValue) -> Bool =
  #| (v,k) => Object.is(v, k)

///|
pub impl Eq for JsValue with equal(self, other) -> Bool {
  object_is(self, other)
}

///|
pub impl Show for JsValue with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for JsValue with to_string(self) {
  if self == undefined() {
    "undefined"
  } else {
    unsafe_cast(self.call_method("toString", []))
  }
}

///|
pub extern "js" fn JsValue::get(self : Self, key : String) -> JsValue =
  #| (v,k) => v[k]

///|
pub extern "js" fn JsValue::set(
  self : Self,
  key : String,
  value : JsValue,
) -> Unit =
  #| (o,k,v) => o[k] = v

///|
pub extern "js" fn JsValue::call(self : Self, args : Array[JsValue]) -> JsValue =
  #| (v, a) => v(...a)

///|
pub extern "js" fn JsValue::call_method(
  self : Self,
  key : String,
  args : Array[JsValue],
) -> JsValue =
  #| (v, key, a) => v[key](...a)

///|
pub extern "js" fn undefined() -> JsValue =
  #| () => undefined

///|
pub extern "js" fn new_object() -> JsValue =
  #| () => ({})

///|
test {
  let v1 : JsValue = js(42)
  let v2 : JsValue = js(42)
  assert_eq(v1, v2)
  let v : Int = unsafe_cast(v1)
  assert_eq(v, 42)
  let obj = new_object()
  obj.set("key", js("value"))
  unsafe_cast(obj.call_method("hasOwnProperty", [js("key")])) |> assert_true
  let val : String = unsafe_cast(obj.get("key"))
  assert_eq(val, "value")
}

///|
fn main {

}
