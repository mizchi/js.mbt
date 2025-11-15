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
    Some(e) => self.invoke("slice", [begin, e]) |> unsafe_cast
    None => self.invoke("slice", [begin]) |> unsafe_cast
  }
}

///|
extern "js" fn ffi_is_view(arg : Val) -> Val =
  #| (arg) => ArrayBuffer.isView(arg)

///|
#alias(isView)
pub fn ArrayBuffer::is_view(arg : Val) -> Bool {
  ffi_is_view(arg) |> unsafe_cast
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
    Some(e) => unsafe_cast(self.invoke("slice", [begin, e]))
    None => unsafe_cast(self.invoke("slice", [begin]))
  }
}

///|
#external
pub type DataView

///|
pub impl Js for DataView

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
  unsafe_cast(ffi_new_dataview(buffer.to_js(), byte_offset, byte_length))
}

///|
pub fn DataView::buffer(self : DataView) -> ArrayBuffer {
  unsafe_cast(self.get("buffer"))
}

///|
#alias(byteLength)
pub fn DataView::byte_length(self : DataView) -> UInt {
  unsafe_cast(self.get("byteLength"))
}

///|
#alias(byteOffset)
pub fn DataView::byte_offset(self : DataView) -> UInt {
  unsafe_cast(self.get("byteOffset"))
}

///|
#alias(getInt8)
pub fn DataView::get_int8(self : DataView, byte_offset : UInt) -> Int {
  self.invoke("getInt8", [byte_offset]) |> unsafe_cast
}

///|
#alias(getUint8)
pub fn DataView::get_uint8(self : DataView, byte_offset : UInt) -> UInt {
  self.invoke("getUint8", [byte_offset]) |> unsafe_cast
}

