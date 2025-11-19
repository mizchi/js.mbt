///|
/// JS: null
pub fn null_() -> Js {
  ffi_null()
}

///|
/// JavaScript Symbol
#external
pub type Symbol

///|
pub impl JsImpl for Symbol

///|
extern "js" fn symbol_class() -> Js =
  #| () => Symbol

///|
/// JS: Symbol(name)
pub fn symbol(name : String) -> Symbol {
  ffi_symbol(name)
}

///|
/// JS: Symbol.for(name)
pub fn Symbol::for_(name : String) -> Symbol {
  symbol_class().call("for", [name]) |> unsafe_cast
}

///|
/// JS: Symbol.iterator
pub fn Symbol::iterator() -> Symbol {
  symbol_class().get("iterator") |> unsafe_cast
}

///|
/// JS: Symbol.asyncIterator
pub fn Symbol::asyncIterator() -> Symbol {
  symbol_class().get("asyncIterator") |> unsafe_cast
}

///|
/// JS: Symbol.dispose
pub fn Symbol::dispose() -> Symbol {
  symbol_class().get("dispose") |> unsafe_cast
}

///|
/// JS: Symbol.asyncDispose
pub fn Symbol::asyncDispose() -> Symbol {
  symbol_class().get("asyncDispose") |> unsafe_cast
}

///|
/// JS: Symbol.asyncDispose
pub fn Symbol::toStringTag() -> Symbol {
  symbol_class().get("toStringTag") |> unsafe_cast
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
  string_instance().call("fromCharCode", values |> from_array |> unsafe_cast)
  |> unsafe_cast
}

///|
/// JS: String.fromCharCode(...values)
pub fn JsString::fromCodePoint(values : Array[Int]) -> String {
  string_instance().call("fromCodePoint", values |> from_array |> unsafe_cast)
  |> unsafe_cast
}

///|
/// JavaScript Object
#external
pub type Object

///|
pub impl JsImpl for Object

///|
/// JS: new Object()
pub fn Object::new() -> Self {
  ffi_new_object() |> unsafe_cast
}

///|
/// get the Object class
fn object_class() -> Js {
  unsafe_cast(globalThis().get("Object"))
}

///|
/// JS: Object.keys(v)
pub fn Object::keys(v : &JsImpl) -> Array[String] {
  object_class().call("keys", [v.to_js()]) |> unsafe_cast
}

///|
/// JS: Object.values(v)
pub fn Object::values(v : &JsImpl) -> Array[Js] {
  object_class().call("values", [v.to_js()]) |> unsafe_cast
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
  object_class().call("assign", [target.to_js(), source.to_js()]) |> unsafe_cast
}

///|
/// JS: Object.create(v)
pub fn Object::create(v : Js) -> Js {
  object_class().call("create", [v]) |> unsafe_cast
}

///|
/// JS: object.propertyIsEnumerable(k)
pub fn Object::propertyIsEnumerable(self : Self, key : &PropertyKey) -> Bool {
  ffi_property_is_enumerable(self.to_js(), key.to_key() |> unsafe_cast)
}

///|
/// JS: object.isPrototypeOf(target)
pub fn Object::isPrototypeOf(self : Self, target : Js) -> Bool {
  ffi_is_prototype_of(self.to_js(), target)
}

///|
pub fn Object::hasOwnProperty(self : Self, key : &PropertyKey) -> Bool {
  ffi_has_own_property(self.to_js(), key.to_key() |> unsafe_cast)
}

///|
pub fn Object::isExtensible(self : Self) -> Bool {
  self.call0("isExtensible") |> unsafe_cast
}

///|
pub fn Object::to_string(self : Self) -> String {
  ffi_json_stringify(self.to_js(), undefined(), undefined())
}

///|
/// JavaScript Array
/// NonGeneric Array only for Array[Js]
/// Use builtin Array[T] for generic array and JsArray::from(array)
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
  ffi_new_array() |> unsafe_cast
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
/// JavaScript Function
#external
pub type Function

///|
pub impl JsImpl for Function

///|
pub fn Function::to_string(self : Self) -> String {
  ffi_json_stringify(self.to_js(), undefined(), undefined())
}

///|
/// JS: function.name
pub fn Function::name(self : Self) -> String {
  self.get("name") |> unsafe_cast
}

///|
/// JS: function.apply
pub extern "js" fn Function::apply(
  self : Self,
  caller : Js,
  args : Array[Js],
) -> Js =
  #|(self, args) => self.apply(caller, args)
