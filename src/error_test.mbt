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
    throw_(err.to_any())
  }) catch {
    e => error_str = e.to_string()
  }
  inspect(error_str, content="Show test error")
}

///|
test "ThrowError::from with TypeError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testTypeError = new TypeError('Type error')"),
  ])
  |> ignore
  let js_error = global._get("testTypeError")
  let throw_error = ThrowError::from(js_error)
  match throw_error {
    ThrowError::TypeError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from with RangeError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testRangeError = new RangeError('Range error')"),
  ])
  |> ignore
  let js_error = global._get("testRangeError")
  let throw_error = ThrowError::from(js_error)
  match throw_error {
    ThrowError::RangeError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from with ReferenceError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testRefError = new ReferenceError('Ref error')"),
  ])
  |> ignore
  let js_error = global._get("testRefError")
  let throw_error = ThrowError::from(js_error)
  match throw_error {
    ThrowError::ReferenceError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from with SyntaxError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testSyntaxError = new SyntaxError('Syntax error')"),
  ])
  |> ignore
  let js_error = global._get("testSyntaxError")
  let throw_error = ThrowError::from(js_error)
  match throw_error {
    ThrowError::SyntaxError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from with URIError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testURIError = new URIError('URI error')"),
  ])
  |> ignore
  let js_error = global._get("testURIError")
  let throw_error = ThrowError::from(js_error)
  match throw_error {
    ThrowError::URIError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from with EvalError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testEvalError = new EvalError('Eval error')"),
  ])
  |> ignore
  let js_error = global._get("testEvalError")
  let throw_error = ThrowError::from(js_error)
  match throw_error {
    ThrowError::EvalError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from with AggregateError" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testAggError = new AggregateError([], 'Agg error')"),
  ])
  |> ignore
  let js_error = global._get("testAggError")
  let throw_error = ThrowError::from(js_error)
  match throw_error {
    ThrowError::AggregateError(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from with generic Error" {
  let global = @global.global_this()
  global._call("eval", [
    @nostd.any("globalThis.testGenericError = new Error('Generic error')"),
  ])
  |> ignore
  let js_error = global._get("testGenericError")
  let throw_error = ThrowError::from(js_error)
  match throw_error {
    ThrowError::Error(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "ThrowError::from with non-error value" {
  let value = @nostd.any("plain string value")
  let throw_error = ThrowError::from(value)
  match throw_error {
    ThrowError::Value(_) => inspect(true, content="true")
    _ => inspect(false, content="true")
  }
}

///|
test "JsIterator::drop" {
  let arr = @nostd.any([1, 2, 3, 4, 5])
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr)
  let dropped = iter.drop(2)
  let result = dropped.toArray()
  inspect(result.length(), content="3")
  inspect(result[0], content="3")
  inspect(result[1], content="4")
  inspect(result[2], content="5")
}

///|
test "JsIterator::take" {
  let arr = @nostd.any([1, 2, 3, 4, 5])
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr)
  let taken = iter.take(3)
  let result = taken.toArray()
  inspect(result.length(), content="3")
  inspect(result[0], content="1")
  inspect(result[1], content="2")
  inspect(result[2], content="3")
}

///|
test "JsIterator::drop and take combined" {
  let arr = @nostd.any([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr)
  let result = iter.drop(2).take(5).toArray()
  inspect(result.length(), content="5")
  inspect(result[0], content="2")
  inspect(result[4], content="6")
}
