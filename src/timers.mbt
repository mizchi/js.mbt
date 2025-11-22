///| Timers

///|
/// JS: setTimeout(f, duration)
#alias(set_timeout)
pub fn setTimeout(f : () -> Unit, duration : Int) -> JsTimer {
  ffi_set_timeout(f, duration)
}

///|
/// JS: clearTimeout(timer)
#alias(clear_timeout)
pub fn clearTimeout(timer : JsTimer) -> Unit {
  ffi_clear_timeout(timer)
}

///|
/// JS: setInterval(f, duration)
#alias(set_interval)
pub fn setInterval(f : () -> Unit, duration : Int) -> JsTimer {
  ffi_set_interval(f, duration)
}

///|
/// JS: clearInterval(timer)
#alias(clear_interval)
pub fn clearInterval(timer : JsTimer) -> Unit {
  ffi_clear_timeout(timer)
}
