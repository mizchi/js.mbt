///|
/// JavaScript AsyncIterator
#external
pub(all) type AsyncIterator[T]

///|
pub impl[T] JsImpl for AsyncIterator[T]

///|
/// JS: asyncIterator.next()
pub async fn[T] AsyncIterator::next(self : AsyncIterator[T]) -> T? {
  let v : Promise[Js] = self.call0("next") |> unsafe_cast
  let v : Js = v.unwrap()
  if (v.get("done") |> unsafe_cast) {
    None
  } else {
    Some(v.get("value") |> unsafe_cast)
  }
}

// TODO: test with async test {}
