///|
#external
pub type ArrayBuffer

///|
pub impl JsImpl for ArrayBuffer

///|
extern "js" fn ffi_new_array_buffer(byte_length : UInt) -> Js =
  #| (len) => new ArrayBuffer(len)

///|
pub fn ArrayBuffer::new(byte_length : UInt) -> ArrayBuffer {
  unsafe_cast(ffi_new_array_buffer(byte_length))
}

///|
#alias(byteLength)
pub fn ArrayBuffer::byte_length(self : ArrayBuffer) -> UInt {
  unsafe_cast(self.get("byteLength"))
}

///|
pub fn ArrayBuffer::slice(
  self : ArrayBuffer,
  begin? : Int = 0,
  end? : Int,
) -> ArrayBuffer {
  match end {
    Some(e) => self.call2("slice", begin, e) |> unsafe_cast
    None => self.call1("slice", begin) |> unsafe_cast
  }
}

///|
extern "js" fn ffi_is_view(arg : Js) -> Js =
  #| (arg) => ArrayBuffer.isView(arg)

///|
#alias(isView)
pub fn ArrayBuffer::is_view(arg : Js) -> Bool {
  ffi_is_view(arg) |> unsafe_cast
}

///|
#external
pub type SharedArrayBuffer

///|
pub impl JsImpl for SharedArrayBuffer

///|
extern "js" fn ffi_new_shared_array_buffer(byte_length : UInt) -> Js =
  #| (len) => new SharedArrayBuffer(len)

///|
pub fn SharedArrayBuffer::new(byte_length : UInt) -> SharedArrayBuffer {
  unsafe_cast(ffi_new_shared_array_buffer(byte_length))
}

///|
#alias(byteLength)
pub fn SharedArrayBuffer::byte_length(self : SharedArrayBuffer) -> UInt {
  unsafe_cast(self.get("byteLength"))
}

///|
pub fn SharedArrayBuffer::slice(
  self : SharedArrayBuffer,
  begin? : Int = 0,
  end? : Int,
) -> SharedArrayBuffer {
  match end {
    Some(e) => unsafe_cast(self.call("slice", [begin, e]))
    None => unsafe_cast(self.call("slice", [begin]))
  }
}
