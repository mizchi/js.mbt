// https://nodejs.org/api/v8.html
// Based on @types/node v8 definitions

///|
using @js {js, unsafe_cast, type Val, trait Js}

///|
using @arraybuffer {type ArrayBuffer}

///|
using @buffer {type Buffer}

///|
/// V8 Module FFI
extern "js" fn ffi_require_v8() -> Val =
  #|() => require("node:v8")

///| Heap Statistics Functions

///|
/// Get heap statistics
pub fn get_heap_statistics() -> Val {
  let v8 = ffi_require_v8()
  v8.invoke("getHeapStatistics", [])
}

///|
/// Get heap space statistics
pub fn get_heap_space_statistics() -> Array[Val] {
  let v8 = ffi_require_v8()
  unsafe_cast(v8.invoke("getHeapSpaceStatistics", []))
}

///|
/// Get heap code statistics
pub fn get_heap_code_statistics() -> Val {
  let v8 = ffi_require_v8()
  v8.invoke("getHeapCodeStatistics", [])
}

///|
/// Get heap snapshot as a readable stream
pub fn get_heap_snapshot(
  expose_internals? : Bool,
  expose_numeric_values? : Bool,
) -> Val {
  let v8 = ffi_require_v8()
  match (expose_internals, expose_numeric_values) {
    (None, None) => v8.invoke("getHeapSnapshot", [])
    _ => {
      let options = @js.new_empty_object()
      match expose_internals {
        Some(ei) => options.set("exposeInternals", ei)
        None => ()
      }
      match expose_numeric_values {
        Some(env) => options.set("exposeNumericValues", env)
        None => ()
      }
      v8.invoke("getHeapSnapshot", [options])
    }
  }
}

///|
/// Write heap snapshot to file
pub fn write_heap_snapshot(filename? : String) -> String {
  let v8 = ffi_require_v8()
  match filename {
    Some(f) => unsafe_cast(v8.invoke("writeHeapSnapshot", [f |> js]))
    None => unsafe_cast(v8.invoke("writeHeapSnapshot", []))
  }
}

///|
/// Set heap snapshot near heap limit
#alias(setHeapSnapshotNearHeapLimit)
pub fn set_heap_snapshot_near_heap_limit(limit : Int) -> Unit {
  let v8 = ffi_require_v8()
  v8.invoke("setHeapSnapshotNearHeapLimit", [limit |> js]) |> ignore
}

///| Serialization Functions

///|
/// Serialize a value to a Buffer
pub fn serialize(value : &Js) -> Buffer {
  let v8 = ffi_require_v8()
  unsafe_cast(v8.invoke("serialize", [value.to_js()]))
}

///|
/// Deserialize a Buffer to a value
pub fn deserialize(buffer : Buffer) -> Val {
  let v8 = ffi_require_v8()
  v8.invoke("deserialize", [buffer.to_js()])
}

///| Serializer Class

///|
#external
pub type Serializer

///|
pub impl Js for Serializer with to_js(self) -> Val {
  self |> js
}

///|
extern "js" fn ffi_new_serializer() -> Val =
  #|() => { const v8 = require("node:v8"); return new v8.Serializer(); }

///|
/// Create a new Serializer
pub fn Serializer::new() -> Serializer {
  unsafe_cast(ffi_new_serializer())
}

///|
/// Write header
#alias(writeHeader)
pub fn Serializer::write_header(self : Self) -> Unit {
  self.to_js().invoke("writeHeader", []) |> ignore
}

///|
/// Write a value
#alias(writeValue)
pub fn Serializer::write_value(self : Self, value : &Js) -> Bool {
  self.invoke("writeValue", [value.to_js()]) |> unsafe_cast
}

///|
/// Release buffer
#alias(releaseBuffer)
pub fn Serializer::release_buffer(self : Self) -> Buffer {
  self.invoke("releaseBuffer", []) |> unsafe_cast
}

