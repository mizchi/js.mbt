///|
extern "js" fn ffi_console_log(value : Value) -> Unit =
  #| console.log

///|
extern "js" fn ffi_console_warn(value : Value) -> Unit =
  #| console.warn

///|
extern "js" fn ffi_console_error(value : Value) -> Unit =
  #| console.error

///|
extern "js" fn ffi_console_info(value : Value) -> Unit =
  #| console.info

///|
pub fn[T] console_log(v : T) -> Unit {
  v |> to_js |> ffi_console_log
}

///|
pub fn[T] console_error(v : T) -> Unit {
  v |> to_js |> ffi_console_error
}

///|
pub fn[T] console_info(v : T) -> Unit {
  v |> to_js |> ffi_console_info
}

///|
pub fn[T] console_warn(v : T) -> Unit {
  v |> identity |> ffi_console_warn
}

///|
pub fnalias console_log as log

///|
pub fn[T1, T2] log2(v1 : T1, v2 : T2) -> Unit {
  console_log([to_js(v1), to_js(v2)])
}
///|
pub fn[T1, T2, T3] log3(v1 : T1, v2 : T2, v3 : T3) -> Unit {
  console_log([to_js(v1), to_js(v2), to_js(v3)])
}