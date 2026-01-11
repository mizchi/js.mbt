// https://nodejs.org/api/v8.html
// Based on @types/node v8 definitions

///|
/// V8 Module FFI
#module("node:v8")
extern "js" fn ffi_get_heap_statistics() -> HeapStatistics = "getHeapStatistics"

///|
#module("node:v8")
extern "js" fn ffi_get_heap_space_statistics() -> Array[HeapSpaceStatistics] = "getHeapSpaceStatistics"

///|
#module("node:v8")
extern "js" fn ffi_get_heap_code_statistics() -> HeapCodeStatistics = "getHeapCodeStatistics"

///|
#module("node:v8")
extern "js" fn ffi_write_heap_snapshot0() -> String = "writeHeapSnapshot"

///|
#module("node:v8")
extern "js" fn ffi_write_heap_snapshot1(filename : String) -> String = "writeHeapSnapshot"

///|
#module("node:v8")
extern "js" fn ffi_set_heap_snapshot_near_heap_limit(limit : Int) -> Unit = "setHeapSnapshotNearHeapLimit"

///|
#module("node:v8")
extern "js" fn ffi_serialize(value : @core.Any) -> @buffer.Buffer = "serialize"

///|
#module("node:v8")
extern "js" fn ffi_deserialize(buffer : @buffer.Buffer) -> @core.Any = "deserialize"

///|
#module("node:v8")
extern "js" fn ffi_cached_data_version_tag() -> Int = "cachedDataVersionTag"

///|
#module("node:v8")
extern "js" fn ffi_set_flags_from_string(flags : String) -> Unit = "setFlagsFromString"

///|
#module("node:v8")
extern "js" fn ffi_stop_coverage() -> Unit = "stopCoverage"

///|
#module("node:v8")
extern "js" fn ffi_take_coverage() -> Unit = "takeCoverage"

///|
extern "js" fn ffi_new_serializer() -> @core.Any =
  #|() => { const v8 = require("node:v8"); return new v8.Serializer(); }

///|
extern "js" fn ffi_new_deserializer(buffer : @core.Any) -> @core.Any =
  #|(buffer) => { const v8 = require("node:v8"); return new v8.Deserializer(buffer); }

///|
/// HeapStatistics - Result of getHeapStatistics()
#external
pub type HeapStatistics

///|
pub fn HeapStatistics::as_any(self : HeapStatistics) -> @core.Any = "%identity"

///|
pub fn HeapStatistics::total_heap_size(self : HeapStatistics) -> Int {
  self.as_any()._get("total_heap_size") |> @core.identity
}

///|
pub fn HeapStatistics::total_heap_size_executable(self : HeapStatistics) -> Int {
  self.as_any()._get("total_heap_size_executable") |> @core.identity
}

///|
pub fn HeapStatistics::total_physical_size(self : HeapStatistics) -> Int {
  self.as_any()._get("total_physical_size") |> @core.identity
}

///|
pub fn HeapStatistics::total_available_size(self : HeapStatistics) -> Int {
  self.as_any()._get("total_available_size") |> @core.identity
}

///|
pub fn HeapStatistics::used_heap_size(self : HeapStatistics) -> Int {
  self.as_any()._get("used_heap_size") |> @core.identity
}

///|
pub fn HeapStatistics::heap_size_limit(self : HeapStatistics) -> Int {
  self.as_any()._get("heap_size_limit") |> @core.identity
}

///|
pub fn HeapStatistics::malloced_memory(self : HeapStatistics) -> Int {
  self.as_any()._get("malloced_memory") |> @core.identity
}

///|
pub fn HeapStatistics::peak_malloced_memory(self : HeapStatistics) -> Int {
  self.as_any()._get("peak_malloced_memory") |> @core.identity
}

///|
pub fn HeapStatistics::does_zap_garbage(self : HeapStatistics) -> Int {
  self.as_any()._get("does_zap_garbage") |> @core.identity
}

///|
pub fn HeapStatistics::number_of_native_contexts(self : HeapStatistics) -> Int {
  self.as_any()._get("number_of_native_contexts") |> @core.identity
}

///|
pub fn HeapStatistics::number_of_detached_contexts(
  self : HeapStatistics,
) -> Int {
  self.as_any()._get("number_of_detached_contexts") |> @core.identity
}

///|
pub fn HeapStatistics::external_memory(self : HeapStatistics) -> Int {
  self.as_any()._get("external_memory") |> @core.identity
}

///|
/// HeapCodeStatistics - Result of getHeapCodeStatistics()
#external
pub type HeapCodeStatistics

