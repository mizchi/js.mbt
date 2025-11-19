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
