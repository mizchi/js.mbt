///|
/// Promise[T] wrapper for JS Promise
#external
pub type Promise[T]

///|
/// MoonBit builtin %async.suspend
pub async fn[T, E : Error] suspend(
  f : ((T) -> Unit, (E) -> Unit) -> Unit,
) -> T raise E = "%async.suspend"

///|
/// MoonBit builtin %async.run
pub fn run_async(f : async () -> Unit noraise) -> Unit = "%async.run"

///|
/// Await a JS Promise, returning the resolved value
pub async fn[T] Promise::wait(self : Promise[T]) -> T {
  suspend(fn(resolve, reject) {
    let p : Any = self |> identity
    p._call("then", [any(resolve)]) |> ignore
    p._call("catch", [any(reject)]) |> ignore
  })
}

///|
/// Create a new Promise from executor function (internal, untyped)
extern "js" fn promise_new(
  executor : ((Any) -> Unit, (Any) -> Unit) -> Unit,
) -> Any =
  #| (executor) => new Promise(executor)

///|
/// Create a new Promise from executor function
/// Usage: Promise::new(fn(resolve, reject) { ... })
pub fn[T] Promise::new(
  executor : ((T) -> Unit, (Any) -> Unit) -> Unit,
) -> Promise[T] {
  let typed_executor : ((Any) -> Unit, (Any) -> Unit) -> Unit = fn(
    resolve,
    reject,
  ) {
    let typed_resolve : (T) -> Unit = fn(v) { resolve(any(v)) }
    executor(typed_resolve, reject)
  }
  promise_new(typed_executor) |> identity
}

///|
/// Create a Promise from an async function
/// Usage: Promise::async_fn(async fn() { ... })
pub fn[T] Promise::async_fn(f : async () -> T noraise) -> Promise[T] {
  Promise::new(fn(resolve, _reject) {
    run_async(async fn() noraise {
      let result = f()
      resolve(result)
    })
  })
}

///|
/// Promise.resolve(value) - create resolved promise
pub fn[T] Promise::resolve(value : T) -> Promise[T] {
  Promise::new(fn(resolve, _reject) { resolve(value) })
}

///|
/// Promise.reject(error) - create rejected promise
pub fn Promise::reject(error : Any) -> Promise[Any] {
  Promise::new(fn(_resolve, reject) { reject(error) })
}
