///|
/// WebAssembly API for JavaScript environments
/// Based on WebAssembly JavaScript API specification
using @js {
  type Val,
  trait Js,
  js,
  unsafe_cast,
  new_empty_object,
  from_builtin_map,
}

///|
using @arraybuffer {type ArrayBuffer, type Uint8Array}

///|
/// WebAssembly.Module represents a compiled WebAssembly module
#external
pub type WebAssemblyModule

///|
pub impl Js for WebAssemblyModule with to_js(self) -> Val {
  self |> js
}

///|
/// WebAssembly.Instance represents an instantiated WebAssembly module
#external
pub type WebAssemblyInstance

///|
pub impl Js for WebAssemblyInstance with to_js(self) -> Val {
  self |> js
}

///|
/// Get the exports object from a WebAssembly instance
pub fn WebAssemblyInstance::exports(self : Self) -> Val {
  self.to_js().get("exports")
}

///|
/// WebAssembly.Memory represents a resizable ArrayBuffer
#external
pub type WebAssemblyMemory

///|
pub impl Js for WebAssemblyMemory with to_js(self) -> Val {
  self |> js
}

///|
/// Get the buffer from WebAssembly memory
pub fn WebAssemblyMemory::buffer(self : Self) -> ArrayBuffer {
  self.get("buffer") |> unsafe_cast
}

///|
/// Grow the memory by delta pages
pub fn WebAssemblyMemory::grow(self : Self, delta : Int) -> Int {
  self.invoke("grow", [js(delta)]) |> unsafe_cast
}

///|
/// Memory descriptor for creating WebAssembly memory
pub(all) struct MemoryDescriptor {
  initial : Int
  maximum : Int?
  shared : Bool
}

///|
extern "js" fn ffi_new_memory(descriptor : Val) -> WebAssemblyMemory =
  #| (descriptor) => new WebAssembly.Memory(descriptor)

///|
/// Create a new WebAssembly memory
pub fn WebAssemblyMemory::new(
  descriptor : MemoryDescriptor,
) -> WebAssemblyMemory {
  let obj = new_empty_object()
  obj["initial"] = js(descriptor.initial)
  match descriptor.maximum {
    Some(max) => obj["maximum"] = js(max)
    None => ()
  }
  obj["shared"] = js(descriptor.shared)
  ffi_new_memory(obj)
}

///|
/// WebAssembly.Table represents a resizable typed array of references
#external
pub type WebAssemblyTable

///|
pub impl Js for WebAssemblyTable with to_js(self) -> Val {
  self |> js
}

///|
/// Get the length of the table
pub fn WebAssemblyTable::length(self : Self) -> Int {
  self.to_js().get("length") |> unsafe_cast
}

///|
/// Get a value from the table at the given index
pub fn WebAssemblyTable::get(self : Self, index : Int) -> Val {
  self.to_js().invoke("get", [js(index)])
}

///|
/// Set a value in the table at the given index
pub fn WebAssemblyTable::set(self : Self, index : Int, value : Val) -> Unit {
  ignore(self.to_js().invoke("set", [js(index), value]))
}

///|
/// Grow the table by delta elements
pub fn WebAssemblyTable::grow(self : Self, delta : Int, value : Val) -> Int {
  self.to_js().invoke("grow", [js(delta), value]) |> unsafe_cast
}

///|
/// Table descriptor for creating WebAssembly table
pub(all) struct TableDescriptor {
  element : String
  initial : Int
  maximum : Int?
}

///|
extern "js" fn ffi_new_table(descriptor : Val) -> WebAssemblyTable =
  #| (descriptor) => new WebAssembly.Table(descriptor)

///|
/// Create a new WebAssembly table
pub fn WebAssemblyTable::new(descriptor : TableDescriptor) -> WebAssemblyTable {
  let obj = new_empty_object()
  obj["element"] = js(descriptor.element)
  obj["initial"] = js(descriptor.initial)
  match descriptor.maximum {
    Some(max) => obj["maximum"] = js(max)
    None => ()
  }
  ffi_new_table(obj)
}

///|
/// WebAssembly.Global represents a global variable instance
#external
pub type WebAssemblyGlobal

///|
pub impl Js for WebAssemblyGlobal with to_js(self) -> Val {
  self |> js
}

///|
/// Get the value of the global
pub fn WebAssemblyGlobal::value(self : Self) -> Val {
  self.get("value")
}

///|
/// Set the value of the global (only for mutable globals)
pub fn WebAssemblyGlobal::set_value(self : Self, value : Val) -> Unit {
  self.to_js()["value"] = value
}

///|
/// Global descriptor for creating WebAssembly global
pub(all) struct GlobalDescriptor {
  value : String // "i32", "i64", "f32", "f64"
  mutable : Bool
}

///|
extern "js" fn ffi_new_global(
  descriptor : Val,
  value : Val,
) -> WebAssemblyGlobal =
  #| (descriptor, value) => new WebAssembly.Global(descriptor, value)

///|
/// Create a new WebAssembly global
pub fn WebAssemblyGlobal::new(
  descriptor : GlobalDescriptor,
  value : Val,
) -> WebAssemblyGlobal {
  let obj = from_builtin_map({
    "value": js(descriptor.value),
    "mutable": js(descriptor.mutable),
  })
  ffi_new_global(obj, value)
}

///|
extern "js" fn ffi_new_module(bytes : Val) -> WebAssemblyModule =
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
  import_object : Val,
) -> WebAssemblyInstance =
  #| (module, importObject) => new WebAssembly.Instance(module, importObject)

///|
/// Instantiate a WebAssembly module
pub fn WebAssemblyInstance::from_module(
  wasm_module : WebAssemblyModule,
  import_object : Val?,
) -> WebAssemblyInstance {
  let imports = match import_object {
    Some(obj) => obj
    None => @js.undefined()
  }
  ffi_new_instance(wasm_module, imports)
}

///|
extern "js" fn ffi_instantiate(bytes : Val, import_object : Val) -> Val =
  #| async (bytes, importObject) => await WebAssembly.instantiate(bytes, importObject)

///|
/// Compile and instantiate a WebAssembly module from bytes
pub fn instantiate_bytes(
  bytes : Uint8Array,
  import_object : Val?,
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
  import_object : Val?,
) -> WebAssemblyInstance {
  let imports = match import_object {
    Some(obj) => obj
    None => @js.undefined()
  }
  ffi_instantiate(wasm_module.to_js(), imports) |> unsafe_cast
}

///|
extern "js" fn ffi_validate(bytes : Val) -> Bool =
  #| (bytes) => WebAssembly.validate(bytes)

///|
/// Validate WebAssembly bytes
pub fn validate(bytes : Uint8Array) -> Bool {
  ffi_validate(bytes.to_js())
}

///|
extern "js" fn ffi_compile(bytes : Val) -> Val =
  #| async (bytes) => await WebAssembly.compile(bytes)

///|
/// Compile a WebAssembly module (async)
pub fn compile(bytes : Uint8Array) -> Val {
  ffi_compile(bytes.to_js())
}
