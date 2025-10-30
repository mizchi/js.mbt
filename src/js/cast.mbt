///|
pub fn[T] to_js(v : T) -> Value = "%identity"

///|
pub fn[A, B] identity(a : A) -> B {
  to_js(a).cast()
}

///|
pub extern "js" fn Value::is_object(self : Value) -> Bool =
  #| (v) => typeof v === "object" && v !== null
