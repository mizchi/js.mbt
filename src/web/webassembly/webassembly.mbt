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
pub fn WebAssemblyModule::as_any(self : WebAssemblyModule) -> @core.Any = "%identity"

///|
/// WebAssembly.Instance represents an instantiated WebAssembly module
/// https://developer.mozilla.org/ja/docs/WebAssembly/JavaScript_interface/Instance
#external
pub type WebAssemblyInstance

///|
pub fn WebAssemblyInstance::as_any(self : WebAssemblyInstance) -> @core.Any = "%identity"

///|
/// Get the exports object from a WebAssembly instance
pub fn WebAssemblyInstance::exports(self : Self) -> @core.Any {
  self.as_any()["exports"].cast()
}

///|
/// WebAssembly.Memory represents a resizable ArrayBuffer
/// https://developer.mozilla.org/ja/docs/WebAssembly/JavaScript_interface/Memory
#external
pub type WebAssemblyMemory

///|
pub fn WebAssemblyMemory::as_any(self : WebAssemblyMemory) -> @core.Any = "%identity"

///|
/// Get the buffer from WebAssembly memory
pub fn WebAssemblyMemory::buffer(self : Self) -> @arraybuffer.ArrayBuffer {
  self.as_any()["buffer"].cast()
}

///|
/// Grow the memory by delta pages
pub fn WebAssemblyMemory::grow(self : Self, delta : Int) -> Int {
  self.as_any()._call("grow", [@core.any(delta)]).cast()
}

///|
/// Memory descriptor for creating WebAssembly memory
pub(all) struct MemoryDescriptor {
  initial : Int
  maximum : Int?
  shared : Bool
}

///|
extern "js" fn ffi_new_memory(descriptor : @core.Any) -> WebAssemblyMemory =
  #| (descriptor) => new WebAssembly.Memory(descriptor)

///|
/// Create a new WebAssembly memory
pub fn WebAssemblyMemory::new(
  descriptor : MemoryDescriptor,
) -> WebAssemblyMemory {
  let entries : Array[(String, @core.Any)] = []
  entries.push(("initial", @core.any(descriptor.initial)))
  if descriptor.maximum is Some(v) {
    entries.push(("maximum", @core.any(v)))
  }
  entries.push(("shared", @core.any(descriptor.shared)))
  ffi_new_memory(@core.from_entries(entries).cast())
}

///|
/// WebAssembly.Table represents a resizable typed array of references
#external
pub type WebAssemblyTable

///|
pub fn WebAssemblyTable::as_any(self : WebAssemblyTable) -> @core.Any = "%identity"

///|
/// Get the length of the table
pub fn WebAssemblyTable::length(self : Self) -> Int {
  self.as_any()["length"].cast()
}

///|
/// Set a value in the table at the given index
pub fn WebAssemblyTable::set(
  self : Self,
  index : Int,
  value : @core.Any,
) -> Unit {
  ignore(self.as_any()._call("set", [@core.any(index), @core.any(value)]))
}

///|
/// Grow the table by delta elements
pub fn WebAssemblyTable::grow(
  self : Self,
  delta : Int,
  value : @core.Any,
) -> Int {
  self.as_any()._call("grow", [@core.any(delta), @core.any(value)]).cast()
}

///|
/// Table descriptor for creating WebAssembly table
pub(all) struct TableDescriptor {
  element : String
  initial : Int
  maximum : Int?
}

///|
extern "js" fn ffi_new_table(descriptor : @core.Any) -> WebAssemblyTable =
  #| (descriptor) => new WebAssembly.Table(descriptor)

///|
/// Create a new WebAssembly table
pub fn WebAssemblyTable::new(descriptor : TableDescriptor) -> WebAssemblyTable {
  let entries : Array[(String, @core.Any)] = []
  entries.push(("element", @core.any(descriptor.element)))
  entries.push(("initial", @core.any(descriptor.initial)))
  if descriptor.maximum is Some(v) {
    entries.push(("maximum", @core.any(v)))
  }
  ffi_new_table(@core.from_entries(entries).cast())
}

///|
/// WebAssembly.Global represents a global variable instance
#external
pub type WebAssemblyGlobal

