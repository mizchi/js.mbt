///|
/// Promise[T] wrapper for JS Promise
// #external
// pub type Promise[T]

///|
/// MoonBit builtin %async.suspend
pub async fn[T, E : Error] suspend(
  f : ((T) -> Unit, (E) -> Unit) -> Unit,
) -> T raise E = "%async.suspend"

///|
/// MoonBit builtin %async.run
pub fn run_async(f : async () -> Unit noraise) -> Unit = "%async.run"

///| Types

///|
extern "js" fn ffi_promise_resolve(value : Any) -> Any =
  #| (value) => Promise.resolve(value)

///|
extern "js" fn ffi_promise_reject(error : Any) -> Any =
  #| (error) => Promise.reject(error)
  #|

///|
extern "js" fn ffi_promise_then(promise : Any, callback : (Any) -> Any) =
  #| (promise, callback) => promise.then(callback)

///|
extern "js" fn ffi_promise_all(promises : Array[Promise[Any]]) -> Promise[Any] =
  #| (promises) => Promise.all(promises)

///|
extern "js" fn ffi_promise_race(promises : Array[Promise[Any]]) -> Promise[Any] =
  #| (promises) => Promise.race(promises)

///|
extern "js" fn ffi_promise_any(promises : Array[Promise[Any]]) -> Promise[Any] =
  #| (promises) => Promise.any(promises)

///|
extern "js" fn ffi_new_promise(
  executor : ((Any) -> Unit, (Any) -> Unit) -> Unit,
) -> Promise[Any] =
  #| (executor) => new Promise(executor)

///|
extern "js" fn ffi_promise_with_resolvers() -> Any =
  #| () => Promise.withResolvers()

///| Symbols

///| Global Functions

// ///|
// extern "js" fn ffi_json_stringify(
//   value : Any,
//   replacer : Any,
//   space : Any,
// ) -> String =
//   #| (value, replacer, space) => JSON.stringify(value, replacer, space)

// ///|
// extern "js" fn ffi_json_parse(json : String, reviver? : Any) -> Any =
//   #| (json, reviver) => JSON.parse(json, reviver)

///| Timers

///|
/// Await a JS Promise, returning the resolved value
// pub async fn[T] Promise::wait(self : Promise[T]) -> T {
//   suspend(fn(resolve, reject) {
//     let p : Any = self |> identity
//     p._call("then", [any(resolve)]) |> ignore
//     p._call("catch", [any(reject)]) |> ignore
//   })
// }

///|
/// Create a new Promise from executor function (internal, untyped)
// extern "js" fn promise_new(
//   executor : ((Any) -> Unit, (Any) -> Unit) -> Unit,
// ) -> Any =
//   #| (executor) => new Promise(executor)

///|
/// Create a new Promise from executor function
/// Usage: Promise::new(fn(resolve, reject) { ... })
// pub fn[T] Promise::new(
//   executor : ((T) -> Unit, (Any) -> Unit) -> Unit,
// ) -> Promise[T] {
//   let typed_executor : ((Any) -> Unit, (Any) -> Unit) -> Unit = fn(
//     resolve,
//     reject,
//   ) {
//     let typed_resolve : (T) -> Unit = fn(v) { resolve(any(v)) }
//     executor(typed_resolve, reject)
//   }
//   promise_new(typed_executor) |> identity
// }

// ///|
// /// Create a Promise from an async function
// /// Usage: Promise::async_fn(async fn() { ... })
// pub fn[T] Promise::async_fn(f : async () -> T noraise) -> Promise[T] {
//   Promise::new(fn(resolve, _reject) {
//     run_async(async fn() noraise {
//       let result = f()
//       resolve(result)
//     })
//   })
// }

// ///|
// /// Promise.resolve(value) - create resolved promise
// pub fn[T] Promise::resolve(value : T) -> Promise[T] {
//   Promise::new(fn(resolve, _reject) { resolve(value) })
// }

// ///|
// /// Promise.reject(error) - create rejected promise
// pub fn Promise::reject(error : Any) -> Promise[Any] {
//   Promise::new(fn(_resolve, reject) { reject(error) })
// }

///|
/// JavaScript Promise[T]
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise
#external
pub type Promise[T]

///|
pub fn[T] Promise::to_any(self : Promise[T]) -> Any = "%identity"

///|
/// JS: new Promise((resolve, reject) => { ... })
/// Create a Promise from an async executor function with resolve/reject callbacks.
/// ```moonbit no-check
/// let p : Promise[Int] = Promise::new(async fn(resolve, _reject) {
///   let result = some_async_operation()
///   resolve(result)
/// })
/// ```
pub fn[A] Promise::new(
  f : async ((A) -> Unit, (Error) -> Unit) -> Unit,
) -> Promise[A] {
  ffi_new_promise(fn(resolve, reject) {
    run_async(fn() {
      f(a => a |> identity |> resolve, e => e |> identity |> reject) catch {
        e => e |> identity |> reject
      }
    })
  })
  |> identity
}

