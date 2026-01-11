///| Deep Investigation Tests - MoonBit Type JS Representation

///|
/// These tests investigate the internal JavaScript representation of MoonBit types

///|
extern "js" fn ffi_get_own_property_names(v : @core.Any) -> Array[String] =
  #|(v) => Object.getOwnPropertyNames(v)

///|
extern "js" fn ffi_get_property_descriptor(
  v : @core.Any,
  key : String,
) -> @core.Any =
  #|(v, key) => Object.getOwnPropertyDescriptor(v, key)

///|
extern "js" fn ffi_wb_get_constructor_name(v : @core.Any) -> String =
  #|(v) => v?.constructor?.name ?? ""

///|
extern "js" fn json_parse(s : String) -> @core.Any =
  #|(s) => JSON.parse(s)

///|
priv enum TestColor {
  Red
  Green
  Blue
  Rgb(Int, Int, Int)
}

///|
/// Helper to suppress unused_constructor warnings - pattern match on all variants
fn test_color_name(c : TestColor) -> String {
  match c {
    Red => "red"
    Green => "green"
    Blue => "blue"
    Rgb(r, g, b) => "rgb(\{r},\{g},\{b})"
  }
}

///|
test "Deep: TestColor all variants" {
  // Ensure all variants are constructed and read
  ignore(test_color_name(Red))
  ignore(test_color_name(Green))
  ignore(test_color_name(Blue))
  ignore(test_color_name(Rgb(0, 0, 0)))
}

///|
test "Deep: enum tuple variant - no $tag in own properties" {
  let rgb : TestColor = Rgb(255, 0, 0)
  let v : @core.Any = @core.any(rgb)

  // Own properties - $tag is NOT an own property for tuple variants
  let own_props = ffi_get_own_property_names(v)
  inspect(own_props, content="[\"_0\", \"_1\", \"_2\"]")

  // $tag can still be accessed (inherited from prototype/class)
  let tag = v["$tag"]
  inspect(@core.typeof_(tag), content="number")
}

///|
test "Deep: enum unit variant - $tag and $name are enumerable" {
  let red : TestColor = Red
  let v : @core.Any = @core.any(red)
  let own_props = ffi_get_own_property_names(v)
  inspect(own_props, content="[\"$tag\", \"$name\"]")

  // Both $tag and $name are enumerable for unit variants
  let tag_descriptor = ffi_get_property_descriptor(v, "$tag")
  let tag_enumerable : Bool = @core.identity(tag_descriptor["enumerable"])
  inspect(tag_enumerable, content="true")
  let name_descriptor = ffi_get_property_descriptor(v, "$name")
  let name_enumerable : Bool = @core.identity(name_descriptor["enumerable"])
  inspect(name_enumerable, content="true")
}

///|
priv enum TestShape {
  Circle(radius~ : Int)
  Rectangle(width~ : Int, height~ : Int)
}

///|
/// Helper to suppress unused_constructor warnings
fn test_shape_area(s : TestShape) -> Int {
  match s {
    Circle(radius~) => radius * radius
    Rectangle(width~, height~) => width * height
  }
}

///|
test "Deep: TestShape all variants" {
  ignore(test_shape_area(Circle(radius=5)))
  ignore(test_shape_area(Rectangle(width=3, height=4)))
}

///|
test "Deep: enum struct variant (labeled fields) - labels NOT preserved in JS" {
  let circle : TestShape = Circle(radius=10)
  let v : @core.Any = @core.any(circle)

  // IMPORTANT: Labeled fields are NOT preserved in JS!
  // Circle(radius=10) becomes {"_0":10}, not {"radius":10}
  let serialized = @core.json_stringify(v)
  inspect(serialized, content="{\"_0\":10}")
  let own_props = ffi_get_own_property_names(v)
  inspect(own_props, content="[\"_0\"]")

  // Cannot access by label name - it doesn't exist
  let radius_val = v["radius"]
  assert_true(@core.is_undefined(radius_val))

  // Must use positional access
  let val : Int = @core.identity(v["_0"])
  assert_eq(val, 10)
}

