///| FFI Behavior Check Tests
/// This file tests how MoonBit structs interact with JavaScript FFI,
/// particularly around Option types and type conversions.
///
/// ## Key Findings:
///
/// 1. **Struct fields with Option types (T?) DO NOT automatically convert null/undefined to None**
///    - JavaScript `null` becomes `Some(null)` which crashes when accessed
///    - This applies to Int?, String?, Js?, and custom struct types
///
/// 2. **Workarounds:**
///    - Use non-optional fields (T instead of T?) in structs
///    - Access raw JS object with `obj.to_js().get("field")` and check with `is_nullish()`
///    - Use getter methods with `unsafe_cast_option()` for nullable fields
///
/// 3. **unsafe_cast_option() works correctly:**
///    - Converts null/undefined to None
///    - Converts values to Some(T)
///
/// See: https://www.moonbitlang.com/pearls/moonbit-jsffi for official patterns

///| Test Data Structures

///|
/// Simple struct with primitive fields
pub(all) struct SimpleStruct {
  name : String
  age : Int
} derive(Show)

///|
pub impl JsImpl for SimpleStruct

///|
/// Struct with Option fields
pub(all) struct StructWithOptions {
  required : String
  optionalInt : Int?
  optionalString : String?
  optionalJs : Js?
}

///|
pub impl JsImpl for StructWithOptions

///|
/// Nested struct
pub(all) struct NestedStruct {
  id : Int
  simple : SimpleStruct
}

///|
pub impl JsImpl for NestedStruct

///|
/// Struct with optional nested struct
pub(all) struct StructWithOptionalNested {
  id : Int
  nested : SimpleStruct?
}

///|
pub impl JsImpl for StructWithOptionalNested

///|
/// Generic container
pub(all) struct Container[T] {
  value : T
}

///|
pub impl[T : JsImpl] JsImpl for Container[T]

///| Helper Functions - All extern "js" must be at top level

///|
extern "js" fn create_all_fields() -> Js =
  #|() => ({
  #|  required: "test",
  #|  optionalInt: 42,
  #|  optionalString: "hello",
  #|  optionalJs: { foo: "bar" }
  #|})

///|
extern "js" fn create_null_fields() -> Js =
  #|() => ({
  #|  required: "test",
  #|  optionalInt: null,
  #|  optionalString: null,
  #|  optionalJs: null
  #|})

///|
extern "js" fn create_undefined_fields() -> Js =
  #|() => ({
  #|  required: "test",
  #|  optionalInt: undefined,
  #|  optionalString: undefined,
  #|  optionalJs: undefined
  #|})

///|
extern "js" fn create_missing_fields() -> Js =
  #|() => ({ required: "test" })

///|
extern "js" fn create_nested() -> Js =
  #|() => ({
  #|  id: 1,
  #|  simple: { name: "Alice", age: 30 }
  #|})

///|
extern "js" fn create_null_nested() -> Js =
  #|() => ({
  #|  id: 1,
  #|  nested: null
  #|})

///|
extern "js" fn create_undefined_nested() -> Js =
  #|() => ({
  #|  id: 1,
  #|  nested: undefined
  #|})

///|
extern "js" fn create_null_value() -> Js =
  #|() => ({ value: null })

///|
extern "js" fn get_number() -> Js =
  #|() => 42

///|
extern "js" fn get_null() -> Js =
  #|() => null

///|
extern "js" fn get_undefined() -> Js =
  #|() => undefined

///|
extern "js" fn get_simple() -> Js =
  #|() => ({ name: "Charlie", age: 35 })

///| Test Cases

///|
test "Int? field with all values set" {
  let obj : StructWithOptions = create_all_fields() |> unsafe_cast
  inspect(obj.optionalInt, content="Some(42)")
}

///|
test "Int? field with null value" {
  let obj : StructWithOptions = create_null_fields() |> unsafe_cast
  // FFI does not convert null to None - it becomes Some(null)
  // We cannot inspect the value directly as it crashes
  match obj.optionalInt {
    Some(_) => inspect("Some (possibly null)", content="Some (possibly null)")
    None => inspect("None", content="?")
  }
}

///|
test "Int? field with undefined value" {
  let obj : StructWithOptions = create_undefined_fields() |> unsafe_cast
  inspect(obj.optionalInt, content="None")
}

///|
test "Int? field with missing value" {
  let obj : StructWithOptions = create_missing_fields() |> unsafe_cast
  inspect(obj.optionalInt, content="None")
}

