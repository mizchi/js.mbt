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
pub async fn request_animation_frame(f : () -> Unit raise) -> Unit noraise {
  @js.suspend(fn(ok, _err) {
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
pub async fn wait_animation_frames() -> Unit noraise {
  @js.suspend((ok, _) => ffi_request_animation_frame(() => ok(()))) catch {
    _ => ()
  }
}

///|
test "raf" {
  @js.run_async(() => {
    let mut f : (async () -> Unit noraise)? = None
    let mut cnt = 0
    f = Some(() => {
      guard f is Some(next)
      request_animation_frame(() => {
        if cnt >= 5 {
          f = None
          return
        }
        cnt += 1
        @js.run_async(next)
      })
    })
    f.unwrap() |> @js.run_async
  })
}
