///|
pub extern "js" fn js_null() -> Value = "() => null"

///|
pub extern "js" fn js_undefined() -> Value = "() => undefined"

///|
pub extern "js" fn new_object() -> Value =
  #| () => ({})

///|
pub extern "js" fn new_array() -> Value =
  #| () => []

///|
pub fn Value::from_array(a : Array[&ToJs]) -> Value {
  let arr = new_array()
  for v in a {
    arr.push(v)
  }
  arr
}

///|
pub fn Value::from_js_array(a : Array[Value]) -> Value {
  let arr = new_array()
  for v in a {
    arr.push(v)
  }
  arr
}
