///|
/// Tests for Show implementations and to_string methods

///|
test "JsError Show implementation" {
  let error = JsError::new("Test error message")
  let str = error.to_string()
  inspect(str, content="Test error message")
  // Test that output() uses to_string()
  inspect(error, content="Test error message")
}

///|
test "JsError with cause" {
  let cause = JsError::new("Root cause")
  let error = JsError::new("Main error", cause~)
  let str = error.to_string()
  inspect(str, content="Main error")
}

///|
test "ThrowError Show through throwable" {
  // Test Error variant
  let mut error_str = ""
  throwable(fn() {
    let err = JsError::new("Show test error")
    throw_(err)
  }) catch {
    e => error_str = e.to_string()
  }
  inspect(error_str, content="Show test error")
}

///|
test "ThrowError::from_js with TypeError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testTypeError = new TypeError('Type error')"),
  ])
  |> ignore
  let js_error = global.get("testTypeError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::TypeError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with RangeError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testRangeError = new RangeError('Range error')"),
  ])
  |> ignore
  let js_error = global.get("testRangeError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::RangeError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with ReferenceError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testRefError = new ReferenceError('Ref error')"),
  ])
  |> ignore
  let js_error = global.get("testRefError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::ReferenceError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with SyntaxError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testSyntaxError = new SyntaxError('Syntax error')"),
  ])
  |> ignore
  let js_error = global.get("testSyntaxError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::SyntaxError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with URIError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testURIError = new URIError('URI error')"),
  ])
  |> ignore
  let js_error = global.get("testURIError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::URIError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with EvalError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testEvalError = new EvalError('Eval error')"),
  ])
  |> ignore
  let js_error = global.get("testEvalError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::EvalError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with AggregateError" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testAggError = new AggregateError([], 'Agg error')"),
  ])
  |> ignore
  let js_error = global.get("testAggError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::AggregateError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with generic Error" {
  let global = @js.globalThis()
  global.call("eval", [
    @js.js("globalThis.testGenericError = new Error('Generic error')"),
  ])
  |> ignore
  let js_error = global.get("testGenericError")
  let throw_error = ThrowError::from_js(js_error)
  match throw_error {
    ThrowError::Error(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from_js with non-error value" {
  let value = @js.js("plain string value")
  let throw_error = ThrowError::from_js(value)
  match throw_error {
    ThrowError::Value(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "JsIterator::drop" {
  let arr = @js.JsArray::new()
  arr.push(1)
  arr.push(2)
  arr.push(3)
  arr.push(4)
  arr.push(5)
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr.to_js())
  let dropped = iter.drop(2)
  let result = dropped.toArray()
  inspect(result.length(), content="3")
  inspect(result[0], content="3")
  inspect(result[1], content="4")
  inspect(result[2], content="5")
}

///|
test "JsIterator::take" {
  let arr = @js.JsArray::new()
  arr.push(1)
  arr.push(2)
  arr.push(3)
  arr.push(4)
  arr.push(5)
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr.to_js())
  let taken = iter.take(3)
  let result = taken.toArray()
  inspect(result.length(), content="3")
  inspect(result[0], content="1")
  inspect(result[1], content="2")
  inspect(result[2], content="3")
}

///|
test "JsIterator::drop and take combined" {
  let arr = @js.JsArray::new()
  for i = 0; i < 10; i = i + 1 {
    arr.push(i)
  }
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr.to_js())
  let result = iter.drop(2).take(5).toArray()
  inspect(result.length(), content="5")
  inspect(result[0], content="2")
  inspect(result[4], content="6")
}
