///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
#external
pub type Promise[T]

///|
impl[T] Js for Promise[T] with to_js(self) -> Val {
  self |> js
}

///|
pub async fn[T, E : Error] suspend(
  f : ((T) -> Unit, (E) -> Unit) -> Unit,
) -> T raise E = "%async.suspend"

///|
pub fn run_async(f : async () -> Unit noraise) -> Unit = "%async.run"

///|
/// js: Promise.new((resolve, reject) => { ... })
/// ```
/// let p: Promise[Int] = Promise::new((resolve, reject) => {
///    resolve(10)
/// })
/// ```
pub fn[A] Promise::new(
  f : ((A) -> Unit, (Error) -> Unit) -> Unit,
) -> Promise[A] {
  ffi_new_promise(fn(resolve, reject) {
    f(a => a |> unsafe_cast |> resolve, e => e |> unsafe_cast |> reject)
  })
  |> unsafe_cast
}

///|
/// js: Promise.resolve(value)
pub fn[A] Promise::resolve(x : A) -> Self[A] {
  ffi_promise_resolve(unsafe_cast(x)) |> unsafe_cast
}

///|
/// js: Promise.reject(error)
pub fn Promise::reject(x : Val) -> Self[Val] {
  ffi_promise_reject(unsafe_cast(x)) |> unsafe_cast
}

///|
pub fn[A, B] Promise::then(
  self : Promise[A],
  resolve : (A) -> Promise[B] raise,
) -> Promise[B] {
  ffi_promise_then(self.to_js(), a => (a
  |> unsafe_cast
  |> resolve
  |> unsafe_cast) catch {
    e => e |> ffi_promise_reject |> unsafe_cast
  })
  |> unsafe_cast
}

///|
pub fn[A, B] Promise::catch_(
  self : Self[A],
  f : (Error) -> Promise[B],
) -> Promise[B] {
  self.to_js().invoke("catch", [js(f)]).cast()
}

///|
pub fn[A] Promise::finally_(self : Self[A], f : () -> Unit) -> Self[A] {
  self.to_js().invoke("finally", [js(f)]).cast()
}

///|
/// Waits for the Promise to be resolved or rejected.
pub async fn[A] Promise::unwrap(self : Self[A]) -> A {
  suspend((ok, err) => self
    .to_js()
    .invoke("then", [js(ok)])
    .invoke("catch", [js(err)])
    |> ignore)
}

///|
pub fn[A] Promise::all(promises : Array[Promise[A]]) -> Promise[Array[A]] {
  ffi_promise_all(promises |> unsafe_cast) |> unsafe_cast
}

///|
pub fn[A] Promise::race(promises : Array[Promise[A]]) -> Promise[A] {
  ffi_promise_race(promises |> unsafe_cast) |> unsafe_cast
}

///|
pub(all) struct Resolvers[T] {
  promise : Promise[T]
  resolve : (T) -> Unit
  reject : (Error) -> Unit
}

///|
/// Creates a deferred Promise along with its resolve and reject functions.
/// ```
/// run_async(() => {
///   let {promise, resolve, reject} = Promise::with_resolvers()
///   let f = async fn () noraise {
///     resolve(10)
///   }
///   f()
///   let v: Int = promise.unwrap() catch { _ => 0 }
/// })
/// ```
pub fn[T] Promise::with_resolvers() -> Resolvers[T] {
  ffi_promise_with_resolvers() |> unsafe_cast
}

///|
pub fn[R] promisify0(f : async () -> R) -> () -> Promise[R] noraise {
  () => {
    let { promise, resolve, reject } = Promise::with_resolvers()
    run_async(() => try f() |> resolve catch {
      e => reject(e)
    })
    promise
  }
}

///|
pub fn[A, R] promisify1(f : async (A) -> R) -> (A) -> Promise[R] noraise {
  fn(a) {
    let { promise, resolve, reject } = Promise::with_resolvers()
    run_async(() => try f(a) |> resolve catch {
      e => reject(e)
    })
    promise
  }
}

///|
pub fn[A, B, R] promisify2(
  f : async (A, B) -> R,
) -> (A, B) -> Promise[R] noraise {
  (a, b) => {
    let { promise, resolve, reject } = Promise::with_resolvers()
    run_async(() => try f(a, b) |> resolve catch {
      e => reject(e)
    })
    promise
  }
}

///|
pub fn[A, B, C, R] promisify3(
  f : async (A, B, C) -> R,
) -> (A, B, C) -> Promise[R] noraise {
  (a, b, c) => {
    let { promise, resolve, reject } = Promise::with_resolvers()
    run_async(() => try f(a, b, c) |> resolve catch {
      e => reject(e)
    })
    promise
  }
}

///|
/// Converts an async raise function to a Promise.
///
/// Executes the provided async function and returns a Promise that:
/// - Resolves with the function's return value if it succeeds
/// - Rejects with the error if the function raises an error
///
/// # Parameters
///
/// - `f`: An async function that may raise an error
///
/// # Returns
///
/// A Promise that represents the result of the async operation
///
/// # Example
///
/// ```moonbit
/// let p = Promise::try_(async fn () { 42 })
/// // Promise resolves to 42
///
/// let p2 = Promise::try_(async fn () { fail("error") })
/// // Promise rejects with error
/// ```
pub fn[R] Promise::try_(f : async () -> R) -> Promise[R] noraise {
  let { promise, resolve, reject } = Promise::with_resolvers()
  run_async(() => try f() |> resolve catch {
    e => reject(e)
  })
  promise
}
