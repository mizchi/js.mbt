// TODO: this test will be useless after async test support is added to moonbit

extern "js" fn ffi_import_node_test() -> Promise[Value] = "() => import('node:test')"

///|
#external
pub type NodeTest
///|
impl ToJs for NodeTest with to_js(self) -> Value {
  self |> identity
}
///|
pub async fn NodeTest::load() -> NodeTest {
  ffi_import_node_test().wait().cast()
}

///|
#external
pub type TestContext
///|
pub impl ToJs for TestContext with to_js(self) -> Value {
  self |> identity
}

pub fn TestContext::todo(self: Self, description: String) -> Unit {
  self.to_js().call_property("todo", [to_js(description)]) |> ignore
}

pub fn NodeTest::it(
  self: Self,
  name : String,
  f : async (TestContext) -> Unit raise,
  skip?: String
) -> Unit noraise {
  let af = to_promise_fn1(f)

  let args: Array[&ToJs] = if skip is Some(skip) {
    let arg = Object::from({
      "skip": skip
    })
    [to_js(name), arg, to_js(af)]
  } else {
    [to_js(name), to_js(af)]
  }
  self.to_js().call_property("it", args) |> ignore
}

pub fn NodeTest::before_each(
  self: Self,
  f : async () -> Unit raise,
) -> Unit noraise {
  let af = to_promise_fn0(f)
  self.to_js().call_property("beforeEach", [to_js(af)]) |> ignore
}

///|
test {
  run_async(() => {
    let t = NodeTest::load() catch { _ => panic() }
    t.it("t1", _ => assert_eq(1 + 1, 2))
    t.it("t2", skip="skip this test", _ => assert_eq(1 + 1, 3))
    t.it("todo test", ctx => {
      ctx.todo("this test is todo")
    })
  })
}
test {
  run_async(() => {
    let t = NodeTest::load() catch { _ => panic() }
    t.it("t3", _ctx => assert_eq(1 + 1, 2))
    // t.it("t4", _ctx => assert_eq(1 + 1, 3))
    t.it("t5", skip="skip this test", _ctx => assert_eq(1 + 1, 3))
  })
}