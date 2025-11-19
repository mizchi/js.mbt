///|
/// JavaScript Promise[T]
#external
pub type Promise[T]

///|
impl[T] JsImpl for Promise[T]

///|
/// JS: Promise.new((resolve, reject) => { ... })
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
pub fn Promise::reject(x : Js) -> Self[Js] {
  ffi_promise_reject(unsafe_cast(x)) |> unsafe_cast
}

///|
pub fn[A, B] Promise::then(
  self : Self[A],
  resolve : (A) -> Self[B] raise,
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
  self.call("catch", [@js.from_fn1(f)]) |> unsafe_cast
}

///|
/// JS: promise.finally(() => { ... })
pub fn[A] Promise::finally_(self : Self[A], f : () -> Unit) -> Self[A] {
  self.call("finally", [@js.from_fn0(f)]) |> unsafe_cast
}

///|
/// JS: await promise
/// Waits for the Promise to be resolved or rejected.
pub async fn[T] Promise::unwrap(self : Self[T]) -> T {
  suspend((ok, err) => self
    .call("then", [@js.from_fn1(ok)])
    .call("catch", [@js.from_fn1(err)])
    |> ignore)
}

///|
/// JS: Promise.all(promises)
pub fn[A] Promise::all(promises : Array[Promise[A]]) -> Promise[Array[A]] {
  ffi_promise_all(promises |> unsafe_cast) |> unsafe_cast
}

///|
/// JS: Promise.race(promises)
pub fn[T] Promise::race(promises : Array[Promise[T]]) -> Promise[T] {
  ffi_promise_race(promises |> unsafe_cast) |> unsafe_cast
}

///|
/// JS: Promise.any(promises)
pub fn[T] Promise::any(promises : Array[Promise[T]]) -> Promise[T] {
  ffi_promise_any(promises |> unsafe_cast) |> unsafe_cast
}

///|
/// Result type for Promise.allSettled
pub(all) struct SettledResult[T] {
  status : String // "fulfilled" | "rejected"
  value : T?
  reason : Js?
}

///|
/// JS: Promise.all(promises)
pub fn[A] Promise::allSettled(
  promises : Array[Promise[A]],
) -> Promise[Array[SettledResult[A]]] {
  ffi_promise_all(promises |> unsafe_cast) |> unsafe_cast
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
pub(all) struct Resolvers[T] {
  promise : Promise[T]
  resolve : (T) -> Unit
  reject : (Error) -> Unit
}

///|
/// JS: Promise.withResolvers()
pub fn[T] Promise::withResolvers() -> Resolvers[T] {
  ffi_promise_with_resolvers() |> unsafe_cast
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
