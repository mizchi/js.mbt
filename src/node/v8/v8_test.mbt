///|
/// Node.js v8 API Tests

///| Heap Statistics Tests

///|
/// Test get_heap_statistics returns object
test "get_heap_statistics returns object" {
  let stats = @v8.getHeapStatistics()
  inspect(stats.total_heap_size() > 0, content="true")
}

///|
/// Test heap statistics has total_heap_size
test "heap statistics has total_heap_size" {
  let stats = @v8.getHeapStatistics()
  let total = stats.total_heap_size()
  inspect(total > 0, content="true")
}

///|
/// Test heap statistics has used_heap_size
test "heap statistics has used_heap_size" {
  let stats = @v8.getHeapStatistics()
  let used = stats.used_heap_size()
  inspect(used > 0, content="true")
}

///|
/// Test get_heap_space_statistics returns array
test "get_heap_space_statistics returns array" {
  let spaces = @v8.getHeapSpaceStatistics()
  inspect(spaces.length() > 0, content="true")
}

///|
/// Test heap space has space_name
test "heap space has space_name" {
  let spaces = @v8.getHeapSpaceStatistics()
  let first = spaces[0]
  let name = first.space_name()
  inspect(name.length() > 0, content="true")
}

///|
/// Test get_heap_code_statistics returns object
test "get_heap_code_statistics returns object" {
  let stats = @v8.getHeapCodeStatistics()
  inspect(stats.code_and_metadata_size() >= 0, content="true")
}

///| Heap Snapshot Tests

///|
/// Test write_heap_snapshot returns filename
test "write_heap_snapshot returns filename" {
  let filename = @v8.writeHeapSnapshot()
  inspect(filename.length() > 0, content="true")
  // Clean up snapshot file
  @js.run_async(async fn() noraise {
    @fs_promises.rm(filename) catch {
      _ => ()
    }
  })
}

///|
/// Test write_heap_snapshot with custom filename
test "write_heap_snapshot with custom filename" {
  let custom_name = "/tmp/test-heap-snapshot.heapsnapshot"
  let filename = @v8.writeHeapSnapshot(filename=custom_name)
  inspect(filename == custom_name, content="true")
  // Clean up snapshot file
  @js.run_async(async fn() noraise {
    @fs_promises.rm(filename) catch {
      _ => ()
    }
  })
}

///|
/// Test get_heap_snapshot returns stream
test "get_heap_snapshot returns stream" {
  let stream = @v8.getHeapSnapshot()
  inspect(@nostd.typeof_(stream) == "object", content="true")
}

///|
/// Test get_heap_snapshot with options
test "get_heap_snapshot with expose_internals" {
  let stream = @v8.getHeapSnapshot(expose_internals=true)
  inspect(@nostd.typeof_(stream) == "object", content="true")
}

///|
/// Test get_heap_snapshot with expose_numeric_values
test "get_heap_snapshot with expose_numeric_values" {
  let stream = @v8.getHeapSnapshot(expose_numeric_values=true)
  inspect(@nostd.typeof_(stream) == "object", content="true")
}

///|
/// Test get_heap_snapshot with both options
test "get_heap_snapshot with both options" {
  let stream = @v8.getHeapSnapshot(
    expose_internals=true,
    expose_numeric_values=true,
  )
  inspect(@nostd.typeof_(stream) == "object", content="true")
}

///|
/// Test set_heap_snapshot_near_heap_limit
test "set_heap_snapshot_near_heap_limit" {
  @v8.setHeapSnapshotNearHeapLimit(10)
  inspect(true, content="true")
}

///| Serialization Tests

///|
/// Test serialize and deserialize number
test "serialize and deserialize number" {
  let original = 42
  let serialized = serialize(original |> @nostd.any)
  let deserialized = deserialize(serialized)
  inspect(@nostd.identity(deserialized) == 42, content="true")
}

///|
/// Test serialize and deserialize string
test "serialize and deserialize string" {
  let original = "Hello, V8!"
  let serialized = serialize(original |> @nostd.any)
  let deserialized : String = @nostd.identity(deserialize(serialized))
  inspect(deserialized == "Hello, V8!", content="true")
}

///|
/// Test serialize and deserialize object
test "serialize and deserialize object" {
  let obj = @nostd.Object::new()
  obj._set("name", "test" |> @nostd.any)
  obj._set("value", 123 |> @nostd.any)
  let serialized = serialize(obj)
  let deserialized = deserialize(serialized)
  inspect(@nostd.identity(deserialized._get("name")) == "test", content="true")
  inspect(@nostd.identity(deserialized._get("value")) == 123, content="true")
}

///| Serializer Tests

///|
/// Test Serializer write and release
test "Serializer write and release" {
  let serializer = Serializer::new()
  serializer.write_header()
  let success = serializer.write_value(42 |> @nostd.any)
  inspect(success, content="true")
  let buffer = serializer.releaseBuffer()
  inspect(@nostd.identity(buffer.as_any()._get("length")) > 0, content="true")
}

