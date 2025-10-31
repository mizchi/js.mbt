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
pub impl[T] Js for Promise[T] with to_js(self) -> Val {
  self |> js
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
  ffi_promise_then(self.to_js(), a => (a |> unsafe_cast |> resolve |> unsafe_cast) catch {
    e => e |> ffi_promise_reject |> unsafe_cast
  })
  |> unsafe_cast
}

///|
pub fn[A, B] Promise::catch_(self : Self[A], f : (Error) -> Promise[B]) -> Promise[B] {
  self.to_js().call_method("catch", [js(f)]).cast()
}

///|
pub fn[A] Promise::finally_(self : Self[A], f : () -> Unit) -> Self[A] {
  self.to_js().call_method("finally", [js(f)]).cast()
}

///|
/// Waits for the Promise to be resolved or rejected.
pub async fn[A] Promise::unwrap(self : Self[A]) -> A raise {
  suspend((ok, err) => self
    .to_js()
    .call_method("then", [js(ok)])
    .call_method("catch", [js(err)])
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
///   let v: Int = p.unwrap() catch { _ => 0 }
/// })
/// ```
pub fn[T] Promise::deferred() -> (Promise[T], (T) -> Unit, (Error) -> Unit) {
  ffi_deferred_internal() |> unsafe_cast
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
