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
///    - Access raw JS object with `obj.as_any().get("field")` and check with `is_nullish()`
///    - Use getter methods with `identity_option()` for nullable fields
///
/// 3. **identity_option() works correctly:**
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
  optionalJs : Any?
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
extern "js" fn create_all_fields() -> Any =
  #|() => ({
  #|  required: "test",
  #|  optionalInt: 42,
  #|  optionalString: "hello",
  #|  optionalJs: { foo: "bar" }
  #|})

///|
extern "js" fn create_null_fields() -> Any =
  #|() => ({
  #|  required: "test",
  #|  optionalInt: null,
  #|  optionalString: null,
  #|  optionalJs: null
  #|})

///|
extern "js" fn create_undefined_fields() -> Any =
  #|() => ({
  #|  required: "test",
  #|  optionalInt: undefined,
  #|  optionalString: undefined,
  #|  optionalJs: undefined
  #|})

///|
extern "js" fn create_missing_fields() -> Any =
  #|() => ({ required: "test" })

///|
extern "js" fn create_nested() -> Any =
  #|() => ({
  #|  id: 1,
  #|  simple: { name: "Alice", age: 30 }
  #|})

///|
extern "js" fn create_null_nested() -> Any =
  #|() => ({
  #|  id: 1,
  #|  nested: null
  #|})

///|
extern "js" fn create_undefined_nested() -> Any =
  #|() => ({
  #|  id: 1,
  #|  nested: undefined
  #|})

///|
extern "js" fn create_null_value() -> Any =
  #|() => ({ value: null })

///|
extern "js" fn get_number() -> Any =
  #|() => 42

///|
extern "js" fn get_null() -> Any =
  #|() => null

///|
extern "js" fn get_undefined() -> Any =
  #|() => undefined

///|
extern "js" fn get_simple() -> Any =
  #|() => ({ name: "Charlie", age: 35 })

///| Test Cases

///|
test "Int? field with all values set" {
  let obj : StructWithOptions = create_all_fields() |> identity
  inspect(obj.optionalInt, content="Some(42)")
}

///|
test "Int? field with null value" {
  let obj : StructWithOptions = create_null_fields() |> identity
  // FFI does not convert null to None - it becomes Some(null)
  // We cannot inspect the value directly as it crashes
  match obj.optionalInt {
    Some(_) => inspect("Some (possibly null)", content="Some (possibly null)")
    None => inspect("None", content="?")
  }
}

///|
test "Int? field with undefined value" {
  let obj : StructWithOptions = create_undefined_fields() |> identity
  inspect(obj.optionalInt, content="None")
}

///|
test "Int? field with missing value" {
  let obj : StructWithOptions = create_missing_fields() |> identity
  inspect(obj.optionalInt, content="None")
}

///|
test "String? field with all values set" {
  let obj : StructWithOptions = create_all_fields() |> identity
  inspect(obj.optionalString, content="Some(\"hello\")")
}

///|
test "String? field with null value" {
  let obj : StructWithOptions = create_null_fields() |> identity
  // FFI does not convert null to None - it becomes Some(null)
  match obj.optionalString {
    Some(_) => inspect("Some (possibly null)", content="Some (possibly null)")
    None => inspect("None", content="?")
  }
}

///|
test "String? field with undefined value" {
  let obj : StructWithOptions = create_undefined_fields() |> identity
  inspect(obj.optionalString, content="None")
}

///|
test "Js? field with all values set" {
  let obj : StructWithOptions = create_all_fields() |> identity
  // Check if optionalJs has a value and contains an object
  match obj.optionalJs {
    Some(v) => inspect(is_object(v), content="?")
    None => inspect("None", content="None")
  }
}

///|
test "Js? field with null value" {
  let obj : StructWithOptions = create_null_fields() |> identity
  // Js? field cannot be matched - it crashes when trying to access $tag
  // Convert to Any and check with is_nullish instead
  let raw : @js.Any = obj.as_any().get("optionalJs")
  inspect(is_nullish(raw), content="true")
}

///|
test "Js? field with undefined value" {
  let obj : StructWithOptions = create_undefined_fields() |> identity
  // Js? field cannot be matched - it crashes when trying to access $tag
  let raw : @js.Any = obj.as_any().get("optionalJs")
  inspect(is_nullish(raw), content="true")
}

///|
test "Nested struct with value" {
  let obj : NestedStruct = create_nested() |> identity
  inspect(obj.simple.name, content="Alice")
  inspect(obj.simple.age, content="30")
}

