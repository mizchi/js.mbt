// WIP

///|
#external
pub type ArrayBuffer

///|
pub impl Js for ArrayBuffer with to_js(self) -> Val {
  self |> js
}

///|
#external
pub type SharedArrayBuffer

///|
pub impl Js for SharedArrayBuffer with to_js(self) -> Val {
  self |> js
}

///|
#external
pub type DataView

///|
pub impl Js for DataView with to_js(self) -> Val {
  self |> js
}

///|
#external
pub type Uint8Array

///|
pub impl Js for Uint8Array with to_js(self) -> Val {
  self |> js
}

///|
pub extern "js" fn Uint8Array::from_size(length : UInt) -> Uint8Array =
  #| (len) => new Uint8Array(len)

///|
pub extern "js" fn Uint8Array::from_array(array : Array[UInt]) -> Uint8Array =
  #| (arr) => new Uint8Array(arr)

///|
pub extern "js" fn Uint8Array::from_array_buffer(
  buffer : ArrayBuffer,
) -> Uint8Array =
  #| (buf) => new Uint8Array(buf)

///|
#alias("_[_]=_")
pub extern "js" fn Uint8Array::set(
  self : Self,
  index : UInt,
  value : UInt,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn Uint8Array::get(self : Self, index : UInt) -> UInt =
  #| (arr, i) => arr[i]

///|
pub extern "js" fn Uint8Array::length(self : Self) -> UInt =
  #| (arr) => arr.length

///|
pub extern "js" fn Uint8Array::byte_length(self : Self) -> UInt =
  #| (arr) => arr.byteLength

///|
#external
pub type Uint16Array

///|
pub impl Js for Uint16Array with to_js(self) -> Val {
  self |> js
}

///|
#alias("_[_]=_")
pub extern "js" fn Uint16Array::set(
  self : Self,
  index : UInt,
  value : UInt,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn Uint16Array::get(self : Self, index : UInt) -> UInt =
  #| (arr, i) => arr[i]

///|
pub extern "js" fn Uint16Array::length(self : Self) -> UInt =
  #| (arr) => arr.length

///|
#alias(byteLength)
pub extern "js" fn Uint16Array::byte_length(self : Self) -> UInt =
  #| (arr) => arr.byteLength

///|
#external
pub type Uint32Array

///|
pub impl Js for Uint32Array with to_js(self) -> Val {
  self |> js
}

///|
#external
pub type Int8Array

///|
pub impl Js for Int8Array with to_js(self) -> Val {
  self |> js
}

///|
#external
pub type Int16Array

///|
pub impl Js for Int16Array with to_js(self) -> Val {
  self |> js
}

///|
#external
pub type Int32Array

///|
pub impl Js for Int32Array with to_js(self) -> Val {
  self |> js
}

///|
#external
pub type Float32Array

///|
pub impl Js for Float32Array with to_js(self) -> Val {
  self |> js
}

///|
#external
pub type Float64Array

///|
pub impl Js for Float64Array with to_js(self) -> Val {
  self |> js
}
