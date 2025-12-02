// https://nodejs.org/api/v8.html
// Based on @types/node v8 definitions

///|
/// V8 Module FFI
extern "js" fn ffi_require_v8() -> @core.Any =
  #|() => require("node:v8")

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
  let v8 = ffi_require_v8()
  v8._call("getHeapStatistics", []).cast()
}

///|
/// Get heap space statistics
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(get_heap_space_statistics)
pub fn getHeapSpaceStatistics() -> Array[HeapSpaceStatistics] {
  let v8 = ffi_require_v8()
  v8._call("getHeapSpaceStatistics", []) |> @core.identity
}

///|
/// Get heap code statistics
#alias(get_heap_code_statistics)
pub fn getHeapCodeStatistics() -> HeapCodeStatistics {
  let v8 = ffi_require_v8()
  v8._call("getHeapCodeStatistics", []).cast()
}

///|
/// Get heap snapshot as a readable stream
#alias(get_heap_snapshot)
pub fn getHeapSnapshot(
  expose_internals? : Bool,
  expose_numeric_values? : Bool,
) -> @core.Any {
  let v8 = ffi_require_v8()
  match (expose_internals, expose_numeric_values) {
    (None, None) => v8._call("getHeapSnapshot", [])
    _ => {
      let opts : @core.Any = @mbtconv.from_option_map({
        "exposeInternals": expose_internals.map(fn(x) { @core.any(x) }),
        "exposeNumericValues": expose_numeric_values.map(fn(x) { @core.any(x) }),
      }).cast()
      v8._call("getHeapSnapshot", [opts])
    }
  }
}

///|
/// Write heap snapshot to file
#alias(write_heap_snapshot)
pub fn writeHeapSnapshot(filename? : String) -> String {
  let v8 = ffi_require_v8()
  match filename {
    Some(f) => @core.identity(v8._call("writeHeapSnapshot", [@core.any(f)]))
    None => v8._call("writeHeapSnapshot", []).cast()
  }
}

///|
/// Set heap snapshot near heap limit
#alias(set_heap_snapshot_near_heap_limit)
pub fn setHeapSnapshotNearHeapLimit(limit : Int) -> Unit {
  let v8 = ffi_require_v8()
  v8._call("setHeapSnapshotNearHeapLimit", [@core.any(limit)]) |> ignore
}

///| Serialization Functions

///|
/// Serialize a value to a Buffer
pub fn serialize(value : @core.Any) -> @buffer.Buffer {
  let v8 = ffi_require_v8()
  @core.identity(v8._call("serialize", [value]))
}

///|
/// Deserialize a Buffer to a value
pub fn deserialize(buffer : @buffer.Buffer) -> @core.Any {
  let v8 = ffi_require_v8()
  v8._call("deserialize", [@core.any(buffer)])
}

///| Serializer Class

///|
#external
pub type Serializer

///|
pub fn Serializer::as_any(self : Serializer) -> @core.Any = "%identity"

///|
extern "js" fn ffi_new_serializer() -> @core.Any =
  #|() => { const v8 = require("node:v8"); return new v8.Serializer(); }

///|
/// Create a new Serializer
pub fn Serializer::new() -> Serializer {
  @core.identity(ffi_new_serializer())
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
extern "js" fn ffi_new_deserializer(buffer : @core.Any) -> @core.Any =
  #|(buffer) => { const v8 = require("node:v8"); return new v8.Deserializer(buffer); }

///|
extern "js" fn buffer_to_js_any(buffer : @buffer.Buffer) -> @core.Any =
  #| (b) => b

///|
/// Create a new Deserializer
pub fn Deserializer::new(buffer : @buffer.Buffer) -> Deserializer {
  @core.identity(ffi_new_deserializer(buffer_to_js_any(buffer)))
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
  let v8 = ffi_require_v8()
  v8._call("cachedDataVersionTag", []).cast()
}

///|
/// Set V8 flags from string
#alias(set_flags_from_string)
pub fn setFlagsFromString(flags : String) -> Unit {
  let v8 = ffi_require_v8()
  v8._call("setFlagsFromString", [@core.any(flags)]) |> ignore
}

///|
/// Stop code coverage collection
#alias(stop_coverage)
pub fn stopCoverage() -> Unit {
  let v8 = ffi_require_v8()
  v8._call("stopCoverage", []) |> ignore
}

///|
/// Take code coverage snapshot
#alias(take_coverage)
pub fn takeCoverage() -> Unit {
  let v8 = ffi_require_v8()
  v8._call("takeCoverage", []) |> ignore
}