///|
/// Test Serializer write_uint32
test "Serializer write_uint32" {
  let serializer = Serializer::new()
  serializer.write_header()
  serializer.write_uint32(42)
  let buffer = serializer.releaseBuffer()
  inspect(@nostd.identity(buffer.as_any()._get("length")) > 0, content="true")
}

///|
/// Test Serializer write_double
test "Serializer write_double" {
  let serializer = Serializer::new()
  serializer.write_header()
  serializer.write_double(3.14)
  let buffer = serializer.releaseBuffer()
  inspect(@nostd.identity(buffer.as_any()._get("length")) > 0, content="true")
}

///|
/// Test Serializer transfer_array_buffer
test "Serializer transfer_array_buffer" {
  let serializer = Serializer::new()
  serializer.write_header()
  let ab = @js.ArrayBuffer::new(16)
  serializer.transferArrayBuffer(1, ab)
  let buffer = serializer.releaseBuffer()
  inspect(@nostd.identity(buffer.as_any()._get("length")) > 0, content="true")
}

///|
/// Test Serializer write_raw_bytes
test "Serializer write_raw_bytes" {
  let serializer = Serializer::new()
  serializer.write_header()
  let buffer = @buffer.Buffer::from_string("test")
  serializer.write_raw_bytes(buffer |> @nostd.any)
  let released = serializer.releaseBuffer()
  inspect(@nostd.identity(released.as_any()._get("length")) > 0, content="true")
}

///| Deserializer Tests

///|
/// Test Deserializer read value
test "Deserializer read value" {
  let original = 42
  let serialized = serialize(original |> @nostd.any)
  let deserializer = Deserializer::new(serialized)
  deserializer.read_header() |> ignore
  let value = deserializer.read_value()
  inspect(@nostd.identity(value) == 42, content="true")
}

///|
/// Test Deserializer get wire format version
test "Deserializer get_wire_format_version" {
  let serialized = serialize(42 |> @nostd.any)
  let deserializer = Deserializer::new(serialized)
  let version = deserializer.get_wire_format_version()
  inspect(version >= 0, content="true")
}

///|
/// Test Deserializer transfer_array_buffer
test "Deserializer transfer_array_buffer" {
  let ab = @js.ArrayBuffer::new(16)
  let serialized = serialize(ab |> @nostd.any)
  let deserializer = Deserializer::new(serialized)
  deserializer.read_header() |> ignore
  let new_ab = @js.ArrayBuffer::new(16)
  deserializer.transfer_array_buffer(1, new_ab)
  inspect(true, content="true")
}

///|
/// Test Deserializer read_uint32
test "Deserializer read_uint32" {
  let serializer = Serializer::new()
  serializer.write_header()
  serializer.write_uint32(12345)
  let buffer = serializer.releaseBuffer()
  let deserializer = Deserializer::new(buffer)
  deserializer.read_header() |> ignore
  let value = deserializer.readUint32()
  inspect(value == 12345, content="true")
}

///|
/// Test Deserializer read_double
test "Deserializer read_double" {
  let serializer = Serializer::new()
  serializer.write_header()
  serializer.write_double(3.14159)
  let buffer = serializer.releaseBuffer()
  let deserializer = Deserializer::new(buffer)
  deserializer.read_header() |> ignore
  let value = deserializer.readDouble()
  inspect(value > 3.14 && value < 3.15, content="true")
}

///|
/// Test Deserializer read_raw_bytes
test "Deserializer read_raw_bytes" {
  let serializer = Serializer::new()
  serializer.write_header()
  let test_buffer = @buffer.Buffer::from_string("test data")
  serializer.write_raw_bytes(test_buffer |> @nostd.any)
  let buffer = serializer.releaseBuffer()
  let deserializer = Deserializer::new(buffer)
  deserializer.read_header() |> ignore
  let read_buffer = deserializer.readRawBytes(9)
  inspect(
    @nostd.identity(read_buffer.as_any()._get("length")) == 9,
    content="true",
  )
}

///| Utility Function Tests

///|
/// Test cached_data_version_tag returns number
test "cached_data_version_tag returns number" {
  let tag = @v8.cached_data_version_tag()
  inspect(tag > 0, content="true")
}

///|
/// Test set_flags_from_string API exists
test "set_flags_from_string" {
  // Set a harmless flag to verify the API works
  @v8.setFlagsFromString("--expose-gc")
  inspect(true, content="true")
}

///|
/// Test stop_coverage API exists
test "stop_coverage API exists" {
  @v8.stop_coverage()
  inspect(true, content="true")
}

///|
/// Test take_coverage API exists
test "take_coverage API exists" {
  @v8.take_coverage()
  inspect(true, content="true")
}
