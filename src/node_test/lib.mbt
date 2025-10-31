using @val {
  type Val,
  type Promise,
  trait Js,
  js,
  unsafe_cast,
  to_promise_fn0,
  to_promise_fn1,
  run_async,
}

using @module {
  import_module,
}

extern "js" fn ffi_sleep(ms : Int) -> Promise[Unit] =
  #| (ms) => new Promise((resolve) => setTimeout(resolve, ms))
///|
async fn sleep(ms : Int) -> Unit {
  ffi_sleep(ms).unwrap() catch {
    _ => ()
  }
}

///|
#external
type NodeTest

///|
impl Js for NodeTest with to_js(self) -> Val {
  self |> js
}

///|
async fn NodeTest::load() -> NodeTest {
  import_module("node:test")
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
  self.to_js().call_method("todo", [js(description)]) |> ignore
}

///|
pub fn NodeTest::it(
  self : Self,
  name : String,
  f : async (TestContext) -> Unit,
  skip? : String,
) -> Unit noraise {
  let af = to_promise_fn1(f)
  let args : Array[&Js] = if skip is Some(skip) {
    let arg = @val.new_object()
    arg.set("skip", skip)
    [js(name), arg, js(af)]
  } else {
    [js(name), js(af)]
  }
  self.to_js().call_method("it", args) |> ignore
}

///|
pub fn NodeTest::before_each(self : Self, f : async () -> Unit) -> Unit noraise {
  let af = to_promise_fn0(f)
  self.to_js().call_method("beforeEach", [js(af)]) |> ignore
}

///|
pub fn it(
  name : String,
  skip? : String,
  op : async (TestContext) -> Unit,
) -> Unit {
  run_async(async fn() noraise {
    let t = NodeTest::load() catch { _ => panic() }
    t.it(name, skip?, ctx => op(ctx))
  })
}

///|
pub fn before_each(op : async () -> Unit) -> Unit {
  run_async(async fn() noraise {
    let t = NodeTest::load() catch { _ => panic() }
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
