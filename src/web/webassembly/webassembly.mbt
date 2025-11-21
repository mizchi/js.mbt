///|
/// WebAssembly API for JavaScript environments
/// Based on WebAssembly JavaScript API specification
/// https://developer.mozilla.org/ja/docs/WebAssembly

///|
/// WebAssembly.Module represents a compiled WebAssembly module
/// https://developer.mozilla.org/ja/docs/WebAssembly/JavaScript_interface/Module
#external
pub type WebAssemblyModule

///|
pub impl JsImpl for WebAssemblyModule

///|
/// WebAssembly.Instance represents an instantiated WebAssembly module
/// https://developer.mozilla.org/ja/docs/WebAssembly/JavaScript_interface/Instance
#external
pub type WebAssemblyInstance

///|
pub impl JsImpl for WebAssemblyInstance

///|
/// Get the exports object from a WebAssembly instance
pub fn WebAssemblyInstance::exports(self : Self) -> Js {
  self.get("exports")
}

///|
/// WebAssembly.Memory represents a resizable ArrayBuffer
/// https://developer.mozilla.org/ja/docs/WebAssembly/JavaScript_interface/Memory
#external
pub type WebAssemblyMemory

///|
pub impl JsImpl for WebAssemblyMemory

///|
/// Get the buffer from WebAssembly memory
pub fn WebAssemblyMemory::buffer(self : Self) -> ArrayBuffer {
  self.get("buffer") |> unsafe_cast
}

///|
/// Grow the memory by delta pages
pub fn WebAssemblyMemory::grow(self : Self, delta : Int) -> Int {
  self.call("grow", [delta]) |> unsafe_cast
}

///|
/// Memory descriptor for creating WebAssembly memory
pub(all) struct MemoryDescriptor {
  initial : Int
  maximum : Int?
  shared : Bool
}

///|
extern "js" fn ffi_new_memory(descriptor : Js) -> WebAssemblyMemory =
  #| (descriptor) => new WebAssembly.Memory(descriptor)

///|
/// Create a new WebAssembly memory
pub fn WebAssemblyMemory::new(
  descriptor : MemoryDescriptor,
) -> WebAssemblyMemory {
  ffi_new_memory(
    @js.from_entries_option([
      ("initial", Some(descriptor.initial)),
      ("maximum", descriptor.maximum.map(x => x)),
      ("shared", Some(descriptor.shared)),
    ]),
  )
}

///|
/// WebAssembly.Table represents a resizable typed array of references
#external
pub type WebAssemblyTable

///|
pub impl JsImpl for WebAssemblyTable

///|
/// Get the length of the table
pub fn WebAssemblyTable::length(self : Self) -> Int {
  self.get("length") |> unsafe_cast
}

///|
/// Set a value in the table at the given index
pub fn WebAssemblyTable::set(self : Self, index : Int, value : Js) -> Unit {
  ignore(self.call2("set", index, value))
}

///|
/// Grow the table by delta elements
pub fn WebAssemblyTable::grow(self : Self, delta : Int, value : Js) -> Int {
  self.call2("grow", delta, value) |> unsafe_cast
}

///|
/// Table descriptor for creating WebAssembly table
pub(all) struct TableDescriptor {
  element : String
  initial : Int
  maximum : Int?
}

///|
extern "js" fn ffi_new_table(descriptor : Js) -> WebAssemblyTable =
  #| (descriptor) => new WebAssembly.Table(descriptor)

///|
/// Create a new WebAssembly table
pub fn WebAssemblyTable::new(descriptor : TableDescriptor) -> WebAssemblyTable {
  ffi_new_table(
    @js.from_entries_option([
      ("element", Some(descriptor.element)),
      ("initial", Some(descriptor.initial)),
      ("maximum", descriptor.maximum.map(x => x)),
    ]),
  )
}

///|
/// WebAssembly.Global represents a global variable instance
#external
pub type WebAssemblyGlobal

///|
pub impl JsImpl for WebAssemblyGlobal

