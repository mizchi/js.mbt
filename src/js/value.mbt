///|
/// js value
#external
pub type Value

///|
pub fn[T] Value::cast(self : Value) -> T = "%identity"

///|
pub fn Value::cast_as_nullable(self : Value) -> Value? {
  if self.is_undefined() || self.is_null() {
    None
  } else {
    Some(self.cast())
  }
}

///|
pub fn[T] Value::cast_from(self : T) -> Value = "%identity"

///|
pub extern "js" fn Value::to_string(self : Value) -> String =
  #| (v) => String(v)

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
pub fn Value::push(self : Value, value : &ToJsValue) -> Unit {
  self.push_internal(value.to_js())
}

///|
pub extern "js" fn Value::call(self : Value, args : Array[Value]) -> Value =
  #|(f, args) => f(...args)

///|
#alias("_[_]=_")
pub fn Value::set(self : Value, key : String, value : &ToJsValue) -> Unit {
  self.set_internal(key, value.to_js())
}

///|
pub fn[T] Value::to_option(self : Value) -> T? {
  if self.is_undefined() || self.is_null() {
    None
  } else {
    Some(self |> identity)
  }
}

///|
pub extern "js" fn Value::keys(self : Value) -> Array[String] =
  #| (obj) => Object.keys(obj)

///|
pub extern "js" fn Value::length(self : Value) -> Int =
  #| (obj) => obj.length

///|
pub extern "js" fn Value::is_equal(self : Value, other : Value) -> Bool =
  #| (v, o) => v === o

///|
pub fn[A, B] identity(a : A) -> B {
  Value::cast_from(a).cast()
}
