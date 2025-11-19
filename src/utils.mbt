///|
/// JS: v.propertyIsEnumerable(k)
pub fn[T : JsImpl] propertyIsEnumerable(v : T, k : String) -> Bool {
  ffi_property_is_enumerable(v.to_js(), k)
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
///   undefined().invoke_self([])
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
/// Log a value to the console (JavaScript console.log).
///
/// This is a convenience function for debugging.
///
/// # Example
///
/// ```moonbit skip
/// log("Hello, World!")
/// log(42)
/// log([1, 2, 3])
/// ```
pub fn[T] log(v : T) -> Unit {
  ffi_console_log([v |> unsafe_cast]) |> ignore
}

///|
pub fn[T, U] log2(v : T, u : U) -> Unit {
  ffi_console_log([v |> unsafe_cast, u |> unsafe_cast]) |> ignore
}
