///|
/// Base type that consolidates common operations for TypedArray.
/// Downcast from concrete TypedArray types using as_typed_array() to use.
#external
pub type TypedArray

///|
pub fn TypedArray::as_any(self : TypedArray) -> @core.Any = "%identity"

///|
/// Common methods
pub fn TypedArray::length(self : TypedArray) -> Int {
  self.as_any()._get("length").cast()
}

///|
pub fn TypedArray::byteLength(self : TypedArray) -> Int {
  self.as_any()._get("byteLength").cast()
}

///|
pub fn TypedArray::byteOffset(self : TypedArray) -> Int {
  self.as_any()._get("byteOffset").cast()
}

///|
pub fn TypedArray::slice(
  self : TypedArray,
  start? : Int = 0,
  end? : Int,
) -> TypedArray {
  match end {
    Some(e) =>
      self.as_any()._call("slice", [@core.any(start), @core.any(e)]).cast()
    None => self.as_any()._call("slice", [@core.any(start)]).cast()
  }
}

///|
pub fn TypedArray::subarray(
  self : TypedArray,
  begin? : Int = 0,
  end? : Int,
) -> TypedArray {
  match end {
    Some(e) =>
      self.as_any()._call("subarray", [@core.any(begin), @core.any(e)]).cast()
    None => self.as_any()._call("subarray", [@core.any(begin)]).cast()
  }
}

///|
pub fn TypedArray::indexOf(
  self : Self,
  search_element : Int,
  from_index? : Int = 0,
) -> Int {
  self
  .as_any()
  ._call("indexOf", [@core.any(search_element), @core.any(from_index)])
  .cast()
}

///|
pub fn TypedArray::lastIndexOf(
  self : Self,
  search_element : Int,
  from_index? : Int = 0,
) -> Int {
  self
  .as_any()
  ._call("lastIndexOf", [@core.any(search_element), @core.any(from_index)])
  .cast()
}

///|
pub fn TypedArray::copyWithin(
  self : TypedArray,
  target : Int,
  start : Int,
  end? : Int,
) -> TypedArray {
  match end {
    Some(e) =>
      self
      .as_any()
      ._call("copyWithin", [@core.any(target), @core.any(start), @core.any(e)])
      .cast()
    None =>
      self
      .as_any()
      ._call("copyWithin", [@core.any(target), @core.any(start)])
      .cast()
  }
}

///|
pub fn TypedArray::reverse(self : TypedArray) -> TypedArray {
  self.as_any()._call("reverse", []).cast()
}

///|
pub fn TypedArray::sort(self : TypedArray) -> TypedArray {
  self.as_any()._call("sort", []).cast()
}

///|
pub fn TypedArray::join(self : TypedArray, separator? : String = ",") -> String {
  self.as_any()._call("join", [@core.any(separator)]).cast()
}

///|
pub fn TypedArray::toString(self : TypedArray) -> String {
  self.as_any()._call("toString", []).cast()
}

///|
#alias("_[_]=_")
pub extern "js" fn TypedArray::set_at(
  self : Self,
  index : Int,
  value : Int,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn TypedArray::get_at(self : Self, index : Int) -> Int =
  #| (arr, i) => arr[i]

///|
pub fn TypedArray::set(
  self : Self,
  array : Array[Int],
  offset? : Int = 0,
) -> Unit {
  let arr : @core.Any = @core.any(array) |> @core.any
  let self_any : @core.Any = self.as_any() |> @core.any
  self_any._call("set", [arr, @core.any(offset)]) |> ignore
}

///|
pub fn TypedArray::fill(
  self : Self,
  value : Int,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) =>
      self
      .as_any()
      ._call("fill", [@core.any(value), @core.any(start), @core.any(e)])
      .cast()
    None =>
      self.as_any()._call("fill", [@core.any(value), @core.any(start)]).cast()
  }
}

///|
pub fn TypedArray::includes(
  self : Self,
  search_element : Int,
  from_index? : Int = 0,
) -> Bool {
  self
  .as_any()
  ._call("includes", [@core.any(search_element), @core.any(from_index)])
  .cast()
}
