///|
fn nodetest() -> Js {
  unsafe_cast(@node.require("node:test"))
}

///|
#external
pub type TestContext

///|
pub impl JsImpl for TestContext

///|
#external
pub type SuiteContext

///|
pub impl JsImpl for SuiteContext

///| TestContext methods

///|
pub fn TestContext::skip(self : Self, message? : String) -> Unit {
  match message {
    Some(msg) => self.call("skip", [@js.js(msg)]) |> ignore
    None => self.call0("skip") |> ignore
  }
}

///|
pub fn TestContext::todo(self : Self, message? : String) -> Unit {
  match message {
    Some(msg) => self.call("todo", [@js.js(msg)]) |> ignore
    None => self.call0("todo") |> ignore
  }
}

///|
pub fn TestContext::diagnostic(self : Self, message : String) -> Unit {
  self.call("diagnostic", [@js.js(message)]) |> ignore
}

///|
pub fn TestContext::plan(self : Self, count : Int) -> Unit {
  self.call("plan", [@js.js(count)]) |> ignore
}

///|
pub fn TestContext::runOnly(self : Self, shouldRunOnlyTests : Bool) -> Unit {
  self.call("runOnly", [@js.js(shouldRunOnlyTests)]) |> ignore
}

///| Test definition functions

///|
/// test_(name, fn) - Define a test case (test is reserved keyword)
pub fn test_(
  name : String,
  skip? : Bool,
  todo? : Bool,
  only? : Bool,
  timeout? : Int,
  f : async (TestContext) -> Unit,
) -> Unit {
  let options = @js.Object::new()
  if skip is Some(true) {
    options.set("skip", true)
  }
  if todo is Some(true) {
    options.set("todo", true)
  }
  if only is Some(true) {
    options.set("only", true)
  }
  if timeout is Some(t) {
    options.set("timeout", t)
  }
  nodetest().call("test", [name, options, promisify1(f) |> @js.from_fn1])
  |> ignore
}

///|
/// test.skip(name, fn) - Skip a test
pub fn test_skip(name : String, f : async (TestContext) -> Unit) -> Unit {
  test_(name, skip=true, f)
}

///|
/// test.todo(name, fn) - Mark test as TODO
pub fn test_todo(name : String, f? : async (TestContext) -> Unit) -> Unit {
  match f {
    Some(fn_) => test_(name, todo=true, fn_)
    None => {
      let options = @js.Object::new()
      options.set("todo", true)
      nodetest().call2("test", name, options) |> ignore
    }
  }
}

///|
/// test.only(name, fn) - Run only this test
pub fn test_only(name : String, f : async (TestContext) -> Unit) -> Unit {
  test_(name, only=true, f)
}

///|
/// it(name, fn) - Alias for test()
pub fn it(
  name : String,
  skip? : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  let args : Array[&JsImpl] = if skip is Some(skip) {
    let arg : Json = { "skip": skip }
    [name, arg, promisify1(f) |> @js.from_fn1]
  } else {
    [name, promisify1(f) |> @js.from_fn1]
  }
  nodetest().call("it", args) |> ignore
}

///|
/// describe(name, fn) - Group related tests (BDD style)
pub fn describe(
  name : String,
  skip? : Bool,
  todo? : Bool,
  only? : Bool,
  f : async (SuiteContext) -> Unit,
) -> Unit {
  let options = @js.Object::new()
  if skip is Some(true) {
    options.set("skip", true)
  }
  if todo is Some(true) {
    options.set("todo", true)
  }
  if only is Some(true) {
    options.set("only", true)
  }
  nodetest().call("describe", [name, options, promisify1(f) |> @js.from_fn1])
  |> ignore
}

///|
/// describe.skip(name, fn)
pub fn describe_skip(name : String, f : async (SuiteContext) -> Unit) -> Unit {
  describe(name, skip=true, f)
}

///|
/// describe.todo(name, fn)
pub fn describe_todo(name : String, f? : async (SuiteContext) -> Unit) -> Unit {
  match f {
    Some(fn_) => describe(name, todo=true, fn_)
    None => {
      let options = @js.Object::new()
      options.set("todo", true)
      nodetest().call2("describe", name, options) |> ignore
    }
  }
}

///|
/// describe.only(name, fn)
pub fn describe_only(name : String, f : async (SuiteContext) -> Unit) -> Unit {
  describe(name, only=true, f)
}

///| Lifecycle hooks

///|
/// before(fn) - Run once before suite tests
pub fn before(f : async () -> Unit, timeout? : Int) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(t) {
    options.set("timeout", t)
  }
  nodetest().call2("before", promisify0(f) |> @js.from_fn0, options) |> ignore
}

///|
/// after(fn) - Run once after suite completion
pub fn after(f : async () -> Unit, timeout? : Int) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(t) {
    options.set("timeout", t)
  }
  nodetest().call2("after", promisify0(f) |> @js.from_fn0, options) |> ignore
}

///|
/// beforeEach(fn) - Run before each test
pub fn beforeEach(f : async () -> Unit, timeout? : Int) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(t) {
    options.set("timeout", t)
  }
  nodetest().call2("beforeEach", promisify0(f) |> @js.from_fn0, options)
  |> ignore
}

///|
/// afterEach(fn) - Run after each test
pub fn afterEach(f : async () -> Unit, timeout? : Int) -> Unit {
  let options = @js.Object::new()
  if timeout is Some(t) {
    options.set("timeout", t)
  }
  nodetest().call2("afterEach", promisify0(f) |> @js.from_fn0, options)
  |> ignore
}

///|
/// Aliases for compatibility
#alias(before_all)
pub fn beforeAll(f : async () -> Unit) -> Unit {
  before(f)
}

///|
#alias(after_all)
pub fn afterAll(f : async () -> Unit) -> Unit {
  after(f)
}
