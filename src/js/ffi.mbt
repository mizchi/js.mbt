///|
pub extern "js" fn ffi_get(v : Value, key : String) -> Value =
  #| (obj, k) => obj[k]

///|
extern "js" fn ffi_set(obj : Value, key : String, value : Value) -> Unit =
  #| (obj, k, v) => obj[k] = v

///|
extern "js" fn ffi_call(f : Value, args : Array[Value]) -> Value =
  #|(f, args) => f(...args)

///|
extern "js" fn ffi_call_property(
  v : Value,
  key : String,
  args : Array[Value],
) -> Value =
  #|(obj, k, args) => obj[k](...args)

///|
extern "js" fn ffi_delete(v : Value, key : String) -> Unit =
  #| (obj, k) => { delete obj[k]; }

///|
extern "js" fn ffi_to_string(v : Value) -> String =
  #| (v) => v == null ? String(v) : v.toString()

///|
pub extern "js" fn ffi_has_own_property(v : Value, k : String) -> Bool =
  #| (obj, k) => obj.hasOwnProperty(k)

///|
extern "js" fn ffi_safe_call(
  f : () -> Value raise?,
  args : Array[Value],
) -> Result[Value, Error] noraise =
  #|(f) => {
  #|  try {
  #|    return { $tag: 1, value: f(...args) };
  #|  } catch (e) {
  #|    return { $tag: 0, value: e };
  #|  }
  #|}

// Object

///|
extern "js" fn ffi_object_assign(a : Value, b : Value) -> Value =
  #| (target, sources) => Object.assign(target, sources)

///|
// extern "js" fn ffi_object_freeze(obj : Value) -> Value =
//   #| (obj) => Object.freeze(obj)

// ///|
// extern "js" fn ffi_object_seal(obj : Value) -> Value =
//   #| (obj) => Object.seal(obj)

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
