///|
#external
pub type Uint8Array

///|
pub impl JsImpl for Uint8Array

///|
extern "js" fn ffi_uint8array_from_size(length : UInt) -> Js =
  #| (len) => new Uint8Array(len)

///|
pub fn Uint8Array::from_size(length : UInt) -> Uint8Array {
  unsafe_cast(ffi_uint8array_from_size(length))
}

///|
extern "js" fn ffi_uint8array_from_array(array : Js) -> Js =
  #| (arr) => new Uint8Array(arr)

///|
pub fn Uint8Array::from_array(array : Array[UInt]) -> Uint8Array {
  unsafe_cast(ffi_uint8array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_uint8array_from_buffer(
  buffer : Js,
  byte_offset : UInt,
  length : UInt?,
) -> Js =
  #| (buf, offset, len) => len !== undefined ? new Uint8Array(buf, offset, len) : new Uint8Array(buf, offset)

///|
pub fn Uint8Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Uint8Array {
  unsafe_cast(ffi_uint8array_from_buffer(buffer.to_js(), byte_offset, length))
}

///|
#alias("_[_]=_")
pub extern "js" fn Uint8Array::set_at(
  self : Self,
  index : UInt,
  value : UInt,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn Uint8Array::get_at(self : Self, index : UInt) -> UInt =
  #| (arr, i) => arr[i]

///|
pub fn Uint8Array::length(self : Self) -> UInt {
  self.get("length") |> unsafe_cast
}

///|
#alias(byteLength)
pub fn Uint8Array::byte_length(self : Self) -> UInt {
  self.get("byteLength") |> unsafe_cast
}

///|
#alias(byteOffset)
pub fn Uint8Array::byte_offset(self : Self) -> UInt {
  self.get("byteOffset") |> unsafe_cast
}

///|
pub fn Uint8Array::buffer(self : Self) -> ArrayBuffer {
  self.get("buffer") |> unsafe_cast
}

///|
pub fn Uint8Array::set(
  self : Self,
  array : Array[UInt],
  offset? : UInt = 0,
) -> Unit {
  self.call("set", [@js.from_array(array), offset]) |> ignore
}

///|
pub fn Uint8Array::slice(self : Self, start? : Int = 0, end? : Int) -> Self {
  match end {
    Some(e) => self.call("slice", [start, e]) |> unsafe_cast
    None => self.call("slice", [start]) |> unsafe_cast
  }
}

///|
pub fn Uint8Array::subarray(self : Self, begin? : Int = 0, end? : Int) -> Self {
  match end {
    Some(e) => self.call("subarray", [begin, e]) |> unsafe_cast
    None => self.call("subarray", [begin]) |> unsafe_cast
  }
}

///|
pub fn Uint8Array::fill(
  self : Self,
  value : UInt,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("fill", [value, start, e]) |> unsafe_cast
    None => self.call("fill", [value, start]) |> unsafe_cast
  }
}

///|
#alias(copyWithin)
pub fn Uint8Array::copy_within(
  self : Self,
  target : Int,
  start : Int,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("copyWithin", [target, start, e]) |> unsafe_cast
    None => self.call("copyWithin", [target, start]) |> unsafe_cast
  }
}

///|
pub fn Uint8Array::reverse(self : Self) -> Self {
  self.call("reverse", []) |> unsafe_cast
}

///|
pub fn Uint8Array::sort(self : Self) -> Self {
  self.call("sort", []) |> unsafe_cast
}

///|
#alias(indexOf)
pub fn Uint8Array::index_of(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Int {
  self.call("indexOf", [search_element, from_index]) |> unsafe_cast
}

///|
#alias(lastIndexOf)
pub fn Uint8Array::last_index_of(
  self : Self,
  search_element : UInt,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.call("lastIndexOf", [search_element, i]) |> unsafe_cast
    None => self.call("lastIndexOf", [search_element]) |> unsafe_cast
  }
}

///|
pub fn Uint8Array::includes(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Bool {
  self.call("includes", [search_element, from_index]) |> unsafe_cast
}

///|
pub fn Uint8Array::join(self : Self, separator? : String = ",") -> String {
  self.call("join", [separator]) |> unsafe_cast
}

///|
#alias(toString)
pub fn Uint8Array::to_string(self : Self) -> String {
  self.call0("toString") |> unsafe_cast
}

///|
#external
pub type Uint16Array

///|
pub impl JsImpl for Uint16Array

///|
pub fn Uint16Array::from_size(length : UInt) -> Uint16Array {
  unsafe_cast(ffi_uint16array_from_size(length))
}

///|
extern "js" fn ffi_uint16array_from_size(length : UInt) -> Js =
  #| (len) => new Uint16Array(len)

///|
pub fn Uint16Array::from_array(array : Array[UInt]) -> Uint16Array {
  unsafe_cast(ffi_uint16array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_uint16array_from_array(array : Js) -> Js =
  #| (arr) => new Uint16Array(arr)

///|
pub fn Uint16Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Uint16Array {
  unsafe_cast(ffi_uint16array_from_buffer(buffer.to_js(), byte_offset, length))
}

///|
extern "js" fn ffi_uint16array_from_buffer(
  buffer : Js,
  byte_offset : UInt,
  length : UInt?,
) -> Js =
  #| (buf, offset, len) => len !== undefined ? new Uint16Array(buf, offset, len) : new Uint16Array(buf, offset)

///|
#alias("_[_]=_")
pub extern "js" fn Uint16Array::set_at(
  self : Self,
  index : UInt,
  value : UInt,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn Uint16Array::get_at(self : Self, index : UInt) -> UInt =
  #| (arr, i) => arr[i]

///|
pub fn Uint16Array::length(self : Self) -> UInt {
  self.get("length") |> unsafe_cast
}

///|
#alias(byteLength)
pub fn Uint16Array::byte_length(self : Self) -> UInt {
  self.get("byteLength") |> unsafe_cast
}

///|
#alias(byteOffset)
pub fn Uint16Array::byte_offset(self : Self) -> UInt {
  self.get("byteOffset") |> unsafe_cast
}

///|
pub fn Uint16Array::buffer(self : Self) -> ArrayBuffer {
  self.get("buffer") |> unsafe_cast
}

///|
#external
pub type Uint32Array

///|
pub impl JsImpl for Uint32Array

///|
pub fn Uint32Array::from_size(length : UInt) -> Uint32Array {
  unsafe_cast(ffi_uint32array_from_size(length))
}

///|
extern "js" fn ffi_uint32array_from_size(length : UInt) -> Js =
  #| (len) => new Uint32Array(len)

///|
pub fn Uint32Array::from_array(array : Array[UInt]) -> Uint32Array {
  unsafe_cast(ffi_uint32array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_uint32array_from_array(array : Js) -> Js =
  #| (arr) => new Uint32Array(arr)

///|
pub fn Uint32Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Uint32Array {
  unsafe_cast(ffi_uint32array_from_buffer(buffer.to_js(), byte_offset, length))
}

///|
extern "js" fn ffi_uint32array_from_buffer(
  buffer : Js,
  byte_offset : UInt,
  length : UInt?,
) -> Js =
  #| (buf, offset, len) => len !== undefined ? new Uint32Array(buf, offset, len) : new Uint32Array(buf, offset)

///|
#alias("_[_]=_")
pub extern "js" fn Uint32Array::set_at(
  self : Self,
  index : UInt,
  value : UInt,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn Uint32Array::get_at(self : Self, index : UInt) -> UInt =
  #| (arr, i) => arr[i]

///|
pub fn Uint32Array::length(self : Self) -> UInt {
  self.get("length") |> unsafe_cast
}

///|
#alias(byteLength)
pub fn Uint32Array::byte_length(self : Self) -> UInt {
  self.get("byteLength") |> unsafe_cast
}

///|
#alias(byteOffset)
pub fn Uint32Array::byte_offset(self : Self) -> UInt {
  self.get("byteOffset") |> unsafe_cast
}

///|
pub fn Uint32Array::buffer(self : Self) -> ArrayBuffer {
  self.get("buffer") |> unsafe_cast
}

///|
#external
pub type Int8Array

///|
pub impl JsImpl for Int8Array

///|
pub fn Int8Array::from_size(length : UInt) -> Int8Array {
  unsafe_cast(ffi_int8array_from_size(length))
}

///|
extern "js" fn ffi_int8array_from_size(length : UInt) -> Js =
  #| (len) => new Int8Array(len)

///|
pub fn Int8Array::from_array(array : Array[Int]) -> Int8Array {
  unsafe_cast(ffi_int8array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_int8array_from_array(array : Js) -> Js =
  #| (arr) => new Int8Array(arr)

///|
pub fn Int8Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Int8Array {
  unsafe_cast(ffi_int8array_from_buffer(buffer.to_js(), byte_offset, length))
}

///|
extern "js" fn ffi_int8array_from_buffer(
  buffer : Js,
  byte_offset : UInt,
  length : UInt?,
) -> Js =
  #| (buf, offset, len) => len !== undefined ? new Int8Array(buf, offset, len) : new Int8Array(buf, offset)

///|
#alias("_[_]=_")
pub extern "js" fn Int8Array::set_at(
  self : Self,
  index : UInt,
  value : Int,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn Int8Array::get_at(self : Self, index : UInt) -> Int =
  #| (arr, i) => arr[i]

///|
pub fn Int8Array::length(self : Self) -> UInt {
  self.get("length") |> unsafe_cast
}

///|
#alias(byteLength)
pub fn Int8Array::byte_length(self : Self) -> UInt {
  self.get("byteLength") |> unsafe_cast
}

///|
#alias(byteOffset)
pub fn Int8Array::byte_offset(self : Self) -> UInt {
  self.get("byteOffset") |> unsafe_cast
}

///|
pub fn Int8Array::buffer(self : Self) -> ArrayBuffer {
  self.get("buffer") |> unsafe_cast
}

///|
#external
pub type Int16Array

///|
pub impl JsImpl for Int16Array

///|
pub fn Int16Array::from_size(length : UInt) -> Int16Array {
  unsafe_cast(ffi_int16array_from_size(length))
}

///|
extern "js" fn ffi_int16array_from_size(length : UInt) -> Js =
  #| (len) => new Int16Array(len)

///|
pub fn Int16Array::from_array(array : Array[Int]) -> Int16Array {
  unsafe_cast(ffi_int16array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_int16array_from_array(array : Js) -> Js =
  #| (arr) => new Int16Array(arr)

///|
pub fn Int16Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Int16Array {
  unsafe_cast(ffi_int16array_from_buffer(buffer.to_js(), byte_offset, length))
}

///|
extern "js" fn ffi_int16array_from_buffer(
  buffer : Js,
  byte_offset : UInt,
  length : UInt?,
) -> Js =
  #| (buf, offset, len) => len !== undefined ? new Int16Array(buf, offset, len) : new Int16Array(buf, offset)

///|
#alias("_[_]=_")
pub extern "js" fn Int16Array::set_at(
  self : Self,
  index : UInt,
  value : Int,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn Int16Array::get_at(self : Self, index : UInt) -> Int =
  #| (arr, i) => arr[i]

///|
pub fn Int16Array::length(self : Self) -> UInt {
  self.get("length") |> unsafe_cast
}

///|
#alias(byteLength)
pub fn Int16Array::byte_length(self : Self) -> UInt {
  self.get("byteLength") |> unsafe_cast
}

///|
#alias(byteOffset)
pub fn Int16Array::byte_offset(self : Self) -> UInt {
  self.get("byteOffset") |> unsafe_cast
}

///|
pub fn Int16Array::buffer(self : Self) -> ArrayBuffer {
  self.get("buffer") |> unsafe_cast
}

///|
#external
pub type Int32Array

///|
pub impl JsImpl for Int32Array

///|
pub fn Int32Array::from_size(length : UInt) -> Int32Array {
  unsafe_cast(ffi_int32array_from_size(length))
}

///|
extern "js" fn ffi_int32array_from_size(length : UInt) -> Js =
  #| (len) => new Int32Array(len)

///|
pub fn Int32Array::from_array(array : Array[Int]) -> Int32Array {
  unsafe_cast(ffi_int32array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_int32array_from_array(array : Js) -> Js =
  #| (arr) => new Int32Array(arr)

///|
pub fn Int32Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Int32Array {
  unsafe_cast(ffi_int32array_from_buffer(buffer.to_js(), byte_offset, length))
}

///|
extern "js" fn ffi_int32array_from_buffer(
  buffer : Js,
  byte_offset : UInt,
  length : UInt?,
) -> Js =
  #| (buf, offset, len) => len !== undefined ? new Int32Array(buf, offset, len) : new Int32Array(buf, offset)

///|
#alias("_[_]=_")
pub extern "js" fn Int32Array::set_at(
  self : Self,
  index : UInt,
  value : Int,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn Int32Array::get_at(self : Self, index : UInt) -> Int =
  #| (arr, i) => arr[i]

///|
pub fn Int32Array::length(self : Self) -> UInt {
  self.get("length") |> unsafe_cast
}

///|
#alias(byteLength)
pub fn Int32Array::byte_length(self : Self) -> UInt {
  self.get("byteLength") |> unsafe_cast
}

///|
#alias(byteOffset)
pub fn Int32Array::byte_offset(self : Self) -> UInt {
  self.get("byteOffset") |> unsafe_cast
}

///|
pub fn Int32Array::buffer(self : Self) -> ArrayBuffer {
  self.get("buffer") |> unsafe_cast
}

///|
#external
pub type Float32Array

///|
pub impl JsImpl for Float32Array

///|
pub fn Float32Array::from_size(length : UInt) -> Float32Array {
  unsafe_cast(ffi_float32array_from_size(length))
}

///|
extern "js" fn ffi_float32array_from_size(length : UInt) -> Js =
  #| (len) => new Float32Array(len)

///|
pub fn Float32Array::from_array(array : Array[Double]) -> Float32Array {
  unsafe_cast(ffi_float32array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_float32array_from_array(array : Js) -> Js =
  #| (arr) => new Float32Array(arr)

///|
pub fn Float32Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Float32Array {
  unsafe_cast(ffi_float32array_from_buffer(buffer.to_js(), byte_offset, length))
}

///|
extern "js" fn ffi_float32array_from_buffer(
  buffer : Js,
  byte_offset : UInt,
  length : UInt?,
) -> Js =
  #| (buf, offset, len) => len !== undefined ? new Float32Array(buf, offset, len) : new Float32Array(buf, offset)

///|
#alias("_[_]=_")
pub extern "js" fn Float32Array::set_at(
  self : Self,
  index : UInt,
  value : Double,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn Float32Array::get_at(self : Self, index : UInt) -> Double =
  #| (arr, i) => arr[i]

///|
pub fn Float32Array::length(self : Self) -> UInt {
  self.get("length") |> unsafe_cast
}

///|
#alias(byteLength)
pub fn Float32Array::byte_length(self : Self) -> UInt {
  self.get("byteLength") |> unsafe_cast
}

///|
#alias(byteOffset)
pub fn Float32Array::byte_offset(self : Self) -> UInt {
  self.get("byteOffset") |> unsafe_cast
}

///|
pub fn Float32Array::buffer(self : Self) -> ArrayBuffer {
  unsafe_cast(self.get("buffer"))
}

///|
#external
pub type Float64Array

///|
pub impl JsImpl for Float64Array

///|
pub fn Float64Array::from_size(length : UInt) -> Float64Array {
  unsafe_cast(ffi_float64array_from_size(length))
}

///|
extern "js" fn ffi_float64array_from_size(length : UInt) -> Js =
  #| (len) => new Float64Array(len)

///|
pub fn Float64Array::from_array(array : Array[Double]) -> Float64Array {
  unsafe_cast(ffi_float64array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_float64array_from_array(array : Js) -> Js =
  #| (arr) => new Float64Array(arr)

///|
pub fn Float64Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Float64Array {
  unsafe_cast(ffi_float64array_from_buffer(buffer.to_js(), byte_offset, length))
}

///|
extern "js" fn ffi_float64array_from_buffer(
  buffer : Js,
  byte_offset : UInt,
  length : UInt?,
) -> Js =
  #| (buf, offset, len) => len !== undefined ? new Float64Array(buf, offset, len) : new Float64Array(buf, offset)

///|
#alias("_[_]=_")
pub extern "js" fn Float64Array::set_at(
  self : Self,
  index : UInt,
  value : Double,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn Float64Array::get_at(self : Self, index : UInt) -> Double =
  #| (arr, i) => arr[i]

///|
pub fn Float64Array::length(self : Self) -> UInt {
  unsafe_cast(self.get("length"))
}

///|
#alias(byteLength)
pub fn Float64Array::byte_length(self : Self) -> UInt {
  unsafe_cast(self.get("byteLength"))
}

///|
#alias(byteOffset)
pub fn Float64Array::byte_offset(self : Self) -> UInt {
  unsafe_cast(self.get("byteOffset"))
}

///|
pub fn Float64Array::buffer(self : Self) -> ArrayBuffer {
  unsafe_cast(self.get("buffer"))
}
