///|
/// property key for js object access
/// obj[0], obj["name"], obj[symbol]
pub trait PropertyKey {
  to_key(Self) -> Val = _
}

///|
impl PropertyKey with to_key(self) -> Val {
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
pub impl Js for Object

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
pub fn Object::keys(v : &Js) -> Array[String] {
  ffi_object_keys(v.to_js())
}

///|
/// JS: Object.values(v)
pub fn Object::values(v : &Js) -> Array[Val] {
  ffi_object_values(v.to_js())
}

///|
/// JS: Object.entries(v)
pub fn Object::entries(v : &Js) -> Array[(String, Val)] {
  let entries = ffi_object_entries(v.to_js())
  entries.map(entry => (unsafe_cast(entry.get(0)), unsafe_cast(entry.get(1))))
}

///|
/// JS: Object.assign(target, source)
pub fn Object::assign(target : &Js, source : &Js) -> Val {
  ffi_object_assign(target.to_js(), source.to_js())
}

///|
/// Object.create({}).
pub fn Object::create() -> Val {
  ffi_object_create()
}
