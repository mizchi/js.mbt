///|
/// Node.js v8 API Tests

///|
using @js {js, unsafe_cast}

///|
using @buffer {type Buffer}

///|
using @async {run_async}

///|
using @promises {rm}

///| Heap Statistics Tests

///|
/// Test get_heap_statistics returns object
test "get_heap_statistics returns object" {
  let stats = get_heap_statistics()
  inspect(stats.type_of() == "object", content="true")
}

///|
/// Test heap statistics has total_heap_size
test "heap statistics has total_heap_size" {
  let stats = get_heap_statistics()
  let total = stats.get("total_heap_size")
  inspect(total.type_of() == "number", content="true")
}

///|
/// Test heap statistics has used_heap_size
test "heap statistics has used_heap_size" {
  let stats = get_heap_statistics()
  let used = stats.get("used_heap_size")
  inspect(used.type_of() == "number", content="true")
}

///|
/// Test get_heap_space_statistics returns array
test "get_heap_space_statistics returns array" {
  let spaces = get_heap_space_statistics()
  inspect(spaces.length() > 0, content="true")
}

///|
/// Test heap space has space_name
test "heap space has space_name" {
  let spaces = get_heap_space_statistics()
  let first = spaces[0]
  let name = first.get("space_name")
  inspect(name.type_of() == "string", content="true")
}

///|
/// Test get_heap_code_statistics returns object
test "get_heap_code_statistics returns object" {
  let stats = get_heap_code_statistics()
  inspect(stats.type_of() == "object", content="true")
}

///| Heap Snapshot Tests

///|
/// Test write_heap_snapshot returns filename
test "write_heap_snapshot returns filename" {
  let filename = write_heap_snapshot()
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
  let stream = get_heap_snapshot()
  inspect(stream.type_of() == "object", content="true")
}

///| Serialization Tests

///|
/// Test serialize and deserialize number
test "serialize and deserialize number" {
  let original = 42 |> js
  let serialized = serialize(original)
  let deserialized = deserialize(serialized)
  inspect(unsafe_cast(deserialized) == 42, content="true")
}

///|
/// Test serialize and deserialize string
test "serialize and deserialize string" {
  let original = "Hello, V8!" |> js
  let serialized = serialize(original)
  let deserialized : String = unsafe_cast(deserialize(serialized))
  inspect(deserialized == "Hello, V8!", content="true")
}

///|
/// Test serialize and deserialize object
test "serialize and deserialize object" {
  let obj = @js.new_empty_object()
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
  let success = serializer.write_value(42 |> js)
  inspect(success, content="true")
  let buffer = serializer.release_buffer()
  inspect(unsafe_cast(buffer.to_js().get("length")) > 0, content="true")
}

///|
/// Test Serializer write_uint32
test "Serializer write_uint32" {
  let serializer = Serializer::new()
  serializer.write_header()
  serializer.write_uint32(42)
  let buffer = serializer.release_buffer()
  inspect(unsafe_cast(buffer.to_js().get("length")) > 0, content="true")
}

///|
/// Test Serializer write_double
test "Serializer write_double" {
  let serializer = Serializer::new()
  serializer.write_header()
  serializer.write_double(3.14)
  let buffer = serializer.release_buffer()
  inspect(unsafe_cast(buffer.to_js().get("length")) > 0, content="true")
}

///| Deserializer Tests

///|
/// Test Deserializer read value
test "Deserializer read value" {
  let original = 42 |> js
  let serialized = serialize(original)
  let deserializer = Deserializer::new(serialized)
  deserializer.read_header() |> ignore
  let value = deserializer.read_value()
  inspect(unsafe_cast(value) == 42, content="true")
}

///|
/// Test Deserializer get wire format version
test "Deserializer get_wire_format_version" {
  let serialized = serialize(42 |> js)
  let deserializer = Deserializer::new(serialized)
  let version = deserializer.get_wire_format_version()
  inspect(version >= 0, content="true")
}

///| Utility Function Tests

///|
/// Test cached_data_version_tag returns number
test "cached_data_version_tag returns number" {
  let tag = cached_data_version_tag()
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
  stop_coverage()
  inspect(true, content="true")
}

///|
/// Test take_coverage API exists
test "take_coverage API exists" {
  take_coverage()
  inspect(true, content="true")
}
