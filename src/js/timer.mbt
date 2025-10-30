///|
#external
pub type JSTimer

///|
extern "js" fn ffi_set_timeout(f : () -> Unit, duration : Int) -> JSTimer =
  #| (f, duration) => setTimeout(f, duration)

///|
extern "js" fn ffi_clear_timeout(timer : JSTimer) -> Unit =
  #| (timer) => clearTimeout(timer)

///|
pub fn set_timeout(f : () -> Unit, duration : Int) -> JSTimer {
  ffi_set_timeout(f, duration)
}

///|
pub fn clear_timeout(timer : JSTimer) -> Unit {
  ffi_clear_timeout(timer)
}

///|
extern "js" fn ffi_set_interval(
  f : () -> Unit noraise,
  duration : Int,
) -> JSTimer =
  #| (f, duration) => setInterval(f, duration)

///|
pub fn set_interval(f : () -> Unit noraise, duration : Int) -> JSTimer {
  ffi_set_interval(f, duration)
}

///|
pub fn clear_interval(timer : JSTimer) -> Unit {
  ffi_clear_timeout(timer)
}

///|
/// Sleeps for the specified duration.
pub async fn sleep(duration : Int) -> Unit noraise {
  suspend((ok, _) => {
    ffi_set_timeout(() => ok(()), duration) |> ignore
  }) catch {
    _ => ()
  }
}
