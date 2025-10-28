///|
pub struct JsArray(Value)

///|
pub fn Value::as_array(self : Value) -> JsArray {
  JsArray(self)
}

///|
pub fn JsArray::to_value(self : JsArray) -> Value {
  self.0
}

///|
pub fn JsArray::length(self : JsArray) -> Int {
  self.0.length()
}

///|
pub fn JsArray::at(self : JsArray, idx : Int) -> Value {
  self.to_value().at(idx)
}

///|
pub fn JsArray::push(self : JsArray, value : &ToJs) -> Unit {
  self.to_value().push(value)
}

///|
pub fn JsArray::set(self : JsArray, idx : Int, value : &ToJs) -> Unit {
  self.to_value().set(idx.to_string(), value)
}
