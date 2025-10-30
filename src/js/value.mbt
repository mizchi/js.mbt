///|
/// unsafe js value
#external
pub type Value

///|
pub fn[T] Value::cast(self : Value) -> T = "%identity"

///|
pub fn[T] Value::cast_option(self : Value) -> T? {
  if self.is_some() {
    Some(self.cast())
  } else {
    None
  }
}

///|
pub impl Show for Value with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Eq for Value with equal(self, other) -> Bool {
  Object::is_(self, other)
}

///|
#alias("_[_]")
pub fn Value::get(self : Value, key : String) -> Value {
  ffi_get(self, key)
}

///|
pub fn[T] get_as(self : Value, key : String) -> T {
  ffi_get(self, key).cast()
}

///|
pub fn safe_get(self : Value, key : String) -> Value? {
  if self.is_undefined() || self.is_null() {
    None
  } else {
    match ffi_get(self, key).to_option() {
      None => None
      Some(v) => Some(v)
    }
  }
}

///|
#alias("_[_]=_")
pub fn Value::set(self : Value, key : String, value : &ToJs) -> Unit {
  ffi_set(self, key, value.to_js())
}

///|
pub fn call(self : Value, args : Array[&ToJs]) -> Value {
  let args : Array[Value] = args.map(a => a.to_js())
  ffi_call(self, args)
}

///|
pub fn unsafe_call(self : Value, args : Array[&ToJs]) -> Value raise {
  match ffi_safe_call(self |> identity, args.map(_.to_js())) {
    Err(e) => raise e
    Ok(v) => v |> identity
  }
}

///|
pub fn safe_call(self : Value, args : Array[&ToJs]) -> Result[Value, Error] {
  ffi_safe_call(self |> identity, args.map(_.to_js()))
}

///|
pub fn call0(self : Value) -> Value {
  ffi_call(self, [])
}

///|
pub fn call1(self : Value, arg : &ToJs) -> Value {
  ffi_call(self, [arg.to_js()])
}

///|
pub fn call2(self : Value, arg1 : &ToJs, arg2 : &ToJs) -> Value {
  ffi_call(self, [arg1.to_js(), arg2.to_js()])
}

///|
pub fn Value::call_property(
  self : Value,
  key : String,
  args : Array[&ToJs],
) -> Value {
  ffi_call_property(self, key, args.map(_.to_js()))
}

///|
pub fn Value::call_property0(self : Value, key : String) -> Value {
  ffi_call_property(self, key, [])
}

///|
pub fn Value::call_property1(self : Value, key : String, arg1 : &ToJs) -> Value {
  ffi_call_property(self, key, [arg1.to_js()])
}

///|
pub fn Value::call_property2(
  self : Value,
  key : String,
  arg1 : &ToJs,
  arg2 : &ToJs,
) -> Value {
  ffi_call_property(self, key, [arg1.to_js(), arg2.to_js()])
}

///|
pub fn Value::to_string(self : Value) -> String {
  ffi_to_string(self)
}

///|
pub fn Value::at(self : Value, idx : Int) -> Value {
  self.call_property1("at", idx)
}

///|
pub fn push(self : Value, value : &ToJs) -> Unit {
  self.call_property1("push", value) |> ignore
}

///|
pub fn length(self : Value) -> Int {
  self.get_as("length")
}

///|
pub fn delete(self : Value, k : String) -> Unit {
  ffi_delete(self, k)
}

///|
pub fn[T] to_option(self : Value) -> T? {
  if self.is_undefined() || self.is_null() {
    None
  } else {
    Some(self.cast())
  }
}

///|
pub extern "js" fn is_array(self : Value) -> Bool =
  #| (v) => Array.isArray(v)

///|
pub extern "js" fn is_function(self : Value) -> Bool =
  #| (v) => typeof v === "function"

///|
pub extern "js" fn is_string(self : Value) -> Bool =
  #| (v) => typeof v === "string"

///|
pub extern "js" fn is_boolean(self : Value) -> Bool =
  #| (v) => typeof v === "boolean"

///|
pub extern "js" fn is_number(self : Value) -> Bool =
  #| (v) => typeof v === "number"

///|
pub extern "js" fn is_null(self : Value) -> Bool =
  #| (v) => v === null

///|
pub extern "js" fn is_undefined(self : Value) -> Bool =
  #| (v) => v === undefined

///|
pub extern "js" fn is_nan(self : Value) -> Bool =
  #| (v) => Number.isNaN(v)

///|
pub extern "js" fn is_error(self : Value) -> Bool =
  #| (v) => Error.isError(v)

///|
pub extern "js" fn instance_of(self : Value, cls : Value) -> Bool =
  #| (v, cls) => v instanceof cls

///|
pub fn is_some(self : Value) -> Bool {
  !self.is_undefined() && !self.is_null()
}

///|
pub fn is_none(self : Value) -> Bool {
  self.is_undefined() || self.is_null()
}
