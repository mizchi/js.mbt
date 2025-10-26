///|
extern "js" fn stringify_no_indent(v : Value) -> String =
  #| (self) => JSON.stringify(self)

///|
extern "js" fn stringify_with_indent(v : Value, indent : Int) -> String =
  #| (self, indent) => JSON.stringify(self, null, indent)

///|
pub extern "js" fn structured_clone(v : Value) -> Value =
  #| (self) => structuredClone(self)

///|
pub fn stringify(self : Value, indent? : Int) -> String {
  match indent {
    None => stringify_no_indent(self)
    Some(i) => stringify_with_indent(self, i)
  }
}

///|
extern "js" fn ffi_console_log(value : Value) -> Unit =
  #| console.log

///|
extern "js" fn ffi_console_warn(value : Value) -> Unit =
  #| console.warn

///|
extern "js" fn ffi_console_error(value : Value) -> Unit =
  #| console.error

///|
extern "js" fn ffi_console_info(value : Value) -> Unit =
  #| console.info

///|
pub fn[T] log(v : T) -> Unit {
  v |> Value::cast_from |> ffi_console_log
}

///|
pub fn[T] console_error(v : T) -> Unit {
  v |> identity |> ffi_console_error
}

///|
pub fn[T] console_info(v : T) -> Unit {
  v |> identity |> ffi_console_info
}

///|
pub fn[T] console_warn(v : T) -> Unit {
  v |> identity |> ffi_console_warn
}

///|
extern "js" fn Value::set_internal(
  self : Value,
  key : String,
  value : Value,
) -> Unit =
  #| (obj, k, v) => obj[k] = v

///|
pub extern "js" fn js_null() -> Value = "() => null"

///|
pub extern "js" fn js_undefined() -> Value = "() => undefined"

///|
pub extern "js" fn new_object() -> Value =
  #| () => ({})

///|
pub fn Value::from_map(m : Map[String, &ToJsValue]) -> Value {
  let obj = new_object()
  for k, v in m {
    obj.set(k, v.to_js())
  }
  obj
}

///|
pub extern "js" fn new_array() -> Value =
  #| () => []

///|
pub fn Value::from_array(a : Array[&ToJsValue]) -> Value {
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
pub extern "js" fn Value::is_undefined(self : Value) -> Bool =
  #| (v) => v === undefined

///|
pub extern "js" fn Value::is_nan(self : Value) -> Bool =
  #| (v) => Number.isNaN(v)

///|
pub extern "js" fn Value::instance_of(self : Value, cls : Value) -> Bool =
  #| (v, cls) => v instanceof cls
