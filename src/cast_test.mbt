// ///|
// /// Test basic js() function with primitives
// test "js() with primitives" {
//   // Int
//   let int_val : Val = js(42)
//   assert_eq(unsafe_cast(int_val), 42)

//   // String
//   let str_val : Val = js("hello")
//   assert_eq(unsafe_cast(str_val), "hello")

//   // Bool
//   let bool_val : Val = js(true)
//   assert_eq(unsafe_cast(bool_val), true)

//   // Double
//   let double_val : Val = js(3.14)
//   assert_eq(unsafe_cast(double_val), 3.14)
// }

// ///|
// /// Test js_safe() function with types implementing Js trait
// test "js_safe() with Js trait types" {
//   // Int implements Js
//   let int_val : Val = js_safe(42)
//   assert_eq(unsafe_cast(int_val), 42)

//   // String implements Js
//   let str_val : Val = js_safe("hello")
//   assert_eq(unsafe_cast(str_val), "hello")

//   // Bool implements Js
//   let bool_val : Val = js_safe(true)
//   assert_eq(unsafe_cast(bool_val), true)
// }

// ///|
// /// Test js() vs js_safe() behavior
// test "js() vs js_safe()" {
//   // Both should produce the same result for primitive types
//   let js_int : Val = js(100)
//   let js_safe_int : Val = js_safe(100)
//   let int1 : Int = unsafe_cast(js_int)
//   let int2 : Int = unsafe_cast(js_safe_int)
//   assert_eq(int1, int2)
//   let js_str : Val = js("test")
//   let js_safe_str : Val = js_safe("test")
//   let str1 : String = unsafe_cast(js_str)
//   let str2 : String = unsafe_cast(js_safe_str)
//   assert_eq(str1, str2)
// }

// ///|
// /// Helper function to check if a value is a trait object
// /// Trait objects have structure: { self: ..., method_0: ... }
// fn is_trait_object(v : Val) -> Bool {
//   v.has_own_property("self") && v.has_own_property("method_0")
// }

// ///|
// /// Test trait object structure when using js()
// test "js() with trait object" {
//   // When we cast a trait reference with js(), it might expose internal structure
//   let show_trait : &Show = "hello"
//   let show_val : Val = js(show_trait)
//   inspect(is_trait_object(show_val), content="true")

//   // Trait object should have 'self' and 'method_0' properties
//   assert_true(show_val.has_own_property("self"))
//   assert_true(show_val.has_own_property("method_0"))
// }

// ///|
// /// Test another trait object to confirm the pattern
// test "trait object properties with another trait" {
//   let show_int : &Show = 42
//   let show_val : Val = js(show_int)

//   // Check if it's a trait object
//   inspect(is_trait_object(show_val), content="true")

//   // Int trait object should also have the same structure
//   assert_true(show_val.has_own_property("self"))
//   assert_true(show_val.has_own_property("method_0"))
// }

// ///|
// /// Test Array conversion with js() and js_safe()
// test "js() with array" {
//   let arr = [1, 2, 3]
//   let arr_val : Val = js(arr)
//   assert_true(is_array(arr_val))
//   assert_eq(unsafe_cast(arr_val.get("0")), 1)
//   assert_eq(unsafe_cast(arr_val.get("1")), 2)
//   assert_eq(unsafe_cast(arr_val.get("2")), 3)
// }

// ///|
// /// Test Array with Js trait implementation
// test "js_safe() with Array[T : Js]" {
//   let arr = [1, 2, 3]
//   let arr_val : Val = js_safe(arr)
//   assert_true(is_array(arr_val))
//   assert_eq(unsafe_cast(arr_val.get("0")), 1)
// }

// ///|
// /// Test Option conversion
// test "js() with Option" {
//   let some_val : Int? = Some(42)
//   let some_js : Val = js(some_val)
//   assert_eq(unsafe_cast(some_js), 42)
//   let none_val : Int? = None
//   let none_js : Val = js(none_val)
//   assert_true(is_undefined(none_js))
// }

// ///|
// /// Test Option with js_safe()
// test "js_safe() with Option" {
//   let some_val : Int? = Some(100)
//   let some_js : Val = js_safe(some_val)
//   assert_eq(unsafe_cast(some_js), 100)
//   let none_val : Int? = None
//   let none_js : Val = js_safe(none_val)
//   assert_true(is_undefined(none_js))
// }

// ///|
// /// Test unsafe_cast between different types
// test "unsafe_cast" {
//   let int_val : Int = 42
//   let val : Val = unsafe_cast(int_val)
//   let back_to_int : Int = unsafe_cast(val)
//   assert_eq(back_to_int, 42)
// }

// ///|
// /// Test to_option conversion
// test "to_option with Some and None" {
//   let val : Val = js(42)
//   let opt : Int? = to_option(val)
//   assert_eq(opt, Some(42))
//   let null_val : Val = null_()
//   let null_opt : Int? = to_option(null_val)
//   assert_eq(null_opt, None)
//   let undef_val : Val = undefined()
//   let undef_opt : Int? = to_option(undef_val)
//   assert_eq(undef_opt, None)
// }

