///|
pub struct JsObject(Value)

///|
pub fn Value::as_object(self : Value) -> JsObject {
  JsObject(self)
}

///|
pub fn JsObject::to_value(self : JsObject) -> Value {
  self.0
}

///|
pub fn JsObject::get(self : JsObject, key : String) -> Value? {
  let v = self.to_value().get(key)
  if v.is_undefined() {
    None
  } else {
    Some(v)
  }
}

///|
pub fn JsObject::set(self : JsObject, key : String, value : &ToJsValue) -> Unit {
  self.to_value().set(key, value)
}

///|
pub fn JsObject::delete(self : JsObject, key : String) -> Unit {
  self.to_value().delete(key)
}