///|
/// Get the value of the global
pub fn WebAssemblyGlobal::value(self : Self) -> Js {
  self.get("value")
}

///|
/// Set the value of the global (only for mutable globals)
pub fn WebAssemblyGlobal::set_value(self : Self, value : Js) -> Unit {
  self.set("value", value)
}

///|
/// Global descriptor for creating WebAssembly global
pub(all) struct GlobalDescriptor {
  value : String // "i32", "i64", "f32", "f64"
  mutable : Bool
}

///|
extern "js" fn ffi_new_global(descriptor : Js, value : Js) -> WebAssemblyGlobal =
  #| (descriptor, value) => new WebAssembly.Global(descriptor, value)

///|
/// Create a new WebAssembly global
pub fn WebAssemblyGlobal::new(
  descriptor : GlobalDescriptor,
  value : Js,
) -> WebAssemblyGlobal {
  let obj = @js.from_map({
    "value": js(descriptor.value),
    "mutable": js(descriptor.mutable),
  })
  ffi_new_global(obj, value)
}

///|
extern "js" fn ffi_new_module(bytes : Js) -> WebAssemblyModule =
  #| (bytes) => new WebAssembly.Module(bytes)

///|
/// Compile a WebAssembly module from bytes
pub fn WebAssemblyModule::from_bytes(bytes : Uint8Array) -> WebAssemblyModule {
  ffi_new_module(bytes.to_js())
}

///|
/// Compile a WebAssembly module from ArrayBuffer
pub fn WebAssemblyModule::from_buffer(
  buffer : ArrayBuffer,
) -> WebAssemblyModule {
  ffi_new_module(buffer.to_js())
}

///|
extern "js" fn ffi_new_instance(
  wasm_module : WebAssemblyModule,
  import_object : Js,
) -> WebAssemblyInstance =
  #| (module, importObject) => new WebAssembly.Instance(module, importObject)

///|
/// Instantiate a WebAssembly module
pub fn WebAssemblyInstance::from_module(
  wasm_module : WebAssemblyModule,
  import_object : Js?,
) -> WebAssemblyInstance {
  let imports = match import_object {
    Some(obj) => obj
    None => @js.undefined()
  }
  ffi_new_instance(wasm_module, imports)
}

///|
extern "js" fn ffi_instantiate(bytes : Js, import_object : Js) -> Js =
  #| async (bytes, importObject) => await WebAssembly.instantiate(bytes, importObject)

///|
/// Compile and instantiate a WebAssembly module from bytes
pub fn instantiate_bytes(
  bytes : Uint8Array,
  import_object : Js?,
) -> (WebAssemblyModule, WebAssemblyInstance) {
  let imports = match import_object {
    Some(obj) => obj
    None => @js.undefined()
  }
  let result = ffi_instantiate(bytes.to_js(), imports)
  let wasm_module : WebAssemblyModule = result.get("module") |> unsafe_cast
  let instance : WebAssemblyInstance = result.get("instance") |> unsafe_cast
  (wasm_module, instance)
}

///|
/// Compile and instantiate a WebAssembly module from a module
pub fn instantiate_module(
  wasm_module : WebAssemblyModule,
  import_object : Js?,
) -> WebAssemblyInstance {
  let imports = match import_object {
    Some(obj) => obj
    None => @js.undefined()
  }
  ffi_instantiate(wasm_module.to_js(), imports) |> unsafe_cast
}

///|
extern "js" fn ffi_validate(bytes : Js) -> Bool =
  #| (bytes) => WebAssembly.validate(bytes)

///|
/// Validate WebAssembly bytes
pub fn validate(bytes : Uint8Array) -> Bool {
  ffi_validate(bytes.to_js())
}

///|
extern "js" fn ffi_compile(bytes : Js) -> Js =
  #| async (bytes) => await WebAssembly.compile(bytes)

///|
/// Compile a WebAssembly module (async)
pub fn compile(bytes : Uint8Array) -> Js {
  ffi_compile(bytes.to_js())
}
