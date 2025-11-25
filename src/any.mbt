///|
/// Represents an unsafe JavaScript value like TypeScript's `any`
/// It can hold any JavaScript value including primitives, objects, arrays, functions, etc.
///
/// ## Example
///
/// ```moonbit
/// let num: @js.Any = @js.any(42) // MoonBit Int -> @js.Any
/// let _val : Int = num.cast()   // Any -> MoonBit Int (unsafe)
/// ```
#external
pub type Any

///|
/// Unsafe cast the `Any` value to a specific MoonBit type.
pub fn[T] Any::cast(self : Self) -> T {
  identity(self)
}

///|
/// JS: value[key]
#alias("_[_]")
pub fn Any::get_property(self : Any, key : &PropertyKey) -> Any {
  self.get(key)
}

///|
/// JS: value[key] = val
#alias("_[_]=_")
pub fn Any::set_property(self : Any, key : &PropertyKey, val : &JsImpl) -> Unit {
  self.set(key, val)
}

///|
pub impl Show for Any with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for Any with to_string(self) {
  if is_array(self) {
    ffi_json_stringify(self, undefined(), undefined())
  } else if is_object(self) {
    ffi_json_stringify(self, undefined(), undefined())
  } else {
    ffi_to_string(self)
  }
}

///|
pub impl Eq for Any with equal(self, other) -> Bool {
  ffi_object_is(self, other)
}

///|
/// Identity implementation for Js.
pub impl JsImpl for Any

///|
/// Nullable type for explicit null handling in FFI struct fields.
///
/// Use `Nullable[T]` when you need to represent JavaScript fields that can be `null`.
/// Unlike `T?` which treats both `null` and `undefined` as `None`, `Nullable[T]`
/// only checks for `null` specifically.
///
/// # When to Use
///
/// **Use `Nullable[T]` for:**
/// - FFI struct fields that can be explicitly null
/// - When you need to distinguish between null and undefined
///
/// **Use `T?` (Option) for:**
/// - Function parameters and return values
/// - General nullable handling where null/undefined distinction doesn't matter
///
/// # Example
///
/// Define FFI struct with nullable fields:
/// - `result : Nullable[ArrayBuffer]` - Can be null during reading
/// - `error : Nullable[JsError]` - Can be null when no error
///
/// Check if null: `reader.result.is_null()`
/// Convert to Option: `reader.result.to_option()`
///
/// # See Also
/// - `identity_option(Any) -> A?` - For converting Any to Option
/// - `from_option(A?) -> Any` - For converting Option to Js
#external
pub type Nullable[T]

///|
pub fn[T] Nullable::to_option(self : Nullable[T]) -> T? {
  let js_value : Any = self |> identity
  if ffi_is_null(js_value) {
    None
  } else {
    Some(self |> identity)
  }
}

///|
pub fn[T] Nullable::is_null(self : Nullable[T]) -> Bool {
  let js_value : Any = self |> identity
  ffi_is_null(js_value)
}

///|
#external
pub type Nullish[T]

///|
pub fn[T] Nullish::to_option(self : Nullish[T]) -> T? {
  let js_value : Any = self |> identity
  if ffi_is_nullish(js_value) {
    None
  } else {
    Some(self |> identity)
  }
}