///|
pub fn HeapCodeStatistics::as_any(self : HeapCodeStatistics) -> @core.Any = "%identity"

///|
pub fn HeapCodeStatistics::code_and_metadata_size(
  self : HeapCodeStatistics,
) -> Int {
  self.as_any()._get("code_and_metadata_size") |> @core.identity
}

///|
pub fn HeapCodeStatistics::bytecode_and_metadata_size(
  self : HeapCodeStatistics,
) -> Int {
  self.as_any()._get("bytecode_and_metadata_size") |> @core.identity
}

///|
pub fn HeapCodeStatistics::external_script_source_size(
  self : HeapCodeStatistics,
) -> Int {
  self.as_any()._get("external_script_source_size") |> @core.identity
}

///|
pub fn HeapCodeStatistics::cpu_profiler_metadata_size(
  self : HeapCodeStatistics,
) -> Int {
  self.as_any()._get("cpu_profiler_metadata_size") |> @core.identity
}

///|
/// HeapSpaceStatistics - Element of getHeapSpaceStatistics() array
#external
pub type HeapSpaceStatistics

///|
pub fn HeapSpaceStatistics::as_any(self : HeapSpaceStatistics) -> @core.Any = "%identity"

///|
pub fn HeapSpaceStatistics::space_name(self : HeapSpaceStatistics) -> String {
  self.as_any()._get("space_name") |> @core.identity
}

///|
pub fn HeapSpaceStatistics::space_size(self : HeapSpaceStatistics) -> Int {
  self.as_any()._get("space_size") |> @core.identity
}

///|
pub fn HeapSpaceStatistics::space_used_size(self : HeapSpaceStatistics) -> Int {
  self.as_any()._get("space_used_size") |> @core.identity
}

///|
pub fn HeapSpaceStatistics::space_available_size(
  self : HeapSpaceStatistics,
) -> Int {
  self.as_any()._get("space_available_size") |> @core.identity
}

///|
pub fn HeapSpaceStatistics::physical_space_size(
  self : HeapSpaceStatistics,
) -> Int {
  self.as_any()._get("physical_space_size") |> @core.identity
}

///| Heap Statistics Functions

///|
/// Get heap statistics
#alias(get_heap_statistics)
pub fn getHeapStatistics() -> HeapStatistics {
  ffi_get_heap_statistics()
}

///|
/// Get heap space statistics
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(get_heap_space_statistics)
pub fn getHeapSpaceStatistics() -> Array[HeapSpaceStatistics] {
  ffi_get_heap_space_statistics()
}

///|
/// Get heap code statistics
#alias(get_heap_code_statistics)
pub fn getHeapCodeStatistics() -> HeapCodeStatistics {
  ffi_get_heap_code_statistics()
}

///|
#module("node:v8")
extern "js" fn ffi_get_heap_snapshot0() -> @core.Any = "getHeapSnapshot"

///|
#module("node:v8")
extern "js" fn ffi_get_heap_snapshot1(options : @core.Any) -> @core.Any = "getHeapSnapshot"

///|
/// Get heap snapshot as a readable stream
#alias(get_heap_snapshot)
pub fn getHeapSnapshot(
  expose_internals? : Bool,
  expose_numeric_values? : Bool,
) -> @core.Any {
  match (expose_internals, expose_numeric_values) {
    (None, None) => ffi_get_heap_snapshot0()
    _ => {
      let entries : Array[(String, @core.Any)] = []
      if expose_internals is Some(v) {
        entries.push(("exposeInternals", @core.any(v)))
      }
      if expose_numeric_values is Some(v) {
        entries.push(("exposeNumericValues", @core.any(v)))
      }
      let opts = @core.from_entries(entries)
      ffi_get_heap_snapshot1(opts)
    }
  }
}

///|
/// Write heap snapshot to file
#alias(write_heap_snapshot)
pub fn writeHeapSnapshot(filename? : String) -> String {
  match filename {
    Some(f) => ffi_write_heap_snapshot1(f)
    None => ffi_write_heap_snapshot0()
  }
}

///|
/// Set heap snapshot near heap limit
#alias(set_heap_snapshot_near_heap_limit)
pub fn setHeapSnapshotNearHeapLimit(limit : Int) -> Unit {
  ffi_set_heap_snapshot_near_heap_limit(limit)
}

///| Serialization Functions

///|
/// Serialize a value to a Buffer
pub fn serialize(value : @core.Any) -> @buffer.Buffer {
  ffi_serialize(value)
}

///|
/// Deserialize a Buffer to a value
pub fn deserialize(buffer : @buffer.Buffer) -> @core.Any {
  ffi_deserialize(buffer)
}

