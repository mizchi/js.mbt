///|
pub struct JsFunction(Value)

///|
pub fn Value::as_function(self : Value) -> JsFunction {
  JsFunction(self)
}

///|
pub fn JsFunction::to_value(self : JsFunction) -> Value {
  self.0
}

///|
pub extern "js" fn JsFunction::call(
  self : JsFunction,
  args : Array[Value],
) -> Value =
  #| (f, ...args) => f(...args)

///|
pub extern "js" fn JsFunction::name(self : JsFunction) -> String? =
  #| (f) => f.name

///|
extern "js" fn ffi_try_call(f : () -> Value raise) -> Value noraise =
  #|(f) => {
  #|  try {
  #|    return { isError: false, value: f() };
  #|  } catch (e) {
  #|    return { isError: true, value: e };
  #|  }
  #|}

///|
pub fn[T] JsFunction::call_with_try(
  self : Self,
  args : Array[Value],
) -> T raise JsError {
  let v = ffi_try_call(() => self.call(args))
  let is_error : Bool = v.get("isError").cast()
  let result = v.get("value")
  if is_error {
    raise result |> identity |> JsError
  }
  return result.cast()
}

///|
pub suberror JsError Value

///|
extern "js" fn test_no_error_fn() -> JsFunction = "() => () => 1"

///|
extern "js" fn test_error_thrower_fn() -> JsFunction = "() => () => { throw new TypeError('This is a test TypeError'); }"

///|
test {
  let test_fn = test_no_error_fn()
  let args : Array[Value] = []
  let r : Result[Int, JsError] = try? test_fn.call_with_try(args)
  match r {
    Ok(v) => log("Function call succeeded with value: \{v}")
    _ => fail("Function call was expected to succeed")
  }
}

///|
test {
  let test_fn = test_error_thrower_fn()
  let args : Array[Value] = []
  let r : Result[Int, JsError] = try? test_fn.call_with_try(args)
  match r {
    Err(_e) => assert_true(true)
    _ => fail("Function call was expected to fail")
  }
}
