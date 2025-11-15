///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
using @async {type Promise, promisify0, promisify1, run_async, sleep}

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
pub impl Js for TestContext with to_js(self) -> Val {
  self |> unsafe_cast
}

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
pub fn NodeTest::before_each(self : Self, f : async () -> Unit) -> Unit noraise {
  let af = promisify0(f)
  self.invoke("beforeEach", [js(af)]) |> ignore
}

///|
pub fn it(
  name : String,
  skip? : String,
  op : async (TestContext) -> Unit,
) -> Unit {
  run_async(async fn() noraise {
    let t = NodeTest::require()
    t.it(name, skip?, ctx => op(ctx))
  })
}

///|
pub fn before_each(op : async () -> Unit) -> Unit {
  run_async(async fn() noraise {
    let t = NodeTest::require()
    t.before_each(() => op())
  })
}

///|
test {
  before_each(() => sleep(1))
  it("simple test", _ => assert_eq(2 + 2, 4))
  it("lazy test", _ => {
    sleep(100)
    assert_eq(2 + 2, 4)
  })
  it("skip test", skip="skip this test", _ => assert_eq(2 + 2, 5))
  it("todo test", ctx => ctx.todo("this test is todo"))
}
