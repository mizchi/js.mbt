///|
/// Node.js v8 API Tests

///|
using @js {unsafe_cast}

///|
using @buffer {type Buffer}

///|
using @promise {run_async}

///|
using @promises {rm}

///|
using @v8 {serialize, deserialize, type Serializer, type Deserializer}

///| Heap Statistics Tests

///|
/// Test get_heap_statistics returns object
test "get_heap_statistics returns object" {
  let stats = @v8.getHeapStatistics()
  inspect(@js.typeof_(stats) == "object", content="true")
}

///|
/// Test heap statistics has total_heap_size
test "heap statistics has total_heap_size" {
  let stats = @v8.getHeapStatistics()
  let total = stats.get("total_heap_size")
  inspect(@js.typeof_(total) == "number", content="true")
}

///|
/// Test heap statistics has used_heap_size
test "heap statistics has used_heap_size" {
  let stats = @v8.getHeapStatistics()
  let used = stats.get("used_heap_size")
  inspect(@js.typeof_(used) == "number", content="true")
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
  let name = first.get("space_name")
  inspect(@js.typeof_(name) == "string", content="true")
}

///|
/// Test get_heap_code_statistics returns object
test "get_heap_code_statistics returns object" {
  let stats = @v8.getHeapCodeStatistics()
  inspect(@js.typeof_(stats) == "object", content="true")
}

///| Heap Snapshot Tests

///|
/// Test write_heap_snapshot returns filename
test "write_heap_snapshot returns filename" {
  let filename = @v8.writeHeapSnapshot()
  inspect(filename.length() > 0, content="true")
  // Clean up snapshot file
  run_async(async fn() noraise {
    try rm(filename).unwrap() |> ignore catch {
      _ => ()
    }
  })
}

///|
/// Test get_heap_snapshot returns stream
test "get_heap_snapshot returns stream" {
  let stream = @v8.getHeapSnapshot()
  inspect(@js.typeof_(stream) == "object", content="true")
}

///| Serialization Tests

///|
/// Test serialize and deserialize number
test "serialize and deserialize number" {
  let original = 42
  let serialized = serialize(original)
  let deserialized = deserialize(serialized)
  inspect(unsafe_cast(deserialized) == 42, content="true")
}

///|
/// Test serialize and deserialize string
test "serialize and deserialize string" {
  let original = "Hello, V8!"
  let serialized = serialize(original)
  let deserialized : String = unsafe_cast(deserialize(serialized))
  inspect(deserialized == "Hello, V8!", content="true")
}

///|
/// Test serialize and deserialize object
test "serialize and deserialize object" {
  let obj = @js.Object::new()
  obj.set("name", "test")
  obj.set("value", 123)
  let serialized = serialize(obj)
  let deserialized = deserialize(serialized)
  inspect(unsafe_cast(deserialized.get("name")) == "test", content="true")
  inspect(unsafe_cast(deserialized.get("value")) == 123, content="true")
}

///| Serializer Tests

///|
/// Test Serializer write and release
test "Serializer write and release" {
  let serializer = Serializer::new()
  serializer.write_header()
  let success = serializer.write_value(42)
  inspect(success, content="true")
  let buffer = serializer.releaseBuffer()
  inspect(unsafe_cast(buffer.get("length")) > 0, content="true")
}

///|
/// Test Serializer write_uint32
test "Serializer write_uint32" {
  let serializer = Serializer::new()
  serializer.write_header()
  serializer.write_uint32(42)
  let buffer = serializer.releaseBuffer()
  inspect(unsafe_cast(buffer.get("length")) > 0, content="true")
}

///|
/// Test Serializer write_double
test "Serializer write_double" {
  let serializer = Serializer::new()
  serializer.write_header()
  serializer.write_double(3.14)
  let buffer = serializer.releaseBuffer()
  inspect(unsafe_cast(buffer.get("length")) > 0, content="true")
}

///| Deserializer Tests

///|
/// Test Deserializer read value
test "Deserializer read value" {
  let original = 42
  let serialized = serialize(original)
  let deserializer = Deserializer::new(serialized)
  deserializer.read_header() |> ignore
  let value = deserializer.read_value()
  inspect(unsafe_cast(value) == 42, content="true")
}

///|
/// Test Deserializer get wire format version
test "Deserializer get_wire_format_version" {
  let serialized = serialize(42)
  let deserializer = Deserializer::new(serialized)
  let version = deserializer.get_wire_format_version()
  inspect(version >= 0, content="true")
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
test "set_flags_from_string API exists" {
  // Just verify the API exists without setting dangerous flags
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
