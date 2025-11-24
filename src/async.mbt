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
  @js_async.run_promise(
    (signal : @js_async.AbortSignal) => {
      let converted_signal : AbortSignal = unsafe_cast(signal)
      let promise : Promise[X] = f(converted_signal)
      unsafe_cast(promise)
    },
  )
}

///|
/// Moonbit Async Function to JS Promise Function
pub fn[R] promisify0(f : async () -> R) -> () -> Promise[R] noraise {
  () => {
    // Use moonbitlang/async/js_async for better async support
    @js_async.Promise::from_async(f) |> unsafe_cast
  }
}

///|
/// Moonbit Async Function to JS Promise Function
pub fn[A, R] promisify1(f : async (A) -> R) -> (A) -> Promise[R] noraise {
  a => {
    // Use moonbitlang/async/js_async for better async support
    @js_async.Promise::from_async(async fn() { f(a) }) |> unsafe_cast
  }
}

///|
/// Moonbit Async Function to JS Promise Function
pub fn[A, B, R] promisify2(
  f : async (A, B) -> R,
) -> (A, B) -> Promise[R] noraise {
  (a, b) => {
    // Use moonbitlang/async/js_async for better async support
    @js_async.Promise::from_async(async fn() { f(a, b) }) |> unsafe_cast
  }
}

///|
/// Moonbit Async Function to JS Promise Function
pub fn[A, B, C, R] promisify3(
  f : async (A, B, C) -> R,
) -> (A, B, C) -> Promise[R] noraise {
  (a, b, c) => {
    // Use moonbitlang/async/js_async for better async support
    @js_async.Promise::from_async(async fn() { f(a, b, c) }) |> unsafe_cast
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
