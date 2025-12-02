// This module provides conversion utilities between MoonBit and JavaScript types.
//
// Main functions:
// - from_array() - Convert MoonBit Array to JS Array
// - from_map() - Convert MoonBit Map to JS Object (all keys set)
// - from_option_map() - Convert MoonBit Map to JS Object (skip None keys)
// - from_option_map_or_undefined() - Same as above, returns undefined if empty
// - from_fn0/1/2/3() - Convert MoonBit functions to JS functions
// - from_json() - Convert MoonBit Json type to JS Object
// - to_json() / as_any() - Bidirectional conversion between Json and Js

///| JsImpl implementations for MoonBit primitive types
///  Note: These must remain as impl JsImpl because we cannot define methods on foreign types

///|
/// Conversion functions
pub using @nostd {from_fn0, from_fn1, from_fn2, from_fn3}

///|
/// Cast a MoonBit Array to a JavaScript array.
pub fn[T] from_array(v : Array[T]) -> @nostd.Any {
  identity(v)
}

///|
extern "js" fn ffi_wrap_sync(
  f : Any,
  ok : (Any) -> Result[Any, Any],
  err : (Any) -> Result[Any, Any],
) -> Result[Any, Any] =
  #|(f, ok, err) => {
  #|  try {
  #|    return ok(f())
  #|  } catch(e) {
  #|    return err(e)
  #|  }
  #|}

///|
/// Unsafely cast a value from one type to another.
/// When you cast to `Js`, use `js(v)` or `unsafe_any(v)` instead.
pub fn[A, B] identity(v : A) -> B = "%identity"

///|
/// Cast any value to a JavaScript Val safely.
pub fn[T] any(a : T) -> Any {
  identity(a)
}

///|
/// Convert any MoonBit value to a JavaScript Val.
/// Use `unsafe_any()` if you can
pub fn[T] unsafe_any(v : T) -> Any {
  identity(v)
}

///|
/// Safely convert a JavaScript value to an Option type.
///
/// Converts JavaScript `null` or `undefined` to `None`, otherwise returns `Some(value)`.
/// This is essential for FFI because accessing properties on null/undefined will crash.
///
/// # Common Patterns
///
/// - DOM API nullable returns: `node._get("parentNode") |> identity_option()`
/// - Optional object properties: `obj._get("name") |> identity_option()`
/// - Converting back to Js: use `from_option(opt)`
///
/// # Related Functions
/// - `from_option(A?) -> Js` - Inverse conversion (Option to Js)
/// - `@js.Nullable[T]` - For FFI struct fields that need explicit null handling
pub fn[A] identity_option(v : Any) -> A? {
  if ffi_is_nullish(v) {
    None
  } else {
    Some(identity(v))
  }
}

///|
/// Convert an Option to Any, mapping None to null and Some(v) to v.
///
/// This is the inverse of `identity_option`. Use this when you need to pass
/// MoonBit Option values back to JavaScript APIs.
///
/// # Usage
///
/// - `Some(42) |> from_option` returns Js(42)
/// - `None |> from_option` returns Js(null)
/// - Use with match to set optional properties on objects
///
/// # See Also
/// - `identity_option(Js) -> A?` - Inverse conversion (Js to Option)
pub fn[A] from_option(opt : A?) -> Any {
  match opt {
    Some(v) => identity(v)
    None => ffi_null()
  }
}

///|
/// JS: Array.isArray(v)
pub fn[T] is_array(v : T) -> Bool {
  ffi_is_array(identity(v))
}

///|
/// JS: typeof v === "object" && v !== null && !Array.isArray(v)
// pub fn[T] is_object(v : T) -> Bool {
//   ffi_is_object(identity(v))
// }

pub fn is_object(v : @nostd.Any) -> Bool {
  ffi_is_object(identity(v))
}

///|
/// JS: v === null
pub fn[T] is_null(v : T) -> Bool {
  ffi_is_null(identity(v))
}

///|
/// JS: v === undefined
pub fn[T] is_undefined(v : T) -> Bool {
  ffi_is_undefined(identity(v))
}

///|
/// JS: v == undefined
pub fn[T] is_nullish(v : T) -> Bool {
  ffi_is_nullish(identity(v))
}

///|
pub fn[T] is_builtin_trait(v : T) -> Bool {
  let v = @nostd.any(v)
  ffi_has_own_property(v.cast(), "self") &&
  ffi_has_own_property(v.cast(), "method_0")
}

///|
/// Wraps a synchronous function call, converting any thrown JS errors into ThrowError
/// ```moonbit skip
/// let result = throwable(() => undefined().call_self([]))
/// ```
pub fn[T] throwable(f : () -> T raise?) -> T raise ThrowError {
  match throwable_result(f |> identity) {
    Ok(result) => result |> identity
    Err(e) => {
      if ffi_is_error(e) {
        let error : JsError = identity(e)
        let error_type = ffi_get_error_type(e)
        match error_type {
          "TypeError" => raise ThrowError::TypeError(error)
          "RangeError" => raise ThrowError::RangeError(error)
          "ReferenceError" => raise ThrowError::ReferenceError(error)
          "SyntaxError" => raise ThrowError::SyntaxError(error)
          "URIError" => raise ThrowError::URIError(error)
          "EvalError" => raise ThrowError::EvalError(error)
          "AggregateError" => raise ThrowError::AggregateError(error)
          _ => raise ThrowError::Error(error)
        }
      }
      raise ThrowError::Value(e |> identity)
    }
  }
}

///|
/// Wraps a synchronous function call that returns Result, converting any thrown JS errors into JsError
fn throwable_result(f : () -> Result[Any, Any]) -> Result[Any, Any] {
  ffi_wrap_sync(identity(f), Ok(_), Err(_))
}

///|
/// JS: console.log(v)
pub fn[T] log(v : T) -> Unit {
  ffi_console_log([v |> identity]) |> ignore
}

///|
/// JS: console.log(a, b)
pub fn[T, U] log2(a : T, b : U) -> Unit {
  ffi_console_log([a |> identity, b |> identity]) |> ignore
}
