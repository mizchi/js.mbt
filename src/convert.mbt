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

///|
pub fn[T] is_builtin_trait(v : T) -> Bool {
  let v = @core.any(v)
  ffi_has_own_property(v.cast(), "self") &&
  ffi_has_own_property(v.cast(), "method_0")
}

///|
/// Wraps a synchronous function call, converting any thrown JS errors into ThrowError
/// ```moonbit skip
/// let result = throwable(() => undefined()._invoke([]))
/// ```
pub fn[T] throwable(f : () -> T raise?) -> T raise ThrowError {
  match throwable_result(f |> @core.identity) {
    Ok(result) => result |> @core.identity
    Err(e) => raise ThrowError(e |> @core.identity)
  }
}

///|
/// Wraps a synchronous function call that returns Result, converting any thrown JS errors into JsError
fn throwable_result(f : () -> Result[Any, Any]) -> Result[Any, Any] {
  ffi_wrap_sync(@core.identity(f), Ok(_), Err(_))
}

///|
/// JS: console.log(v)
pub fn[T] log(v : T) -> Unit {
  ffi_console_log([v |> @core.identity]) |> ignore
}

///|
/// JS: console.log(a, b)
pub fn[T, U] log2(a : T, b : U) -> Unit {
  ffi_console_log([a |> @core.identity, b |> @core.identity]) |> ignore
}