///|
test "Deep: Result - only constructor.name distinguishes Ok/Err" {
  let ok_val : Result[Int, String] = Ok(42)
  let err_val : Result[Int, String] = Err("error")
  let ok_any : @core.Any = @core.any(ok_val)
  let err_any : @core.Any = @core.any(err_val)

  // Own properties are identical
  let ok_props = ffi_get_own_property_names(ok_any)
  let err_props = ffi_get_own_property_names(err_any)
  inspect(ok_props, content="[\"_0\"]")
  inspect(err_props, content="[\"_0\"]")

  // The only way to distinguish is constructor.name
  let ok_ctor = ffi_wb_get_constructor_name(ok_any)
  let err_ctor = ffi_wb_get_constructor_name(err_any)
  assert_true(ok_ctor.contains("Ok"))
  assert_true(err_ctor.contains("Err"))
}

///|
/// Newtype is unwrapped in JS (zero-cost abstraction)
priv struct TestUserId(Int)

///|
fn test_user_id_value(id : TestUserId) -> Int {
  match id {
    TestUserId(v) => v
  }
}

///|
test "Deep: newtype unwraps to primitive" {
  let user_id : TestUserId = TestUserId(123)
  let v : @core.Any = @core.any(user_id)

  // Newtype is unwrapped in JS
  let serialized = @core.json_stringify(v)
  inspect(serialized, content="123")

  // typeof is number
  inspect(@core.typeof_(v), content="number")

  // Read the value to suppress unused_constructor warning
  ignore(test_user_id_value(user_id))
}

///|
test "Deep: BigInt representation" {
  let big : BigInt = 12345678901234567890N
  let v : @core.Any = @core.any(big)
  inspect(@core.typeof_(v), content="bigint")
  // Note: BigInt cannot be JSON.stringify'd directly (throws TypeError)
}

///|
extern "js" fn ffi_uint8array_constructor() -> @core.Any =
  #|() => Uint8Array

///|
test "Deep: Bytes is Uint8Array" {
  let bytes : Bytes = b"hello"
  let v : @core.Any = @core.any(bytes)
  inspect(@core.typeof_(v), content="object")
  assert_true(@core.instanceof_(v, ffi_uint8array_constructor()))
}

///|
test "Deep: Map has internal structure" {
  let map : Map[String, Int] = { "a": 1, "b": 2 }
  let v : @core.Any = @core.any(map)
  inspect(@core.typeof_(v), content="object")
  let own_props = ffi_get_own_property_names(v)
  // Map has internal structure, not plain object
  inspect(
    own_props,
    content=(
      #|["entries", "size", "capacity", "capacity_mask", "grow_at", "head", "tail"]
    ),
  )
}

///|
test "Deep: Array is native JS Array" {
  let arr : Array[Int] = [1, 2, 3]
  let v : @core.Any = @core.any(arr)
  inspect(@core.typeof_(v), content="object")
  assert_true(@core.is_array(v))
  let serialized = @core.json_stringify(v)
  inspect(serialized, content="[1,2,3]")
}

///|
test "Deep: function is callable" {
  let f = fn(x : Int) -> Int { x * 2 }
  let v : @core.Any = @core.any(f)
  inspect(@core.typeof_(v), content="function")

  // Can call directly
  let result = v._invoke([@core.any(5)])
  let r : Int = @core.identity(result)
  assert_eq(r, 10)
}

///|
priv struct TestPoint {
  x : Int
  y : Int
} derive(Show, Eq)

///|
test "Deep: struct JSON roundtrip" {
  let original = TestPoint::{ x: 10, y: 20 }
  let serialized = @core.json_stringify(@core.any(original))
  let parsed : @core.Any = json_parse(serialized)
  let restored : TestPoint = @core.identity(parsed)
  assert_eq(restored, original)
  inspect(serialized, content="{\"x\":10,\"y\":20}")
}

///|
test "Deep: primitive JSON roundtrip" {
  let int_val = 42
  let str_val = "hello"
  let bool_val = true
  let float_val = 3.14
  let int_back : Int = @core.identity(
    json_parse(@core.json_stringify(@core.any(int_val))),
  )
  let str_back : String = @core.identity(
    json_parse(@core.json_stringify(@core.any(str_val))),
  )
  let bool_back : Bool = @core.identity(
    json_parse(@core.json_stringify(@core.any(bool_val))),
  )
  let float_back : Double = @core.identity(
    json_parse(@core.json_stringify(@core.any(float_val))),
  )
  assert_eq(int_back, int_val)
  assert_eq(str_back, str_val)
  assert_eq(bool_back, bool_val)
  assert_eq(float_back, float_val)
}
