// https://nodejs.org/api/v8.html
// Based on @types/node v8 definitions

///|
/// V8 Module FFI
extern "js" fn ffi_require_v8() -> Js =
  #|() => require("node:v8")

///| Heap Statistics Functions

///|
/// Get heap statistics
#alias(get_heap_statistics)
pub fn getHeapStatistics() -> Js {
  let v8 = ffi_require_v8()
  v8.call0("getHeapStatistics")
}

///|
/// Get heap space statistics
#alias(get_heap_space_statistics)
pub fn getHeapSpaceStatistics() -> Array[Js] {
  let v8 = ffi_require_v8()
  v8.call0("getHeapSpaceStatistics") |> unsafe_cast
}

///|
/// Get heap code statistics
#alias(get_heap_code_statistics)
pub fn getHeapCodeStatistics() -> Js {
  let v8 = ffi_require_v8()
  v8.call0("getHeapCodeStatistics")
}

///|
/// Get heap snapshot as a readable stream
#alias(get_heap_snapshot)
pub fn getHeapSnapshot(
  expose_internals? : Bool,
  expose_numeric_values? : Bool,
) -> Js {
  let v8 = ffi_require_v8()
  match (expose_internals, expose_numeric_values) {
    (None, None) => v8.call0("getHeapSnapshot")
    _ =>
      v8.call("getHeapSnapshot", [
        @js.from_entries_option_cast([
          ("exposeInternals", expose_internals),
          ("exposeNumericValues", expose_numeric_values),
        ]),
      ])
  }
}

///|
/// Write heap snapshot to file
#alias(write_heap_snapshot)
pub fn writeHeapSnapshot(filename? : String) -> String {
  let v8 = ffi_require_v8()
  match filename {
    Some(f) => unsafe_cast(v8.call("writeHeapSnapshot", [f]))
    None => v8.call0("writeHeapSnapshot") |> unsafe_cast
  }
}

///|
/// Set heap snapshot near heap limit
#alias(set_heap_snapshot_near_heap_limit)
pub fn setHeapSnapshotNearHeapLimit(limit : Int) -> Unit {
  let v8 = ffi_require_v8()
  v8.call("setHeapSnapshotNearHeapLimit", [limit]) |> ignore
}

///| Serialization Functions

///|
/// Serialize a value to a Buffer
pub fn serialize(value : &JsImpl) -> Buffer {
  let v8 = ffi_require_v8()
  unsafe_cast(v8.call("serialize", [value.to_js()]))
}

///|
/// Deserialize a Buffer to a value
pub fn deserialize(buffer : Buffer) -> Js {
  let v8 = ffi_require_v8()
  v8.call("deserialize", [buffer.to_js()])
}

///| Serializer Class

///|
#external
pub type Serializer

///|
pub impl JsImpl for Serializer

///|
extern "js" fn ffi_new_serializer() -> Js =
  #|() => { const v8 = require("node:v8"); return new v8.Serializer(); }

///|
/// Create a new Serializer
pub fn Serializer::new() -> Serializer {
  unsafe_cast(ffi_new_serializer())
}

///|
/// Write header
#alias(write_header)
pub fn Serializer::writeHeader(self : Self) -> Unit {
  self.call0("writeHeader") |> ignore
}

///|
/// Write a value
#alias(write_value)
pub fn Serializer::writeValue(self : Self, value : &JsImpl) -> Bool {
  self.call("writeValue", [value.to_js()]) |> unsafe_cast
}

///|
/// Release buffer
#alias(release_buffer)
pub fn Serializer::releaseBuffer(self : Self) -> Buffer {
  self.call0("releaseBuffer") |> unsafe_cast
}

///|
/// Transfer ArrayBuffer
#alias(transfer_array_buffer)
pub fn Serializer::transferArrayBuffer(
  self : Self,
  id : Int,
  array_buffer : ArrayBuffer,
) -> Unit {
  self.call2("transferArrayBuffer", id, array_buffer) |> ignore
}

///|
/// Write uint32
#alias(writeUint32)
pub fn Serializer::write_uint32(self : Self, value : Int) -> Unit {
  self.call("writeUint32", [value]) |> ignore
}

///|
/// Write double
#alias(writeDouble)
pub fn Serializer::write_double(self : Self, value : Double) -> Unit {
  self.call("writeDouble", [value]) |> ignore
}

///|
/// Write raw bytes
#alias(writeRawBytes)
pub fn Serializer::write_raw_bytes(self : Self, buffer : &JsImpl) -> Unit {
  self.call("writeRawBytes", [buffer.to_js()]) |> ignore
}

///| Deserializer Class

///|
#external
pub type Deserializer

///|
pub impl JsImpl for Deserializer

///|
extern "js" fn ffi_new_deserializer(buffer : Js) -> Js =
  #|(buffer) => { const v8 = require("node:v8"); return new v8.Deserializer(buffer); }

///|
/// Create a new Deserializer
pub fn Deserializer::new(buffer : Buffer) -> Deserializer {
  unsafe_cast(ffi_new_deserializer(buffer.to_js()))
}

///|
/// Read header
#alias(read_header)
pub fn Deserializer::readHeader(self : Self) -> Bool {
  self.call0("readHeader") |> unsafe_cast
}

///|
/// Read a value
#alias(read_value)
pub fn Deserializer::readValue(self : Self) -> Js {
  self.call0("readValue")
}

///|
/// Transfer ArrayBuffer
#alias(transferArrayBuffer)
pub fn Deserializer::transfer_array_buffer(
  self : Self,
  id : Int,
  array_buffer : ArrayBuffer,
) -> Unit {
  self.call2("transferArrayBuffer", id, array_buffer) |> ignore
}

///|
/// Get wire format version
#alias(get_wire_format_version)
pub fn Deserializer::getWireFormatVersion(self : Self) -> Int {
  self.call0("getWireFormatVersion") |> unsafe_cast
}

///|
/// Read uint32
#alias(read_uint32)
pub fn Deserializer::readUint32(self : Self) -> Int {
  self.call0("readUint32") |> unsafe_cast
}

///|
/// Read double
#alias(read_double)
pub fn Deserializer::readDouble(self : Self) -> Double {
  self.call0("readDouble") |> unsafe_cast
}

///|
/// Read raw bytes
#alias(read_raw_bytes)
pub fn Deserializer::readRawBytes(self : Self, length : Int) -> Buffer {
  self.call("readRawBytes", [length]) |> unsafe_cast
}

///| Utility Functions

///|
/// Get cached data version tag
#alias(cached_data_version_tag)
pub fn cachedDataVersionTag() -> Int {
  let v8 = ffi_require_v8()
  v8.call0("cachedDataVersionTag") |> unsafe_cast
}

///|
/// Set V8 flags from string
#alias(set_flags_from_string)
pub fn setFlagsFromString(flags : String) -> Unit {
  let v8 = ffi_require_v8()
  v8.call("setFlagsFromString", [flags]) |> ignore
}

///|
/// Stop code coverage collection
#alias(stop_coverage)
pub fn stopCoverage() -> Unit {
  let v8 = ffi_require_v8()
  v8.call0("stopCoverage") |> ignore
}

///|
/// Take code coverage snapshot
#alias(take_coverage)
pub fn takeCoverage() -> Unit {
  let v8 = ffi_require_v8()
  v8.call0("takeCoverage") |> ignore
}
