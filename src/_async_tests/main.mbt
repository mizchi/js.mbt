///|
fn main {
  beforeEach(() => println("before each test"))
  it("sample test", fn(_) { assert_true(true) })
  it("sample test", fn(_) { assert_true(false) })
  // beforeEach(() => sleep(1))
  it("simple test", _ => assert_eq(2 + 2, 4))
  it("lazy test", _ => {
    sleep(100)
    assert_eq(2 + 2, 4)
  })
  it("skip test", skip="skip this test", _ => assert_eq(2 + 2, 5))
  it("todo test", ctx => ctx.todo(message="this test is todo"))

  // TestContext assertion methods demo
  describe("TestContext assertion methods", fn(_) {
    it("assert_ok", ctx => {
      ctx.assert_ok(true)
      ctx.assert_ok(true, message="value should be true")
    })

    it("assert_strict_equal", ctx => {
      ctx.assert_strict_equal(42, 42)
      ctx.assert_strict_equal("hello", "hello", message="strings should match")
    })

    it("assert_deep_strict_equal", ctx => {
      let obj1 = @js.from_entries([("a", 1), ("b", 2)])
      let obj2 = @js.from_entries([("a", 1), ("b", 2)])
      ctx.assert_deep_strict_equal(obj1, obj2)
    })

    it("assert_match", ctx => {
      let pattern = @regexp.RegExp::new("hello")
      ctx.assert_match("hello world", pattern)
    })

    it("assert_throws", ctx => {
      ctx.assert_throws(fn() { abort("test error") })
    })

    it("assert_rejects", ctx => {
      ctx.assert_rejects(async fn() { abort("async error") })
    })
  })
}
