///|
pub fn[T] to_js(v : T) -> Value = "%identity"

///|
pub fn[A, B] identity(a : A) -> B {
  to_js(a).cast()
}

///|
pub extern "js" fn Value::is_object(self : Value) -> Bool =
  #| (v) => typeof v === "object" && v !== null

///|
pub extern "js" fn Value::is_array(self : Value) -> Bool =
  #| (v) => Array.isArray(v)

///|
pub extern "js" fn Value::is_function(self : Value) -> Bool =
  #| (v) => typeof v === "function"

///|
pub extern "js" fn Value::is_string(self : Value) -> Bool =
  #| (v) => typeof v === "string"

///|
pub extern "js" fn Value::is_boolean(self : Value) -> Bool =
  #| (v) => typeof v === "boolean"

///|
pub extern "js" fn Value::is_number(self : Value) -> Bool =
  #| (v) => typeof v === "number"

///|
pub extern "js" fn Value::is_null(self : Value) -> Bool =
  #| (v) => v === null

///|
pub extern "js" fn Value::is_some(self : Value) -> Bool =
  #| (v) => v !== null && v !== undefined

///|
pub extern "js" fn Value::is_undefined(self : Value) -> Bool =
  #| (v) => v === undefined

///|
pub extern "js" fn Value::is_nan(self : Value) -> Bool =
  #| (v) => Number.isNaN(v)

///|
pub extern "js" fn Value::is_error(self : Value) -> Bool =
  #| (v) => Error.isError(v)

///|
pub extern "js" fn Value::instance_of(self : Value, cls : Value) -> Bool =
  #| (v, cls) => v instanceof cls
