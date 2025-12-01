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
pub fn WebAssemblyModule::as_any(self : WebAssemblyModule) -> @nostd.Any = "%identity"

///|
/// WebAssembly.Instance represents an instantiated WebAssembly module
/// https://developer.mozilla.org/ja/docs/WebAssembly/JavaScript_interface/Instance
#external
pub type WebAssemblyInstance

///|
pub fn WebAssemblyInstance::as_any(self : WebAssemblyInstance) -> @nostd.Any = "%identity"

///|
/// Get the exports object from a WebAssembly instance
pub fn WebAssemblyInstance::exports(self : Self) -> @js.Any {
  self.as_any()["exports"].cast()
}

///|
/// WebAssembly.Memory represents a resizable ArrayBuffer
/// https://developer.mozilla.org/ja/docs/WebAssembly/JavaScript_interface/Memory
#external
pub type WebAssemblyMemory

///|
pub fn WebAssemblyMemory::as_any(self : WebAssemblyMemory) -> @nostd.Any = "%identity"

///|
/// Get the buffer from WebAssembly memory
pub fn WebAssemblyMemory::buffer(self : Self) -> @js.ArrayBuffer {
  self.as_any()["buffer"].cast()
}

///|
/// Grow the memory by delta pages
pub fn WebAssemblyMemory::grow(self : Self, delta : Int) -> Int {
  self.as_any()._call("grow", [@nostd.any(delta)]).cast()
}

///|
/// Memory descriptor for creating WebAssembly memory
pub(all) struct MemoryDescriptor {
  initial : Int
  maximum : Int?
  shared : Bool
}

///|
extern "js" fn ffi_new_memory(descriptor : @js.Any) -> WebAssemblyMemory =
  #| (descriptor) => new WebAssembly.Memory(descriptor)

///|
/// Create a new WebAssembly memory
pub fn WebAssemblyMemory::new(
  descriptor : MemoryDescriptor,
) -> WebAssemblyMemory {
  ffi_new_memory(
    @mbtconv.from_option_map({
      "initial": Some(@nostd.any(descriptor.initial)),
      "maximum": descriptor.maximum.map(fn(x) { @nostd.any(x) }),
      "shared": Some(@nostd.any(descriptor.shared)),
    }).cast(),
  )
}

///|
/// WebAssembly.Table represents a resizable typed array of references
#external
pub type WebAssemblyTable

///|
pub fn WebAssemblyTable::as_any(self : WebAssemblyTable) -> @nostd.Any = "%identity"

///|
/// Get the length of the table
pub fn WebAssemblyTable::length(self : Self) -> Int {
  self.as_any()["length"].cast()
}

///|
/// Set a value in the table at the given index
pub fn WebAssemblyTable::set(self : Self, index : Int, value : @js.Any) -> Unit {
  ignore(self.as_any()._call("set", [@nostd.any(index), @nostd.any(value)]))
}

///|
/// Grow the table by delta elements
pub fn WebAssemblyTable::grow(self : Self, delta : Int, value : @js.Any) -> Int {
  self.as_any()._call("grow", [@nostd.any(delta), @nostd.any(value)]).cast()
}

///|
/// Table descriptor for creating WebAssembly table
pub(all) struct TableDescriptor {
  element : String
  initial : Int
  maximum : Int?
}

///|
extern "js" fn ffi_new_table(descriptor : @js.Any) -> WebAssemblyTable =
  #| (descriptor) => new WebAssembly.Table(descriptor)

///|
/// Create a new WebAssembly table
pub fn WebAssemblyTable::new(descriptor : TableDescriptor) -> WebAssemblyTable {
  ffi_new_table(
    @mbtconv.from_option_map({
      "element": Some(@nostd.any(descriptor.element)),
      "initial": Some(@nostd.any(descriptor.initial)),
      "maximum": descriptor.maximum.map(fn(x) { @nostd.any(x) }),
    }).cast(),
  )
}

///|
/// WebAssembly.Global represents a global variable instance
#external
pub type WebAssemblyGlobal

///|
pub fn WebAssemblyGlobal::as_any(self : WebAssemblyGlobal) -> @nostd.Any = "%identity"

