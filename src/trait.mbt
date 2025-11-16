///|
/// Trait for types that can be safely converted to JavaScript values.
///
/// This trait provides a type-safe way to convert MoonBit values to JavaScript
/// values (Val). Unlike the unsafe `js()` function, implementations of this trait
/// should ensure the conversion is well-defined and safe.
///
/// # Implementations
///
/// The trait is implemented for:
/// - Primitive types: `Int`, `Double`, `Float`, `Bool`, `String`
/// - `Val` itself (identity conversion)
/// - `Array[&Js]` (recursively converts elements)
/// - `Option[T]` where T implements Js (None becomes undefined)
///
/// # Example
///
/// ```moonbit
/// // Using the trait explicitly
/// let val : Val = Js::to_js("hello")
/// let num : Val = Js::to_js(42)
///
/// // Using with polymorphic functions
/// fn create_object(name : &Js, age : &Js) -> Val {
///   let obj = @js.Object::new()
///   obj.set("name", name)
///   obj.set("age", age)
///   obj.to_js()
/// }
/// let obj = create_object("Alice", 30)  // Strings and Ints implement Js
/// ```
///
/// # Custom Implementations
///
/// You can implement this trait for your own types to control
/// how they are converted to JavaScript values.
pub(open) trait Js {
  to_js(Self) -> Val = _
  get(Self, &PropertyKey) -> Val = _
  set(Self, &PropertyKey, &Js) -> Unit = _
  invoke(Self, &PropertyKey, Array[&Js]) -> Val = _
  invoke_throwable(Self, &PropertyKey, Array[&Js]) -> Val raise JsError = _
  invoke_self(Self, Array[&Js]) -> Val = _
  invoke_self_throwable(Self, Array[&Js]) -> Val raise JsError = _
  delete(Self, &PropertyKey) -> Unit = _
  has_own_property(Self, &PropertyKey) -> Bool = _
}

///|
impl Js with to_js(self) -> Val {
  js(self)
}

///|
impl Js with get(self, key : &PropertyKey) -> Val {
  ffi_get(self.to_js(), key.to_key() |> unsafe_cast)
}

///|
impl Js with set(self, key : &PropertyKey, val : &Js) -> Unit {
  ffi_set(self.to_js(), key.to_key() |> unsafe_cast, val.to_js())
}

///|
impl Js with invoke(self, key, args) -> Val {
  ffi_invoke(self.to_js(), key.to_key() |> unsafe_cast, args.map(_.to_js()))
}

///|
impl Js with invoke_throwable(self, key, args) -> Val raise JsError {
  throwable(() => ffi_invoke(
    self.to_js(),
    key.to_key() |> unsafe_cast,
    args.map(_.to_js()),
  ))
}

///|
/// Invoke a method on the JavaScript value with no arguments.
impl Js with invoke_self(self, args) -> Val {
  ffi_call(self.to_js(), args.map(_.to_js()))
}

///|
impl Js with invoke_self_throwable(self, args) -> Val raise JsError {
  throwable(() => ffi_call(self.to_js(), args.map(_.to_js())))
}

///|
impl Js with delete(self, key : &PropertyKey) -> Unit {
  ffi_delete(self.to_js(), key.to_key() |> unsafe_cast)
}

///|
impl Js with has_own_property(self, key : &PropertyKey) -> Bool {
  ffi_has_own_property(self.to_js(), key.to_key() |> unsafe_cast)
}
