// https://nodejs.org/api/v8.html
// Based on @types/node v8 definitions

///|
/// V8 Module FFI
extern "js" fn ffi_require_v8() -> @js.Any =
  #|() => require("node:v8")

///|
/// HeapStatistics - Result of getHeapStatistics()
#external
pub type HeapStatistics

///|
pub impl @js.JsImpl for HeapStatistics

///|
pub fn HeapStatistics::total_heap_size(self : HeapStatistics) -> Int {
  self.get("total_heap_size") |> @js.identity
}

///|
pub fn HeapStatistics::total_heap_size_executable(self : HeapStatistics) -> Int {
  self.get("total_heap_size_executable") |> @js.identity
}

///|
pub fn HeapStatistics::total_physical_size(self : HeapStatistics) -> Int {
  self.get("total_physical_size") |> @js.identity
}

///|
pub fn HeapStatistics::total_available_size(self : HeapStatistics) -> Int {
  self.get("total_available_size") |> @js.identity
}

///|
pub fn HeapStatistics::used_heap_size(self : HeapStatistics) -> Int {
  self.get("used_heap_size") |> @js.identity
}

///|
pub fn HeapStatistics::heap_size_limit(self : HeapStatistics) -> Int {
  self.get("heap_size_limit") |> @js.identity
}

///|
pub fn HeapStatistics::malloced_memory(self : HeapStatistics) -> Int {
  self.get("malloced_memory") |> @js.identity
}

///|
pub fn HeapStatistics::peak_malloced_memory(self : HeapStatistics) -> Int {
  self.get("peak_malloced_memory") |> @js.identity
}

///|
pub fn HeapStatistics::does_zap_garbage(self : HeapStatistics) -> Int {
  self.get("does_zap_garbage") |> @js.identity
}

///|
pub fn HeapStatistics::number_of_native_contexts(self : HeapStatistics) -> Int {
  self.get("number_of_native_contexts") |> @js.identity
}

///|
pub fn HeapStatistics::number_of_detached_contexts(
  self : HeapStatistics,
) -> Int {
  self.get("number_of_detached_contexts") |> @js.identity
}

///|
pub fn HeapStatistics::external_memory(self : HeapStatistics) -> Int {
  self.get("external_memory") |> @js.identity
}

///|
/// HeapCodeStatistics - Result of getHeapCodeStatistics()
#external
pub type HeapCodeStatistics

///|
pub impl @js.JsImpl for HeapCodeStatistics

///|
pub fn HeapCodeStatistics::code_and_metadata_size(
  self : HeapCodeStatistics,
) -> Int {
  self.get("code_and_metadata_size") |> @js.identity
}

///|
pub fn HeapCodeStatistics::bytecode_and_metadata_size(
  self : HeapCodeStatistics,
) -> Int {
  self.get("bytecode_and_metadata_size") |> @js.identity
}

///|
pub fn HeapCodeStatistics::external_script_source_size(
  self : HeapCodeStatistics,
) -> Int {
  self.get("external_script_source_size") |> @js.identity
}

///|
pub fn HeapCodeStatistics::cpu_profiler_metadata_size(
  self : HeapCodeStatistics,
) -> Int {
  self.get("cpu_profiler_metadata_size") |> @js.identity
}

///|
/// HeapSpaceStatistics - Element of getHeapSpaceStatistics() array
#external
pub type HeapSpaceStatistics

///|
pub impl @js.JsImpl for HeapSpaceStatistics

///|
pub fn HeapSpaceStatistics::space_name(self : HeapSpaceStatistics) -> String {
  self.get("space_name") |> @js.identity
}

///|
pub fn HeapSpaceStatistics::space_size(self : HeapSpaceStatistics) -> Int {
  self.get("space_size") |> @js.identity
}

///|
pub fn HeapSpaceStatistics::space_used_size(self : HeapSpaceStatistics) -> Int {
  self.get("space_used_size") |> @js.identity
}

///|
pub fn HeapSpaceStatistics::space_available_size(
  self : HeapSpaceStatistics,
) -> Int {
  self.get("space_available_size") |> @js.identity
}

///|
pub fn HeapSpaceStatistics::physical_space_size(
  self : HeapSpaceStatistics,
) -> Int {
  self.get("physical_space_size") |> @js.identity
}

///| Heap Statistics Functions

///|
/// Get heap statistics
#alias(get_heap_statistics)
pub fn getHeapStatistics() -> HeapStatistics {
  let v8 = ffi_require_v8()
  v8.call0("getHeapStatistics").cast()
}

///|
/// Get heap space statistics
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(get_heap_space_statistics)
pub fn getHeapSpaceStatistics() -> Array[HeapSpaceStatistics] {
  let v8 = ffi_require_v8()
  v8.call0("getHeapSpaceStatistics") |> @js.identity
}

///|
/// Get heap code statistics
#alias(get_heap_code_statistics)
pub fn getHeapCodeStatistics() -> HeapCodeStatistics {
  let v8 = ffi_require_v8()
  v8.call0("getHeapCodeStatistics").cast()
}

