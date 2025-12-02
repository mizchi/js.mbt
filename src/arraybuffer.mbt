// ArrayBuffer - Frequently used binary data buffer
//
// For TypedArray (Uint8Array, Int32Array, etc.) and DataView,
// see src/builtins/typedarray/

///| ArrayBuffer

///|
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer
// #external
pub(all) struct ArrayBuffer {
  // Empty
  byteLength : Int
  maxByteLength : Int
  resizable : Bool
}

///|
pub fn ArrayBuffer::to_any(self : ArrayBuffer) -> @core.Any = "%identity"

///|
extern "js" fn ffi_new_array_buffer(
  byte_length : Int,
  max_byte_length : Int?,
) -> @core.Any =
  #| (len, maxLen) => maxLen !== undefined ? new ArrayBuffer(len, { maxByteLength: maxLen }) : new ArrayBuffer(len)

///|
pub fn ArrayBuffer::new(
  byte_length : Int,
  max_byte_length? : Int,
) -> ArrayBuffer {
  identity(ffi_new_array_buffer(byte_length, max_byte_length))
}

///|
pub fn ArrayBuffer::resize(self : ArrayBuffer, new_byte_length : Int) -> Unit {
  self.to_any()._call("resize", [@core.any(new_byte_length)]) |> ignore
}

///|
pub fn ArrayBuffer::slice(
  self : ArrayBuffer,
  begin? : Int = 0,
  end? : Int,
) -> ArrayBuffer {
  match end {
    Some(e) =>
      self.to_any()._call("slice", [@core.any(begin), @core.any(e)]).cast()
    None => self.to_any()._call("slice", [@core.any(begin)]).cast()
  }
}

///|
pub extern "js" fn ArrayBuffer::isView(arg : @core.Any) -> Bool =
  #| (arg) => ArrayBuffer.isView(arg)

///|
// #external
pub(all) struct SharedArrayBuffer {
  byteLength : Int
}

///|
pub fn SharedArrayBuffer::to_any(self : SharedArrayBuffer) -> @core.Any = "%identity"

///|
pub extern "js" fn SharedArrayBuffer::new(
  byte_length : Int,
) -> SharedArrayBuffer =
  #| (len) => new SharedArrayBuffer(len)

///|
pub extern "js" fn SharedArrayBuffer::slice(
  self : Self,
  begin? : Int = 0,
  end? : Int,
) -> Self =
  #| (self, begin, end) => {
  #|   if (end !== undefined) {
  #|     return self.slice(begin, end);
  #|   } else {
  #|     return self.slice(begin);
  #|   }
  #| }