///|
#alias(getInt16)
pub fn DataView::get_int16(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Int {
  self.invoke("getInt16", [byte_offset, little_endian]) |> unsafe_cast
}

///|
#alias(getUint16)
pub fn DataView::get_uint16(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> UInt {
  self.invoke("getUint16", [byte_offset, little_endian]) |> unsafe_cast
}

///|
#alias(getInt32)
pub fn DataView::get_int32(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Int {
  self.invoke("getInt32", [byte_offset, little_endian]) |> unsafe_cast
}

///|
#alias(getUint32)
pub fn DataView::get_uint32(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> UInt {
  self.invoke("getUint32", [byte_offset, little_endian]) |> unsafe_cast
}

///|
#alias(getFloat32)
pub fn DataView::get_float32(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Double {
  self.invoke("getFloat32", [byte_offset, little_endian]) |> unsafe_cast
}

///|
#alias(getFloat64)
pub fn DataView::get_float64(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Double {
  self.invoke("getFloat64", [byte_offset, little_endian]) |> unsafe_cast
}

///|
#alias(setInt8)
pub fn DataView::set_int8(
  self : DataView,
  byte_offset : UInt,
  value : Int,
) -> Unit {
  self.invoke("setInt8", [byte_offset, value]) |> ignore
}

///|
#alias(setUint8)
pub fn DataView::set_uint8(
  self : DataView,
  byte_offset : UInt,
  value : UInt,
) -> Unit {
  self.invoke("setUint8", [byte_offset, value]) |> ignore
}

///|
#alias(setInt16)
pub fn DataView::set_int16(
  self : DataView,
  byte_offset : UInt,
  value : Int,
  little_endian? : Bool = false,
) -> Unit {
  self.invoke("setInt16", [byte_offset, value, little_endian]) |> ignore
}

///|
#alias(setUint16)
pub fn DataView::set_uint16(
  self : DataView,
  byte_offset : UInt,
  value : UInt,
  little_endian? : Bool = false,
) -> Unit {
  self.invoke("setUint16", [byte_offset, value, little_endian]) |> ignore
}

///|
#alias(setInt32)
pub fn DataView::set_int32(
  self : DataView,
  byte_offset : UInt,
  value : Int,
  little_endian? : Bool = false,
) -> Unit {
  self.invoke("setInt32", [byte_offset, value, little_endian]) |> ignore
}

///|
#alias(setUint32)
pub fn DataView::set_uint32(
  self : DataView,
  byte_offset : UInt,
  value : UInt,
  little_endian? : Bool = false,
) -> Unit {
  self.invoke("setUint32", [byte_offset, value, little_endian]) |> ignore
}

///|
#alias(setFloat32)
pub fn DataView::set_float32(
  self : DataView,
  byte_offset : UInt,
  value : Double,
  little_endian? : Bool = false,
) -> Unit {
  self.invoke("setFloat32", [byte_offset, value, little_endian]) |> ignore
}

///|
#alias(setFloat64)
pub fn DataView::set_float64(
  self : DataView,
  byte_offset : UInt,
  value : Double,
  little_endian? : Bool = false,
) -> Unit {
  self.invoke("setFloat64", [byte_offset, value, little_endian]) |> ignore
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
  unsafe_cast(ffi_uint8array_from_size(length))
}

///|
extern "js" fn ffi_uint8array_from_array(array : Val) -> Val =
  #| (arr) => new Uint8Array(arr)

///|
pub fn Uint8Array::from_array(array : Array[UInt]) -> Uint8Array {
  unsafe_cast(ffi_uint8array_from_array(@js.from_builtin_array(array)))
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
  self.invoke("set", [@js.from_builtin_array(array), offset]) |> ignore
}

///|
pub fn Uint8Array::slice(self : Self, start? : Int = 0, end? : Int) -> Self {
  match end {
    Some(e) => self.invoke("slice", [start, e]) |> unsafe_cast
    None => self.invoke("slice", [start]) |> unsafe_cast
  }
}

///|
pub fn Uint8Array::subarray(self : Self, begin? : Int = 0, end? : Int) -> Self {
  match end {
    Some(e) => self.invoke("subarray", [begin, e]) |> unsafe_cast
    None => self.invoke("subarray", [begin]) |> unsafe_cast
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
    Some(e) => self.invoke("fill", [value, start, e]) |> unsafe_cast
    None => self.invoke("fill", [value, start]) |> unsafe_cast
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
    Some(e) => self.invoke("copyWithin", [target, start, e]) |> unsafe_cast
    None => self.invoke("copyWithin", [target, start]) |> unsafe_cast
  }
}

///|
pub fn Uint8Array::reverse(self : Self) -> Self {
  self.invoke("reverse", []) |> unsafe_cast
}

///|
pub fn Uint8Array::sort(self : Self) -> Self {
  self.invoke("sort", []) |> unsafe_cast
}

///|
#alias(indexOf)
pub fn Uint8Array::index_of(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Int {
  self.invoke("indexOf", [search_element, from_index]) |> unsafe_cast
}

///|
#alias(lastIndexOf)
pub fn Uint8Array::last_index_of(
  self : Self,
  search_element : UInt,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.invoke("lastIndexOf", [search_element, i]) |> unsafe_cast
    None => self.invoke("lastIndexOf", [search_element]) |> unsafe_cast
  }
}

///|
pub fn Uint8Array::includes(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Bool {
  self.invoke("includes", [search_element, from_index]) |> unsafe_cast
}

///|
pub fn Uint8Array::join(self : Self, separator? : String = ",") -> String {
  self.invoke("join", [separator]) |> unsafe_cast
}

///|
#alias(toString)
pub fn Uint8Array::to_string(self : Self) -> String {
  self.invoke("toString", []) |> unsafe_cast
}

///|
#external
pub type Uint16Array

///|
pub impl Js for Uint16Array

///|
pub fn Uint16Array::from_size(length : UInt) -> Uint16Array {
  unsafe_cast(ffi_uint16array_from_size(length))
}

///|
extern "js" fn ffi_uint16array_from_size(length : UInt) -> Val =
  #| (len) => new Uint16Array(len)

///|
pub fn Uint16Array::from_array(array : Array[UInt]) -> Uint16Array {
  unsafe_cast(ffi_uint16array_from_array(@js.from_builtin_array(array)))
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
  unsafe_cast(ffi_uint16array_from_buffer(buffer.to_js(), byte_offset, length))
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
pub impl Js for Uint32Array

///|
pub fn Uint32Array::from_size(length : UInt) -> Uint32Array {
  unsafe_cast(ffi_uint32array_from_size(length))
}

///|
extern "js" fn ffi_uint32array_from_size(length : UInt) -> Val =
  #| (len) => new Uint32Array(len)

///|
pub fn Uint32Array::from_array(array : Array[UInt]) -> Uint32Array {
  unsafe_cast(ffi_uint32array_from_array(@js.from_builtin_array(array)))
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
  unsafe_cast(ffi_uint32array_from_buffer(buffer.to_js(), byte_offset, length))
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
pub impl Js for Int8Array

///|
pub fn Int8Array::from_size(length : UInt) -> Int8Array {
  unsafe_cast(ffi_int8array_from_size(length))
}

///|
extern "js" fn ffi_int8array_from_size(length : UInt) -> Val =
  #| (len) => new Int8Array(len)

///|
pub fn Int8Array::from_array(array : Array[Int]) -> Int8Array {
  unsafe_cast(ffi_int8array_from_array(@js.from_builtin_array(array)))
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
  unsafe_cast(ffi_int8array_from_buffer(buffer.to_js(), byte_offset, length))
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
pub impl Js for Int16Array

///|
pub fn Int16Array::from_size(length : UInt) -> Int16Array {
  unsafe_cast(ffi_int16array_from_size(length))
}

///|
extern "js" fn ffi_int16array_from_size(length : UInt) -> Val =
  #| (len) => new Int16Array(len)

///|
pub fn Int16Array::from_array(array : Array[Int]) -> Int16Array {
  unsafe_cast(ffi_int16array_from_array(@js.from_builtin_array(array)))
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
  unsafe_cast(ffi_int16array_from_buffer(buffer.to_js(), byte_offset, length))
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
pub impl Js for Int32Array

///|
pub fn Int32Array::from_size(length : UInt) -> Int32Array {
  unsafe_cast(ffi_int32array_from_size(length))
}

///|
extern "js" fn ffi_int32array_from_size(length : UInt) -> Val =
  #| (len) => new Int32Array(len)

///|
pub fn Int32Array::from_array(array : Array[Int]) -> Int32Array {
  unsafe_cast(ffi_int32array_from_array(@js.from_builtin_array(array)))
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
  unsafe_cast(ffi_int32array_from_buffer(buffer.to_js(), byte_offset, length))
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
pub impl Js for Float32Array

///|
pub fn Float32Array::from_size(length : UInt) -> Float32Array {
  unsafe_cast(ffi_float32array_from_size(length))
}

///|
extern "js" fn ffi_float32array_from_size(length : UInt) -> Val =
  #| (len) => new Float32Array(len)

///|
pub fn Float32Array::from_array(array : Array[Double]) -> Float32Array {
  unsafe_cast(ffi_float32array_from_array(@js.from_builtin_array(array)))
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
  unsafe_cast(ffi_float32array_from_buffer(buffer.to_js(), byte_offset, length))
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
pub impl Js for Float64Array

///|
pub fn Float64Array::from_size(length : UInt) -> Float64Array {
  unsafe_cast(ffi_float64array_from_size(length))
}

///|
extern "js" fn ffi_float64array_from_size(length : UInt) -> Val =
  #| (len) => new Float64Array(len)

///|
pub fn Float64Array::from_array(array : Array[Double]) -> Float64Array {
  unsafe_cast(ffi_float64array_from_array(@js.from_builtin_array(array)))
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
  unsafe_cast(ffi_float64array_from_buffer(buffer.to_js(), byte_offset, length))
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
