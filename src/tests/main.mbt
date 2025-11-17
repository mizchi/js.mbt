///|
using @test {it}

///|
fn main {
  it("sample test", fn(_) { assert_true(true) })
  it("sample test", fn(_) { assert_true(false) })

}

///|
test {
  // beforeEach(() => @async.sleep(1))
  it("simple test", _ => assert_eq(2 + 2, 4))
  it("lazy test", _ => {
    @async.sleep(100)
    assert_eq(2 + 2, 4)
  })
  it("skip test", skip="skip this test", _ => assert_eq(2 + 2, 5))
  it("todo test", ctx => ctx.todo("this test is todo"))
}