///|
test "String? field with all values set" {
  let obj : StructWithOptions = create_all_fields() |> unsafe_cast
  inspect(obj.optionalString, content="Some(\"hello\")")
}

///|
test "String? field with null value" {
  let obj : StructWithOptions = create_null_fields() |> unsafe_cast
  // FFI does not convert null to None - it becomes Some(null)
  match obj.optionalString {
    Some(_) => inspect("Some (possibly null)", content="Some (possibly null)")
    None => inspect("None", content="?")
  }
}

///|
test "String? field with undefined value" {
  let obj : StructWithOptions = create_undefined_fields() |> unsafe_cast
  inspect(obj.optionalString, content="None")
}

///|
test "Js? field with all values set" {
  let obj : StructWithOptions = create_all_fields() |> unsafe_cast
  // Check if optionalJs has a value and contains an object
  match obj.optionalJs {
    Some(v) => inspect(is_object(v), content="?")
    None => inspect("None", content="None")
  }
}

///|
test "Js? field with null value" {
  let obj : StructWithOptions = create_null_fields() |> unsafe_cast
  // Js? field cannot be matched - it crashes when trying to access $tag
  // Convert to Js and check with is_nullish instead
  let raw : Js = obj.to_js().get("optionalJs")
  inspect(is_nullish(raw), content="true")
}

///|
test "Js? field with undefined value" {
  let obj : StructWithOptions = create_undefined_fields() |> unsafe_cast
  // Js? field cannot be matched - it crashes when trying to access $tag
  let raw : Js = obj.to_js().get("optionalJs")
  inspect(is_nullish(raw), content="true")
}

///|
test "Nested struct with value" {
  let obj : NestedStruct = create_nested() |> unsafe_cast
  inspect(obj.simple.name, content="Alice")
  inspect(obj.simple.age, content="30")
}

///|
test "Optional nested struct with value" {
  let obj : StructWithOptionalNested = create_nested() |> unsafe_cast
  match obj.nested {
    Some(s) => {
      inspect(s.name, content="?")
      inspect(s.age, content="?")
    }
    None => inspect(false, content="false")
  }
}

///|
test "Optional nested struct with null" {
  let obj : StructWithOptionalNested = create_null_nested() |> unsafe_cast
  // Cannot inspect SimpleStruct? directly when it contains null
  match obj.nested {
    Some(_) => inspect("has value", content="has value")
    None => inspect("None", content="?")
  }
}

///|
test "Optional nested struct with undefined" {
  let obj : StructWithOptionalNested = create_undefined_nested() |> unsafe_cast
  inspect(obj.nested, content="None")
}

///|
test "Generic Container[Int]" {
  let js_obj = @js.Object::new()
  js_obj.set("value", 42)
  let container : Container[Int] = js_obj.to_js() |> unsafe_cast
  inspect(container.value, content="42")
}

///|
test "Generic Container[String]" {
  let js_obj = @js.Object::new()
  js_obj.set("value", "test")
  let container : Container[String] = js_obj.to_js() |> unsafe_cast
  inspect(container.value, content="test")
}

///|
test "Generic Container[Int?] with value" {
  let js_obj = @js.Object::new()
  js_obj.set("value", 42)
  let container : Container[Int?] = js_obj.to_js() |> unsafe_cast
  inspect(container.value, content="Some(42)")
}

///|
test "Generic Container[Int?] with null" {
  let container : Container[Int?] = create_null_value() |> unsafe_cast
  // FFI does not convert null to None - it becomes Some(null)
  match container.value {
    Some(_) => inspect("Some (possibly null)", content="Some (possibly null)")
    None => inspect("None", content="?")
  }
}

///|
test "Generic Container[SimpleStruct]" {
  let js_obj = @js.Object::new()
  let simple_obj = @js.Object::new()
  simple_obj.set("name", "Bob")
  simple_obj.set("age", 25)
  js_obj.set("value", simple_obj.to_js())
  let container : Container[SimpleStruct] = js_obj.to_js() |> unsafe_cast
  inspect(container.value.name, content="Bob")
  inspect(container.value.age, content="25")
}

///|
test "Direct unsafe_cast to Int? with number" {
  let value : Int? = get_number() |> unsafe_cast
  inspect(value, content="Some(42)")
}

///|
test "Direct unsafe_cast to Int? with null" {
  let value : Int? = get_null() |> unsafe_cast
  // FFI does not convert null to None - it becomes Some(null)
  match value {
    Some(_) => inspect("Some (possibly null)", content="Some (possibly null)")
    None => inspect("None", content="?")
  }
}

