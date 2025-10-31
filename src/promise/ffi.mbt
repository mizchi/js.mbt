///|
extern "js" fn ffi_promise_resolve(x : Val) -> Val = "(x) => Promise.resolve(x)"

///|
extern "js" fn ffi_promise_reject(e : Error) -> Val = "(x) => Promise.reject(x)"

///|
extern "js" fn ffi_promise_then(x : Val, ok : (Val) -> Val) = "(x,f) => x.then(f)"

///|
extern "js" fn ffi_new_promise(
  f : ((Val) -> Unit, (Val) -> Unit) -> Unit,
) -> Promise[Val] = "(f) => new Promise(f)"

///|
extern "js" fn ffi_deferred_internal() -> Val =
  #| () => {
  #|   let ok, err;
  #|   const p = new Promise((_ok, _err) => {
  #|     ok = _ok;
  #|     err = _err;
  #|   });
  #|   return { _0: p, _1: ok, _2: err };
  #| }
