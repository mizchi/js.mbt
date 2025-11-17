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

///|
extern "js" fn ffi_request_animation_frame(f : () -> Unit) -> Unit =
  #|(f) => {
  #|  if (globalThis.requestAnimationFrame) {
  #|    requestAnimationFrame(f)
  #|  } else {
  #|    setTimeout(f,0) // fallback
  #|  }
  #|}

///|
pub async fn requestAnimationFrame(f : () -> Unit raise) -> Unit noraise {
  suspend(fn(ok, _err) {
    ffi_request_animation_frame(() => {
      f() catch {
        _ => ()
      }
      ok(())
    })
  }) catch {
    _ => ()
  }
}

///|
pub async fn wait_animation_frame() -> Unit noraise {
  suspend((ok, _) => ffi_request_animation_frame(() => ok(()))) catch {
    _ => ()
  }
}

///|
// test "raf" {
//   run_async(() => {
//     let mut cnt = 0
//     let mut f : (async () -> Unit noraise)? = None
//     f = Some(() => {
//       guard f is Some(next)
//       requestAnimationFrame(() => {
//         if cnt >= 5 {
//           f = None
//           return
//         }
//         cnt += 1
//         run_async(next)
//       })
//     })
//     f.unwrap() |> run_async
//   })
// }
