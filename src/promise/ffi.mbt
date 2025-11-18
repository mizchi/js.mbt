///|
extern "js" fn ffi_promise_resolve(x : Js) -> Js = "(x) => Promise.resolve(x)"

///|
extern "js" fn ffi_promise_reject(e : Error) -> Js = "(x) => Promise.reject(x)"

///|
extern "js" fn ffi_promise_then(x : Js, ok : (Js) -> Js) = "(x,f) => x.then(f)"

///|
extern "js" fn ffi_promise_all(f : Array[Promise[Js]]) -> Promise[Js] = "(values) => Promise.all(values)"

///|
extern "js" fn ffi_promise_race(f : Array[Promise[Js]]) -> Promise[Js] = "(values) => Promise.race(values)"

///|
extern "js" fn ffi_new_promise(
  f : ((Js) -> Unit, (Js) -> Unit) -> Unit,
) -> Promise[Js] = "(f) => new Promise(f)"

///|
extern "js" fn ffi_promise_with_resolvers() -> Js =
  #| () => Promise.withResolvers()
