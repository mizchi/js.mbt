///|
extern "js" fn ffi_wrap_fn(
  f : Val,
  ok : (Val) -> Unit,
  err : (Val) -> Unit,
) -> Unit =
  #|(f, ok, err) => {
  #|  try {
  #|    ok(f())
  #|  } catch(e) {
  #|    err(e)
  #|  }
  #|}

///|
#inline
fn[T] wrap_fn_sync(f : () -> T) -> T raise {
  let mut v : Result[T, Val] = Err(undefined())
  let ok = r => v = Ok(r |> unsafe_cast)
  let err = e => v = Err(e)
  ffi_wrap_fn(unsafe_cast(f), ok, err)
  match v {
    Ok(result) => result
    Err(e) => raise JsError(e |> unsafe_cast)
  }
}
