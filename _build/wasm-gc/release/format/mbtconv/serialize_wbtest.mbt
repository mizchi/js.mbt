///| Safe Serialization Tests

///|
/// Tests for safely serializing MoonBit types to JSON with type information preserved
/// Uses serialize_result, deserialize_result, serialize_option, deserialize_option
/// from mbtconv.mbt

///|
extern "js" fn serialize_json_parse(s : String) -> @core.Any =
  #|(s) => JSON.parse(s)

///|
test "serialize_result: Ok roundtrip" {
  let original : Result[Int, String] = Ok(42)
  let serialized = serialize_result(original)
  let json = @core.json_stringify(serialized)
  inspect(json, content="{\"_tag\":\"Ok\",\"_0\":42}")
  let parsed = serialize_json_parse(json)
  let restored : Result[Int, String] = deserialize_result(parsed)
  assert_eq(restored, Ok(42))
}

///|
test "serialize_result: Err roundtrip" {
  let original : Result[Int, String] = Err("error message")
  let serialized = serialize_result(original)
  let json = @core.json_stringify(serialized)
  inspect(json, content="{\"_tag\":\"Err\",\"_0\":\"error message\"}")
  let parsed = serialize_json_parse(json)
  let restored : Result[Int, String] = deserialize_result(parsed)
  assert_eq(restored, Err("error message"))
}

///|
test "serialize_option: Some roundtrip" {
  let original : Int? = Some(42)
  let serialized = serialize_option(original)
  let json = @core.json_stringify(serialized)
  inspect(json, content="{\"_some\":true,\"_0\":42}")
  let parsed = serialize_json_parse(json)
  let restored : Int? = deserialize_option(parsed)
  assert_eq(restored, Some(42))
}

///|
test "serialize_option: None roundtrip" {
  let original : Int? = None
  let serialized = serialize_option(original)
  let json = @core.json_stringify(serialized)
  inspect(json, content="{\"_some\":false}")
  let parsed = serialize_json_parse(json)
  let restored : Int? = deserialize_option(parsed)
  assert_eq(restored, None)
}

///|
/// Serialize an enum with tag preserved
/// Output: { "_tag": number, "_name": string, "_args": [...] }
priv enum SerializeTestColor {
  Red
  Green
  Blue
  Rgb(Int, Int, Int)
} derive(Eq, Show)

///|
fn serialize_color(color : SerializeTestColor) -> @core.Any {
  let obj = @core.new_object()
  match color {
    Red => {
      obj["_tag"] = @core.any(0)
      obj["_name"] = @core.any("Red")
    }
    Green => {
      obj["_tag"] = @core.any(1)
      obj["_name"] = @core.any("Green")
    }
    Blue => {
      obj["_tag"] = @core.any(2)
      obj["_name"] = @core.any("Blue")
    }
    Rgb(r, g, b) => {
      obj["_tag"] = @core.any(3)
      obj["_name"] = @core.any("Rgb")
      obj["_args"] = @core.any([r, g, b])
    }
  }
  obj
}

///|
fn deserialize_color(v : @core.Any) -> SerializeTestColor {
  let tag : Int = @core.identity(v["_tag"])
  match tag {
    0 => Red
    1 => Green
    2 => Blue
    3 => {
      let args : Array[Int] = @core.identity(v["_args"])
      Rgb(args[0], args[1], args[2])
    }
    _ => Red // fallback
  }
}

///|
test "serialize_enum: unit variant roundtrip" {
  let original : SerializeTestColor = Red
  let serialized = serialize_color(original)
  let json = @core.json_stringify(serialized)
  inspect(json, content="{\"_tag\":0,\"_name\":\"Red\"}")
  let parsed = serialize_json_parse(json)
  let restored = deserialize_color(parsed)
  assert_eq(restored, Red)
}

///|
test "serialize_enum: tuple variant roundtrip" {
  let original : SerializeTestColor = Rgb(255, 128, 64)
  let serialized = serialize_color(original)
  let json = @core.json_stringify(serialized)
  inspect(json, content="{\"_tag\":3,\"_name\":\"Rgb\",\"_args\":[255,128,64]}")
  let parsed = serialize_json_parse(json)
  let restored = deserialize_color(parsed)
  assert_eq(restored, Rgb(255, 128, 64))
}

///|
/// Complex nested structure serialization
priv struct ApiResponse {
  success : Bool
  data : Result[UserData, String]
  metadata : Metadata?
} derive(Eq, Show)

///|
priv struct UserData {
  id : Int
  name : String
  tags : Array[String]
} derive(Eq, Show)

///|
priv struct Metadata {
  version : String
  timestamp : Int
} derive(Eq, Show)