///|
test "Direct unsafe_cast to Int? with undefined" {
  let value : Int? = get_undefined() |> unsafe_cast
  inspect(value, content="None")
}

///|
test "unsafe_cast_option with null" {
  let value : Int? = unsafe_cast_option(get_null())
  inspect(value, content="None")
}

///|
test "unsafe_cast_option with undefined" {
  let value : Int? = unsafe_cast_option(get_undefined())
  inspect(value, content="None")
}

///|
test "unsafe_cast_option with value" {
  let value : Int? = unsafe_cast_option(get_number())
  inspect(value, content="Some(42)")
}

///| Trait-based conversion tests

///|
pub trait Convertible {
  from_js(Js) -> Self
}

///|
pub impl Convertible for SimpleStruct with from_js(js : Js) -> SimpleStruct {
  unsafe_cast(js)
}

///|
test "Trait-based conversion" {
  let simple : SimpleStruct = SimpleStruct::from_js(get_simple())
  inspect(simple.name, content="Charlie")
  inspect(simple.age, content="35")
}

///| Custom struct Option tests
///
/// CRITICAL FINDING: CustomStruct? behaves differently for null vs undefined
/// - null: becomes Some(null) - DANGEROUS, crashes on field access
/// - undefined: becomes None - SAFE
///
/// This means CustomStruct? is only safe if JavaScript APIs exclusively use undefined,
/// but many DOM APIs return null, making this pattern unsafe in practice.

///|
pub(all) struct CustomStruct {
  id : Int
  name : String
} derive(Show)

///|
pub impl JsImpl for CustomStruct

///|
pub(all) struct ContainerWithCustom {
  required : String
  optional : CustomStruct?
}

///|
pub impl JsImpl for ContainerWithCustom

///|
extern "js" fn create_with_null_custom() -> Js =
  #|() => ({
  #|  required: "test",
  #|  optional: null
  #|})

///|
extern "js" fn create_with_undefined_custom() -> Js =
  #|() => ({
  #|  required: "test",
  #|  optional: undefined
  #|})

///|
extern "js" fn create_with_custom_value() -> Js =
  #|() => ({
  #|  required: "test",
  #|  optional: { id: 42, name: "Alice" }
  #|})

///|
test "CustomStruct? field with null" {
  let obj : ContainerWithCustom = create_with_null_custom() |> unsafe_cast
  let raw = obj.to_js().get("optional")
  inspect(is_nullish(raw), content="true")

  // CustomStruct? field with null - same issue as Js?
  match obj.optional {
    Some(_) =>
      inspect("has value (possibly null)", content="has value (possibly null)")
    None => inspect("None", content="?")
  }
}

///|
test "CustomStruct? field with undefined" {
  let obj : ContainerWithCustom = create_with_undefined_custom() |> unsafe_cast
  let raw = obj.to_js().get("optional")
  inspect(is_nullish(raw), content="true")

  // CustomStruct? field with undefined
  match obj.optional {
    Some(_) => inspect("has value (possibly undefined)", content="?")
    None => inspect("None", content="None")
  }
}

///|
test "CustomStruct? field with value" {
  let obj : ContainerWithCustom = create_with_custom_value() |> unsafe_cast
  let raw = obj.to_js().get("optional")
  inspect(is_nullish(raw), content="false")

  // CustomStruct? field with actual value
  match obj.optional {
    Some(s) => {
      inspect(s.id, content="42")
      inspect(s.name, content="Alice")
    }
    None => inspect("None", content="?")
  }
}

///| from_option tests

///|
test "from_option with Some(Int)" {
  let opt : Int? = Some(42)
  let js_val = from_option(opt)
  inspect(is_nullish(js_val), content="false")
  let back : Int = js_val |> unsafe_cast
  inspect(back, content="42")
}

///|
test "from_option with None" {
  let opt : Int? = None
  let js_val = from_option(opt)
  inspect(is_nullish(js_val), content="true")
  inspect(is_null(js_val), content="true")
}

///|
test "from_option with Some(String)" {
  let opt : String? = Some("hello")
  let js_val = from_option(opt)
  inspect(is_nullish(js_val), content="false")
  let back : String = js_val |> unsafe_cast
  inspect(back, content="hello")
}

///|
test "from_option roundtrip" {
  let original : Int? = Some(123)
  let js_val = from_option(original)
  let restored : Int? = unsafe_cast_option(js_val)
  inspect(restored, content="Some(123)")
}

///|
test "from_option roundtrip with None" {
  let original : String? = None
  let js_val = from_option(original)
  let restored : String? = unsafe_cast_option(js_val)
  inspect(restored, content="None")
}
