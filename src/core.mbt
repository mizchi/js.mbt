///|
/// Represents an unsafe JavaScript value.
///
/// `Val` is the core type for FFI operations between MoonBit and JavaScript.
/// It can hold any JavaScript value including primitives, objects, arrays, functions, etc.
///
/// # Example
///
/// ```moonbit
/// let num = js(42)                 // MoonBit Int -> @js.Js
/// let _str = js("hello")            // MoonBit String -> @js.Js
/// let _val : Int = identity(num) // Val -> MoonBit Int (unsafe)
/// ```
#external
pub type Js

///|
pub fn[T] Js::cast(self : Self) -> T {
  identity(self)
}

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
/// let _val : Js = JsImpl::to_js("hello")
/// let _num : Js = JsImpl::to_js(42)
///
/// // Using with polymorphic functions
/// fn create_object(name : &JsImpl, age : &JsImpl) -> Js {
///   let obj = @js.Object::new()
///   obj.set("name", name)
///   obj.set("age", age)
///   obj.to_js()
/// }
/// let _obj = create_object("Alice", 30)  // Strings and Ints implement Js
/// ```
pub(open) trait JsImpl {
  to_js(Self) -> Js = _
  get(Self, &PropertyKey) -> Js = _
  set(Self, &PropertyKey, &JsImpl) -> Unit = _
  call(Self, &PropertyKey, Array[&JsImpl]) -> Js = _
  call0(Self, &PropertyKey) -> Js = _
  call1(Self, &PropertyKey, &JsImpl) -> Js = _
  call2(Self, &PropertyKey, &JsImpl, &JsImpl) -> Js = _
  call_throwable(Self, &PropertyKey, Array[&JsImpl]) -> Js raise ThrowError = _
  call_self(Self, Array[&JsImpl]) -> Js = _
  call_self0(Self) -> Js = _
  call_self_throwable(Self, Array[&JsImpl]) -> Js raise ThrowError = _
  delete(Self, &PropertyKey) -> Unit = _
  hasOwnProperty(Self, &PropertyKey) -> Bool = _
}

///|
impl JsImpl with to_js(self) -> Js {
  identity(self)
}

///|
/// JS: self[key]
impl JsImpl with get(self, key : &PropertyKey) -> Js {
  ffi_get(self.to_js(), key.to_key() |> identity)
}

///|
/// JS: self[key] = val
impl JsImpl with set(self, key : &PropertyKey, val : &JsImpl) -> Unit {
  ffi_set(self.to_js(), key.to_key() |> identity, val.to_js())
}

///|
/// call a method on the JavaScript value.
/// JS: self[key](...args)
impl JsImpl with call(self, key, args) -> Js {
  ffi_call(self.to_js(), key.to_key() |> identity, args.map(_.to_js()))
}

///|
/// call a method on the JavaScript value.
/// JS: self[key](...args)
impl JsImpl with call0(self, key) -> Js {
  ffi_call0(self.to_js(), key.to_key() |> identity)
}

///|
/// call a method on the JavaScript value.
/// JS: self[key](arg1)
impl JsImpl with call1(self, key, arg1) -> Js {
  ffi_call1(self.to_js(), key.to_key() |> identity, arg1.to_js())
}

///|
/// call a method on the JavaScript value.
/// JS: self[key](arg1, arg2)
impl JsImpl with call2(self, key, arg1, arg2) -> Js {
  ffi_call2(self.to_js(), key.to_key() |> identity, arg1.to_js(), arg2.to_js())
}

///|
/// JS: try { self[key](...args) } catch (e) { throw new ThrowError(e); }
impl JsImpl with call_throwable(self, key, args) -> Js raise ThrowError {
  throwable(() => ffi_call(
    self.to_js(),
    key.to_key() |> identity,
    args.map(_.to_js()),
  ))
}

///|
/// call a method on the JavaScript value with no arguments.
/// JS: self(...args)
impl JsImpl with call_self(self, args) -> Js {
  ffi_call_self(self.to_js(), args.map(_.to_js()))
}

///|
/// call a method on the JavaScript value with no arguments.
/// JS: self()
impl JsImpl with call_self0(self) -> Js {
  ffi_call_self0(self.to_js())
}

///|
impl JsImpl with call_self_throwable(self, args) -> Js raise ThrowError {
  throwable(() => ffi_call_self(self.to_js(), args.map(_.to_js())))
}

///|
impl JsImpl with delete(self, key : &PropertyKey) -> Unit {
  ffi_delete(self.to_js(), key.to_key() |> identity)
}

///|
impl JsImpl with hasOwnProperty(self, key : &PropertyKey) -> Bool {
  ffi_has_own_property(self.to_js(), key.to_key() |> identity)
}

///|
/// Identity implementation for Js.
pub impl JsImpl for Js
