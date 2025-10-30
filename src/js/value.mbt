///|
/// unsafe js value
#external
pub type Value

///|
pub fn[T] Value::cast(self : Value) -> T = "%identity"

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
pub fn[T] Value::get_as(self : Value, key : String) -> T {
  ffi_get(self, key).cast()
}

///|
#alias("_[_]=_")
pub fn Value::set(self : Value, key : String, value : &ToJs) -> Unit {
  ffi_set(self, key, value.to_js())
}

///|
pub fn Value::call(self : Value, args : Array[&ToJs]) -> Value {
  let js_args : Array[Value] = args.map(a => a.to_js())
  ffi_call(self, js_args)
}

///|
pub fn Value::call0(self : Value) -> Value {
  ffi_call(self, [])
}

///|
pub fn Value::call1(self : Value, arg : &ToJs) -> Value {
  ffi_call(self, [arg.to_js()])
}

///|
pub fn Value::call2(self : Value, arg1 : &ToJs, arg2 : &ToJs) -> Value {
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
pub fn Value::to_string(self : Value) -> String {
  ffi_to_string(self)
}

///|
pub fn Value::at(self : Value, idx : Int) -> Value {
  self.call_property("at", [idx |> to_js()])
}

///|
pub fn Value::push(self : Value, value : &ToJs) -> Unit {
  self.call_property("push", [value.to_js()]) |> ignore
}

///|
pub fn Value::length(self : Value) -> Int {
  self.get_as("length")
}

///|
pub fn Value::delete(self : Value, k : String) -> Unit {
  ffi_delete(self, k)
}

///|
pub fn[T] Value::to_option(self : Value) -> T? {
  if self.is_undefined() || self.is_null() {
    None
  } else {
    Some(self.cast())
  }
}

///|
pub fn[T] Value::try_call(self : Self, args : Array[Value]) -> T raise JsError {
  match ffi_try_call(() => ffi_call(self, args)) {
    Err(e) => raise JsError(e)
    Ok(v) => v.cast()
  }
}

///|
pub fn[T] try_call(f : () -> T) -> T raise JsError {
  let f : Value = to_js(f)
  match ffi_try_call(() => ffi_call(f, [])) {
    Err(e) => raise JsError(e)
    Ok(v) => v.cast()
  }
}

///|
pub suberror JsError Value
