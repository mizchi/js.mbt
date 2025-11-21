///|
/// JavaScript Iterator
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator
#external
pub(all) type JsIterator[T]

///|
pub impl[T] JsImpl for JsIterator[T]

///|
extern "js" fn ffi_iterator_from(v : Js) -> Js =
  #|(v) => Iterator.from(v)

///|
/// JS: Iterator.from(v)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/from
pub fn[T] JsIterator::from(v : Js) -> JsIterator[T] {
  ffi_iterator_from(v) |> unsafe_cast
}

///|
/// JS: iterator.next()
pub fn[T] JsIterator::next(self : JsIterator[T]) -> T? {
  let v : Js = self.call0("next") |> unsafe_cast
  if (v.get("done") |> unsafe_cast) {
    None
  } else {
    Some(v.get("value") |> unsafe_cast)
  }
}

///|
/// JS: iterator.drop(limit)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/drop
pub fn[T] JsIterator::drop(self : Self[T], limit : Int) -> Self[T] {
  self.call("drop", [limit]) |> unsafe_cast
}

///|
/// JS: iterator.take(limit)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/take
pub fn[T] JsIterator::take(self : Self[T], limit : Int) -> Self[T] {
  self.call("take", [limit]) |> unsafe_cast
}

///|
/// JS: iterator.toArray()
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/toArray
pub fn[T] JsIterator::toArray(self : Self[T]) -> Array[T] {
  self.call0("toArray") |> unsafe_cast
}

///|
/// to Moonbit Iterator
pub fn[T] JsIterator::iter(self : JsIterator[T]) -> Iterator[T] {
  Iterator::new(() => self.next())
}