///|
test "Optional nested struct with value" {
  let obj : StructWithOptionalNested = create_nested() |> identity
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
  let obj : StructWithOptionalNested = create_null_nested() |> identity
  // Cannot inspect SimpleStruct? directly when it contains null
  match obj.nested {
    Some(_) => inspect("has value", content="has value")
    None => inspect("None", content="?")
  }
}

///|
test "Optional nested struct with undefined" {
  let obj : StructWithOptionalNested = create_undefined_nested() |> identity
  inspect(obj.nested, content="None")
}

///|
test "Generic Container[Int]" {
  let js_obj = @js.Object::new()
  js_obj.set("value", 42)
  let container : Container[Int] = js_obj.as_any() |> identity
  inspect(container.value, content="42")
}

///|
test "Generic Container[String]" {
  let js_obj = @js.Object::new()
  js_obj.set("value", "test")
  let container : Container[String] = js_obj.as_any() |> identity
  inspect(container.value, content="test")
}

///|
test "Generic Container[Int?] with value" {
  let js_obj = @js.Object::new()
  js_obj.set("value", 42)
  let container : Container[Int?] = js_obj.as_any() |> identity
  inspect(container.value, content="Some(42)")
}

///|
test "Generic Container[Int?] with null" {
  let container : Container[Int?] = create_null_value() |> identity
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
  js_obj.set("value", simple_obj.as_any())
  let container : Container[SimpleStruct] = js_obj.as_any() |> identity
  inspect(container.value.name, content="Bob")
  inspect(container.value.age, content="25")
}

///|
test "Direct identity to Int? with number" {
  let value : Int? = get_number() |> identity
  inspect(value, content="Some(42)")
}

///|
test "Direct identity to Int? with null" {
  let value : Int? = get_null() |> identity
  // FFI does not convert null to None - it becomes Some(null)
  match value {
    Some(_) => inspect("Some (possibly null)", content="Some (possibly null)")
    None => inspect("None", content="?")
  }
}

///|
test "Direct identity to Int? with undefined" {
  let value : Int? = get_undefined() |> identity
  inspect(value, content="None")
}

///|
test "identity_option with null" {
  let value : Int? = identity_option(get_null())
  inspect(value, content="None")
}

///|
test "identity_option with undefined" {
  let value : Int? = identity_option(get_undefined())
  inspect(value, content="None")
}

///|
test "identity_option with value" {
  let value : Int? = identity_option(get_number())
  inspect(value, content="Some(42)")
}

///| Trait-based conversion tests

///|
pub trait Convertible {
  from_js(Any) -> Self
}

///|
pub impl Convertible for SimpleStruct with from_js(js : @js.Any) -> SimpleStruct {
  @js.identity(js)
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
extern "js" fn create_with_null_custom() -> Any =
  #|() => ({
  #|  required: "test",
  #|  optional: null
  #|})

///|
extern "js" fn create_with_undefined_custom() -> Any =
  #|() => ({
  #|  required: "test",
  #|  optional: undefined
  #|})

///|
extern "js" fn create_with_custom_value() -> Any =
  #|() => ({
  #|  required: "test",
  #|  optional: { id: 42, name: "Alice" }
  #|})

///|
test "CustomStruct? field with null" {
  let obj : ContainerWithCustom = create_with_null_custom() |> identity
  let raw = obj.as_any().get("optional")
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
  let obj : ContainerWithCustom = create_with_undefined_custom() |> identity
  let raw = obj.as_any().get("optional")
  inspect(is_nullish(raw), content="true")

  // CustomStruct? field with undefined
  match obj.optional {
    Some(_) => inspect("has value (possibly undefined)", content="?")
    None => inspect("None", content="None")
  }
}

///|
test "CustomStruct? field with value" {
  let obj : ContainerWithCustom = create_with_custom_value() |> identity
  let raw = obj.as_any().get("optional")
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
  let back : Int = js_val |> identity
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
  let back : String = js_val |> identity
  inspect(back, content="hello")
}

///|
test "from_option roundtrip" {
  let original : Int? = Some(123)
  let js_val = from_option(original)
  let restored : Int? = identity_option(js_val)
  inspect(restored, content="Some(123)")
}

///|
test "from_option roundtrip with None" {
  let original : String? = None
  let js_val = from_option(original)
  let restored : String? = identity_option(js_val)
  inspect(restored, content="None")
}
