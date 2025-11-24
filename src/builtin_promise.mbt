///|
/// JavaScript Promise[T]
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise
#external
pub type Promise[T]

///|
impl[T] JsImpl for Promise[T]

///|
/// JS: Promise.new((resolve, reject) => { ... })
/// ```
/// let _p: Promise[Int] = Promise::new((resolve, _reject) => {
///    resolve(10)
/// })
/// ```
pub fn[A] Promise::new(
  f : ((A) -> Unit, (Error) -> Unit) -> Unit,
) -> Promise[A] {
  ffi_new_promise(fn(resolve, reject) {
    f(a => a |> identity |> resolve, e => e |> identity |> reject)
  })
  |> identity
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
pub fn Promise::reject(x : Js) -> Self[Js] {
  ffi_promise_reject(identity(x)) |> identity
}

///|
pub fn[A, B] Promise::then(
  self : Self[A],
  resolve : (A) -> Self[B] raise,
) -> Promise[B] {
  ffi_promise_then(self.to_js(), a => (a |> identity |> resolve |> identity) catch {
    e => e |> ffi_promise_reject |> identity
  })
  |> identity
}

///|
pub fn[A, B] Promise::catch_(
  self : Self[A],
  f : (Error) -> Promise[B],
) -> Promise[B] {
  self.call("catch", [from_fn1(f)]) |> identity
}

///|
/// JS: promise.finally(() => { ... })
pub fn[A] Promise::finally_(self : Self[A], f : () -> Unit) -> Self[A] {
  self.call("finally", [from_fn0(f)]) |> identity
}

///|
/// JS: await promise
/// Waits for the Promise to be resolved or rejected.
pub async fn[T] Promise::wait(self : Self[T]) -> T {
  suspend((ok, err) => self
    .call("then", [from_fn1(ok)])
    .call("catch", [from_fn1(err)])
    |> ignore)
}

///|
/// JS: Promise.all(promises)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/all
pub fn[A] Promise::all(promises : Array[Promise[A]]) -> Promise[Array[A]] {
  ffi_promise_all(promises |> identity) |> identity
}

///|
/// JS: Promise.race(promises)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/race
pub fn[T] Promise::race(promises : Array[Promise[T]]) -> Promise[T] {
  ffi_promise_race(promises |> identity) |> identity
}

///|
/// JS: Promise.any(promises)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/any
pub fn[T] Promise::any(promises : Array[Promise[T]]) -> Promise[T] {
  ffi_promise_any(promises |> identity) |> identity
}

///|
/// Result type for Promise.allSettled
pub(all) struct SettledResult[T] {
  status : String // "fulfilled" | "rejected"
  value : T?
  reason : Nullable[Js]
}

///|
pub impl[T] JsImpl for SettledResult[T]

///|
/// JS: Promise.allSettled(promises)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/allSettled
pub fn[A] Promise::allSettled(
  promises : Array[Promise[A]],
) -> Promise[Array[SettledResult[A]]] {
  ffi_promise_all(promises |> identity) |> identity
}

///|
/// Converts an async raise function to a Promise.
/// ```moonbit nocheck
/// let p = Promise::try_(async fn () { 42 })
/// // Promise resolves to 42
///
/// let p2 = Promise::try_(async fn () { fail("error") })
/// // Promise rejects with error
/// ```
pub fn[R] Promise::try_(f : async () -> R) -> Promise[R] noraise {
  let { promise, resolve, reject } = Promise::withResolvers()
  run_async(() => try f() |> resolve catch {
    e => reject(e)
  })
  promise
}

///|
/// JS: Promise.withResolvers()
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/withResolvers
pub(all) struct Resolvers[T] {
  promise : Promise[T]
  resolve : (T) -> Unit
  reject : (Error) -> Unit
}

///|
/// JS: Promise.withResolvers()
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise/withResolvers
pub fn[T] Promise::withResolvers() -> Resolvers[T] {
  ffi_promise_with_resolvers() |> identity
}

///|
/// JS: resolvers.resolve(value)
pub fn[T] Resolvers::resolve(self : Self[T], value : T) -> Unit {
  (self.resolve)(value)
}

///|
/// JS: resolvers.reject(error)
pub fn[T] Resolvers::reject(self : Self[T], error : Error) -> Unit {
  (self.reject)(error)
}
