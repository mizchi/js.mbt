///| Types

///|
#external
pub type JsTimer

///| Type Checking

///|
extern "js" fn ffi_type_of(value : Any) -> String =
  #| (value) => typeof value

///|
extern "js" fn ffi_instance_of(value : Any, cls : Any) -> Bool =
  #| (value, cls) => value instanceof cls

///|
extern "js" fn ffi_is_array(value : Any) -> Bool =
  #| (value) => Array.isArray(value)

///|
extern "js" fn ffi_is_object(value : Any) -> Bool =
  #| (value) => typeof value === "object" && value !== null

///|
extern "js" fn ffi_is_nan(value : Any) -> Bool =
  #| (value) => Number.isNaN(value)

///|
extern "js" fn ffi_is_null(value : Any) -> Bool =
  #| (value) => value === null

///|
extern "js" fn ffi_is_undefined(value : Any) -> Bool =
  #| (value) => value === undefined

///|
extern "js" fn ffi_is_nullish(v : Any) -> Bool =
  #|(v) => v == null

///|
extern "js" fn ffi_is_error(value : Any) -> Bool =
  #| (value) => Error.isError(value)

///| Object Operations

///|
extern "js" fn ffi_new_object() -> Any =
  #| () => ({})

///|
extern "js" fn ffi_get(obj : Any, key : String) -> Any =
  #| (obj, key) => obj[key]

///|
extern "js" fn ffi_set(obj : Any, key : String, value : Any) -> Unit =
  #| (obj, key, value) => { obj[key] = value }

///|
extern "js" fn ffi_delete(obj : Any, key : String) -> Unit =
  #| (obj, key) => { delete obj[key]; }

///|
extern "js" fn ffi_has_own_property(obj : Any, key : String) -> Bool =
  #| (obj, key) => obj.hasOwnProperty(key)

///|
extern "js" fn ffi_property_is_enumerable(obj : Any, key : String) -> Bool =
  #| (obj, key) => obj.propertyIsEnumerable(key)

///|
extern "js" fn ffi_is_prototype_of(obj : Any, target : Any) -> Bool =
  #| (obj, target) => obj.isPrototypeOf(target)

///|
extern "js" fn ffi_object_is(a : Any, b : Any) -> Bool =
  #| (a, b) => Object.is(a, b)

///|
extern "js" fn ffi_object_keys(obj : Any) -> Array[String] =
  #| (obj) => Object.keys(obj)

///|
extern "js" fn ffi_object_entries(obj : Any) -> Array[Any] =
  #| (obj) => Object.entries(obj)

///| Function Calls

///|
extern "js" fn ffi_call(obj : Any, key : String, args : Array[Any]) -> Any =
  #| (obj, key, args) => obj[key](...args)

///|
extern "js" fn ffi_call0(obj : Any, key : String) -> Any =
  #| (obj, key) => obj[key]()

///|
extern "js" fn ffi_call1(obj : Any, key : String, arg1 : Any) -> Any =
  #| (obj, key, arg1) => obj[key](arg1)

///|
extern "js" fn ffi_call2(
  obj : Any,
  key : String,
  arg1 : Any,
  arg2 : Any,
) -> Any =
  #| (obj, key, arg1, arg2) => obj[key](arg1, arg2)

///|
extern "js" fn ffi_call_self(func : Any, args : Array[Any]) -> Any =
  #| (func, args) => func(...args)

///|
extern "js" fn ffi_call_self0(func : Any) -> Any =
  #| (func) => func()

///|
extern "js" fn ffi_new(cls : Any, args : Array[Any]) -> Any =
  #| (cls, args) => new cls(...args)

///| Array Operations

///|
extern "js" fn ffi_new_array() -> Any =
  #| () => ([])

///|
extern "js" fn ffi_array_from(value : Any) -> Array[Any] =
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
extern "js" fn ffi_get_error_type(error : Any) -> String =
  #| (error) => error?.constructor?.name || ""

///| Promise Operations

///|
extern "js" fn ffi_promise_resolve(value : Any) -> Any =
  #| (value) => Promise.resolve(value)

///|
extern "js" fn ffi_promise_reject(error : Error) -> Any =
  #| (error) => Promise.reject(error)

///|
extern "js" fn ffi_promise_then(promise : Any, callback : (Any) -> Any) =
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
extern "js" fn ffi_global_this() -> Any =
  #| () => globalThis

///|
extern "js" fn ffi_undefined() -> Any =
  #| () => undefined

///|
extern "js" fn ffi_null() -> Any =
  #| () => null

///|
extern "js" fn ffi_console_log(values : Array[Any]) -> Unit =
  #| (values) => console.log(...values)

///|
extern "js" fn ffi_dynamic_import(module_name : String) -> Any =
  #| (module_name) => import(module_name)

///| String and Encoding

///|
extern "js" fn ffi_to_string(value : Any) -> String =
  #| (value) => value == null ? String(null) : value.toString()

///|
extern "js" fn ffi_atob(encoded_data : String) -> String =
  #| (encoded_data) => atob(encoded_data)

///|
extern "js" fn ffi_btoa(data : String) -> String =
  #| (data) => btoa(data)

///|
extern "js" fn ffi_encode_uri(uri : String) -> String =
  #| (uri) => encodeURI(uri)

///|
extern "js" fn ffi_decode_uri(encoded_uri : String) -> String =
  #| (encoded_uri) => decodeURI(encoded_uri)

///|
extern "js" fn ffi_encode_uri_component(str : String) -> String =
  #| (str) => encodeURIComponent(str)

///|
extern "js" fn ffi_decode_uri_component(encoded_str : String) -> String =
  #| (encoded_str) => decodeURIComponent(encoded_str)

///| JSON

///|
extern "js" fn ffi_json_stringify(
  value : Any,
  replacer : Any,
  space : Any,
) -> String =
  #| (value, replacer, space) => JSON.stringify(value, replacer, space)

///|
extern "js" fn ffi_json_parse(json : String, reviver? : Any) -> Any =
  #| (json, reviver) => JSON.parse(json, reviver)

///| Timers

///|
extern "js" fn ffi_set_interval(
  callback : () -> Unit noraise,
  duration : Int,
) -> JsTimer =
  #| (callback, duration) => setInterval(callback, duration)

///|
extern "js" fn ffi_set_timeout(
  callback : () -> Unit noraise,
  duration : Int,
) -> JsTimer =
  #| (callback, duration) => setTimeout(callback, duration)

///|
extern "js" fn ffi_clear_timeout(timer : JsTimer) -> Unit =
  #| (timer) => clearTimeout(timer)

///|
extern "js" fn ffi_queue_microtask(callback : () -> Unit noraise) -> Unit =
  #| (callback) => queueMicrotask(callback)

///|
pub extern "js" fn structuredClone(value : Any) -> Any =
  #| (value) => structuredClone(value)

///| Number Parsing and Validation

///|
extern "js" fn ffi_parse_int(string : String, radix : Int) -> Any =
  #| (string, radix) => parseInt(string, radix)

///|
extern "js" fn ffi_parse_float(string : String) -> Any =
  #| (string) => parseFloat(string)

///|
extern "js" fn ffi_is_finite(value : Double) -> Bool =
  #| (value) => isFinite(value)
