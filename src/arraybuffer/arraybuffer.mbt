///|
#external
pub type ArrayBuffer

///|
pub impl Js for ArrayBuffer

///|
extern "js" fn ffi_new_array_buffer(byte_length : UInt) -> Val =
  #| (len) => new ArrayBuffer(len)

///|
pub fn ArrayBuffer::new(byte_length : UInt) -> ArrayBuffer {
  ffi_new_array_buffer(byte_length).cast()
}

///|
#alias(byteLength)
pub fn ArrayBuffer::byte_length(self : ArrayBuffer) -> UInt {
  self.to_js().get("byteLength").cast()
}

///|
pub fn ArrayBuffer::slice(
  self : ArrayBuffer,
  begin? : Int = 0,
  end? : Int,
) -> ArrayBuffer {
  match end {
    Some(e) => self.to_js().invoke("slice", [begin, e]).cast()
    None => self.to_js().invoke("slice", [begin]).cast()
  }
}

///|
extern "js" fn ffi_is_view(arg : Val) -> Val =
  #| (arg) => ArrayBuffer.isView(arg)

///|
#alias(isView)
pub fn ArrayBuffer::is_view(arg : Val) -> Bool {
  ffi_is_view(arg).cast()
}

///|
#external
pub type SharedArrayBuffer

///|
pub impl Js for SharedArrayBuffer

///|
extern "js" fn ffi_new_shared_array_buffer(byte_length : UInt) -> Val =
  #| (len) => new SharedArrayBuffer(len)

///|
pub fn SharedArrayBuffer::new(byte_length : UInt) -> SharedArrayBuffer {
  ffi_new_shared_array_buffer(byte_length).cast()
}

///|
#alias(byteLength)
pub fn SharedArrayBuffer::byte_length(self : SharedArrayBuffer) -> UInt {
  self.to_js().get("byteLength").cast()
}

///|
pub fn SharedArrayBuffer::slice(
  self : SharedArrayBuffer,
  begin? : Int = 0,
  end? : Int,
) -> SharedArrayBuffer {
  match end {
    Some(e) => self.to_js().invoke("slice", [begin, e]).cast()
    None => self.to_js().invoke("slice", [begin]).cast()
  }
}

///|
#external
pub type DataView

///|
pub impl Js for DataView with to_js(self) -> Val {
  self |> js
}

///|
extern "js" fn ffi_new_dataview(
  buffer : Val,
  byte_offset : UInt,
  byte_length : UInt?,
) -> Val =
  #| (buf, offset, len) => len !== undefined ? new DataView(buf, offset, len) : new DataView(buf, offset)

///|
pub fn DataView::new(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  byte_length? : UInt,
) -> DataView {
  ffi_new_dataview(buffer.to_js(), byte_offset, byte_length).cast()
}

///|
pub fn DataView::buffer(self : DataView) -> ArrayBuffer {
  self.to_js().get("buffer").cast()
}

///|
#alias(byteLength)
pub fn DataView::byte_length(self : DataView) -> UInt {
  self.to_js().get("byteLength").cast()
}

///|
#alias(byteOffset)
pub fn DataView::byte_offset(self : DataView) -> UInt {
  self.to_js().get("byteOffset").cast()
}

///|
#alias(getInt8)
pub fn DataView::get_int8(self : DataView, byte_offset : UInt) -> Int {
  self.to_js().invoke("getInt8", [byte_offset]).cast()
}

///|
#alias(getUint8)
pub fn DataView::get_uint8(self : DataView, byte_offset : UInt) -> UInt {
  self.to_js().invoke("getUint8", [byte_offset]).cast()
}

