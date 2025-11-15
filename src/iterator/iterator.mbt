///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
using @async {type Promise}

///|
#external
pub(all) type JsIterator[T]

///|
/// Js Iterator
pub impl[T] Js for JsIterator[T] with to_js(self) {
  self |> js
}

///|
pub fn[T] JsIterator::next(self : JsIterator[T]) -> T? {
  let v : Val = self.invoke("next", []) |> unsafe_cast
  if v.get("done").cast() {
    None
  } else {
    Some(v.get("value").cast())
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
pub impl[T] Js for AsyncIterator[T] with to_js(self) {
  self |> js
}

///|
pub async fn[T] AsyncIterator::next(self : AsyncIterator[T]) -> T? {
  let v : Promise[Val] = self.invoke("next", []).cast()
  let v : Val = v.unwrap()
  if v.get("done").cast() {
    None
  } else {
    Some(v.get("value").cast())
  }
}

// TODO: test with async test {}