///|
fn serialize_api_response(resp : ApiResponse) -> @core.Any {
  let obj = @core.new_object()
  obj["success"] = @core.any(resp.success)
  // Serialize Result with tag
  let data_obj = @core.new_object()
  match resp.data {
    Ok(user) => {
      data_obj["_tag"] = @core.any("Ok")
      let user_obj = @core.new_object()
      user_obj["id"] = @core.any(user.id)
      user_obj["name"] = @core.any(user.name)
      user_obj["tags"] = @core.any(user.tags)
      data_obj["_0"] = user_obj
    }
    Err(e) => {
      data_obj["_tag"] = @core.any("Err")
      data_obj["_0"] = @core.any(e)
    }
  }
  obj["data"] = data_obj
  // Serialize Option with explicit tag
  let meta_obj = @core.new_object()
  match resp.metadata {
    Some(m) => {
      meta_obj["_some"] = @core.any(true)
      let inner = @core.new_object()
      inner["version"] = @core.any(m.version)
      inner["timestamp"] = @core.any(m.timestamp)
      meta_obj["_0"] = inner
    }
    None => meta_obj["_some"] = @core.any(false)
  }
  obj["metadata"] = meta_obj
  obj
}

///|
fn deserialize_api_response(v : @core.Any) -> ApiResponse {
  let success : Bool = @core.identity(v["success"])
  // Deserialize Result
  let data_v = v["data"]
  let data_tag : String = @core.identity(data_v["_tag"])
  let data : Result[UserData, String] = if data_tag == "Ok" {
    let user_v = data_v["_0"]
    Ok(UserData::{
      id: @core.identity(user_v["id"]),
      name: @core.identity(user_v["name"]),
      tags: @core.identity(user_v["tags"]),
    })
  } else {
    Err(@core.identity(data_v["_0"]))
  }
  // Deserialize Option
  let meta_v = v["metadata"]
  let meta_some : Bool = @core.identity(meta_v["_some"])
  let metadata : Metadata? = if meta_some {
    let inner = meta_v["_0"]
    Some(Metadata::{
      version: @core.identity(inner["version"]),
      timestamp: @core.identity(inner["timestamp"]),
    })
  } else {
    None
  }
  ApiResponse::{ success, data, metadata }
}

///|
test "serialize: complex nested structure with Ok and Some" {
  let original = ApiResponse::{
    success: true,
    data: Ok(UserData::{ id: 123, name: "Alice", tags: ["admin", "user"] }),
    metadata: Some(Metadata::{ version: "1.0.0", timestamp: 1703001234 }),
  }
  let serialized = serialize_api_response(original)
  let json = @core.json_stringify(serialized)
  inspect(
    json,
    content="{\"success\":true,\"data\":{\"_tag\":\"Ok\",\"_0\":{\"id\":123,\"name\":\"Alice\",\"tags\":[\"admin\",\"user\"]}},\"metadata\":{\"_some\":true,\"_0\":{\"version\":\"1.0.0\",\"timestamp\":1703001234}}}",
  )
  let parsed = serialize_json_parse(json)
  let restored = deserialize_api_response(parsed)
  assert_eq(restored, original)
}

///|
test "serialize: complex nested structure with Err and None" {
  let original = ApiResponse::{
    success: false,
    data: Err("User not found"),
    metadata: None,
  }
  let serialized = serialize_api_response(original)
  let json = @core.json_stringify(serialized)
  inspect(
    json,
    content="{\"success\":false,\"data\":{\"_tag\":\"Err\",\"_0\":\"User not found\"},\"metadata\":{\"_some\":false}}",
  )
  let parsed = serialize_json_parse(json)
  let restored = deserialize_api_response(parsed)
  assert_eq(restored, original)
}

///|
/// Generic safe serialization utilities that can be exported
/// These use a consistent format: { "_type": "TypeName", ... }

///|
/// Safe wrapper for any serializable value with type tag
pub fn[T] wrap_typed(type_name : String, value : T) -> @core.Any {
  let obj = @core.new_object()
  obj["_type"] = @core.any(type_name)
  obj["_value"] = @core.any(value)
  obj
}

///|
/// Check the type tag of a wrapped value
pub fn get_type_tag(v : @core.Any) -> String {
  @core.identity(v["_type"])
}

///|
/// Unwrap the value from a typed wrapper
pub fn[T] unwrap_typed(v : @core.Any) -> T {
  @core.identity(v["_value"])
}

///|
priv struct SerializeTestPoint {
  x : Int
  y : Int
}

///|
test "wrap_typed: preserves type info through JSON" {
  let point = SerializeTestPoint::{ x: 10, y: 20 }
  // Read fields to suppress unused_field warning
  ignore(point.x)
  ignore(point.y)
  let value = wrap_typed("Point", point)
  let json = @core.json_stringify(value)
  inspect(json, content="{\"_type\":\"Point\",\"_value\":{\"x\":10,\"y\":20}}")
  let parsed = serialize_json_parse(json)
  assert_eq(get_type_tag(parsed), "Point")
}
