///|
extern "js" fn ffi_is_nullish(v : Js) -> Bool =
  #|(v) => v === null || v === undefined

///|
pub fn[T : JsImpl] is_nullish(v : T) -> Bool {
  ffi_is_nullish(v.to_js())
}

///|
/// Unsafely cast a value from one type to another.
/// When you cast to `Js`, use `js(v)` or `unsafe_js(v)` instead.
pub fn[A, B] unsafe_cast(v : A) -> B = "%identity"

///|
/// Cast any JsImpl type to a JavaScript Val safely.
/// When you can not, use `unsafe_js()`.
pub fn js(a : &JsImpl) -> Js {
  unsafe_cast(a.to_js())
}

///|
/// Safe cast JsImpl -> Option[Js].
pub fn[T : JsImpl] option_js(a : T) -> Js? {
  if ffi_is_nullish(a |> unsafe_cast) {
    None
  } else {
    Some(unsafe_cast(a.to_js()))
  }
}

///|
/// Convert any MoonBit value to a JavaScript Val.
/// Use `unsafe_js()` if you can
pub fn[T] unsafe_js(v : T) -> Js {
  unsafe_cast(v)
}

///|
/// Safely convert a JavaScript Val to an Option type.
/// Without check, Moonbit FFI will touch (null).toString() and crash.
pub fn[A] unsafe_cast_option(v : Js) -> A? {
  if ffi_is_nullish(v) {
    None
  } else {
    Some(unsafe_cast(v))
  }
}

///|
/// JS: Array.isArray(v)
pub fn[T : JsImpl] is_array(v : T) -> Bool {
  ffi_is_array(v.to_js())
}

///|
/// JS: typeof v === "object" && v !== null && !Array.isArray(v)
pub fn[T : JsImpl] is_object(v : T) -> Bool {
  ffi_is_object(v.to_js())
}

///|
/// JS: v === null
pub fn[T : JsImpl] is_null(v : T) -> Bool {
  ffi_is_null(v.to_js())
}

///|
/// JS: v === undefined
pub fn[T : JsImpl] is_undefined(v : T) -> Bool {
  ffi_is_undefined(v.to_js())
}

///|
pub fn[T : JsImpl] is_builtin_trait(v : T) -> Bool {
  let v : Js = v |> unsafe_cast
  v.hasOwnProperty("self") && v.hasOwnProperty("method_0")
}

///|
/// Conditionally set a property value if the value exists and is not undefined.
/// JS: if (value !== undefined) { o[key] = value; }
///
/// # Example
///
/// ```moonbit
/// let obj = @js.Object::new()
/// set_if_exists(obj, "name", Some("Alice"))     // Sets property
/// set_if_exists(obj, "city", Some(undefined())) // Does nothing
/// ```
pub fn[O : JsImpl, V : JsImpl] set_if_exists(
  o : O,
  key : &PropertyKey,
  value : V?,
) -> Unit {
  guard value is Some(val) else { return }
  let val = val.to_js()
  if is_undefined(val) {
    return
  }
  ffi_set(o.to_js(), key.to_key() |> unsafe_cast, val.to_js())
}

///|
/// Wraps a synchronous function call, converting any thrown JS errors into JsError
/// ```moonbit skip
/// let result = throwable(() => {
///   undefined().call_self([])
/// })
/// ```
pub fn[T] throwable(f : () -> T raise?) -> T raise JsThrowError {
  match throwable_result(f |> unsafe_cast) {
    Ok(result) => result |> unsafe_cast
    Err(e) => {
      if ffi_is_error(e) {
        raise JsThrowError::Error(unsafe_cast(e))
      }
      raise JsThrowError::Value(e |> unsafe_cast)
    }
  }
}

///|
/// Wraps a synchronous function call that returns Result, converting any thrown JS errors into JsError
fn throwable_result(f : () -> Result[Js, Js]) -> Result[Js, Js] {
  ffi_wrap_sync(unsafe_cast(f), Ok(_), Err(_))
}

///|
/// JS: console.log(v)
pub fn[T] log(v : T) -> Unit {
  ffi_console_log([v |> unsafe_cast]) |> ignore
}

///|
/// JS: console.log(a, b)
pub fn[T, U] log2(a : T, b : U) -> Unit {
  ffi_console_log([a |> unsafe_cast, b |> unsafe_cast]) |> ignore
}
