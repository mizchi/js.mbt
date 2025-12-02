///| Types

///|
extern "js" fn ffi_promise_resolve(value : @core.Any) -> Any =
  #| (value) => Promise.resolve(value)

///|
extern "js" fn ffi_promise_reject(error : @core.Any) -> @core.Any =
  #| (error) => Promise.reject(error)
  #|

///|
extern "js" fn ffi_promise_then(promise : @core.Any, callback : (Any) -> Any) =
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
  value : @core.Any,
  replacer : @core.Any,
  space : @core.Any,
) -> String =
  #| (value, replacer, space) => JSON.stringify(value, replacer, space)

///|
extern "js" fn ffi_json_parse(json : String, reviver? : @core.Any) -> @core.Any =
  #| (json, reviver) => JSON.parse(json, reviver)

///| Timers
