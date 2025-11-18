///|
using @js {type Js, trait JsImpl, js, unsafe_cast}

///|
using @promise {type Promise}

///|
/// JavaScript Iterator
#external
pub(all) type JsIterator[T]

///|
pub impl[T] JsImpl for JsIterator[T]

///|
/// JS: iterator.next()
pub fn[T] JsIterator::next(self : JsIterator[T]) -> T? {
  let v : Js = self.invoke("next", []) |> unsafe_cast
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
/// JavaScript AsyncIterator
#external
pub(all) type AsyncIterator[T]

///|
pub impl[T] JsImpl for AsyncIterator[T]

///|
/// JS: asyncIterator.next()
pub async fn[T] AsyncIterator::next(self : AsyncIterator[T]) -> T? {
  let v : Promise[Js] = unsafe_cast(self.invoke("next", []))
  let v : Js = v.unwrap()
  if unsafe_cast(v.get("done")) {
    None
  } else {
    Some(unsafe_cast(v.get("value")))
  }
}

// TODO: test with async test {}
