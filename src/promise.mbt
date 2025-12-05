///|
/// JS: Promise.withResolvers()
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/withPromiseResolvers
pub(all) struct PromiseResolvers[T] {
  promise : Promise[T]
  resolve : (T) -> Unit
  reject : (Error) -> Unit
}

///|
/// JS: resolvers.resolve(value)
pub fn[T] PromiseResolvers::resolve(self : Self[T], value : T) -> Unit {
  (self.resolve)(value)
}

///|
/// JS: resolvers.reject(error)
pub fn[T] PromiseResolvers::reject(self : Self[T], error : Error) -> Unit {
  (self.reject)(error)
}

///|
pub fn[R] promisify0(f : async () -> R) -> () -> Promise[R] noraise {
  () => {
    let { promise, resolve, reject } = Promise::withResolvers()
    @core.run_async(async fn() noraise {
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
    @core.run_async(async fn() noraise {
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
    @core.run_async(async fn() noraise {
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
    @core.run_async(async fn() noraise {
      try f(a, b, c) |> resolve catch {
        e => reject(e)
      }
    })
    promise
  }
}
