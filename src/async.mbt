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
    let { promise, resolve, reject } = Promise::withResolvers()
    run_async(() => try f() |> resolve catch {
      e => reject(e)
    })
    promise
  }
}

///|
/// Moonbit Async Function to JS Promise Function
pub fn[A, R] promisify1(f : async (A) -> R) -> (A) -> Promise[R] noraise {
  a => {
    let { promise, resolve, reject } = Promise::withResolvers()
    run_async(() => try f(a) |> resolve catch {
      e => reject(e)
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
    run_async(() => try f(a, b) |> resolve catch {
      e => reject(e)
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
    run_async(() => try f(a, b, c) |> resolve catch {
      e => reject(e)
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