///| Serializer Class

///|
#external
pub type Serializer

///|
pub fn Serializer::as_any(self : Serializer) -> @core.Any = "%identity"

///|
/// Create a new Serializer
pub fn Serializer::new() -> Serializer {
  ffi_new_serializer() |> @core.identity
}

///|
/// Write header
#alias(write_header)
pub fn Serializer::writeHeader(self : Self) -> Unit {
  self.as_any()._call("writeHeader", []) |> ignore
}

///|
/// Write a value
#alias(write_value)
pub fn Serializer::writeValue(self : Self, value : @core.Any) -> Bool {
  self.as_any()._call("writeValue", [value]).cast()
}

///|
/// Release buffer
#alias(release_buffer)
pub fn Serializer::releaseBuffer(self : Self) -> @buffer.Buffer {
  self.as_any()._call("releaseBuffer", []).cast()
}

///|
/// Transfer ArrayBuffer
#alias(transfer_array_buffer)
pub fn Serializer::transferArrayBuffer(
  self : Self,
  id : Int,
  array_buffer : @arraybuffer.ArrayBuffer,
) -> Unit {
  self
  .as_any()
  ._call("transferArrayBuffer", [@core.any(id), @core.any(array_buffer)])
  |> ignore
}

///|
/// Write uint32
#alias(writeUint32)
pub fn Serializer::write_uint32(self : Self, value : Int) -> Unit {
  self.as_any()._call("writeUint32", [@core.any(value)]) |> ignore
}

///|
/// Write double
#alias(writeDouble)
pub fn Serializer::write_double(self : Self, value : Double) -> Unit {
  self.as_any()._call("writeDouble", [@core.any(value)]) |> ignore
}

///|
/// Write raw bytes
#alias(writeRawBytes)
pub fn Serializer::write_raw_bytes(self : Self, buffer : @core.Any) -> Unit {
  self.as_any()._call("writeRawBytes", [buffer]) |> ignore
}

///| Deserializer Class

///|
#external
pub type Deserializer

///|
pub fn Deserializer::as_any(self : Deserializer) -> @core.Any = "%identity"

///|
/// Create a new Deserializer
pub fn Deserializer::new(buffer : @buffer.Buffer) -> Deserializer {
  ffi_new_deserializer(buffer |> @core.any) |> @core.identity
}

///|
/// Read header
#alias(read_header)
pub fn Deserializer::readHeader(self : Self) -> Bool {
  self.as_any()._call("readHeader", []).cast()
}

///|
/// Read a value
#alias(read_value)
pub fn Deserializer::readValue(self : Self) -> @core.Any {
  self.as_any()._call("readValue", [])
}

///|
/// Transfer ArrayBuffer
#alias(transferArrayBuffer)
pub fn Deserializer::transfer_array_buffer(
  self : Self,
  id : Int,
  array_buffer : @arraybuffer.ArrayBuffer,
) -> Unit {
  self
  .as_any()
  ._call("transferArrayBuffer", [@core.any(id), @core.any(array_buffer)])
  |> ignore
}

///|
/// Get wire format version
#alias(get_wire_format_version)
pub fn Deserializer::getWireFormatVersion(self : Self) -> Int {
  self.as_any()._call("getWireFormatVersion", []).cast()
}

///|
/// Read uint32
#alias(read_uint32)
pub fn Deserializer::readUint32(self : Self) -> Int {
  self.as_any()._call("readUint32", []).cast()
}

///|
/// Read double
#alias(read_double)
pub fn Deserializer::readDouble(self : Self) -> Double {
  self.as_any()._call("readDouble", []).cast()
}

///|
/// Read raw bytes
#alias(read_raw_bytes)
pub fn Deserializer::readRawBytes(self : Self, length : Int) -> @buffer.Buffer {
  self.as_any()._call("readRawBytes", [@core.any(length)]).cast()
}

///| Utility Functions

///|
/// Get cached data version tag
#alias(cached_data_version_tag)
pub fn cachedDataVersionTag() -> Int {
  ffi_cached_data_version_tag()
}

///|
/// Set V8 flags from string
#alias(set_flags_from_string)
pub fn setFlagsFromString(flags : String) -> Unit {
  ffi_set_flags_from_string(flags)
}

///|
/// Stop code coverage collection
#alias(stop_coverage)
pub fn stopCoverage() -> Unit {
  ffi_stop_coverage()
}

///|
/// Take code coverage snapshot
#alias(take_coverage)
pub fn takeCoverage() -> Unit {
  ffi_take_coverage()
}
