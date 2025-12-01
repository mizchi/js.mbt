///|
/// JS: v instanceof cls
pub fn[T, U] instanceof_(v : T, cls : U) -> Bool {
  ffi_instance_of(identity(v), identity(cls))
}

///|
/// JS: typeof v
pub fn[T] typeof_(v : T) -> String {
  ffi_type_of(identity(v))
}

///|
/// JS: new cls(...args)
pub fn new_(cls : @nostd.Any, args : Array[@nostd.Any]) -> @nostd.Any {
  ffi_new(cls, args)
}

///|
/// Trait for types that can be safely converted to JavaScript values.
///
/// # Example
///
/// ```moonbit
/// // Using the trait explicitly
/// let _val : Any = JsImpl::as_any("hello")
/// let _num : Any = JsImpl::as_any(42)
///
/// // Using with polymorphic functions
/// fn create_object(name : &JsImpl, age : &JsImpl) -> Any {
///   let obj = @nostd.Object::new()
///   obj.set("name", name)
///   obj.set("age", age)
///   obj
/// }
/// let _obj = create_object("Alice", 30)  // Strings and Ints implement Js
/// ```

///|
/// JS: self[key]
// impl JsImpl with get(self, key : &PropertyKey) -> Any {
//   ffi_get(self.as_any(), key.to_key() |> identity)
// }

// ///|
// /// JS: self[key] = val
// impl JsImpl with set(self, key : &PropertyKey, val : &JsImpl) -> Unit {
//   ffi_set(self.as_any(), key.to_key() |> identity, val.as_any())
// }

// ///|
// /// call a method on the JavaScript value.
// /// JS: self[key](...args)
// impl JsImpl with call(self, key, args) -> Any {
//   ffi_call(self.as_any(), key.to_key() |> identity, args.map(_.as_any()))
// }

// ///|
// /// call a method on the JavaScript value.
// /// JS: self[key](...args)
// impl JsImpl with call0(self, key) -> Any {
//   ffi_call0(self.as_any(), key.to_key() |> identity)
// }

// ///|
// /// call a method on the JavaScript value.
// /// JS: self[key](arg1)
// impl JsImpl with call1(self, key, arg1) -> Any {
//   ffi_call1(self.as_any(), key.to_key() |> identity, arg1.as_any())
// }

// ///|
// /// call a method on the JavaScript value.
// /// JS: self[key](arg1, arg2)
// impl JsImpl with call2(self, key, arg1, arg2) -> Any {
//   ffi_call2(
//     self.as_any(),
//     key.to_key() |> identity,
//     arg1.as_any(),
//     arg2.as_any(),
//   )
// }

// ///|
// /// JS: try { self[key](...args) } catch (e) { throw new ThrowError(e); }
// impl JsImpl with call_throwable(self, key, args) -> Any raise ThrowError {
//   throwable(() => ffi_call(
//     self.as_any(),
//     key.to_key() |> identity,
//     args.map(_.as_any()),
//   ))
// }

// ///|
// /// call a method on the JavaScript value with no arguments.
// /// JS: self(...args)
// impl JsImpl with call_self(self, args) -> Any {
//   ffi_call_self(self.as_any(), args.map(_.as_any()))
// }

// ///|
// /// call a method on the JavaScript value with no arguments.
// /// JS: self()
// impl JsImpl with call_self0(self) -> Any {
//   ffi_call_self0(self.as_any())
// }

// ///|
// impl JsImpl with call_self_throwable(self, args) -> Any raise ThrowError {
//   throwable(() => ffi_call_self(self.as_any(), args.map(_.as_any())))
// }

// ///|
// impl JsImpl with delete(self, key : &PropertyKey) -> Unit {
//   ffi_delete(self.as_any(), key.to_key() |> identity)
// }

// ///|
// impl JsImpl with hasOwnProperty(self, key : &PropertyKey) -> Bool {
//   ffi_has_own_property(self.as_any(), key.to_key() |> identity)
// }
