///| Iterator - Iteration protocol

///|
/// JavaScript Iterator
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator
#external
pub(all) type JsIterator[T]

///|
pub fn[T] JsIterator::to_any(self : JsIterator[T]) -> @core.Any = "%identity"

///|
pub fn[T] JsIterator::as_any(self : JsIterator[T]) -> @core.Any = "%identity"

///|
extern "js" fn ffi_iterator_from(v : @core.Any) -> @core.Any =
  #|(v) => Iterator.from(v)

///|
/// JS: Iterator.from(v)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/from
pub fn[T] JsIterator::from(v : @core.Any) -> JsIterator[T] {
  ffi_iterator_from(v) |> @core.identity
}

///|
/// JS: iterator.next()
pub fn[T] JsIterator::next(self : JsIterator[T]) -> T? {
  let v = self.to_any()._call("next", [])
  if (v["done"] |> @core.identity) {
    None
  } else {
    Some(v["value"] |> @core.identity)
  }
}

///|
/// JS: iterator.drop(limit)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/drop
pub fn[T] JsIterator::drop(self : Self[T], limit : Int) -> Self[T] {
  self.to_any()._call("drop", [@core.any(limit)]) |> @core.identity
}

///|
/// JS: iterator.take(limit)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/take
pub fn[T] JsIterator::take(self : Self[T], limit : Int) -> Self[T] {
  self.to_any()._call("take", [@core.any(limit)]) |> @core.identity
}

///|
/// JS: iterator.toArray()
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Iterator/toArray
pub fn[T] JsIterator::toArray(self : Self[T]) -> Array[T] {
  self.to_any()._call("toArray", []) |> @core.identity
}

///|
/// to Moonbit Iterator
pub fn[T] JsIterator::iter(self : JsIterator[T]) -> Iter[T] {
  Iter::new(() => self.next())
}

///| AsyncIterator

///|
/// JavaScript AsyncIterator
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/AsyncIterator
#external
pub(all) type AsyncIterator[T]

///|
pub fn[T] AsyncIterator::to_any(self : AsyncIterator[T]) -> @core.Any = "%identity"

///|
/// JS: asyncIterator.next()
pub async fn[T] AsyncIterator::next(self : AsyncIterator[T]) -> T? {
  let v : @core.Promise[@core.Any] = self.to_any()._call("next", [])
    |> @core.identity
  let v : @core.Any = v.wait()
  if (@core.any(v)["done"] |> @core.identity) {
    None
  } else {
    Some(@core.any(v)["value"] |> @core.identity)
  }
}
