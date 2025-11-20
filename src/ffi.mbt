///| Types

///|
#external
pub type JsTimer

///| Type Checking

///|
extern "js" fn ffi_type_of(value : Js) -> String =
  #| (value) => typeof value

///|
extern "js" fn ffi_instance_of(value : Js, cls : Js) -> Bool =
  #| (value, cls) => value instanceof cls

///|
extern "js" fn ffi_is_array(value : Js) -> Bool =
  #| (value) => Array.isArray(value)

///|
extern "js" fn ffi_is_object(value : Js) -> Bool =
  #| (value) => typeof value === "object" && value !== null

///|
extern "js" fn ffi_is_nan(value : Js) -> Bool =
  #| (value) => Number.isNaN(value)

///|
extern "js" fn ffi_is_null(value : Js) -> Bool =
  #| (value) => value === null

///|
pub extern "js" fn ffi_is_undefined(value : Js) -> Bool =
  #| (value) => value === undefined

///|
extern "js" fn ffi_is_error(value : Js) -> Bool =
  #| (value) => Error.isError(value)

///| Object Operations

///|
extern "js" fn ffi_new_object() -> Js =
  #| () => ({})

///|
extern "js" fn ffi_get(obj : Js, key : String) -> Js =
  #| (obj, key) => obj[key]

///|
extern "js" fn ffi_set(obj : Js, key : String, value : Js) -> Unit =
  #| (obj, key, value) => { obj[key] = value }

///|
extern "js" fn ffi_delete(obj : Js, key : String) -> Unit =
  #| (obj, key) => { delete obj[key]; }

///|
extern "js" fn ffi_has_own_property(obj : Js, key : String) -> Bool =
  #| (obj, key) => obj.hasOwnProperty(key)

///|
extern "js" fn ffi_property_is_enumerable(obj : Js, key : String) -> Bool =
  #| (obj, key) => obj.propertyIsEnumerable(key)

///|
extern "js" fn ffi_is_prototype_of(obj : Js, target : Js) -> Bool =
  #| (obj, target) => obj.isPrototypeOf(target)

///|
extern "js" fn ffi_object_is(a : Js, b : Js) -> Bool =
  #| (a, b) => Object.is(a, b)

///|
extern "js" fn ffi_object_keys(obj : Js) -> Array[String] =
  #| (obj) => Object.keys(obj)

///|
extern "js" fn ffi_object_entries(obj : Js) -> Array[Js] =
  #| (obj) => Object.entries(obj)

///| Function Calls

///|
extern "js" fn ffi_call(obj : Js, key : String, args : Array[Js]) -> Js =
  #| (obj, key, args) => obj[key](...args)

///|
extern "js" fn ffi_call0(obj : Js, key : String) -> Js =
  #| (obj, key) => obj[key]()

///|
extern "js" fn ffi_call1(obj : Js, key : String, arg1 : Js) -> Js =
  #| (obj, key, arg1) => obj[key](arg1)

///|
extern "js" fn ffi_call2(obj : Js, key : String, arg1 : Js, arg2 : Js) -> Js =
  #| (obj, key, arg1, arg2) => obj[key](arg1, arg2)

///|
extern "js" fn ffi_call_self(func : Js, args : Array[Js]) -> Js =
  #| (func, args) => func(...args)

///|
extern "js" fn ffi_call_self0(func : Js) -> Js =
  #| (func) => func()

///|
extern "js" fn ffi_new(cls : Js, args : Array[Js]) -> Js =
  #| (cls, args) => new cls(...args)

///| Array Operations

///|
extern "js" fn ffi_new_array() -> Js =
  #| () => ([])

///|
extern "js" fn ffi_array_from(value : Js) -> Array[Js] =
  #| (value) => Array.from(value)

///| Error Handling

///|
extern "js" fn ffi_new_error(args : Array[Js]) -> JsError =
  #| (args) => new Error(...args)

///|
extern "js" fn ffi_throw(value : Js) -> Unit =
  #| (value) => { throw value }

///| Promise Operations

///|
extern "js" fn ffi_promise_resolve(value : Js) -> Js =
  #| (value) => Promise.resolve(value)

///|
extern "js" fn ffi_promise_reject(error : Error) -> Js =
  #| (error) => Promise.reject(error)

///|
extern "js" fn ffi_promise_then(promise : Js, callback : (Js) -> Js) =
  #| (promise, callback) => promise.then(callback)

///|
extern "js" fn ffi_promise_all(promises : Array[Promise[Js]]) -> Promise[Js] =
  #| (promises) => Promise.all(promises)

///|
extern "js" fn ffi_promise_race(promises : Array[Promise[Js]]) -> Promise[Js] =
  #| (promises) => Promise.race(promises)

///|
extern "js" fn ffi_promise_any(promises : Array[Promise[Js]]) -> Promise[Js] =
  #| (promises) => Promise.any(promises)

///|
extern "js" fn ffi_new_promise(
  executor : ((Js) -> Unit, (Js) -> Unit) -> Unit,
) -> Promise[Js] =
  #| (executor) => new Promise(executor)

///|
extern "js" fn ffi_promise_with_resolvers() -> Js =
  #| () => Promise.withResolvers()

///| Symbols

///|
extern "js" fn ffi_symbol(name : String) -> Symbol =
  #| (name) => Symbol(name)

///| Global Functions

///|
extern "js" fn ffi_global_this() -> Js =
  #| () => globalThis

///|
extern "js" fn ffi_undefined() -> Js =
  #| () => undefined

///|
extern "js" fn ffi_null() -> Js =
  #| () => null

///|
extern "js" fn ffi_console_log(values : Array[Js]) -> Unit =
  #| (values) => console.log(...values)

///|
extern "js" fn ffi_dynamic_import(module_name : String) -> Js =
  #| (module_name) => import(module_name)

///| String and Encoding

///|
extern "js" fn ffi_to_string(value : Js) -> String =
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
  value : Js,
  replacer : Js,
  space : Js,
) -> String =
  #| (value, replacer, space) => JSON.stringify(value, replacer, space)

///|
extern "js" fn ffi_json_parse(json : String, reviver? : Js) -> Js =
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
pub extern "js" fn structuredCclone(value : Js) -> Js =
  #| (value) => structuredClone(value)
