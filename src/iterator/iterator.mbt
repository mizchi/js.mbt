///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
using @async {type Promise}

// TODO: map to builtin iterator

///|
#external
pub(all) type Generator[T]

///|
pub impl[T] Js for Generator[T] with to_js(self) {
  self |> js
}

///|
pub fn[T] Generator::next(self : Generator[T]) -> T? {
  let v : Val = self.to_js().call_method("next", []).cast()
  if v.get("done").cast() {
    None
  } else {
    Some(v.get("value").cast())
  }
}

///|
extern "js" fn create_test_generator() -> Generator[Int] =
  #| () => (function*() { yield 1; yield 2; yield 3; })()

///|
test "iterator" {
  let g = create_test_generator()
  let mut called = 0
  let mut sum = 0
  while g.next() is Some(v) {
    called += 1
    sum += v
  }
  assert_eq(called, 3)
  assert_eq(sum, 6)
}

///|
#external
pub(all) type AsyncGenerator[T]

///|
pub impl[T] Js for AsyncGenerator[T] with to_js(self) {
  self |> js
}

///|
pub async fn[T] AsyncGenerator::next(self : AsyncGenerator[T]) -> T? {
  let v : Promise[Val] = self.to_js().call_method("next", []).cast()
  let v : Val = v.unwrap()
  if v.get("done").cast() {
    None
  } else {
    Some(v.get("value").cast())
  }
}

// TODO: test with async test {}
