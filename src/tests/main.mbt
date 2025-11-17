///|
using @test {it}

///|
fn main {
  it("sample test", fn(_) { assert_true(true) })
  it("sample test", fn(_) { assert_true(false) })
}

///|
test {
  // beforeEach(() => @promise.sleep(1))
  it("simple test", _ => assert_eq(2 + 2, 4))
  it("lazy test", _ => {
    @promise.sleep(100)
    assert_eq(2 + 2, 4)
  })
  it("skip test", skip="skip this test", _ => assert_eq(2 + 2, 5))
  it("todo test", ctx => ctx.todo("this test is todo"))
}
