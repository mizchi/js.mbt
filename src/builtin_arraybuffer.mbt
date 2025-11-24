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
pub impl JsImpl for ArrayBuffer

///|
extern "js" fn ffi_new_array_buffer(
  byte_length : UInt,
  max_byte_length : UInt?,
) -> Any =
  #| (len, maxLen) => maxLen !== undefined ? new ArrayBuffer(len, { maxByteLength: maxLen }) : new ArrayBuffer(len)

///|
pub fn ArrayBuffer::new(
  byte_length : UInt,
  max_byte_length? : UInt,
) -> ArrayBuffer {
  identity(ffi_new_array_buffer(byte_length, max_byte_length))
}

///|
#alias(byte_length)
pub fn ArrayBuffer::byteLength(self : ArrayBuffer) -> UInt {
  self.get("byteLength") |> identity
}

///|
#alias(max_byte_length)
pub fn ArrayBuffer::maxByteLength(self : ArrayBuffer) -> UInt {
  self.get("maxByteLength") |> identity
}

///|
pub fn ArrayBuffer::resizable(self : ArrayBuffer) -> Bool {
  self.get("resizable") |> identity
}

///|
pub fn ArrayBuffer::resize(self : ArrayBuffer, new_byte_length : UInt) -> Unit {
  self.call1("resize", new_byte_length) |> ignore
}

///|
pub fn ArrayBuffer::slice(
  self : ArrayBuffer,
  begin? : Int = 0,
  end? : Int,
) -> ArrayBuffer {
  match end {
    Some(e) => self.call2("slice", begin, e).cast()
    None => self.call1("slice", begin).cast()
  }
}

///|
extern "js" fn ffi_is_view(arg : Any) -> Any =
  #| (arg) => ArrayBuffer.isView(arg)

///|
#alias(is_view)
pub fn ArrayBuffer::isView(arg : Any) -> Bool {
  ffi_is_view(arg) |> identity
}

///| SharedArrayBuffer

///|
#external
pub type SharedArrayBuffer

///|
pub impl JsImpl for SharedArrayBuffer

///|
extern "js" fn ffi_new_shared_array_buffer(byte_length : UInt) -> Any =
  #| (len) => new SharedArrayBuffer(len)

///|
pub fn SharedArrayBuffer::new(byte_length : UInt) -> SharedArrayBuffer {
  identity(ffi_new_shared_array_buffer(byte_length))
}

///|
#alias(byte_length)
pub fn SharedArrayBuffer::byteLength(self : SharedArrayBuffer) -> UInt {
  self.get("byteLength") |> identity
}

///|
pub fn SharedArrayBuffer::slice(
  self : SharedArrayBuffer,
  begin? : Int = 0,
  end? : Int,
) -> SharedArrayBuffer {
  match end {
    Some(e) => self.call2("slice", begin, e) |> identity
    None => identity(self.call("slice", [begin]))
  }
}
