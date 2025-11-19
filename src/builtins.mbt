
///|
/// JS: null
pub fn null_() -> Js {
  ffi_null()
}

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

// JavaScript String
// In this file, we impl only static methods of String.*
// Use builtin String as instance methods.

///|
#external
pub type JsString

///|
pub impl JsImpl for JsString

///|
fn string_instance() -> JsString {
  unsafe_cast(globalThis().get("String"))
}

///|
/// JS: String.fromCharCode(...values)
pub fn JsString::fromCharCode(values : Array[Int]) -> String {
  string_instance().invoke("fromCharCode", values |> from_array |> unsafe_cast)
  |> unsafe_cast
}

///|
/// JS: String.fromCharCode(...values)
pub fn JsString::fromCodePoint(values : Array[Int]) -> String {
  string_instance().invoke("fromCodePoint", values |> from_array |> unsafe_cast)
  |> unsafe_cast
}

///|
/// JavaScript Array
#external
pub type JsArray

///|
pub impl JsImpl for JsArray

///|
pub fn JsArray::to_string(self : Self) -> String {
  ffi_json_stringify(self.to_js(), undefined(), undefined())
}

///|
/// JS: Array.from(items)
pub fn[T] JsArray::from(items : Array[T]) -> JsArray {
  ffi_array_from(items |> unsafe_cast) |> unsafe_cast
}

///|
/// JS: new Array()
pub fn JsArray::new() -> JsArray {
  ffi_new_empty_array() |> unsafe_cast
}

///|
/// JS: array.push(item)
pub fn JsArray::push(self : JsArray, item : &JsImpl) -> Unit {
  self.as_builtin_array().push(item.to_js())
}

///|
/// cast to builtin Array
pub fn[T] JsArray::as_builtin_array(self : Self) -> Array[T] {
  self |> unsafe_cast
}

///|
/// JS: Array.isArray(v)
pub fn[T : JsImpl] JsArray::isArray(v : T) -> Bool {
  ffi_is_array(v.to_js())
}

///|
/// Array.from(v)
pub fn array_from(v : Js) -> Array[Js] {
  ffi_array_from(v)
}

///|
/// JavaScript Symbol
#external
pub type Symbol

///|
pub impl JsImpl for Symbol

///|
/// JS: Symbol(name)
pub fn symbol(name : String) -> Symbol {
  ffi_symbol(name)
}

///|
/// JS: Symbol.for(name)
pub fn Symbol::for_(name : String) -> Symbol {
  ffi_symbol_for(name)
}

///|
/// JS: Symbol.iterator
pub fn Symbol::iterator() -> Symbol {
  ffi_symbol_iterator()
}

///|
/// JS: Symbol.asyncIterator
pub fn Symbol::asyncIterator() -> Symbol {
  ffi_symbol_async_iterator()
}

///|
/// JS: Symbol.dispose
pub fn Symbol::dispose() -> Symbol {
  ffi_symbol_dispose()
}

///|
/// JS: Symbol.asyncDispose
pub fn Symbol::asyncDispose() -> Symbol {
  ffi_symbol_async_dispose()
}
