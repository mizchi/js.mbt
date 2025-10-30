/// original https://github.com/moonbit-community/jmop/blob/main/promise.mbt

///|
#external
pub type Promise[T]

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
    f(a => a |> identity |> resolve, e => e |> identity |> reject)
  })
  |> identity
}

///|
pub impl[T] ToJs for Promise[T] with to_js(self) -> Value {
  self |> to_js
}

///|
/// js: Promise.resolve(value)
pub fn[A] Promise::resolve(x : A) -> Self[A] {
  ffi_promise_resolve(identity(x)) |> identity
}

///|
/// js: Promise.reject(error)
pub fn Promise::reject(x : Value) -> Self[Value] {
  ffi_promise_reject(identity(x)) |> identity
}

///|
pub fn[A, B] Promise::then(
  x : Promise[A],
  resolve : (A) -> Promise[B] raise,
  reject? : (Error) -> Promise[B],
) -> Promise[B] {
  x.bind(resolve, reject?)
}

///|
pub fn[A, B] catch_(self : Promise[A], f : (Error) -> Promise[B]) -> Promise[B] {
  self.to_js().call_property1("catch", to_js(f)).cast()
}

///|
pub fn[A] Promise::finally_(self : Self[A], f : () -> Unit) -> Self[A] {
  self.to_js().call_property1("finally", to_js(f)).cast()
}

///|
fn[A, B] Promise::bind(
  x : Self[A],
  resolve : (A) -> Self[B] raise,
  reject? : (Error) -> Self[B],
) -> Self[B] {
  ffi_promise_then(
    identity(x),
    fn(a) {
      identity(resolve(identity(a))) catch {
        e => identity(ffi_promise_reject(e))
      }
    },
    identity(reject),
  )
  |> identity
}

///|
/// Waits for the Promise to be resolved or rejected.
pub async fn[A] Promise::wait(self : Self[A]) -> A {
  suspend((ok, err) => self
    .to_js()
    .call_property2("then", to_js(ok), to_js(err))
    |> ignore)
}

///|
/// Creates a deferred Promise along with its resolve and reject functions.
/// ```
/// run_async(() => {
///   let (p, resolve, _reject) = Promise::deferred()
///   let f = async fn () noraise {
///     resolve(10)
///   }
///   f()
///   let v: Int = p.wait() catch { _ => 0 }
/// })
/// ```
pub fn[T] Promise::deferred() -> (Promise[T], (T) -> Unit, (Error) -> Unit) {
  ffi_deferred_internal() |> identity
}

///|
pub fn[R] to_promise_fn0(f : async () -> R) -> () -> Promise[R] noraise {
  fn() {
    let (p, ok, err) = Promise::deferred()
    run_async(() => try f() |> ok catch {
      e => err(e)
    })
    p
  }
}

///|
pub fn[A, R] to_promise_fn1(f : async (A) -> R) -> (A) -> Promise[R] noraise {
  fn(a) {
    let (p, ok, err) = Promise::deferred()
    run_async(() => try f(a) |> ok catch {
      e => err(e)
    })
    p
  }
}

///|
pub fn[A, B, R] to_promise_fn2(
  f : async (A, B) -> R,
) -> (A, B) -> Promise[R] noraise {
  (a, b) => {
    let (p, ok, err) = Promise::deferred()
    run_async(() => try f(a, b) |> ok catch {
      e => err(e)
    })
    p
  }
}

///|
pub fn[A, B, C, R] to_promise_fn3(
  f : async (A, B, C) -> R,
) -> (A, B, C) -> Promise[R] noraise {
  (a, b, c) => {
    let (p, ok, err) = Promise::deferred()
    run_async(() => try f(a, b, c) |> ok catch {
      e => err(e)
    })
    p
  }
}
