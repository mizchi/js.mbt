///|
fn nodetest() -> Js {
  unsafe_cast(@node.require("node:test"))
}

///|
#external
type TestContext

///|
pub impl JsImpl for TestContext

///|
pub fn TestContext::todo(self : Self, description : String) -> Unit {
  self.invoke("todo", [@js.js(description)]) |> ignore
}

///|
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
  nodetest().invoke("it", args) |> ignore
}

///|
#alias(before_all)
pub fn beforeAll(f : async () -> Unit) -> Unit {
  nodetest().invoke("beforeEach", [f |> promisify0 |> @js.from_fn0]) |> ignore
}

///|
#alias(after_all)
pub fn afterAll(f : async () -> Unit) -> Unit {
  nodetest().invoke("beforeEach", [f |> promisify0 |> @js.from_fn0]) |> ignore
}

///|
#alias(before_each)
pub fn beforeEach(f : async () -> Unit) -> Unit {
  nodetest().invoke("beforeEach", [f |> promisify0 |> @js.from_fn0]) |> ignore
}

///|
#alias(after_each)
pub fn afterEach(f : async () -> Unit) -> Unit {
  nodetest().invoke("afterEach", [f |> promisify0 |> @js.from_fn0]) |> ignore
}
