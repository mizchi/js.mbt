///|
/// Moonbit builtin %async.suspend
pub async fn[T, E : Error] suspend(
  f : ((T) -> Unit, (E) -> Unit) -> Unit,
) -> T raise E = "%async.suspend"

///|
/// Moonbit builtin %async.run
pub fn run_async(f : async () -> Unit noraise) -> Unit = "%async.run"

///|
/// Run a cancellable promise with automatic AbortController management
///
/// This is a convenient helper from moonbitlang/async/js_async that:
/// - Creates a fresh AbortController
/// - Passes its signal to your function
/// - Waits for the promise to resolve
/// - Activates the abort signal if the operation is cancelled
///
/// Example:
/// ```moonbit no-check
/// async fn fetch_data() -> String {
///   run_promise(abort_signal => {
///     // Your promise that supports AbortSignal
///     fetch_with_abort(url, abort_signal)
///   })
/// }
/// ```
pub async fn[X] run_promise(f : (AbortSignal) -> Promise[X]) -> X {
  @js_async.run_promise((signal : @js_async.AbortSignal) => {
    let converted_signal : AbortSignal = identity(signal)
    let promise : Promise[X] = f(converted_signal)
    identity(promise)
  })
}

///|
/// Moonbit Async Function to JS Promise Function
pub fn[R] promisify0(f : async () -> R) -> () -> Promise[R] noraise {
  () => {
    let { promise, resolve, reject } = Promise::withResolvers()
    run_async(async fn() noraise {
      try f() |> resolve catch {
        e => reject(e)
      }
    })
    promise
  }
}

///|
/// Moonbit Async Function to JS Promise Function
pub fn[A, R] promisify1(f : async (A) -> R) -> (A) -> Promise[R] noraise {
  a => {
    let { promise, resolve, reject } = Promise::withResolvers()
    run_async(async fn() noraise {
      try f(a) |> resolve catch {
        e => reject(e)
      }
    })
    promise
  }
}

///|
/// Moonbit Async Function to JS Promise Function
pub fn[A, B, R] promisify2(
  f : async (A, B) -> R,
) -> (A, B) -> Promise[R] noraise {
  (a, b) => {
    let { promise, resolve, reject } = Promise::withResolvers()
    run_async(async fn() noraise {
      try f(a, b) |> resolve catch {
        e => reject(e)
      }
    })
    promise
  }
}

///|
/// Moonbit Async Function to JS Promise Function
pub fn[A, B, C, R] promisify3(
  f : async (A, B, C) -> R,
) -> (A, B, C) -> Promise[R] noraise {
  (a, b, c) => {
    let { promise, resolve, reject } = Promise::withResolvers()
    run_async(async fn() noraise {
      try f(a, b, c) |> resolve catch {
        e => reject(e)
      }
    })
    promise
  }
}

///|
/// Sleep for given milliseconds
extern "js" fn ffi_sleep(ms : Int) -> Promise[Unit] =
  #| (ms) => new Promise((resolve) => setTimeout(resolve, ms))

///|
pub async fn sleep(ms : Int) -> Unit noraise {
  ffi_sleep(ms).wait() catch {
    _ => panic()
  }
}

///|
/// Convert a callback-based async operation using suspend
///
/// This allows you to convert Node.js-style callback-based APIs
/// into async/await style without sleep polling.
///
/// Example:
/// ```moonbit no-check
/// async test "wait for server" {
///   let server = createServer()
///   defer server.close() |> ignore
///
///   // Instead of sleep, use from_callback
///   from_callback(fn(resolve) {
///     server.listen(port, host, callback=fn() { resolve() })
///   }) catch { _ => () }
///
///   // Server is now listening
///   inspect(server.listening(), content="true")
/// }
/// ```
pub async fn[T] from_callback(f : ((T) -> Unit) -> Unit) -> T raise Error {
  suspend(fn(resolve, _reject) { f(resolve) })
}
