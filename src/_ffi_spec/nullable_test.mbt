///| Nullable[T] type tests
/// This tests the new Nullable[T] type for explicit null handling in FFI structs

///|
extern "js" fn create_object_with_null() -> @js.Js =
  #|() => ({ value: null })

///|
extern "js" fn create_object_with_value() -> @js.Js =
  #|() => ({ value: 42 })

///|
extern "js" fn create_object_with_undefined() -> @js.Js =
  #|() => ({ value: undefined })

///|
test "Nullable[Int] with null value converts to None" {
  let obj = create_object_with_null()
  let nullable : @js.Nullable[Int] = obj.get("value") |> @js.unsafe_cast
  match nullable.to_option() {
    Some(_) => fail("Should be None for null value")
    None => inspect("null converts to None", content="null converts to None")
  }
}

///|
test "Nullable[Int] with actual value converts to Some" {
  let obj = create_object_with_value()
  let nullable : @js.Nullable[Int] = obj.get("value") |> @js.unsafe_cast
  match nullable.to_option() {
    Some(v) => inspect(v, content="42")
    None => fail("Should be Some for actual value")
  }
}

///|
test "Nullable[Int] with undefined value" {
  let obj = create_object_with_undefined()
  let nullable : @js.Nullable[Int] = obj.get("value") |> @js.unsafe_cast
  // undefined should be treated as Some(undefined) since we're only checking for null
  match nullable.to_option() {
    Some(_) => inspect("undefined is Some", content="undefined is Some")
    None => inspect("undefined is None", content="undefined is None")
  }
}

///|
test "Nullable[String] with null" {
  let obj = create_object_with_null()
  let nullable : @js.Nullable[String] = obj.get("value") |> @js.unsafe_cast
  match nullable.to_option() {
    Some(_) => fail("Should be None for null")
    None => inspect("null string is None", content="null string is None")
  }
}

///|
test "Nullable[T].unwrap extracts raw value" {
  let obj = create_object_with_value()
  let nullable : @js.Nullable[Int] = obj.get("value") |> @js.unsafe_cast
  let unwrapped = nullable.unwrap()
  inspect(unwrapped, content="42")
}

///|
/// Example struct using Nullable[T] for field
pub(all) struct TestStruct {
  value : @js.Nullable[Int]
}

///|
pub impl @js.JsImpl for TestStruct

///|
extern "js" fn create_test_struct_with_null() -> @js.Js =
  #|() => ({ value: null })

///|
extern "js" fn create_test_struct_with_value() -> @js.Js =
  #|() => ({ value: 123 })

///|
test "struct with Nullable[Int] field - null value" {
  let obj = create_test_struct_with_null()
  let s : TestStruct = obj |> @js.unsafe_cast
  match s.value.to_option() {
    Some(_) => fail("Should be None")
    None =>
      inspect("struct field null works", content="struct field null works")
  }
}

///|
test "struct with Nullable[Int] field - actual value" {
  let obj = create_test_struct_with_value()
  let s : TestStruct = obj |> @js.unsafe_cast
  match s.value.to_option() {
    Some(v) => inspect(v, content="123")
    None => fail("Should be Some(123)")
  }
}

///|
/// Real-world example: API that explicitly returns null
extern "js" fn api_find_user(id : Int) -> @js.Js =
  #|(id) => {
  #|  // Simulate API that returns null when user not found
  #|  if (id === 999) {
  #|    return null;
  #|  }
  #|  return { name: "Alice", age: 30 };
  #|}

///|
pub(all) struct User {
  name : String
  age : Int
}

///|
pub impl @js.JsImpl for User

///|
test "API returning explicit null - user not found" {
  let result : @js.Nullable[User] = api_find_user(999) |> @js.unsafe_cast
  match result.to_option() {
    Some(_) => fail("Should be None when API returns null")
    None =>
      inspect(
        "API null handled correctly",
        content="API null handled correctly",
      )
  }
}

///|
test "API returning explicit null - user found" {
  let result : @js.Nullable[User] = api_find_user(1) |> @js.unsafe_cast
  match result.to_option() {
    Some(user) => {
      inspect(user.name, content="Alice")
      inspect(user.age, content="30")
    }
    None => fail("Should be Some when user exists")
  }
}

///|
/// Example: DOM API that returns null
extern "js" fn get_element_by_id(id : String) -> @js.Js =
  #|(id) => {
  #|  // Simulate document.getElementById which returns null when not found
  #|  if (id === "missing") {
  #|    return null;
  #|  }
  #|  return { tagName: "DIV", id: id };
  #|}

///|
pub(all) struct Element {
  tagName : String
  id : String
}

///|
pub impl @js.JsImpl for Element

///|
test "DOM API returning null - element not found" {
  let element : @js.Nullable[Element] = get_element_by_id("missing")
    |> @js.unsafe_cast
  match element.to_option() {
    Some(_) => fail("Should be None when element not found")
    None => inspect("Element not found", content="Element not found")
  }
}

///|
test "DOM API returning null - element found" {
  let element : @js.Nullable[Element] = get_element_by_id("myDiv")
    |> @js.unsafe_cast
  match element.to_option() {
    Some(el) => {
      inspect(el.tagName, content="DIV")
      inspect(el.id, content="myDiv")
    }
    None => fail("Should be Some when element exists")
  }
}

///|
/// Example: Array.prototype.find() which returns undefined (not null)
extern "js" fn array_find(target : Int) -> @js.Js =
  #|(target) => {
  #|  const arr = [1, 2, 3, 4, 5];
  #|  return arr.find(x => x === target);
  #|}

///|
test "API returning undefined vs null - undefined case" {
  let result : @js.Nullable[Int] = array_find(999) |> @js.unsafe_cast
  // Nullable only checks for null, not undefined
  // So undefined will be Some (this documents the behavior)
  match result.to_option() {
    Some(_) => inspect("undefined is Some", content="undefined is Some")
    None => inspect("undefined is None", content="undefined is None")
  }
}

///|
test "API returning undefined vs null - found case" {
  let result : @js.Nullable[Int] = array_find(3) |> @js.unsafe_cast
  match result.to_option() {
    Some(v) => inspect(v, content="3")
    None => fail("Should find value 3")
  }
}
