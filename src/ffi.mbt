///| Types

///|
#external
pub type JsTimer

///|
extern "js" fn ffi_is_array(value : @nostd.Any) -> Bool =
  #| (value) => Array.isArray(value)

///| Object Operations

///|
extern "js" fn ffi_get(obj : @nostd.Any, key : String) -> @nostd.Any =
  #| (obj, key) => obj[key]

///|
extern "js" fn ffi_get_dyn(obj : @nostd.Any, key : @nostd.Any) -> @nostd.Any =
  #| (obj, key) => obj[key]

///|
extern "js" fn ffi_has_own_property(obj : @nostd.Any, key : String) -> Bool =
  #| (obj, key) => obj.hasOwnProperty(key)

///| Function Calls

///|
extern "js" fn ffi_call_self0(func : @nostd.Any) -> Any =
  #| (func) => func()

///| Array Operations

///|
extern "js" fn ffi_array_from(value : @nostd.Any) -> Array[Any] =
  #| (value) => Array.from(value)

///| Error Handling

///|
extern "js" fn ffi_throw(value : Any) -> Unit =
  #| (value) => { throw value }

///| Promise Operations

///|
extern "js" fn ffi_promise_resolve(value : @nostd.Any) -> Any =
  #| (value) => Promise.resolve(value)

///|
extern "js" fn ffi_promise_reject(error : @nostd.Any) -> @nostd.Any =
  #| (error) => Promise.reject(error)
  #|

///|
extern "js" fn ffi_promise_then(promise : @nostd.Any, callback : (Any) -> Any) =
  #| (promise, callback) => promise.then(callback)

///|
extern "js" fn ffi_promise_all(promises : Array[Promise[Any]]) -> Promise[Any] =
  #| (promises) => Promise.all(promises)

///|
extern "js" fn ffi_promise_race(promises : Array[Promise[Any]]) -> Promise[Any] =
  #| (promises) => Promise.race(promises)

///|
extern "js" fn ffi_promise_any(promises : Array[Promise[Any]]) -> Promise[Any] =
  #| (promises) => Promise.any(promises)

///|
extern "js" fn ffi_new_promise(
  executor : ((Any) -> Unit, (Any) -> Unit) -> Unit,
) -> Promise[Any] =
  #| (executor) => new Promise(executor)

///|
extern "js" fn ffi_promise_with_resolvers() -> Any =
  #| () => Promise.withResolvers()

///| Symbols

///| Global Functions

///|
extern "js" fn ffi_console_log(values : Array[Any]) -> Unit =
  #| (values) => console.log(...values)

///| String and Encoding

///| JSON

///|
extern "js" fn ffi_json_stringify(
  value : @nostd.Any,
  replacer : @nostd.Any,
  space : @nostd.Any,
) -> String =
  #| (value, replacer, space) => JSON.stringify(value, replacer, space)

///|
extern "js" fn ffi_json_parse(
  json : String,
  reviver? : @nostd.Any,
) -> @nostd.Any =
  #| (json, reviver) => JSON.parse(json, reviver)

///| Timers
