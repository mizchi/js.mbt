// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/take

///|
using @js {type Js, trait JsImpl, unsafe_cast, type Promise}

///|
/// JavaScript Iterator
#external
pub(all) type JsIterator[T]

///|
pub impl[T] JsImpl for JsIterator[T]

///|
extern "js" fn ffi_iterator_from(v : Js) -> Js =
  #|(v) => Iterator.from(v)

///|
/// JS: Iterator.from(v)
pub fn[T] JsIterator::from(v : Js) -> JsIterator[T] {
  ffi_iterator_from(v) |> unsafe_cast
}

///|
/// JS: iterator.next()
pub fn[T] JsIterator::next(self : JsIterator[T]) -> T? {
  let v : Js = self.call("next", []) |> unsafe_cast
  if unsafe_cast(v.get("done")) {
    None
  } else {
    Some(unsafe_cast(v.get("value")))
  }
}

///|
/// JS: iterator.drop(limit)
pub fn[T] JsIterator::drop(self : Self[T], limit : Int) -> Self[T] {
  self.call("drop", [limit]) |> unsafe_cast
}

///|
/// JS: iterator.take(limit)
pub fn[T] JsIterator::take(self : Self[T], limit : Int) -> Self[T] {
  self.call("take", [limit]) |> unsafe_cast
}

///|
/// JS: iterator.toArray()
pub fn[T] JsIterator::toArray(self : Self[T]) -> Array[T] {
  self.call("toArray", []) |> unsafe_cast
}

///|
/// to Moonbit Iterator
pub fn[T] JsIterator::iter(self : JsIterator[T]) -> Iterator[T] {
  Iterator::new(() => self.next())
}
