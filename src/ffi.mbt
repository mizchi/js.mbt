///|
extern "js" fn ffi_to_string(v : Val) -> String =
  #| (v) => v == null ? String(null) : v.toString()

///|
extern "js" fn ffi_get(v : Val, key : String) -> Val =
  #| (obj, k) => obj[k]

///|
extern "js" fn ffi_set(obj : Val, key : String, value : Val) -> Unit =
  #| (obj, k, v) => obj[k] = v

///|
extern "js" fn ffi_new(v : Val, args : Array[Val]) -> Val =
  #| (obj, args) => new obj(...args)

///|
extern "js" fn ffi_new_error(args : Array[Val]) -> ErrorObject =
  #| (args) => new Error(...args)

///|
extern "js" fn ffi_is_error(v : ErrorObject) -> Bool =
  #| (v) => Error.isError(v)

///|
extern "js" fn ffi_throw(v : Val) -> Unit =
  #| (v) => { throw v }

///|
extern "js" fn ffi_call(f : Val, args : Array[Val]) -> Val =
  #|(f, args) => f(...args)

///|
extern "js" fn ffi_call_method(v : Val, key : String, args : Array[Val]) -> Val =
  #|(obj, k, args) => obj[k](...args)

///|
extern "js" fn ffi_new_object() -> Val =
  #|() => ({})

///|
extern "js" fn ffi_new_empty_array() -> Val =
  #|() => ([])

///|
extern "js" fn ffi_new_set() -> Val =
  #|() => new Set()

///|
extern "js" fn ffi_new_map() -> Val =
  #|() => new Map()

///|
extern "js" fn ffi_object_create() -> Val =
  #| () => Object.create({})

///|
extern "js" fn ffi_symbol_iterator() -> Symbol =
  #| () => Symbol.iterator

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
extern "js" fn ffi_delete(v : Val, key : String) -> Unit =
  #| (obj, k) => { delete obj[k]; }

///|
extern "js" fn ffi_has_own_property(v : Val, k : String) -> Bool =
  #| (obj, k) => obj.hasOwnProperty(k)

///|
extern "js" fn ffi_property_is_enumerable(v : Val, k : String) -> Bool =
  #| (obj, k) => obj.propertyIsEnumerable(k)

// Object

///|
extern "js" fn ffi_object_is(a : Val, b : Val) -> Bool =
  #| (a, b) => Object.is(a, b)

///|
extern "js" fn ffi_global_this() -> Val =
  #| () => globalThis

///|
extern "js" fn ffi_undefined() -> Val =
  #| () => undefined

///|
extern "js" fn ffi_null() -> Val =
  #| () => null

///|
extern "js" fn ffi_object_keys(v : Val) -> Array[String] =
  #| (obj) => Object.keys(obj)

///|
extern "js" fn ffi_object_entries(v : Val) -> Array[Val] =
  #|(v) => Object.entries(v)

///|
extern "js" fn ffi_object_values(v : Val) -> Array[Val] =
  #|(v) => Object.values(v)

///|
extern "js" fn ffi_object_assign(v : Val, o : Val) -> Val =
  #|(obj, o) => Object.assign(obj, o)

///|
extern "js" fn ffi_console_log(v : Array[Val]) -> Unit =
  #|(obj) => console.log(...obj)

///|
extern "js" fn ffi_json_stringify(
  v : Val,
  replacer : Val,
  space : Val,
) -> String =
  #|(v, replacer, space) => JSON.stringify(v, replacer, space)

///|
extern "js" fn ffi_json_parse(v : String, reviver? : Val) -> Val =
  #|(v, reviver) => JSON.parse(v, reviver)

///|
pub extern "js" fn structured_clone(v : Val) -> Val =
  #|(v) => structuredClone(v)

///|
extern "js" fn ffi_dynamic_import(module_name : String) -> Val =
  #|(moduleName) => import(moduleName)

///|
extern "js" fn ffi_atob(encoded_data : String) -> String =
  #|(encodedData) => atob(encodedData)

///|
extern "js" fn ffi_btoa(data : String) -> String =
  #|(data) => btoa(data)

///|
extern "js" fn ffi_array_from(v : Val) -> Array[Val] =
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