///|
pub fn WebAssemblyGlobal::as_any(self : WebAssemblyGlobal) -> @core.Any = "%identity"

///|
/// Get the value of the global
pub fn WebAssemblyGlobal::value(self : Self) -> @core.Any {
  self.as_any()["value"].cast()
}

///|
/// Set the value of the global (only for mutable globals)
pub fn WebAssemblyGlobal::set_value(self : Self, value : @core.Any) -> Unit {
  self.as_any()["value"] = @core.any(value)
}

///|
/// Global descriptor for creating WebAssembly global
pub(all) struct GlobalDescriptor {
  value : String // "i32", "i64", "f32", "f64"
  mutable : Bool
}

///|
extern "js" fn ffi_new_global(
  descriptor : @core.Any,
  value : @core.Any,
) -> WebAssemblyGlobal =
  #| (descriptor, value) => new WebAssembly.Global(descriptor, value)

///|
/// Create a new WebAssembly global
pub fn WebAssemblyGlobal::new(
  descriptor : GlobalDescriptor,
  value : @core.Any,
) -> WebAssemblyGlobal {
  let obj : @core.Any = @core.from_entries([
    ("value", @core.any(descriptor.value)),
    ("mutable", @core.any(descriptor.mutable)),
  ]).cast()
  ffi_new_global(obj, value)
}

///|
extern "js" fn ffi_new_module(bytes : @core.Any) -> WebAssemblyModule =
  #| (bytes) => new WebAssembly.Module(bytes)

///|
/// Compile a WebAssembly module from bytes
pub fn WebAssemblyModule::from_bytes(
  bytes : @arraybuffer.Uint8Array,
) -> WebAssemblyModule {
  ffi_new_module(@core.any(bytes))
}

///|
/// Compile a WebAssembly module from ArrayBuffer
pub fn WebAssemblyModule::from_buffer(
  buffer : @arraybuffer.ArrayBuffer,
) -> WebAssemblyModule {
  ffi_new_module(@core.any(buffer))
}

///|
extern "js" fn ffi_new_instance(
  wasm_module : WebAssemblyModule,
  import_object : @core.Any,
) -> WebAssemblyInstance =
  #| (module, importObject) => new WebAssembly.Instance(module, importObject)

///|
/// Instantiate a WebAssembly module
pub fn WebAssemblyInstance::from_module(
  wasm_module : WebAssemblyModule,
  import_object : @core.Any?,
) -> WebAssemblyInstance {
  let imports = match import_object {
    Some(obj) => obj
    None => @global.undefined()
  }
  ffi_new_instance(wasm_module, imports)
}

///|
extern "js" fn ffi_instantiate(
  bytes : @core.Any,
  import_object : @core.Any,
) -> @core.Any =
  #| async (bytes, importObject) => await WebAssembly.instantiate(bytes, importObject)

///|
/// Compile and instantiate a WebAssembly module from bytes
pub fn instantiate_bytes(
  bytes : @arraybuffer.Uint8Array,
  import_object : @core.Any?,
) -> (WebAssemblyModule, WebAssemblyInstance) {
  let imports = match import_object {
    Some(obj) => obj
    None => @global.undefined()
  }
  let result = ffi_instantiate(bytes.as_any(), imports)
  let wasm_module : WebAssemblyModule = result._get("module").cast()
  let instance : WebAssemblyInstance = result._get("instance").cast()
  (wasm_module, instance)
}

///|
/// Compile and instantiate a WebAssembly module from a module
pub fn instantiate_module(
  wasm_module : WebAssemblyModule,
  import_object : @core.Any?,
) -> WebAssemblyInstance {
  let imports = match import_object {
    Some(obj) => obj
    None => @global.undefined()
  }
  ffi_instantiate(wasm_module.as_any().cast(), imports).cast()
}

///|
/// Validate WebAssembly bytes
pub extern "js" fn validate(bytes : @arraybuffer.Uint8Array) -> Bool =
  #| (bytes) => WebAssembly.validate(bytes)

///|
/// Compile a WebAssembly module (async)
pub extern "js" fn compile(bytes : @arraybuffer.Uint8Array) -> @core.Any =
  #| async (bytes) => await WebAssembly.compile(bytes)
