///|
extern "js" fn create_test_generator() -> JsIterator[Int] =
  #| () => (function*() { yield 1; yield 2; yield 3; })()

///|
test "iterator" {
  let g = create_test_generator()
  let mut called = 0
  let mut sum = 0
  for v in g.iter() {
    called += 1
    sum += v
  }
  assert_eq(called, 3)
  assert_eq(sum, 6)
}
