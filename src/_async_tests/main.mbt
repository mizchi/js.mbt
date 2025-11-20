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
}
