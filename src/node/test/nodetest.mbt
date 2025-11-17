///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
using @promise {type Promise, promisify0, promisify1, run_async, sleep}

///|
/// node:test
#external
type NodeTest

///|
impl Js for NodeTest

///|
pub fn NodeTest::require() -> NodeTest {
  unsafe_cast(@node.require("node:test"))
}

///|
#external
type TestContext

///|
pub impl Js for TestContext

///|
pub fn TestContext::todo(self : Self, description : String) -> Unit {
  self.invoke("todo", [js(description)]) |> ignore
}

///|
pub fn NodeTest::it(
  self : Self,
  name : String,
  f : async (TestContext) -> Unit,
  skip? : String,
) -> Unit noraise {
  let af = promisify1(f)
  let args : Array[&Js] = if skip is Some(skip) {
    let arg : Json = { "skip": skip }
    [name, arg, js(af)]
  } else {
    [name, js(af)]
  }
  self.invoke("it", args) |> ignore
}

///|
// pub fn NodeTest::beforeEach(self : Self, f : async () -> Unit) -> Unit noraise {
//   self.invoke("beforeEach", [f |> promisify0 |> @js.from_fn0]) |> ignore
// }

///|
pub fn NodeTest::afterEach(self : Self, f : async () -> Unit) -> Unit noraise {
  let af = promisify0(f)
  self.invoke("afterEach", [@js.from_fn0(af)]) |> ignore
}

///|
pub fn it(
  name : String,
  skip? : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  let args : Array[&Js] = if skip is Some(skip) {
    let arg : Json = { "skip": skip }
    [name, arg, promisify1(f) |> @js.from_fn1]
  } else {
    [name, promisify1(f) |> @js.from_fn1]
  }
  NodeTest::require().invoke("it", args) |> ignore
}

///|
#alias(before_each)
pub fn beforeEach(f : async () -> Unit) -> Unit {
  NodeTest::require().invoke("beforeEach", [f |> promisify0 |> @js.from_fn0])
  |> ignore
}

///|
#alias(after_each)
pub fn afterEach(f : async () -> Unit) -> Unit {
  NodeTest::require().invoke("afterEach", [f |> promisify0 |> @js.from_fn0])
  |> ignore
}
