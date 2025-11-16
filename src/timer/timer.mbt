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
#alias(set_timeout)
pub fn setTimeout(f : () -> Unit, duration : Int) -> JsTimer {
  ffi_set_timeout(f, duration)
}

///|
#alias(clear_timeout)
pub fn clearTimeout(timer : JsTimer) -> Unit {
  ffi_clear_timeout(timer)
}

///|
extern "js" fn ffi_set_interval(
  f : () -> Unit noraise,
  duration : Int,
) -> JsTimer =
  #| (f, duration) => setInterval(f, duration)

///|
#alias(set_interval)
pub fn setInterval(f : () -> Unit noraise, duration : Int) -> JsTimer {
  ffi_set_interval(f, duration)
}

///|
#alias(clear_interval)
pub fn clearInterval(timer : JsTimer) -> Unit {
  ffi_clear_timeout(timer)
}