///|
/// Get heap snapshot as a readable stream
#alias(get_heap_snapshot)
pub fn getHeapSnapshot(
  expose_internals? : Bool,
  expose_numeric_values? : Bool,
) -> @js.Any {
  let v8 = ffi_require_v8()
  match (expose_internals, expose_numeric_values) {
    (None, None) => v8.call0("getHeapSnapshot")
    _ =>
      v8.call("getHeapSnapshot", [
        @js.from_option_map({
          "exposeInternals": expose_internals.map(fn(x) { @js.any(x) }),
          "exposeNumericValues": expose_numeric_values.map(fn(x) { @js.any(x) }),
        }),
      ])
  }
}

///|
/// Write heap snapshot to file
#alias(write_heap_snapshot)
pub fn writeHeapSnapshot(filename? : String) -> String {
  let v8 = ffi_require_v8()
  match filename {
    Some(f) => @js.identity(v8.call("writeHeapSnapshot", [f]))
    None => v8.call0("writeHeapSnapshot").cast()
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
pub fn serialize(value : &@js.JsImpl) -> @buffer.Buffer {
  let v8 = ffi_require_v8()
  @js.identity(v8.call("serialize", [value.as_any()]))
}

///|
/// Deserialize a Buffer to a value
pub fn deserialize(buffer : @buffer.Buffer) -> @js.Any {
  let v8 = ffi_require_v8()
  v8.call("deserialize", [buffer])
}

///| Serializer Class

///|
#external
pub type Serializer

///|
pub impl @js.JsImpl for Serializer

///|
extern "js" fn ffi_new_serializer() -> @js.Any =
  #|() => { const v8 = require("node:v8"); return new v8.Serializer(); }

///|
/// Create a new Serializer
pub fn Serializer::new() -> Serializer {
  @js.identity(ffi_new_serializer())
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
pub fn Serializer::writeValue(self : Self, value : &@js.JsImpl) -> Bool {
  self.call("writeValue", [value.as_any()]).cast()
}

///|
/// Release buffer
#alias(release_buffer)
pub fn Serializer::releaseBuffer(self : Self) -> @buffer.Buffer {
  self.call0("releaseBuffer").cast()
}

///|
/// Transfer ArrayBuffer
#alias(transfer_array_buffer)
pub fn Serializer::transferArrayBuffer(
  self : Self,
  id : Int,
  array_buffer : @js.ArrayBuffer,
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
pub fn Serializer::write_raw_bytes(self : Self, buffer : &@js.JsImpl) -> Unit {
  self.call("writeRawBytes", [buffer.as_any()]) |> ignore
}

///| Deserializer Class

///|
#external
pub type Deserializer

///|
pub impl @js.JsImpl for Deserializer

///|
extern "js" fn ffi_new_deserializer(buffer : @js.Any) -> @js.Any =
  #|(buffer) => { const v8 = require("node:v8"); return new v8.Deserializer(buffer); }

///|
extern "js" fn buffer_to_js_any(buffer : @buffer.Buffer) -> @js.Any =
  #| (b) => b

///|
/// Create a new Deserializer
pub fn Deserializer::new(buffer : @buffer.Buffer) -> Deserializer {
  @js.identity(ffi_new_deserializer(buffer_to_js_any(buffer)))
}

///|
/// Read header
#alias(read_header)
pub fn Deserializer::readHeader(self : Self) -> Bool {
  self.call0("readHeader").cast()
}

///|
/// Read a value
#alias(read_value)
pub fn Deserializer::readValue(self : Self) -> @js.Any {
  self.call0("readValue")
}

///|
/// Transfer ArrayBuffer
#alias(transferArrayBuffer)
pub fn Deserializer::transfer_array_buffer(
  self : Self,
  id : Int,
  array_buffer : @js.ArrayBuffer,
) -> Unit {
  self.call2("transferArrayBuffer", id, array_buffer) |> ignore
}

///|
/// Get wire format version
#alias(get_wire_format_version)
pub fn Deserializer::getWireFormatVersion(self : Self) -> Int {
  self.call0("getWireFormatVersion").cast()
}

///|
/// Read uint32
#alias(read_uint32)
pub fn Deserializer::readUint32(self : Self) -> Int {
  self.call0("readUint32").cast()
}

///|
/// Read double
#alias(read_double)
pub fn Deserializer::readDouble(self : Self) -> Double {
  self.call0("readDouble").cast()
}

///|
/// Read raw bytes
#alias(read_raw_bytes)
pub fn Deserializer::readRawBytes(self : Self, length : Int) -> @buffer.Buffer {
  self.call("readRawBytes", [length]).cast()
}

///| Utility Functions

///|
/// Get cached data version tag
#alias(cached_data_version_tag)
pub fn cachedDataVersionTag() -> Int {
  let v8 = ffi_require_v8()
  v8.call0("cachedDataVersionTag").cast()
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
