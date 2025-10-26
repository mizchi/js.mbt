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
extern "js" fn ffi_promise_catch(x : Value, err : (Error) -> Value) = "(x,f) => x.catch(f)"

///|
extern "js" fn ffi_is_promise(x : Value) -> Bool = "(a) => a instanceof Promise"

///|
pub suberror InvalidNestedPromise SourceLoc

///|
#external
pub type Promise[T]

///|
pub fn[A] Promise::resolve(x : A) -> Self[A] {
  Promise::new(x)
}

///|
pub fn[A] Promise::reject(error : Error) -> Self[A] {
  ffi_promise_reject(identity(error)) |> identity
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

///|
#callsite(autofill(loc))
pub fn[A] Promise::new(x : A, loc~ : SourceLoc) -> Self[A] {
  (if ffi_is_promise(identity(x)) {
    ffi_promise_reject(InvalidNestedPromise(loc))
  } else {
    ffi_promise_resolve(identity(x))
  })
  |> identity
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
pub async fn[A] Promise::wait(x : Self[A]) -> A {
  suspend(fn(ok, err) {
    ffi_promise_then(identity(x), identity(ok), identity(err))
  })
}
