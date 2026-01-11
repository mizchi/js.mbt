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
pub async fn wait_animation_frame() -> Unit noraise {
  @js.suspend((ok, _) => ffi_request_animation_frame(() => ok(()))) catch {
    _ => ()
  }
}
