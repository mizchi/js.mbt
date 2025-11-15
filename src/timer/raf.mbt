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
test "raf" {
  run_async(() => {
    let mut cnt = 0
    let mut f : (async () -> Unit noraise)? = None
    f = Some(() => {
      guard f is Some(next)
      request_animation_frame(() => {
        if cnt >= 5 {
          f = None
          return
        }
        cnt += 1
        run_async(next)
      })
    })
    f.unwrap() |> run_async
  })
}
