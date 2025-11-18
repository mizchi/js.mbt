///|
/// property key for js object access
/// obj[0], obj["name"], obj[symbol]
pub trait PropertyKey {
  to_key(Self) -> Js = _
}

///|
impl PropertyKey with to_key(self) -> Js {
  self |> unsafe_cast
}

///|
pub impl PropertyKey for String

///|
pub impl PropertyKey for Int

///|
pub impl PropertyKey for Symbol

///|
/// JavaScript Object
#external
pub type Object

///|
pub impl JsImpl for Object

///|
/// JS: new Object()
pub fn Object::new() -> Self {
  ffi_new_empty_object() |> unsafe_cast
}

///|
pub fn Object::to_string(self : Self) -> String {
  ffi_json_stringify(self.to_js(), undefined(), undefined())
}

///|
/// JS: Object.keys(v)
pub fn Object::keys(v : &JsImpl) -> Array[String] {
  ffi_object_keys(v.to_js())
}

///|
/// JS: Object.values(v)
pub fn Object::values(v : &JsImpl) -> Array[Js] {
  ffi_object_values(v.to_js())
}

///|
/// JS: Object.entries(v)
pub fn Object::entries(v : &JsImpl) -> Array[(String, Js)] {
  let entries = ffi_object_entries(v.to_js())
  entries.map(entry => (unsafe_cast(entry.get(0)), unsafe_cast(entry.get(1))))
}

///|
/// JS: Object.assign(target, source)
pub fn Object::assign(target : &JsImpl, source : &JsImpl) -> Js {
  ffi_object_assign(target.to_js(), source.to_js())
}

///|
/// Object.create({}).
pub fn Object::create() -> Js {
  ffi_object_create()
}
