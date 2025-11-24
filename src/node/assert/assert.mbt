///|
/// node:assert module
fn assert_module() -> @js.Any {
  @node.require("node:assert")
}

///| Basic Assertions

///|
/// Assert that a value is truthy
pub fn ok(value : Bool, message? : String) -> Unit {
  let a = assert_module()
  match message {
    Some(msg) => a.call2("ok", value, msg) |> ignore
    None => a.call("ok", [value]) |> ignore
  }
}

///|
/// Assert equality (==)
pub fn equal(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_module()
  match message {
    Some(msg) =>
      a.call("equal", [actual.to_any(), expected.to_any(), msg]) |> ignore
    None => a.call2("equal", actual.to_any(), expected.to_any()) |> ignore
  }
}

///|
/// Assert inequality (!=)
pub fn notEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_module()
  match message {
    Some(msg) =>
      a.call("notEqual", [actual.to_any(), expected.to_any(), msg]) |> ignore
    None => a.call2("notEqual", actual.to_any(), expected.to_any()) |> ignore
  }
}

///|
/// Assert deep equality
pub fn deepEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_module()
  match message {
    Some(msg) =>
      a.call("deepEqual", [actual.to_any(), expected.to_any(), msg]) |> ignore
    None => a.call2("deepEqual", actual.to_any(), expected.to_any()) |> ignore
  }
}

///|
/// Assert deep inequality
pub fn notDeepEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_module()
  match message {
    Some(msg) =>
      a.call("notDeepEqual", [actual.to_any(), expected.to_any(), msg])
      |> ignore
    None =>
      a.call2("notDeepEqual", actual.to_any(), expected.to_any()) |> ignore
  }
}

///|
/// Assert strict equality (===)
pub fn strictEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_module()
  match message {
    Some(msg) =>
      a.call("strictEqual", [actual.to_any(), expected.to_any(), msg]) |> ignore
    None => a.call2("strictEqual", actual.to_any(), expected.to_any()) |> ignore
  }
}

///|
/// Assert strict inequality (!==)
pub fn notStrictEqual(
  actual : &@js.JsImpl,
  expected : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_module()
  match message {
    Some(msg) =>
      a.call("notStrictEqual", [actual.to_any(), expected.to_any(), msg])
      |> ignore
    None =>
      a.call2("notStrictEqual", actual.to_any(), expected.to_any()) |> ignore
  }
}

///| Error Assertions

///|
/// Assert that a function throws
pub fn throws(fn_ : () -> Unit, message? : String) -> Unit {
  let a = assert_module()
  match message {
    Some(msg) => a.call2("throws", @js.from_fn0(fn_), msg) |> ignore
    None => a.call("throws", [@js.from_fn0(fn_)]) |> ignore
  }
}

///|
/// Assert that a function does not throw
pub fn doesNotThrow(fn_ : () -> Unit, message? : String) -> Unit {
  let a = assert_module()
  match message {
    Some(msg) => a.call2("doesNotThrow", @js.from_fn0(fn_), msg) |> ignore
    None => a.call("doesNotThrow", [@js.from_fn0(fn_)]) |> ignore
  }
}

///|
/// Assert that a promise rejects
pub fn rejects(
  promise : &@js.JsImpl,
  error? : &@js.JsImpl,
  message? : String,
) -> @js.Promise[Unit] {
  let a = assert_module()
  match (error, message) {
    (Some(err), Some(msg)) =>
      a.call("rejects", [promise.to_any(), err.to_any(), msg]).cast()
    (Some(err), None) =>
      a.call2("rejects", promise.to_any(), err.to_any()).cast()
    (None, Some(msg)) => a.call2("rejects", promise.to_any(), msg).cast()
    (None, None) => a.call("rejects", [promise.to_any()]).cast()
  }
}

///|
/// Assert that a promise does not reject
pub fn doesNotReject(
  promise : &@js.JsImpl,
  message? : String,
) -> @js.Promise[Unit] {
  let a = assert_module()
  match message {
    Some(msg) => a.call2("doesNotReject", promise.to_any(), msg).cast()
    None => a.call("doesNotReject", [promise.to_any()]).cast()
  }
}

///| Other Assertions

///|
/// Always fails
pub fn fail(message? : String) -> Unit {
  let a = assert_module()
  match message {
    Some(msg) => a.call("fail", [msg]) |> ignore
    None => a.call0("fail") |> ignore
  }
}

///|
/// Create RegExp from string
extern "js" fn create_regexp(pattern : String) -> @js.Any =
  #|(pattern) => new RegExp(pattern)

///|
/// Assert regex match
pub fn match_(actual : String, regexp : String, message? : String) -> Unit {
  let a = assert_module()
  let regex = create_regexp(regexp)
  match message {
    Some(msg) => a.call("match", [actual, regex, msg]) |> ignore
    None => a.call2("match", actual, regex) |> ignore
  }
}

///|
/// Assert regex does not match
pub fn doesNotMatch(
  actual : String,
  regexp : String,
  message? : String,
) -> Unit {
  let a = assert_module()
  let regex = create_regexp(regexp)
  match message {
    Some(msg) => a.call("doesNotMatch", [actual, regex, msg]) |> ignore
    None => a.call2("doesNotMatch", actual, regex) |> ignore
  }
}

///|
/// Assert that value is instance of constructor
pub fn instanceOf(
  value : &@js.JsImpl,
  ctor : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_module()
  match message {
    Some(msg) =>
      a.call("instanceOf", [value.to_any(), ctor.to_any(), msg]) |> ignore
    None => a.call2("instanceOf", value.to_any(), ctor.to_any()) |> ignore
  }
}

///|
/// Assert that value is not instance of constructor
pub fn notInstanceOf(
  value : &@js.JsImpl,
  ctor : &@js.JsImpl,
  message? : String,
) -> Unit {
  let a = assert_module()
  match message {
    Some(msg) =>
      a.call("notInstanceOf", [value.to_any(), ctor.to_any(), msg]) |> ignore
    None => a.call2("notInstanceOf", value.to_any(), ctor.to_any()) |> ignore
  }
}
