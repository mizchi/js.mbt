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
pub fn new_(cls : Any, args : Array[&JsImpl]) -> Any {
  ffi_new(cls, args.map(_.to_js()))
}

///|
/// Trait for types that can be safely converted to JavaScript values.
///
/// # Example
///
/// ```moonbit
/// // Using the trait explicitly
/// let _val : Any = JsImpl::to_js("hello")
/// let _num : Any = JsImpl::to_js(42)
///
/// // Using with polymorphic functions
/// fn create_object(name : &JsImpl, age : &JsImpl) -> Any {
///   let obj = @js.Object::new()
///   obj.set("name", name)
///   obj.set("age", age)
///   obj.to_js()
/// }
/// let _obj = create_object("Alice", 30)  // Strings and Ints implement Js
/// ```
pub(open) trait JsImpl {
  to_js(Self) -> Any = _
  get(Self, &PropertyKey) -> Any = _
  set(Self, &PropertyKey, &JsImpl) -> Unit = _
  call(Self, &PropertyKey, Array[&JsImpl]) -> Any = _
  call0(Self, &PropertyKey) -> Any = _
  call1(Self, &PropertyKey, &JsImpl) -> Any = _
  call2(Self, &PropertyKey, &JsImpl, &JsImpl) -> Any = _
  call_throwable(Self, &PropertyKey, Array[&JsImpl]) -> Any raise ThrowError = _
  call_self(Self, Array[&JsImpl]) -> Any = _
  call_self0(Self) -> Any = _
  call_self_throwable(Self, Array[&JsImpl]) -> Any raise ThrowError = _
  delete(Self, &PropertyKey) -> Unit = _
  hasOwnProperty(Self, &PropertyKey) -> Bool = _
}

///|
impl JsImpl with to_js(self) -> Any {
  identity(self)
}

///|
/// JS: self[key]
impl JsImpl with get(self, key : &PropertyKey) -> Any {
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
impl JsImpl with call(self, key, args) -> Any {
  ffi_call(self.to_js(), key.to_key() |> identity, args.map(_.to_js()))
}

///|
/// call a method on the JavaScript value.
/// JS: self[key](...args)
impl JsImpl with call0(self, key) -> Any {
  ffi_call0(self.to_js(), key.to_key() |> identity)
}

///|
/// call a method on the JavaScript value.
/// JS: self[key](arg1)
impl JsImpl with call1(self, key, arg1) -> Any {
  ffi_call1(self.to_js(), key.to_key() |> identity, arg1.to_js())
}

///|
/// call a method on the JavaScript value.
/// JS: self[key](arg1, arg2)
impl JsImpl with call2(self, key, arg1, arg2) -> Any {
  ffi_call2(self.to_js(), key.to_key() |> identity, arg1.to_js(), arg2.to_js())
}

///|
/// JS: try { self[key](...args) } catch (e) { throw new ThrowError(e); }
impl JsImpl with call_throwable(self, key, args) -> Any raise ThrowError {
  throwable(() => ffi_call(
    self.to_js(),
    key.to_key() |> identity,
    args.map(_.to_js()),
  ))
}

///|
/// call a method on the JavaScript value with no arguments.
/// JS: self(...args)
impl JsImpl with call_self(self, args) -> Any {
  ffi_call_self(self.to_js(), args.map(_.to_js()))
}

///|
/// call a method on the JavaScript value with no arguments.
/// JS: self()
impl JsImpl with call_self0(self) -> Any {
  ffi_call_self0(self.to_js())
}

///|
impl JsImpl with call_self_throwable(self, args) -> Any raise ThrowError {
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