///|
/// Get the value of the global
pub fn WebAssemblyGlobal::value(self : Self) -> @js.Any {
  self.as_any()["value"].cast()
}

///|
/// Set the value of the global (only for mutable globals)
pub fn WebAssemblyGlobal::set_value(self : Self, value : @js.Any) -> Unit {
  self.as_any()["value"] = @nostd.any(value)
}

///|
/// Global descriptor for creating WebAssembly global
pub(all) struct GlobalDescriptor {
  value : String // "i32", "i64", "f32", "f64"
  mutable : Bool
}

///|
extern "js" fn ffi_new_global(
  descriptor : @js.Any,
  value : @js.Any,
) -> WebAssemblyGlobal =
  #| (descriptor, value) => new WebAssembly.Global(descriptor, value)

///|
/// Create a new WebAssembly global
pub fn WebAssemblyGlobal::new(
  descriptor : GlobalDescriptor,
  value : @js.Any,
) -> WebAssemblyGlobal {
  let obj : @js.Any = @mbtconv.from_map({
    "value": @nostd.any(descriptor.value),
    "mutable": @nostd.any(descriptor.mutable),
  }).cast()
  ffi_new_global(obj, value)
}

///|
extern "js" fn ffi_new_module(bytes : @js.Any) -> WebAssemblyModule =
  #| (bytes) => new WebAssembly.Module(bytes)

///|
/// Compile a WebAssembly module from bytes
pub fn WebAssemblyModule::from_bytes(
  bytes : @typedarray.Uint8Array,
) -> WebAssemblyModule {
  ffi_new_module(bytes.as_any())
}

///|
/// Compile a WebAssembly module from ArrayBuffer
pub fn WebAssemblyModule::from_buffer(
  buffer : @js.ArrayBuffer,
) -> WebAssemblyModule {
  ffi_new_module(buffer.as_any())
}

///|
extern "js" fn ffi_new_instance(
  wasm_module : WebAssemblyModule,
  import_object : @js.Any,
) -> WebAssemblyInstance =
  #| (module, importObject) => new WebAssembly.Instance(module, importObject)

///|
/// Instantiate a WebAssembly module
pub fn WebAssemblyInstance::from_module(
  wasm_module : WebAssemblyModule,
  import_object : @js.Any?,
) -> WebAssemblyInstance {
  let imports = match import_object {
    Some(obj) => obj
    None => @global.undefined()
  }
  ffi_new_instance(wasm_module, imports)
}

///|
extern "js" fn ffi_instantiate(
  bytes : @js.Any,
  import_object : @js.Any,
) -> @js.Any =
  #| async (bytes, importObject) => await WebAssembly.instantiate(bytes, importObject)

///|
/// Compile and instantiate a WebAssembly module from bytes
pub fn instantiate_bytes(
  bytes : @typedarray.Uint8Array,
  import_object : @js.Any?,
) -> (WebAssemblyModule, WebAssemblyInstance) {
  let imports = match import_object {
    Some(obj) => obj
    None => @global.undefined()
  }
  let result = ffi_instantiate(bytes.as_any(), imports)
  let wasm_module : WebAssemblyModule = result.get("module").cast()
  let instance : WebAssemblyInstance = result.get("instance").cast()
  (wasm_module, instance)
}

///|
/// Compile and instantiate a WebAssembly module from a module
pub fn instantiate_module(
  wasm_module : WebAssemblyModule,
  import_object : @js.Any?,
) -> WebAssemblyInstance {
  let imports = match import_object {
    Some(obj) => obj
    None => @global.undefined()
  }
  ffi_instantiate(wasm_module.as_any().cast(), imports).cast()
}

///|
extern "js" fn ffi_validate(bytes : @js.Any) -> Bool =
  #| (bytes) => WebAssembly.validate(bytes)

///|
/// Validate WebAssembly bytes
pub fn validate(bytes : @typedarray.Uint8Array) -> Bool {
  ffi_validate(bytes.as_any())
}

///|
extern "js" fn ffi_compile(bytes : @js.Any) -> @js.Any =
  #| async (bytes) => await WebAssembly.compile(bytes)

///|
/// Compile a WebAssembly module (async)
pub fn compile(bytes : @typedarray.Uint8Array) -> @js.Any {
  ffi_compile(bytes.as_any())
}