// ///|
// /// Test cast_array function
// test "cast_array" {
//   let arr = [1, 2, 3]
//   let arr_val : Val = cast_array(arr)
//   assert_true(is_array(arr_val))
//   assert_eq(unsafe_cast(arr_val.get("length")), 3)
// }

// ///|
// /// Test cast_fn0 (function with no arguments)
// test "cast_fn0" {
//   let f = fn() -> Int { 42 }
//   let f_val : Val = cast_fn0(f)
//   let result : Val = f_val.invoke_self([])
//   assert_eq(unsafe_cast(result), 42)
// }

// ///|
// /// Test cast_fn1 (function with one argument)
// test "cast_fn1" {
//   let f = fn(x : Int) -> Int { x * 2 }
//   let f_val : Val = cast_fn1(f)
//   let result : Val = f_val.invoke_self([js(10)])
//   assert_eq(unsafe_cast(result), 20)
// }

// ///|
// /// Test cast_fn2 (function with two arguments)
// test "cast_fn2" {
//   let f = fn(x : Int, y : Int) -> Int { x + y }
//   let f_val : Val = cast_fn2(f)
//   let result : Val = f_val.invoke_self([js(10), js(20)])
//   assert_eq(unsafe_cast(result), 30)
// }

// ///|
// /// Test cast_fn3 (function with three arguments)
// test "cast_fn3" {
//   let f = fn(x : Int, y : Int, z : Int) -> Int { x + y + z }
//   let f_val : Val = cast_fn3(f)
//   let result : Val = f_val.invoke_self([js(10), js(20), js(30)])
//   assert_eq(unsafe_cast(result), 60)
// }

// ///|
// /// Custom struct to test js() behavior
// struct CustomStruct {
//   name : String
//   age : Int
// } derive(Show)

// ///|
// /// Test js() with custom struct
// test "js() with custom struct" {
//   let obj : CustomStruct = { name: "Alice", age: 30 }
//   let obj_val : Val = js(obj)

//   // Struct should become a JS object
//   assert_true(is_object(obj_val))
//   assert_eq(unsafe_cast(obj_val.get("name")), "Alice")
//   assert_eq(unsafe_cast(obj_val.get("age")), 30)
// }

// ///|
// /// Test what happens when we use js() on a trait reference vs actual value
// test "js() trait reference vs value comparison" {
//   let str_value : String = "hello"
//   let str_trait : &Js = str_value
//   let val_from_value : Val = js(str_value)
//   let val_from_trait : Val = js(str_trait)

//   // val_from_value should be the string
//   assert_eq(unsafe_cast(val_from_value), "hello")

//   // val_from_trait might be a trait object
//   inspect(is_trait_object(val_from_trait), content="true")
// }

// ///|
// /// Test js_safe() with trait-implementing type
// test "js_safe() ensures Js trait" {
//   // This should work because String implements Js
//   let str_val : Val = js_safe("test")
//   assert_eq(unsafe_cast(str_val), "test")

//   // This should also work because Int implements Js
//   let int_val : Val = js_safe(42)
//   assert_eq(unsafe_cast(int_val), 42)

//   // Array[T : Js] also implements Js
//   let arr_val : Val = js_safe([1, 2, 3])
//   assert_true(is_array(arr_val))
// }

// ///|
// /// Test to inspect the actual structure of a trait object
// test "inspect trait object structure" {
//   let show_trait : &Show = "hello"
//   let show_val : Val = js(show_trait)

//   // Log the trait object to see its structure
//   inspect(
//     show_val.to_string(),
//     content=(
//       #|{"self":"hello"}
//     ),
//   )
// }

// ///|
// /// Test difference between direct value and trait object conversion
// test "direct value vs trait object conversion" {
//   let str_value : String = "test"
//   let str_trait : &Show = str_value

//   // Direct conversion
//   let direct : Val = js(str_value)
//   inspect(
//     direct.to_string(),
//     content=(
//       #|test
//     ),
//   )

//   // Trait object conversion
//   let via_trait : Val = js(str_trait)
//   inspect(
//     via_trait.to_string(),
//     content=(
//       #|{"self":"test"}
//     ),
//   )

//   // They are different!
//   assert_true(is_trait_object(via_trait))
//   assert_false(is_trait_object(direct))
// }

// ///|
// /// Test js_safe with actual Js trait implementation
// test "js_safe with Js trait prevents trait object leak" {
//   // When we use js_safe with a value that implements Js,
//   // it should use the to_js() method from the Js trait
//   let str_value : String = "safe"
//   let safe_val : Val = js_safe(str_value)

//   // Should be the direct value, not a trait object
//   inspect(
//     safe_val.to_string(),
//     content=(
//       #|safe
//     ),
//   )
//   assert_false(is_trait_object(safe_val))
// }
