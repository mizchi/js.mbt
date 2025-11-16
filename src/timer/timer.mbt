///|
#external
pub type JsTimer

///|
extern "js" fn ffi_set_timeout(f : () -> Unit, duration : Int) -> JsTimer =
  #| (f, duration) => setTimeout(f, duration)

///|
extern "js" fn ffi_clear_timeout(timer : JsTimer) -> Unit =
  #| (timer) => clearTimeout(timer)

///|
pub fn set_timeout(f : () -> Unit, duration : Int) -> JsTimer {
  ffi_set_timeout(f, duration)
}

///|
pub fn clear_timeout(timer : JsTimer) -> Unit {
  ffi_clear_timeout(timer)
}

///|
extern "js" fn ffi_set_interval(
  f : () -> Unit noraise,
  duration : Int,
) -> JsTimer =
  #| (f, duration) => setInterval(f, duration)

///|
pub fn set_interval(f : () -> Unit noraise, duration : Int) -> JsTimer {
  ffi_set_interval(f, duration)
}

///|
pub fn clear_interval(timer : JsTimer) -> Unit {
  ffi_clear_timeout(timer)
}