///|
/// Transfer ArrayBuffer
#alias(transferArrayBuffer)
pub fn Serializer::transfer_array_buffer(
  self : Self,
  id : Int,
  array_buffer : ArrayBuffer,
) -> Unit {
  self.to_js().invoke("transferArrayBuffer", [id |> js, array_buffer.to_js()])
  |> ignore
}

///|
/// Write uint32
#alias(writeUint32)
pub fn Serializer::write_uint32(self : Self, value : Int) -> Unit {
  self.to_js().invoke("writeUint32", [value |> js]) |> ignore
}

///|
/// Write double
#alias(writeDouble)
pub fn Serializer::write_double(self : Self, value : Double) -> Unit {
  self.to_js().invoke("writeDouble", [value |> js]) |> ignore
}

///|
/// Write raw bytes
#alias(writeRawBytes)
pub fn Serializer::write_raw_bytes(self : Self, buffer : &Js) -> Unit {
  self.to_js().invoke("writeRawBytes", [buffer.to_js()]) |> ignore
}

///| Deserializer Class

///|
#external
pub type Deserializer

///|
pub impl Js for Deserializer with to_js(self) -> Val {
  self |> js
}

///|
extern "js" fn ffi_new_deserializer(buffer : Val) -> Val =
  #|(buffer) => { const v8 = require("node:v8"); return new v8.Deserializer(buffer); }

///|
/// Create a new Deserializer
pub fn Deserializer::new(buffer : Buffer) -> Deserializer {
  unsafe_cast(ffi_new_deserializer(buffer.to_js()))
}

///|
/// Read header
#alias(readHeader)
pub fn Deserializer::read_header(self : Self) -> Bool {
  self.invoke("readHeader", []) |> unsafe_cast
}

///|
/// Read a value
#alias(readValue)
pub fn Deserializer::read_value(self : Self) -> Val {
  self.to_js().invoke("readValue", [])
}

///|
/// Transfer ArrayBuffer
#alias(transferArrayBuffer)
pub fn Deserializer::transfer_array_buffer(
  self : Self,
  id : Int,
  array_buffer : ArrayBuffer,
) -> Unit {
  self.to_js().invoke("transferArrayBuffer", [id |> js, array_buffer.to_js()])
  |> ignore
}

///|
/// Get wire format version
#alias(getWireFormatVersion)
pub fn Deserializer::get_wire_format_version(self : Self) -> Int {
  self.invoke("getWireFormatVersion", []) |> unsafe_cast
}

///|
/// Read uint32
#alias(readUint32)
pub fn Deserializer::read_uint32(self : Self) -> Int {
  self.invoke("readUint32", []) |> unsafe_cast
}

///|
/// Read double
#alias(readDouble)
pub fn Deserializer::read_double(self : Self) -> Double {
  self.invoke("readDouble", []) |> unsafe_cast
}

///|
/// Read raw bytes
#alias(readRawBytes)
pub fn Deserializer::read_raw_bytes(self : Self, length : Int) -> Buffer {
  self.invoke("readRawBytes", [length |> js]) |> unsafe_cast
}

///| Utility Functions

///|
/// Get cached data version tag
#alias(cachedDataVersionTag)
pub fn cached_data_version_tag() -> Int {
  let v8 = ffi_require_v8()
  unsafe_cast(v8.invoke("cachedDataVersionTag", []))
}

///|
/// Set V8 flags from string
#alias(setFlagsFromString)
pub fn set_flags_from_string(flags : String) -> Unit {
  let v8 = ffi_require_v8()
  v8.invoke("setFlagsFromString", [flags |> js]) |> ignore
}

///|
/// Stop code coverage collection
#alias(stopCoverage)
pub fn stop_coverage() -> Unit {
  let v8 = ffi_require_v8()
  v8.invoke("stopCoverage", []) |> ignore
}

///|
/// Take code coverage snapshot
#alias(takeCoverage)
pub fn take_coverage() -> Unit {
  let v8 = ffi_require_v8()
  v8.invoke("takeCoverage", []) |> ignore
}
