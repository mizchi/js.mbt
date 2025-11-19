///|
/// Represents an unsafe JavaScript value.
///
/// `Val` is the core type for FFI operations between MoonBit and JavaScript.
/// It can hold any JavaScript value including primitives, objects, arrays, functions, etc.
///
/// # Example
///
/// ```moonbit
/// let num = js(42)                 // MoonBit Int -> Js
/// let str = js("hello")            // MoonBit String -> Js
/// let val : Int = unsafe_cast(num) // Val -> MoonBit Int (unsafe)
/// ```
#external
pub type Js

///|
pub impl Show for Js with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for Js with to_string(self) {
  if is_array(self) {
    return ffi_json_stringify(self, undefined(), undefined())
  }
  if is_object(self) {
    return ffi_json_stringify(self, undefined(), undefined())
  }
  ffi_to_string(self)
}

///|
pub impl Eq for Js with equal(self, other) -> Bool {
  ffi_object_is(self, other)
}

///|
/// JS: v instanceof cls
pub fn[T : JsImpl] instanceof_(v : T, cls : T) -> Bool {
  ffi_instance_of(v.to_js(), cls.to_js())
}

///|
/// JS: typeof v
pub fn[T : JsImpl] typeof_(v : T) -> String {
  ffi_type_of(v.to_js())
}

///|
/// Check if a value is neither undefined nor null.
///
/// # Returns
///
/// `true` if the value is defined and not null, `false` otherwise
///
/// # Example
///
/// ```moonbit
/// assert_true(js(42).is_some())        // true
/// assert_true(js("hello").is_some())   // true
/// assert_false(undefined().is_some())   // false
/// assert_false(null_().is_some())       // false
/// ```
#deprecated
pub fn Js::is_some(self : Self) -> Bool {
  !is_undefined(self) && !is_null(self)
}

///|
/// Check if a value is undefined or null.
///
/// # Returns
///
/// `true` if the value is undefined or null, `false` otherwise
///
/// # Example
///
/// ```moonbit
/// assert_true(undefined().is_none())   // true
/// assert_true(null_().is_none())       // true
/// assert_false(js(42).is_none())        // false
/// assert_false(js("hello").is_none())   // false
/// ```
pub fn Js::is_none(self : Self) -> Bool {
  is_undefined(self) || is_null(self)
}

///|
/// JS: new cls(...args)
pub fn new_(cls : Js, args : Array[&JsImpl]) -> Js {
  ffi_new(cls, args.map(_.to_js()))
}

///|
/// Trait for types that can be safely converted to JavaScript values.
///
/// # Example
///
/// ```moonbit
/// // Using the trait explicitly
/// let val : Js = JsImpl::to_js("hello")
/// let num : Js = JsImpl::to_js(42)
///
/// // Using with polymorphic functions
/// fn create_object(name : &JsImpl, age : &JsImpl) -> Js {
///   let obj = @js.Object::new()
///   obj.set("name", name)
///   obj.set("age", age)
///   obj.to_js()
/// }
/// let obj = create_object("Alice", 30)  // Strings and Ints implement Js
/// ```
pub(open) trait JsImpl {
  to_js(Self) -> Js = _
  get(Self, &PropertyKey) -> Js = _
  set(Self, &PropertyKey, &JsImpl) -> Unit = _
  invoke(Self, &PropertyKey, Array[&JsImpl]) -> Js = _
  invoke_throwable(Self, &PropertyKey, Array[&JsImpl]) -> Js raise JsThrowError = _
  invoke_self(Self, Array[&JsImpl]) -> Js = _
  invoke_self_throwable(Self, Array[&JsImpl]) -> Js raise JsThrowError = _
  delete(Self, &PropertyKey) -> Unit = _
  hasOwnProperty(Self, &PropertyKey) -> Bool = _
}

///|
impl JsImpl with to_js(self) -> Js {
  unsafe_cast(self)
}

///|
/// JS: self[key]
impl JsImpl with get(self, key : &PropertyKey) -> Js {
  ffi_get(self.to_js(), key.to_key() |> unsafe_cast)
}

///|
/// JS: self[key] = val
impl JsImpl with set(self, key : &PropertyKey, val : &JsImpl) -> Unit {
  ffi_set(self.to_js(), key.to_key() |> unsafe_cast, val.to_js())
}

///|
/// Invoke a method on the JavaScript value.
/// JS: self[key](...args)
impl JsImpl with invoke(self, key, args) -> Js {
  ffi_invoke(self.to_js(), key.to_key() |> unsafe_cast, args.map(_.to_js()))
}

///|
/// JS: try { self[key](...args) } catch (e) { throw new JsThrowError(e); }
impl JsImpl with invoke_throwable(self, key, args) -> Js raise JsThrowError {
  throwable(() => ffi_invoke(
    self.to_js(),
    key.to_key() |> unsafe_cast,
    args.map(_.to_js()),
  ))
}

///|
/// Invoke a method on the JavaScript value with no arguments.
/// JS: self(...args)
impl JsImpl with invoke_self(self, args) -> Js {
  ffi_call(self.to_js(), args.map(_.to_js()))
}

///|
impl JsImpl with invoke_self_throwable(self, args) -> Js raise JsThrowError {
  throwable(() => ffi_call(self.to_js(), args.map(_.to_js())))
}

///|
impl JsImpl with delete(self, key : &PropertyKey) -> Unit {
  ffi_delete(self.to_js(), key.to_key() |> unsafe_cast)
}

///|
impl JsImpl with hasOwnProperty(self, key : &PropertyKey) -> Bool {
  ffi_has_own_property(self.to_js(), key.to_key() |> unsafe_cast)
}

///|
/// Identity implementation for Js.
pub impl JsImpl for Js

///|
pub impl JsImpl for String

///|
pub impl JsImpl for Double

///|
pub impl JsImpl for Float

///|
pub impl JsImpl for Int

///|
/// Convert a MoonBit Bool to a JavaScript boolean value.
pub impl JsImpl for Bool

///|
/// Convert a MoonBit UInt to a JavaScript number value.
pub impl JsImpl for UInt

///|
pub impl JsImpl for Unit

///|
/// Convert an Array of Js-implementing types to a JavaScript array.
pub impl JsImpl for Array[&JsImpl] with to_js(self) {
  from_array(self)
}

///|
pub impl JsImpl for Map[String, &JsImpl] with to_js(self) {
  let v = Object::new()
  for k, val in self {
    v.set(k, val.to_js())
  }
  v.to_js()
}

///|
/// Convert an Option to a JavaScript value.
pub impl[T] JsImpl for T? with to_js(self) {
  unsafe_cast(self)
}
