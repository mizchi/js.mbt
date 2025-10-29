/// original https://github.com/moonbit-community/jmop/blob/main/promise.mbt

///|
extern "js" fn ffi_promise_resolve(x : Value) -> Value = "(x) => Promise.resolve(x)"

///|
extern "js" fn ffi_promise_reject(e : Error) -> Value = "(x) => Promise.reject(x)"

///|
extern "js" fn ffi_promise_then(
  x : Value,
  ok : (Value) -> Value,
  err : (Value) -> Value,
) = "(x,f,g) => x.then(f,g)"
///|
extern "js" fn ffi_promise_catch(x : Value, err : (Error) -> Value) -> Value = "(x,f) => x.catch(f)"

///|
extern "js" fn ffi_promise_finally(x : Value, f : () -> Unit) -> Value = "(x,f) => x.finally(f)"

///|
extern "js" fn ffi_new_promise(
  f : ((Value) -> Unit, (Value) -> Unit) -> Unit,
) -> Promise[Value] = "(f) => new Promise(f)"

///|
extern "js" fn ffi_deferred_internal() -> Value =
  #| () => {
  #|   let ok, err;
  #|   const p = new Promise((_ok, _err) => {
  #|     ok = _ok;
  #|     err = _err;
  #|   });
  #|   return { _0: p, _1: ok, _2: err };
  #| }

///|
#external
pub type Promise[T]

pub fn[A] Promise::resolve(x : A) -> Self[A] {
  ffi_promise_resolve(identity(x)) |> identity
}

pub fn Promise::reject(x : Value) -> Self[Value] {
  ffi_promise_reject(identity(x)) |> identity
}

///|
pub fn[A, B] Promise::then(
  x : Self[A],
  resolve : (A) -> Self[B] raise,
  reject? : (Error) -> Self[B],
) -> Self[B] {
  x.bind(resolve, reject?)
}

///|
pub fn[A, B] Promise::catch_(x : Self[A], f : (Error) -> Self[B]) -> Self[B] {
  ffi_promise_catch(identity(x), identity(f)) |> identity
}

pub fn[A] Promise::finally_(x : Self[A], f : () -> Unit) -> Self[A] {
  ffi_promise_finally(identity(x), identity(f)) |> identity
}

pub fn[A] Promise::new(f: ((A) -> Unit,(Error) -> Unit) -> Unit) -> Promise[A] {
  ffi_new_promise(
    fn(resolve, reject) {
      f(
        (a) => a |> identity |> resolve,
        (e) => e |> identity |> reject
      )
    }
  ) |> identity
}
///|
pub fn[A, B] Promise::bind(
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
pub async fn[A] Promise::wait(x : Self[A]) -> A raise {
  suspend(fn(ok, err) {
    ffi_promise_then(identity(x), identity(ok), identity(err))
  })
}

pub fn[T] Promise::deferred() -> (Promise[T], (T) -> Unit, (Error) -> Unit) {
  ffi_deferred_internal() |> identity
}

pub fn[R] return_promise(f: async () -> R raise) -> Promise[R] noraise {
  let (p, resolve, reject) = Promise::deferred()
  run_async(() => {
    try { f() |> resolve } catch {
      e => reject(e)
    }
  })
  p
}

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
  fn(a, b) {
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
  fn(a, b, c) {
    let (p, ok, err) = Promise::deferred()
    run_async(() => try f(a, b, c) |> ok catch {
      e => err(e)
    })
    p
  }
}


///|
test "ok" {
  run_async(() => {
    let v = return_promise(async fn() { 123 })
    let r : Int = v.wait() catch { _ => 0 }
    // assert_eq(r, 123)
    guard r == 123
    fn f(v : Int) {
      return_promise(async fn() {
        sleep(10)
        v * 2
      })
    }

    let r2 : Int = f(r).wait() catch { _ => 0 }
    guard r2 == 246
    let f2 = to_promise_fn1(async fn(x : Int) {
      sleep(10)
      x + 1
    })
    let r3 : Int = f2(r2).wait() catch { _ => 0 }
    guard r3 == 247
  })
}