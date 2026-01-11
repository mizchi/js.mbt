///|
test "ToAny - primitive types" {
  // Test basic conversions using Trait::method syntax
  let _int_any : Any = ToAny::to_any(42)
  let _uint_any : Any = ToAny::to_any(42U)
  let _float_any : Any = ToAny::to_any((3.14 : Float))
  let _double_any : Any = ToAny::to_any(3.14)
  let _string_any : Any = ToAny::to_any("hello")
  let _bool_any : Any = ToAny::to_any(true)

  // All should compile and run without errors
}

///|
test "ToAny - array" {
  let arr = [1, 2, 3]
  let _arr_any : Any = ToAny::to_any(arr)

}

///|
test "ToAny - unit" {
  let unit_val : Unit = ()
  let any_val = ToAny::to_any(unit_val)
  inspect(
    is_undefined(any_val),
    content="true", // Unit -> undefined
  )
}

///|
test "ToAny - Any passthrough" {
  let original = any(42)
  let converted = ToAny::to_any(original)
  inspect(equal(original, converted), content="true")
}

///|
/// Example: Generic function using ToAny trait
fn[T : ToAny] set_prop(obj : Any, key : String, value : T) -> Unit {
  obj._set(key, ToAny::to_any(value))
}

///|
test "ToAny - generic function usage" {
  let obj = new_object()
  set_prop(obj, "name", "Alice")
  set_prop(obj, "age", 30)
  set_prop(obj, "active", true)
  let name : String = obj["name"] |> Any::cast()
  let age : Int = obj["age"] |> Any::cast()
  let active : Bool = obj["active"] |> Any::cast()
  inspect(name, content="Alice")
  inspect(age, content="30")
  inspect(active, content="true")
}
