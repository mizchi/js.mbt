// JavaScript Timer functions
// https://developer.mozilla.org/en-US/docs/Web/API/Window/setTimeout

///|
/// Timer handle returned by setTimeout/setInterval
#external
pub type Timer

///|
pub fn Timer::as_any(self : Timer) -> @nostd.Any = "%identity"

///|
extern "js" fn ffi_set_timeout(f : () -> Unit, duration : Int) -> Timer =
  #| (f, duration) => setTimeout(f, duration)

///|
extern "js" fn ffi_clear_timeout(timer : Timer) -> Unit =
  #| (timer) => clearTimeout(timer)

///|
extern "js" fn ffi_set_interval(f : () -> Unit, duration : Int) -> Timer =
  #| (f, duration) => setInterval(f, duration)

///|
extern "js" fn ffi_clear_interval(timer : Timer) -> Unit =
  #| (timer) => clearInterval(timer)

///|
extern "js" fn ffi_queue_microtask(callback : () -> Unit) -> Unit =
  #| (callback) => queueMicrotask(callback)

///|
/// JS: setTimeout(f, duration)
///
/// Schedules a function to be called after a specified delay (in milliseconds).
/// Returns a Timer that can be used to cancel the scheduled execution.
pub fn set_timeout(f : () -> Unit, duration : Int) -> Timer {
  ffi_set_timeout(f, duration)
}

///|
/// JS: clearTimeout(timer)
///
/// Cancels a timeout previously established by calling setTimeout().
pub fn clear_timeout(timer : Timer) -> Unit {
  ffi_clear_timeout(timer)
}

///|
/// JS: setInterval(f, duration)
///
/// Repeatedly calls a function with a fixed time delay between each call.
/// Returns a Timer that can be used to cancel the interval.
pub fn set_interval(f : () -> Unit, duration : Int) -> Timer {
  ffi_set_interval(f, duration)
}

///|
/// JS: clearInterval(timer)
///
/// Cancels an interval previously established by calling setInterval().
pub fn clear_interval(timer : Timer) -> Unit {
  ffi_clear_interval(timer)
}

///|
/// JS: queueMicrotask(callback)
///
/// Queue a microtask to be executed after the current task finishes.
/// Microtasks are executed before the next task in the event loop.
pub fn queue_microtask(callback : () -> Unit) -> Unit {
  ffi_queue_microtask(callback)
}
