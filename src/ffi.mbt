///| Types

///|
#external
pub type JsTimer

///| Type Checking

///|
extern "js" fn ffi_type_of(value : @nostd.Any) -> String =
  #| (value) => typeof value

///|
extern "js" fn ffi_instance_of(value : @nostd.Any, cls : @nostd.Any) -> Bool =
  #| (value, cls) => value instanceof cls

///|
extern "js" fn ffi_is_array(value : @nostd.Any) -> Bool =
  #| (value) => Array.isArray(value)

///|
extern "js" fn ffi_is_object(value : @nostd.Any) -> Bool =
  #| (value) => typeof value === "object" && value !== null

///|
extern "js" fn ffi_is_null(value : @nostd.Any) -> Bool =
  #| (value) => value === null

///|
extern "js" fn ffi_is_undefined(value : @nostd.Any) -> Bool =
  #| (value) => value === undefined

///|
extern "js" fn ffi_is_nullish(v : @nostd.Any) -> Bool =
  #|(v) => v == null

///|
extern "js" fn ffi_is_error(value : @nostd.Any) -> Bool =
  #| (value) => Error.isError(value)

///| Object Operations

///|
extern "js" fn ffi_new_object() -> @nostd.Any =
  #| () => ({})

///|
extern "js" fn ffi_get(obj : @nostd.Any, key : String) -> @nostd.Any =
  #| (obj, key) => obj[key]

///|
extern "js" fn ffi_get_dyn(obj : @nostd.Any, key : @nostd.Any) -> @nostd.Any =
  #| (obj, key) => obj[key]

///|
extern "js" fn ffi_set(
  obj : @nostd.Any,
  key : String,
  value : @nostd.Any,
) -> Unit =
  #| (obj, key, value) => { obj[key] = value }

///|
extern "js" fn ffi_has_own_property(obj : @nostd.Any, key : String) -> Bool =
  #| (obj, key) => obj.hasOwnProperty(key)

///|
extern "js" fn ffi_property_is_enumerable(
  obj : @nostd.Any,
  key : String,
) -> Bool =
  #| (obj, key) => obj.propertyIsEnumerable(key)

///|
extern "js" fn ffi_is_prototype_of(
  obj : @nostd.Any,
  target : @nostd.Any,
) -> Bool =
  #| (obj, target) => obj.isPrototypeOf(target)

///|
extern "js" fn ffi_object_entries(obj : @nostd.Any) -> Array[Any] =
  #| (obj) => Object.entries(obj)

///| Function Calls

///|
extern "js" fn ffi_call(
  obj : @nostd.Any,
  key : String,
  args : Array[Any],
) -> Any =
  #| (obj, key, args) => obj[key](...args)

///|
extern "js" fn ffi_call0(obj : @nostd.Any, key : String) -> Any =
  #| (obj, key) => obj[key]()

///|
extern "js" fn ffi_call1(obj : @nostd.Any, key : String, arg1 : Any) -> Any =
  #| (obj, key, arg1) => obj[key](arg1)

///|
extern "js" fn ffi_call_self0(func : @nostd.Any) -> Any =
  #| (func) => func()

///| Array Operations

///|
extern "js" fn ffi_new_array() -> Any =
  #| () => ([])

///|
extern "js" fn ffi_array_from(value : @nostd.Any) -> Array[Any] =
  #| (value) => Array.from(value)

///| Error Handling

///|
extern "js" fn ffi_new_error(args : Array[Any]) -> JsError =
  #| (args) => new Error(...args)

///|
extern "js" fn ffi_throw(value : Any) -> Unit =
  #| (value) => { throw value }

///|
/// Get the error type name (constructor name)
extern "js" fn ffi_get_error_type(error : @nostd.Any) -> String =
  #| (error) => error?.constructor?.name || ""

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

///|
extern "js" fn ffi_symbol(name : String) -> Symbol =
  #| (name) => Symbol(name)

///| Global Functions

///|
extern "js" fn ffi_null() -> Any =
  #| () => null

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
  #|

///| Timers
