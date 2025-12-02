// ArrayBuffer - Frequently used binary data buffer
//
// For TypedArray (Uint8Array, Int32Array, etc.) and DataView,
// see src/builtins/typedarray/

///| ArrayBuffer

///|
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer
#external
pub type ArrayBuffer

///|
pub fn ArrayBuffer::to_any(self : ArrayBuffer) -> @nostd.Any = "%identity"

///|
extern "js" fn ffi_new_array_buffer(
  byte_length : Int,
  max_byte_length : Int?,
) -> @nostd.Any =
  #| (len, maxLen) => maxLen !== undefined ? new ArrayBuffer(len, { maxByteLength: maxLen }) : new ArrayBuffer(len)

///|
pub fn ArrayBuffer::new(
  byte_length : Int,
  max_byte_length? : Int,
) -> ArrayBuffer {
  identity(ffi_new_array_buffer(byte_length, max_byte_length))
}

///|
#alias(byte_length)
pub fn ArrayBuffer::byteLength(self : ArrayBuffer) -> Int {
  self.to_any()["byteLength"].cast()
}

///|
#alias(max_byte_length)
pub fn ArrayBuffer::maxByteLength(self : ArrayBuffer) -> Int {
  self.to_any()["maxByteLength"].cast()
}

///|
pub fn ArrayBuffer::resizable(self : ArrayBuffer) -> Bool {
  self.to_any()["resizable"].cast()
}

///|
pub fn ArrayBuffer::resize(self : ArrayBuffer, new_byte_length : Int) -> Unit {
  self.to_any()._call("resize", [@nostd.any(new_byte_length)]) |> ignore
}

///|
pub fn ArrayBuffer::slice(
  self : ArrayBuffer,
  begin? : Int = 0,
  end? : Int,
) -> ArrayBuffer {
  match end {
    Some(e) =>
      self.to_any()._call("slice", [@nostd.any(begin), @nostd.any(e)]).cast()
    None => self.to_any()._call("slice", [@nostd.any(begin)]).cast()
  }
}

///|
extern "js" fn ffi_is_view(arg : @nostd.Any) -> Bool =
  #| (arg) => ArrayBuffer.isView(arg)

///|
#alias(is_view)
pub fn ArrayBuffer::isView(arg : @nostd.Any) -> Bool {
  ffi_is_view(arg)
}

///| SharedArrayBuffer

///|
#external
pub type SharedArrayBuffer

///|
pub fn SharedArrayBuffer::to_any(self : SharedArrayBuffer) -> @nostd.Any = "%identity"

///|
extern "js" fn ffi_new_shared_array_buffer(byte_length : Int) -> @nostd.Any =
  #| (len) => new SharedArrayBuffer(len)

///|
pub fn SharedArrayBuffer::new(byte_length : Int) -> SharedArrayBuffer {
  identity(ffi_new_shared_array_buffer(byte_length))
}

///|
#alias(byte_length)
pub fn SharedArrayBuffer::byteLength(self : SharedArrayBuffer) -> Int {
  self.to_any()["byteLength"].cast()
}

///|
pub fn SharedArrayBuffer::slice(
  self : SharedArrayBuffer,
  begin? : Int = 0,
  end? : Int,
) -> SharedArrayBuffer {
  match end {
    Some(e) =>
      self.to_any()._call("slice", [@nostd.any(begin), @nostd.any(e)]).cast()
    None => self.to_any()._call("slice", [@nostd.any(begin)]).cast()
  }
}
