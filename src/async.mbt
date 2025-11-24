///|
/// Moonbit builtin %async.suspend
pub async fn[T, E : Error] suspend(
  f : ((T) -> Unit, (E) -> Unit) -> Unit,
) -> T raise E = "%async.suspend"

///|
/// Moonbit builtin %async.run
pub fn run_async(f : async () -> Unit noraise) -> Unit = "%async.run"

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
