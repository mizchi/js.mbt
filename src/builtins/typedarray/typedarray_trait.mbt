// TypedArray trait - Common interface for all TypedArray types
//
// This trait provides default implementations for common TypedArray methods
// following the same pattern as EventTargetImpl in src/web/event/

///|
/// Base trait for TypedArray types (Uint8Array, Int32Array, Float64Array, etc.)
/// Provides common methods shared by all TypedArray implementations
pub(open) trait TypedArrayImpl: @js.JsImpl {
  /// Get the length of the array (number of elements)
  length(Self) -> UInt = _

  /// Get the byte length of the array
  byteLength(Self) -> UInt = _

  /// Get the byte offset in the underlying ArrayBuffer
  byteOffset(Self) -> UInt = _

  /// Create a new array with a shallow copy of a portion of the array
  slice(Self, start? : Int, end? : Int) -> Self = _

  /// Create a new view on the same ArrayBuffer
  subarray(Self, begin? : Int, end? : Int) -> Self = _

  /// Copy a sequence of array elements within the array
  copyWithin(Self, target : Int, start : Int, end? : Int) -> Self = _

  /// Reverse the array in place
  reverse(Self) -> Self = _

  /// Sort the array in place
  sort(Self) -> Self = _

  /// Join all elements into a string
  join(Self, separator? : String) -> String = _

  /// Convert to string
  toString(Self) -> String = _

  /// Internal helpers for JS interop
  _get(Self, String) -> @nostd.Any = _
  _call(Self, String, Array[@nostd.Any]) -> @nostd.Any = _
  call0(Self, String) -> @nostd.Any = _
  call2(Self, String, @nostd.Any, @nostd.Any) -> @nostd.Any = _
}

///| Helper bridge to @nostd.Any operations for typed arrays
impl TypedArrayImpl with _get(self, key : String) -> @nostd.Any {
  @nostd.any(self)._get(key)
}

///|
impl TypedArrayImpl with _call(
  self,
  key : String,
  args : Array[@nostd.Any],
) -> @nostd.Any {
  @nostd.any(self)._call(key, args)
}

///|
impl TypedArrayImpl with call0(self, key : String) -> @nostd.Any {
  @nostd.any(self).call0(key)
}

///|
impl TypedArrayImpl with call2(
  self,
  key : String,
  arg1 : @nostd.Any,
  arg2 : @nostd.Any,
) -> @nostd.Any {
  @nostd.any(self).call2(key, arg1, arg2)
}

///| Default implementations

///|
impl TypedArrayImpl with length(self) -> UInt {
  self._get("length").cast()
}

///|
impl TypedArrayImpl with byteLength(self) -> UInt {
  self._get("byteLength").cast()
}

///|
impl TypedArrayImpl with byteOffset(self) -> UInt {
  self._get("byteOffset").cast()
}

///|
impl TypedArrayImpl with slice(self, start? : Int = 0, end? : Int) -> Self {
  match end {
    Some(e) => self.call2("slice", @nostd.any(start), @nostd.any(e)).cast()
    None => self._call("slice", [@nostd.any(start)]).cast()
  }
}

///|
impl TypedArrayImpl with subarray(self, begin? : Int = 0, end? : Int) -> Self {
  match end {
    Some(e) => self.call2("subarray", @nostd.any(begin), @nostd.any(e)).cast()
    None => self._call("subarray", [@nostd.any(begin)]).cast()
  }
}

///|
impl TypedArrayImpl with copyWithin(self, target, start, end? : Int) -> Self {
  match end {
    Some(e) =>
      self._call("copyWithin", [
        @nostd.any(target),
        @nostd.any(start),
        @nostd.any(e),
      ]).cast()
    None => self.call2("copyWithin", @nostd.any(target), @nostd.any(start)).cast()
  }
}

///|
impl TypedArrayImpl with reverse(self) -> Self {
  self.call0("reverse").cast()
}

///|
impl TypedArrayImpl with sort(self) -> Self {
  self.call0("sort").cast()
}

///|
impl TypedArrayImpl with join(self, separator? : String = ",") -> String {
  self._call("join", [@nostd.any(separator)]).cast()
}

///|
impl TypedArrayImpl with toString(self) -> String {
  self.call0("toString").cast()
}
