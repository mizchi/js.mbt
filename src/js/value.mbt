///|
/// js value
#external
pub type Value

///|
pub fn[T] Value::cast(self : Value) -> T = "%identity"

///|
pub fn[T] to_js(v : T) -> Value = "%identity"

///|
pub fn[A, B] identity(a : A) -> B {
  to_js(a).cast()
}

pub extern "js" fn Value::to_string(self : Value) -> String =
  #| (v) => v == null ? String(v) : v.toString()

///|
pub impl Show for Value with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
#alias("_[_]")
pub fn Value::get(self : Value, key : String) -> Value {
  self.get_inner(key)
}

///|
pub extern "js" fn Value::get_inner(self : Value, key : String) -> Value =
  #| (obj, k) => obj[k]

///|
pub extern "js" fn Value::at(self : Value, idx : Int) -> Value =
  #| (obj, idx) => obj.at(idx)

///|
pub extern "js" fn Value::delete(self : Value, key : String) -> Unit =
  #| (obj, k) => { delete obj[k]; }

///|
extern "js" fn Value::push_internal(self : Value, value : Value) -> Unit =
  #| (xs, v) => xs.push(v)

///|
pub fn Value::push(self : Value, value : &ToJs) -> Unit {
  self.push_internal(value.to_js())
}

///|
pub extern "js" fn Value::call(self : Value, args : Array[Value]) -> Value =
  #|(f, args) => f(...args)

///|
extern "js" fn Value::set_internal(
  self : Value,
  key : String,
  value : Value,
) -> Unit =
  #| (obj, k, v) => obj[k] = v

///|
#alias("_[_]=_")
pub fn Value::set(self : Value, key : String, value : &ToJs) -> Unit {
  self.set_internal(key, value.to_js())
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
pub extern "js" fn Value::length(self : Value) -> Int =
  #| (obj) => obj.length

///|
pub extern "js" fn Value::is_equal(self : Value, other : Value) -> Bool =
  #| (v, o) => v === o

///|
extern "js" fn ffi_try_call(
  f : () -> Value raise,
) -> Result[Value, Value] noraise =
  #|(f) => {
  #|  try {
  #|    return { $tag: 1, value: f() };
  #|  } catch (e) {
  #|    return { $tag: 0, value: e };
  #|  }
  #|}

///|
pub fn[T] Value::try_call(
  self : Self,
  args : Array[Value],
) -> T raise JsError {
  match ffi_try_call(() => self.call(args)) {
    Err(e) => raise JsError(e)
    Ok(v) => v.cast()
  }
}

pub fn[T] try_call(
  f: () -> T,
) -> T raise JsError {
  let f: Value = to_js(f)
  match ffi_try_call(() => f.call([])) {
    Err(e) => raise JsError(e)
    Ok(v) => v.cast()
  }
}


///|
pub suberror JsError Value


