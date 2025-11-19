///|
extern "js" fn create_test_generator() -> JsIterator[Int] =
  #| () => (function*() { yield 1; yield 2; yield 3; })()

///|
extern "js" fn create_large_generator() -> JsIterator[Int] =
  #| () => (function*() { for(let i = 0; i < 10; i++) yield i; })()

///|
test "JsIterator.iter() iterates over generator values" {
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

///|
test "JsIterator.drop() skips first n elements" {
  let g = create_large_generator()
  let result = g.drop(5)
  let values = []
  for v in result.iter() {
    values.push(v)
  }
  // Should have values [5, 6, 7, 8, 9]
  assert_eq(values.length(), 5)
  assert_eq(values[0], 5)
  assert_eq(values[4], 9)
}

///|
test "JsIterator.take() takes first n elements" {
  let g = create_large_generator()
  let result = g.take(3)
  let values = []
  for v in result.iter() {
    values.push(v)
  }
  // Should have values [0, 1, 2]
  assert_eq(values.length(), 3)
  assert_eq(values[0], 0)
  assert_eq(values[2], 2)
}

///|
test "JsIterator.toArray() converts iterator to array" {
  let g = create_test_generator()
  let arr = g.toArray()
  assert_eq(arr.length(), 3)
  assert_eq(arr[0], 1)
  assert_eq(arr[1], 2)
  assert_eq(arr[2], 3)
}

///|
test "JsIterator.from() creates iterator from iterable" {
  let arr_js : @js.Js = @js.from_array([10, 20, 30])
  let iter : JsIterator[Int] = JsIterator::from(arr_js)
  let mut sum = 0
  for v in iter.iter() {
    sum += v
  }
  assert_eq(sum, 60)
}
