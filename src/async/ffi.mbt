///|
extern "js" fn ffi_promise_resolve(x : Val) -> Val = "(x) => Promise.resolve(x)"

///|
extern "js" fn ffi_promise_reject(e : Error) -> Val = "(x) => Promise.reject(x)"

///|
extern "js" fn ffi_promise_then(x : Val, ok : (Val) -> Val) = "(x,f) => x.then(f)"

///|
extern "js" fn ffi_promise_all(f : Array[Promise[Val]]) -> Promise[Val] = "(values) => Promise.all(values)"

///|
extern "js" fn ffi_promise_race(f : Array[Promise[Val]]) -> Promise[Val] = "(values) => Promise.race(values)"

///|
extern "js" fn ffi_new_promise(
  f : ((Val) -> Unit, (Val) -> Unit) -> Unit,
) -> Promise[Val] = "(f) => new Promise(f)"

///|
extern "js" fn ffi_promise_with_resolvers() -> Val =
  #| () => Promise.withResolvers()