///|
#alias(getInt16)
pub fn DataView::get_int16(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Int {
  self.to_js().invoke("getInt16", [byte_offset, little_endian]).cast()
}

///|
#alias(getUint16)
pub fn DataView::get_uint16(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> UInt {
  self.to_js().invoke("getUint16", [byte_offset, little_endian]).cast()
}

///|
#alias(getInt32)
pub fn DataView::get_int32(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Int {
  self.to_js().invoke("getInt32", [byte_offset, little_endian]).cast()
}

///|
#alias(getUint32)
pub fn DataView::get_uint32(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> UInt {
  self.to_js().invoke("getUint32", [byte_offset, little_endian]).cast()
}

///|
#alias(getFloat32)
pub fn DataView::get_float32(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Double {
  self.to_js().invoke("getFloat32", [byte_offset, little_endian]).cast()
}

///|
#alias(getFloat64)
pub fn DataView::get_float64(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Double {
  self.to_js().invoke("getFloat64", [byte_offset, little_endian]).cast()
}

///|
#alias(setInt8)
pub fn DataView::set_int8(
  self : DataView,
  byte_offset : UInt,
  value : Int,
) -> Unit {
  self.to_js().invoke("setInt8", [byte_offset, value]) |> ignore
}

///|
#alias(setUint8)
pub fn DataView::set_uint8(
  self : DataView,
  byte_offset : UInt,
  value : UInt,
) -> Unit {
  self.to_js().invoke("setUint8", [byte_offset, value]) |> ignore
}

///|
#alias(setInt16)
pub fn DataView::set_int16(
  self : DataView,
  byte_offset : UInt,
  value : Int,
  little_endian? : Bool = false,
) -> Unit {
  self.to_js().invoke("setInt16", [byte_offset, value, little_endian]) |> ignore
}

///|
#alias(setUint16)
pub fn DataView::set_uint16(
  self : DataView,
  byte_offset : UInt,
  value : UInt,
  little_endian? : Bool = false,
) -> Unit {
  self.to_js().invoke("setUint16", [byte_offset, value, little_endian])
  |> ignore
}

///|
#alias(setInt32)
pub fn DataView::set_int32(
  self : DataView,
  byte_offset : UInt,
  value : Int,
  little_endian? : Bool = false,
) -> Unit {
  self.to_js().invoke("setInt32", [byte_offset, value, little_endian]) |> ignore
}

///|
#alias(setUint32)
pub fn DataView::set_uint32(
  self : DataView,
  byte_offset : UInt,
  value : UInt,
  little_endian? : Bool = false,
) -> Unit {
  self.to_js().invoke("setUint32", [byte_offset, value, little_endian])
  |> ignore
}

///|
#alias(setFloat32)
pub fn DataView::set_float32(
  self : DataView,
  byte_offset : UInt,
  value : Double,
  little_endian? : Bool = false,
) -> Unit {
  self.to_js().invoke("setFloat32", [byte_offset, value, little_endian])
  |> ignore
}

///|
#alias(setFloat64)
pub fn DataView::set_float64(
  self : DataView,
  byte_offset : UInt,
  value : Double,
  little_endian? : Bool = false,
) -> Unit {
  self.to_js().invoke("setFloat64", [byte_offset, value, little_endian])
  |> ignore
}

///|
#external
pub type Uint8Array

///|
pub impl Js for Uint8Array

///|
extern "js" fn ffi_uint8array_from_size(length : UInt) -> Val =
  #| (len) => new Uint8Array(len)

///|
pub fn Uint8Array::from_size(length : UInt) -> Uint8Array {
  ffi_uint8array_from_size(length).cast()
}

///|
extern "js" fn ffi_uint8array_from_array(array : Val) -> Val =
  #| (arr) => new Uint8Array(arr)

///|
pub fn Uint8Array::from_array(array : Array[UInt]) -> Uint8Array {
  ffi_uint8array_from_array(@js.from_builtin_array(array)).cast()
}

///|
extern "js" fn ffi_uint8array_from_buffer(
  buffer : Val,
  byte_offset : UInt,
  length : UInt?,
) -> Val =
  #| (buf, offset, len) => len !== undefined ? new Uint8Array(buf, offset, len) : new Uint8Array(buf, offset)

///|
pub fn Uint8Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Uint8Array {
  ffi_uint8array_from_buffer(buffer.to_js(), byte_offset, length).cast()
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
  self.to_js().get("length").cast()
}

///|
#alias(byteLength)
pub fn Uint8Array::byte_length(self : Self) -> UInt {
  self.to_js().get("byteLength").cast()
}

///|
#alias(byteOffset)
pub fn Uint8Array::byte_offset(self : Self) -> UInt {
  self.to_js().get("byteOffset").cast()
}

///|
pub fn Uint8Array::buffer(self : Self) -> ArrayBuffer {
  self.to_js().get("buffer").cast()
}

///|
pub fn Uint8Array::set(
  self : Self,
  array : Array[UInt],
  offset? : UInt = 0,
) -> Unit {
  self.to_js().invoke("set", [@js.from_builtin_array(array), offset]) |> ignore
}

///|
pub fn Uint8Array::slice(self : Self, start? : Int = 0, end? : Int) -> Self {
  match end {
    Some(e) => self.to_js().invoke("slice", [start, e]).cast()
    None => self.to_js().invoke("slice", [start]).cast()
  }
}

///|
pub fn Uint8Array::subarray(self : Self, begin? : Int = 0, end? : Int) -> Self {
  match end {
    Some(e) => self.to_js().invoke("subarray", [begin, e]).cast()
    None => self.to_js().invoke("subarray", [begin]).cast()
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
    Some(e) => self.to_js().invoke("fill", [value, start, e]).cast()
    None => self.to_js().invoke("fill", [value, start]).cast()
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
    Some(e) => self.to_js().invoke("copyWithin", [target, start, e]).cast()
    None => self.to_js().invoke("copyWithin", [target, start]).cast()
  }
}

///|
pub fn Uint8Array::reverse(self : Self) -> Self {
  self.to_js().invoke("reverse", []).cast()
}

///|
pub fn Uint8Array::sort(self : Self) -> Self {
  self.to_js().invoke("sort", []).cast()
}

///|
#alias(indexOf)
pub fn Uint8Array::index_of(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Int {
  self.to_js().invoke("indexOf", [search_element, from_index]).cast()
}

///|
#alias(lastIndexOf)
pub fn Uint8Array::last_index_of(
  self : Self,
  search_element : UInt,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.to_js().invoke("lastIndexOf", [search_element, i]).cast()
    None => self.to_js().invoke("lastIndexOf", [search_element]).cast()
  }
}

///|
pub fn Uint8Array::includes(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Bool {
  self.to_js().invoke("includes", [search_element, from_index]).cast()
}

///|
pub fn Uint8Array::join(self : Self, separator? : String = ",") -> String {
  self.to_js().invoke("join", [separator]).cast()
}

///|
#alias(toString)
pub fn Uint8Array::to_string(self : Self) -> String {
  self.to_js().invoke("toString", []).cast()
}

///|
#external
pub type Uint16Array

///|
pub impl Js for Uint16Array

///|
pub fn Uint16Array::from_size(length : UInt) -> Uint16Array {
  ffi_uint16array_from_size(length).cast()
}

///|
extern "js" fn ffi_uint16array_from_size(length : UInt) -> Val =
  #| (len) => new Uint16Array(len)

///|
pub fn Uint16Array::from_array(array : Array[UInt]) -> Uint16Array {
  ffi_uint16array_from_array(@js.from_builtin_array(array)).cast()
}

///|
extern "js" fn ffi_uint16array_from_array(array : Val) -> Val =
  #| (arr) => new Uint16Array(arr)

///|
pub fn Uint16Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Uint16Array {
  ffi_uint16array_from_buffer(buffer.to_js(), byte_offset, length).cast()
}

///|
extern "js" fn ffi_uint16array_from_buffer(
  buffer : Val,
  byte_offset : UInt,
  length : UInt?,
) -> Val =
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
  self.to_js().get("length").cast()
}

///|
#alias(byteLength)
pub fn Uint16Array::byte_length(self : Self) -> UInt {
  self.to_js().get("byteLength").cast()
}

///|
#alias(byteOffset)
pub fn Uint16Array::byte_offset(self : Self) -> UInt {
  self.to_js().get("byteOffset").cast()
}

///|
pub fn Uint16Array::buffer(self : Self) -> ArrayBuffer {
  self.to_js().get("buffer").cast()
}

///|
#external
pub type Uint32Array

///|
pub impl Js for Uint32Array with to_js(self) -> Val {
  self |> js
}

///|
pub fn Uint32Array::from_size(length : UInt) -> Uint32Array {
  ffi_uint32array_from_size(length).cast()
}

///|
extern "js" fn ffi_uint32array_from_size(length : UInt) -> Val =
  #| (len) => new Uint32Array(len)

///|
pub fn Uint32Array::from_array(array : Array[UInt]) -> Uint32Array {
  ffi_uint32array_from_array(@js.from_builtin_array(array)).cast()
}

///|
extern "js" fn ffi_uint32array_from_array(array : Val) -> Val =
  #| (arr) => new Uint32Array(arr)

///|
pub fn Uint32Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Uint32Array {
  ffi_uint32array_from_buffer(buffer.to_js(), byte_offset, length).cast()
}

///|
extern "js" fn ffi_uint32array_from_buffer(
  buffer : Val,
  byte_offset : UInt,
  length : UInt?,
) -> Val =
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
  self.to_js().get("length").cast()
}

///|
#alias(byteLength)
pub fn Uint32Array::byte_length(self : Self) -> UInt {
  self.to_js().get("byteLength").cast()
}

///|
#alias(byteOffset)
pub fn Uint32Array::byte_offset(self : Self) -> UInt {
  self.to_js().get("byteOffset").cast()
}

///|
pub fn Uint32Array::buffer(self : Self) -> ArrayBuffer {
  self.to_js().get("buffer").cast()
}

///|
#external
pub type Int8Array

///|
pub impl Js for Int8Array with to_js(self) -> Val {
  self |> js
}

///|
pub fn Int8Array::from_size(length : UInt) -> Int8Array {
  ffi_int8array_from_size(length).cast()
}

///|
extern "js" fn ffi_int8array_from_size(length : UInt) -> Val =
  #| (len) => new Int8Array(len)

///|
pub fn Int8Array::from_array(array : Array[Int]) -> Int8Array {
  ffi_int8array_from_array(@js.from_builtin_array(array)).cast()
}

///|
extern "js" fn ffi_int8array_from_array(array : Val) -> Val =
  #| (arr) => new Int8Array(arr)

///|
pub fn Int8Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Int8Array {
  ffi_int8array_from_buffer(buffer.to_js(), byte_offset, length).cast()
}

///|
extern "js" fn ffi_int8array_from_buffer(
  buffer : Val,
  byte_offset : UInt,
  length : UInt?,
) -> Val =
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
  self.to_js().get("length").cast()
}

///|
#alias(byteLength)
pub fn Int8Array::byte_length(self : Self) -> UInt {
  self.to_js().get("byteLength").cast()
}

///|
#alias(byteOffset)
pub fn Int8Array::byte_offset(self : Self) -> UInt {
  self.to_js().get("byteOffset").cast()
}

///|
pub fn Int8Array::buffer(self : Self) -> ArrayBuffer {
  self.to_js().get("buffer").cast()
}

///|
#external
pub type Int16Array

///|
pub impl Js for Int16Array with to_js(self) -> Val {
  self |> js
}

///|
pub fn Int16Array::from_size(length : UInt) -> Int16Array {
  ffi_int16array_from_size(length).cast()
}

///|
extern "js" fn ffi_int16array_from_size(length : UInt) -> Val =
  #| (len) => new Int16Array(len)

///|
pub fn Int16Array::from_array(array : Array[Int]) -> Int16Array {
  ffi_int16array_from_array(@js.from_builtin_array(array)).cast()
}

///|
extern "js" fn ffi_int16array_from_array(array : Val) -> Val =
  #| (arr) => new Int16Array(arr)

///|
pub fn Int16Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Int16Array {
  ffi_int16array_from_buffer(buffer.to_js(), byte_offset, length).cast()
}

///|
extern "js" fn ffi_int16array_from_buffer(
  buffer : Val,
  byte_offset : UInt,
  length : UInt?,
) -> Val =
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
  self.to_js().get("length").cast()
}

///|
#alias(byteLength)
pub fn Int16Array::byte_length(self : Self) -> UInt {
  self.to_js().get("byteLength").cast()
}

///|
#alias(byteOffset)
pub fn Int16Array::byte_offset(self : Self) -> UInt {
  self.to_js().get("byteOffset").cast()
}

///|
pub fn Int16Array::buffer(self : Self) -> ArrayBuffer {
  self.to_js().get("buffer").cast()
}

///|
#external
pub type Int32Array

///|
pub impl Js for Int32Array with to_js(self) -> Val {
  self |> js
}

///|
pub fn Int32Array::from_size(length : UInt) -> Int32Array {
  ffi_int32array_from_size(length).cast()
}

///|
extern "js" fn ffi_int32array_from_size(length : UInt) -> Val =
  #| (len) => new Int32Array(len)

///|
pub fn Int32Array::from_array(array : Array[Int]) -> Int32Array {
  ffi_int32array_from_array(@js.from_builtin_array(array)).cast()
}

///|
extern "js" fn ffi_int32array_from_array(array : Val) -> Val =
  #| (arr) => new Int32Array(arr)

///|
pub fn Int32Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Int32Array {
  ffi_int32array_from_buffer(buffer.to_js(), byte_offset, length).cast()
}

///|
extern "js" fn ffi_int32array_from_buffer(
  buffer : Val,
  byte_offset : UInt,
  length : UInt?,
) -> Val =
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
  self.to_js().get("length").cast()
}

///|
#alias(byteLength)
pub fn Int32Array::byte_length(self : Self) -> UInt {
  self.to_js().get("byteLength").cast()
}

///|
#alias(byteOffset)
pub fn Int32Array::byte_offset(self : Self) -> UInt {
  self.to_js().get("byteOffset").cast()
}

///|
pub fn Int32Array::buffer(self : Self) -> ArrayBuffer {
  self.to_js().get("buffer").cast()
}

///|
#external
pub type Float32Array

///|
pub impl Js for Float32Array with to_js(self) -> Val {
  self |> js
}

///|
pub fn Float32Array::from_size(length : UInt) -> Float32Array {
  ffi_float32array_from_size(length).cast()
}

///|
extern "js" fn ffi_float32array_from_size(length : UInt) -> Val =
  #| (len) => new Float32Array(len)

///|
pub fn Float32Array::from_array(array : Array[Double]) -> Float32Array {
  ffi_float32array_from_array(@js.from_builtin_array(array)).cast()
}

///|
extern "js" fn ffi_float32array_from_array(array : Val) -> Val =
  #| (arr) => new Float32Array(arr)

///|
pub fn Float32Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Float32Array {
  ffi_float32array_from_buffer(buffer.to_js(), byte_offset, length).cast()
}

///|
extern "js" fn ffi_float32array_from_buffer(
  buffer : Val,
  byte_offset : UInt,
  length : UInt?,
) -> Val =
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
  self.to_js().get("length").cast()
}

///|
#alias(byteLength)
pub fn Float32Array::byte_length(self : Self) -> UInt {
  self.to_js().get("byteLength").cast()
}

///|
#alias(byteOffset)
pub fn Float32Array::byte_offset(self : Self) -> UInt {
  self.to_js().get("byteOffset").cast()
}

///|
pub fn Float32Array::buffer(self : Self) -> ArrayBuffer {
  self.to_js().get("buffer").cast()
}

///|
#external
pub type Float64Array

///|
pub impl Js for Float64Array with to_js(self) -> Val {
  self |> js
}

///|
pub fn Float64Array::from_size(length : UInt) -> Float64Array {
  ffi_float64array_from_size(length).cast()
}

///|
extern "js" fn ffi_float64array_from_size(length : UInt) -> Val =
  #| (len) => new Float64Array(len)

///|
pub fn Float64Array::from_array(array : Array[Double]) -> Float64Array {
  ffi_float64array_from_array(@js.from_builtin_array(array)).cast()
}

///|
extern "js" fn ffi_float64array_from_array(array : Val) -> Val =
  #| (arr) => new Float64Array(arr)

///|
pub fn Float64Array::from_array_buffer(
  buffer : ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Float64Array {
  ffi_float64array_from_buffer(buffer.to_js(), byte_offset, length).cast()
}

///|
extern "js" fn ffi_float64array_from_buffer(
  buffer : Val,
  byte_offset : UInt,
  length : UInt?,
) -> Val =
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
  self.to_js().get("length").cast()
}

///|
#alias(byteLength)
pub fn Float64Array::byte_length(self : Self) -> UInt {
  self.to_js().get("byteLength").cast()
}

///|
#alias(byteOffset)
pub fn Float64Array::byte_offset(self : Self) -> UInt {
  self.to_js().get("byteOffset").cast()
}

///|
pub fn Float64Array::buffer(self : Self) -> ArrayBuffer {
  self.to_js().get("buffer").cast()
}