///|
/// Convert an async function to a Promise.
/// ```moonbit no-check
/// let p : Promise[Int] = Promise::from_async(async fn() {
///   let result = some_async_operation()
///   result
/// })
/// ```
pub fn[A] Promise::from_async(f : async () -> A) -> Promise[A] noraise {
  let { promise, resolve, reject } = Promise::withResolvers()
  run_async(fn() {
    try f() |> resolve catch {
      e => reject(e)
    }
  })
  promise
}

///|
/// js: Promise.resolve(value)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/resolve
pub fn[A] Promise::resolve(x : A) -> Self[A] {
  ffi_promise_resolve(identity(x)) |> identity
}

///|
/// js: Promise.reject(error)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/reject
pub fn Promise::reject(x : Any) -> Self[Any] {
  ffi_promise_reject(identity(x)) |> identity
}

///|
pub fn[A, B] Promise::then(
  self : Self[A],
  resolve : (A) -> Self[B] raise,
) -> Promise[B] {
  ffi_promise_then(self.to_any() |> identity, a => (a
  |> identity
  |> resolve
  |> identity) catch {
    e => e |> identity |> ffi_promise_reject |> identity
  })
  |> identity
}

///|
pub fn[A, B] Promise::catch_(
  self : Self[A],
  f : (Error) -> Promise[B],
) -> Promise[B] {
  self.to_any()._call("catch", [any(from_fn1(f))]).cast()
}

///|
/// JS: promise.finally(() => { ... })
pub fn[A] Promise::finally_(self : Self[A], f : () -> Unit) -> Self[A] {
  self.to_any()._call("finally", [any(from_fn0(f))]).cast()
}

///|
/// JS: await promise
/// Waits for the Promise to be resolved or rejected.
pub async fn[T] Promise::wait(self : Self[T]) -> T {
  suspend((ok, err) => self
    .to_any()
    ._call("then", [any(from_fn1(ok))])
    ._call("catch", [any(from_fn1(err))])
    |> ignore)
}

///|
/// JS: Promise.all(promises)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/all
/// ```moonbit no-check
/// let results = Promise::all([
///   Promise::from_async(async fn() { fetch_user() }),
///   Promise::from_async(async fn() { fetch_posts() }),
/// ]).wait()
/// ```
pub fn[A] Promise::all(promises : Array[Promise[A]]) -> Promise[Array[A]] {
  ffi_promise_all(promises |> identity) |> identity
}

///|
/// JS: Promise.race(promises)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/race
/// ```moonbit no-check
/// let first = Promise::race([
///   Promise::from_async(async fn() {
///     sleep(100)
///     "slow"
///   }),
///   Promise::from_async(async fn() {
///     sleep(10)
///     "fast"
///   }),
/// ]).wait() // "fast"
/// ```
pub fn[T] Promise::race(promises : Array[Promise[T]]) -> Promise[T] {
  ffi_promise_race(promises |> identity) |> identity
}

///|
/// JS: Promise.any(promises)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/any
/// ```moonbit no-check
/// let first_success = Promise::any([
///   Promise::from_async(async fn() { fetch_from_mirror1() }),
///   Promise::from_async(async fn() { fetch_from_mirror2() }),
/// ]).wait()
/// ```
pub fn[T] Promise::any(promises : Array[Promise[T]]) -> Promise[T] {
  ffi_promise_any(promises |> identity) |> identity
}

///|
/// Result type for Promise.allSettled
pub(all) struct SettledResult[T] {
  status : String // "fulfilled" | "rejected"
  value : T?
  reason : Nullable[Any]
}

///|
pub fn[T] SettledResult::to_any(self : SettledResult[T]) -> Any = "%identity"

///|
/// JS: Promise.allSettled(promises)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/allSettled
/// ```moonbit no-check
/// let results = Promise::allSettled([
///   Promise::from_async(async fn() { 1 }),
///   Promise::from_async(async fn() { fail("error") }),
/// ]).wait()
/// // results[0].status == "fulfilled", results[0].value == Some(1)
/// // results[1].status == "rejected", results[1].reason != null
/// ```
pub fn[A] Promise::allSettled(
  promises : Array[Promise[A]],
) -> Promise[Array[SettledResult[A]]] {
  ffi_promise_all(promises |> identity) |> identity
}

///|
/// JS: Promise.withResolvers()
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/withPromiseResolvers
pub(all) struct PromiseResolvers[T] {
  promise : Promise[T]
  resolve : (T) -> Unit
  reject : (Error) -> Unit
}

///|
/// JS: Promise.withResolvers()
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/withPromiseResolvers
pub fn[T] Promise::withResolvers() -> PromiseResolvers[T] {
  ffi_promise_with_resolvers() |> identity
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
/// Async dispose (Symbol.asyncDispose)
/// Usage: defer value |> dispose_async
// pub async fn dispose_async(value : Any) -> Unit {
//   let dispose_fn : Any = value._get(@symbol.Symbol::asyncDispose() |> identity)
//   let promise : Promise[Unit] = Any::_invoke(dispose_fn, []) |> identity
//   promise.wait()
// }
