///|
/// TypedArray の共通操作をまとめたベース型。
/// 具体的な TypedArray 型から as_typed_array() でダウンキャストして利用する。
#external
pub type TypedArray

///|
pub fn TypedArray::as_any(self : TypedArray) -> @nostd.Any = "%identity"

///|
/// JS との橋渡し用ヘルパー
// pub fn TypedArray::_get(self : TypedArray, key : String) -> @nostd.Any {
//   self.as_any()._get(key)
// }

///|
// pub fn TypedArray::_call(
//   self : TypedArray,
//   key : String,
//   args : Array[@nostd.Any],
// ) -> @nostd.Any {
//   self.as_any()._call(key, args)
// }

///|
// pub fn TypedArray::call0(self : TypedArray, key : String) -> @nostd.Any {
//   self.as_any().call0(key)
// }

///|
// pub fn TypedArray::call2(
//   self : TypedArray,
//   key : String,
//   arg1 : @nostd.Any,
//   arg2 : @nostd.Any,
// ) -> @nostd.Any {
//   self.as_any().call2(key, arg1, arg2)
// }

///|
/// 共通メソッド群
pub fn TypedArray::length(self : TypedArray) -> UInt {
  self.as_any()._get("length").cast()
}

///|
pub fn TypedArray::byteLength(self : TypedArray) -> UInt {
  self.as_any()._get("byteLength").cast()
}

///|
pub fn TypedArray::byteOffset(self : TypedArray) -> UInt {
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
      self.as_any()._call("slice", [@nostd.any(start), @nostd.any(e)]).cast()
    None => self.as_any()._call("slice", [@nostd.any(start)]).cast()
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
      self.as_any()._call("subarray", [@nostd.any(begin), @nostd.any(e)]).cast()
    None => self.as_any()._call("subarray", [@nostd.any(begin)]).cast()
  }
}

///|
pub fn TypedArray::indexOf(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Int {
  self
  .as_any()
  ._call("indexOf", [@nostd.any(search_element), @nostd.any(from_index)])
  .cast()
}

///|
pub fn TypedArray::lastIndexOf(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Int {
  self
  .as_any()
  ._call("indexOf", [@nostd.any(search_element), @nostd.any(from_index)])
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
      ._call("copyWithin", [
        @nostd.any(target),
        @nostd.any(start),
        @nostd.any(e),
      ])
      .cast()
    None =>
      self
      .as_any()
      ._call("copyWithin", [@nostd.any(target), @nostd.any(start)])
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
  self.as_any()._call("join", [@nostd.any(separator)]).cast()
}

///|
pub fn TypedArray::toString(self : TypedArray) -> String {
  self.as_any()._call("toString", []).cast()
}

///|
#alias("_[_]=_")
pub extern "js" fn TypedArray::set_at(
  self : Self,
  index : UInt,
  value : UInt,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn TypedArray::get_at(self : Self, index : UInt) -> UInt =
  #| (arr, i) => arr[i]

///|
pub fn TypedArray::set(
  self : Self,
  array : Array[UInt],
  offset? : UInt = 0,
) -> Unit {
  let arr : @nostd.Any = @nostd.any(array) |> @nostd.any
  let self_any : @nostd.Any = self.as_any() |> @nostd.any
  self_any._call("set", [arr, @nostd.any(offset)]) |> ignore
}

///|
pub fn TypedArray::fill(
  self : Self,
  value : UInt,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) =>
      self
      .as_any()
      ._call("fill", [@nostd.any(value), @nostd.any(start), @nostd.any(e)])
      .cast()
    None =>
      self.as_any()._call("fill", [@nostd.any(value), @nostd.any(start)]).cast()
  }
}

///|
pub fn TypedArray::includes(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Bool {
  self
  .as_any()
  ._call("includes", [@nostd.any(search_element), @nostd.any(from_index)])
  .cast()
}
