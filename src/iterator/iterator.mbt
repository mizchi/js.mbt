///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
using @async {type Promise}

///|
#external
pub(all) type JsIterator[T]

///|
/// Js Iterator
pub impl[T] Js for JsIterator[T]

///|
pub fn[T] JsIterator::next(self : JsIterator[T]) -> T? {
  let v : Val = self.invoke("next", []) |> unsafe_cast
  if unsafe_cast(v.get("done")) {
    None
  } else {
    Some(unsafe_cast(v.get("value")))
  }
}

///|
/// to Moonbit Iterator
pub fn[T] JsIterator::iter(self : JsIterator[T]) -> Iterator[T] {
  Iterator::new(() => self.next())
}

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

///|
#external
pub(all) type AsyncIterator[T]

///|
pub impl[T] Js for AsyncIterator[T]

///|
pub async fn[T] AsyncIterator::next(self : AsyncIterator[T]) -> T? {
  let v : Promise[Val] = unsafe_cast(self.invoke("next", []))
  let v : Val = v.unwrap()
  if unsafe_cast(v.get("done")) {
    None
  } else {
    Some(unsafe_cast(v.get("value")))
  }
}

// TODO: test with async test {}
