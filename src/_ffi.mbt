///|
#external
pub type JsTimer

///|
extern "js" fn ffi_to_string(v : Js) -> String =
  #| (v) => v == null ? String(null) : v.toString()

///|
extern "js" fn ffi_is_null(v : Js) -> Bool =
  #| (v) => v === null

///|
/// JS:
pub extern "js" fn ffi_is_undefined(v : Js) -> Bool =
  #| (v) => v === undefined

///|
extern "js" fn ffi_get(v : Js, key : String) -> Js =
  #| (obj, k) => obj[k]

///|
extern "js" fn ffi_set(obj : Js, key : String, value : Js) -> Unit =
  #| (obj, k, v) => obj[k] = v

///|
extern "js" fn ffi_new(v : Js, args : Array[Js]) -> Js =
  #| (obj, args) => new obj(...args)

///|
extern "js" fn ffi_new_error(args : Array[Js]) -> JsError =
  #| (args) => new Error(...args)

///|
extern "js" fn ffi_is_error(v : Js) -> Bool =
  #| (v) => Error.isError(v)

///|
extern "js" fn ffi_throw(v : Js) -> Unit =
  #| (v) => { throw v }

///|
extern "js" fn ffi_call(f : Js, args : Array[Js]) -> Js =
  #|(f, args) => f(...args)

///|
extern "js" fn ffi_invoke(v : Js, key : String, args : Array[Js]) -> Js =
  #|(obj, k, args) => obj[k](...args)

///|
extern "js" fn ffi_new_empty_object() -> Js =
  #|() => ({})

///|
extern "js" fn ffi_new_empty_array() -> Js =
  #|() => ([])

///|
extern "js" fn ffi_symbol_for(name : String) -> Symbol =
  #| (name) => Symbol.for(name)

///|
extern "js" fn ffi_object_create() -> Js =
  #| () => Object.create({})

///|
extern "js" fn ffi_symbol_iterator() -> Symbol =
  #| () => Symbol.iterator

///|
extern "js" fn ffi_symbol_async_iterator() -> Symbol =
  #| () => Symbol.asyncIterator

///|
extern "js" fn ffi_symbol_dispose() -> Symbol =
  #| () => Symbol.dispose

///|
extern "js" fn ffi_symbol_async_dispose() -> Symbol =
  #| () => Symbol.asyncDispose

///|
extern "js" fn ffi_symbol(name : String) -> Symbol =
  #| (name) => Symbol(name)

///|
extern "js" fn ffi_delete(v : Js, key : String) -> Unit =
  #| (obj, k) => { delete obj[k]; }

///|
extern "js" fn ffi_has_own_property(v : Js, k : String) -> Bool =
  #| (obj, k) => obj.hasOwnProperty(k)

///|
extern "js" fn ffi_property_is_enumerable(v : Js, k : String) -> Bool =
  #| (obj, k) => obj.propertyIsEnumerable(k)

// Object

///|
extern "js" fn ffi_object_is(a : Js, b : Js) -> Bool =
  #| (a, b) => Object.is(a, b)

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
extern "js" fn ffi_object_keys(v : Js) -> Array[String] =
  #| (obj) => Object.keys(obj)

///|
extern "js" fn ffi_object_entries(v : Js) -> Array[Js] =
  #|(v) => Object.entries(v)

///|
extern "js" fn ffi_object_values(v : Js) -> Array[Js] =
  #|(v) => Object.values(v)

///|
extern "js" fn ffi_object_assign(v : Js, o : Js) -> Js =
  #|(obj, o) => Object.assign(obj, o)

///|
extern "js" fn ffi_console_log(v : Array[Js]) -> Unit =
  #|(obj) => console.log(...obj)

///|
extern "js" fn ffi_json_stringify(v : Js, replacer : Js, space : Js) -> String =
  #|(v, replacer, space) => JSON.stringify(v, replacer, space)

///|
extern "js" fn ffi_json_parse(v : String, reviver? : Js) -> Js =
  #|(v, reviver) => JSON.parse(v, reviver)

///|
pub extern "js" fn structured_clone(v : Js) -> Js =
  #|(v) => structuredClone(v)

///|
extern "js" fn ffi_dynamic_import(module_name : String) -> Js =
  #|(moduleName) => import(moduleName)

///|
extern "js" fn ffi_atob(encoded_data : String) -> String =
  #|(encodedData) => atob(encodedData)

///|
extern "js" fn ffi_btoa(data : String) -> String =
  #|(data) => btoa(data)

///|
extern "js" fn ffi_array_from(v : Js) -> Array[Js] =
  #|(v) => Array.from(v)

///|
extern "js" fn ffi_encode_uri(uri : String) -> String =
  #|(uri) => encodeURI(uri)

///|
extern "js" fn ffi_decode_uri(encoded_uri : String) -> String =
  #|(encodedURI) => decodeURI(encodedURI)

///|
extern "js" fn ffi_encode_uri_component(str : String) -> String =
  #|(str) => encodeURIComponent(str)

///|
extern "js" fn ffi_decode_uri_component(encoded_str : String) -> String =
  #|(encodedStr) => decodeURIComponent(encodedStr)

///|
extern "js" fn ffi_type_of(v : Js) -> String =
  #| (v) => typeof v

///|
extern "js" fn ffi_instance_of(v : Js, cls : Js) -> Bool =
  #| (v, cls) => v instanceof cls

///|
extern "js" fn ffi_is_array(v : Js) -> Bool =
  #| (v) => Array.isArray(v)

///|
extern "js" fn ffi_is_object(v : Js) -> Bool =
  #| (v) => typeof v === "object" && v !== null

///|
extern "js" fn ffi_is_nan(v : Js) -> Bool =
  #| (v) => Number.isNaN(v)

///|
extern "js" fn ffi_set_interval(
  f : () -> Unit noraise,
  duration : Int,
) -> JsTimer =
  #| (f, duration) => setInterval(f, duration)

///|
extern "js" fn ffi_set_timeout(
  f : () -> Unit noraise,
  duration : Int,
) -> JsTimer =
  #| (f, duration) => setTimeout(f, duration)

///|
extern "js" fn ffi_clear_timeout(timer : JsTimer) -> Unit =
  #| (timer) => clearTimeout(timer)
