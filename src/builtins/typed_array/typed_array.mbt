///|
pub(all) struct Uint8Array {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
  length : UInt
}

///|
pub impl @js.JsImpl for Uint8Array

///|
pub impl TypedArrayImpl for Uint8Array

///|
#alias(copy_within)
pub fn Uint8Array::copyWithin(
  self : Self,
  target : Int,
  start : Int,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("copyWithin", [target, start, e]) |> @js.unsafe_cast
    None => self.call2("copyWithin", target, start) |> @js.unsafe_cast
  }
}

///|
#alias(index_of)
pub fn Uint8Array::indexOf(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Int {
  self.call2("indexOf", search_element, from_index) |> @js.unsafe_cast
}

///|
#alias(last_index_of)
pub fn Uint8Array::lastIndexOf(
  self : Self,
  search_element : UInt,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.call2("lastIndexOf", search_element, i) |> @js.unsafe_cast
    None => self.call("lastIndexOf", [search_element]) |> @js.unsafe_cast
  }
}

///|
#alias(to_string)
pub fn Uint8Array::toString(self : Self) -> String {
  self.call0("toString") |> @js.unsafe_cast
}

///|
extern "js" fn ffi_uint8array_from_size(length : UInt) -> @js.Js =
  #| (len) => new Uint8Array(len)

///|
pub fn Uint8Array::from_size(length : UInt) -> Uint8Array {
  @js.unsafe_cast(ffi_uint8array_from_size(length))
}

///|
extern "js" fn ffi_uint8array_from_array(array : @js.Js) -> @js.Js =
  #| (arr) => new Uint8Array(arr)

///|
pub fn Uint8Array::from_array(array : Array[UInt]) -> Uint8Array {
  @js.unsafe_cast(ffi_uint8array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_uint8array_from_buffer(
  buffer : @js.Js,
  byte_offset : UInt,
  length : UInt?,
) -> @js.Js =
  #| (buf, offset, len) => len !== undefined ? new Uint8Array(buf, offset, len) : new Uint8Array(buf, offset)

///|
pub fn Uint8Array::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Uint8Array {
  @js.unsafe_cast(
    ffi_uint8array_from_buffer(buffer.to_js(), byte_offset, length),
  )
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
pub fn Uint8Array::set(
  self : Self,
  array : Array[UInt],
  offset? : UInt = 0,
) -> Unit {
  self.call2("set", @js.from_array(array), offset) |> ignore
}

///|
pub fn Uint8Array::fill(
  self : Self,
  value : UInt,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("fill", [value, start, e]) |> @js.unsafe_cast
    None => self.call2("fill", value, start) |> @js.unsafe_cast
  }
}

///|
pub fn Uint8Array::includes(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Bool {
  self.call2("includes", search_element, from_index) |> @js.unsafe_cast
}

///|
pub(all) struct Uint16Array {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
  length : UInt
}

///|
pub impl @js.JsImpl for Uint16Array

///|
pub impl TypedArrayImpl for Uint16Array

///|
#alias(copy_within)
pub fn Uint16Array::copyWithin(
  self : Self,
  target : Int,
  start : Int,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("copyWithin", [target, start, e]) |> @js.unsafe_cast
    None => self.call2("copyWithin", target, start) |> @js.unsafe_cast
  }
}

///|
#alias(index_of)
pub fn Uint16Array::indexOf(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Int {
  self.call2("indexOf", search_element, from_index) |> @js.unsafe_cast
}

///|
#alias(last_index_of)
pub fn Uint16Array::lastIndexOf(
  self : Self,
  search_element : UInt,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.call2("lastIndexOf", search_element, i) |> @js.unsafe_cast
    None => self.call("lastIndexOf", [search_element]) |> @js.unsafe_cast
  }
}

///|
#alias(to_string)
pub fn Uint16Array::toString(self : Self) -> String {
  self.call0("toString") |> @js.unsafe_cast
}

///|
pub fn Uint16Array::from_size(length : UInt) -> Uint16Array {
  @js.unsafe_cast(ffi_uint16array_from_size(length))
}

///|
extern "js" fn ffi_uint16array_from_size(length : UInt) -> @js.Js =
  #| (len) => new Uint16Array(len)

///|
pub fn Uint16Array::from_array(array : Array[UInt]) -> Uint16Array {
  @js.unsafe_cast(ffi_uint16array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_uint16array_from_array(array : @js.Js) -> @js.Js =
  #| (arr) => new Uint16Array(arr)

///|
pub fn Uint16Array::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Uint16Array {
  @js.unsafe_cast(
    ffi_uint16array_from_buffer(buffer.to_js(), byte_offset, length),
  )
}

///|
extern "js" fn ffi_uint16array_from_buffer(
  buffer : @js.Js,
  byte_offset : UInt,
  length : UInt?,
) -> @js.Js =
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
pub fn Uint16Array::fill(
  self : Self,
  value : UInt,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("fill", [value, start, e]) |> @js.unsafe_cast
    None => self.call2("fill", value, start) |> @js.unsafe_cast
  }
}

///|
pub fn Uint16Array::includes(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Bool {
  self.call2("includes", search_element, from_index) |> @js.unsafe_cast
}

///|
pub(all) struct Uint32Array {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
  length : UInt
}

///|
pub impl @js.JsImpl for Uint32Array

///|
pub impl TypedArrayImpl for Uint32Array

///|
#alias(copy_within)
pub fn Uint32Array::copyWithin(
  self : Self,
  target : Int,
  start : Int,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("copyWithin", [target, start, e]) |> @js.unsafe_cast
    None => self.call2("copyWithin", target, start) |> @js.unsafe_cast
  }
}

///|
#alias(index_of)
pub fn Uint32Array::indexOf(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Int {
  self.call2("indexOf", search_element, from_index) |> @js.unsafe_cast
}

///|
#alias(last_index_of)
pub fn Uint32Array::lastIndexOf(
  self : Self,
  search_element : UInt,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.call2("lastIndexOf", search_element, i) |> @js.unsafe_cast
    None => self.call("lastIndexOf", [search_element]) |> @js.unsafe_cast
  }
}

///|
#alias(to_string)
pub fn Uint32Array::toString(self : Self) -> String {
  self.call0("toString") |> @js.unsafe_cast
}

///|
pub fn Uint32Array::from_size(length : UInt) -> Uint32Array {
  @js.unsafe_cast(ffi_uint32array_from_size(length))
}

///|
extern "js" fn ffi_uint32array_from_size(length : UInt) -> @js.Js =
  #| (len) => new Uint32Array(len)

///|
pub fn Uint32Array::from_array(array : Array[UInt]) -> Uint32Array {
  @js.unsafe_cast(ffi_uint32array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_uint32array_from_array(array : @js.Js) -> @js.Js =
  #| (arr) => new Uint32Array(arr)

///|
pub fn Uint32Array::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Uint32Array {
  @js.unsafe_cast(
    ffi_uint32array_from_buffer(buffer.to_js(), byte_offset, length),
  )
}

///|
extern "js" fn ffi_uint32array_from_buffer(
  buffer : @js.Js,
  byte_offset : UInt,
  length : UInt?,
) -> @js.Js =
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
pub fn Uint32Array::fill(
  self : Self,
  value : UInt,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("fill", [value, start, e]) |> @js.unsafe_cast
    None => self.call2("fill", value, start) |> @js.unsafe_cast
  }
}

///|
pub fn Uint32Array::includes(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Bool {
  self.call2("includes", search_element, from_index) |> @js.unsafe_cast
}

///|
pub(all) struct Int8Array {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
  length : UInt
}

///|
pub impl @js.JsImpl for Int8Array

///|
pub impl TypedArrayImpl for Int8Array

///|
#alias(copy_within)
pub fn Int8Array::copyWithin(
  self : Self,
  target : Int,
  start : Int,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("copyWithin", [target, start, e]) |> @js.unsafe_cast
    None => self.call2("copyWithin", target, start) |> @js.unsafe_cast
  }
}

///|
#alias(index_of)
pub fn Int8Array::indexOf(
  self : Self,
  search_element : Int,
  from_index? : Int = 0,
) -> Int {
  self.call2("indexOf", search_element, from_index) |> @js.unsafe_cast
}

///|
#alias(last_index_of)
pub fn Int8Array::lastIndexOf(
  self : Self,
  search_element : Int,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.call2("lastIndexOf", search_element, i) |> @js.unsafe_cast
    None => self.call("lastIndexOf", [search_element]) |> @js.unsafe_cast
  }
}

///|
#alias(to_string)
pub fn Int8Array::toString(self : Self) -> String {
  self.call0("toString") |> @js.unsafe_cast
}

///|
pub fn Int8Array::from_size(length : UInt) -> Int8Array {
  @js.unsafe_cast(ffi_int8array_from_size(length))
}

///|
extern "js" fn ffi_int8array_from_size(length : UInt) -> @js.Js =
  #| (len) => new Int8Array(len)

///|
pub fn Int8Array::from_array(array : Array[Int]) -> Int8Array {
  @js.unsafe_cast(ffi_int8array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_int8array_from_array(array : @js.Js) -> @js.Js =
  #| (arr) => new Int8Array(arr)

///|
pub fn Int8Array::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Int8Array {
  @js.unsafe_cast(
    ffi_int8array_from_buffer(buffer.to_js(), byte_offset, length),
  )
}

///|
extern "js" fn ffi_int8array_from_buffer(
  buffer : @js.Js,
  byte_offset : UInt,
  length : UInt?,
) -> @js.Js =
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
pub fn Int8Array::fill(
  self : Self,
  value : Int,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("fill", [value, start, e]) |> @js.unsafe_cast
    None => self.call2("fill", value, start) |> @js.unsafe_cast
  }
}

///|
pub fn Int8Array::includes(
  self : Self,
  search_element : Int,
  from_index? : Int = 0,
) -> Bool {
  self.call2("includes", search_element, from_index) |> @js.unsafe_cast
}

///|
pub(all) struct Int16Array {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
  length : UInt
}

///|
pub impl @js.JsImpl for Int16Array

///|
pub impl TypedArrayImpl for Int16Array

///|
#alias(copy_within)
pub fn Int16Array::copyWithin(
  self : Self,
  target : Int,
  start : Int,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("copyWithin", [target, start, e]) |> @js.unsafe_cast
    None => self.call2("copyWithin", target, start) |> @js.unsafe_cast
  }
}

///|
#alias(index_of)
pub fn Int16Array::indexOf(
  self : Self,
  search_element : Int,
  from_index? : Int = 0,
) -> Int {
  self.call2("indexOf", search_element, from_index) |> @js.unsafe_cast
}

///|
#alias(last_index_of)
pub fn Int16Array::lastIndexOf(
  self : Self,
  search_element : Int,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.call2("lastIndexOf", search_element, i) |> @js.unsafe_cast
    None => self.call("lastIndexOf", [search_element]) |> @js.unsafe_cast
  }
}

///|
#alias(to_string)
pub fn Int16Array::toString(self : Self) -> String {
  self.call0("toString") |> @js.unsafe_cast
}

///|
pub fn Int16Array::from_size(length : UInt) -> Int16Array {
  @js.unsafe_cast(ffi_int16array_from_size(length))
}

///|
extern "js" fn ffi_int16array_from_size(length : UInt) -> @js.Js =
  #| (len) => new Int16Array(len)

///|
pub fn Int16Array::from_array(array : Array[Int]) -> Int16Array {
  @js.unsafe_cast(ffi_int16array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_int16array_from_array(array : @js.Js) -> @js.Js =
  #| (arr) => new Int16Array(arr)

///|
pub fn Int16Array::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Int16Array {
  @js.unsafe_cast(
    ffi_int16array_from_buffer(buffer.to_js(), byte_offset, length),
  )
}

///|
extern "js" fn ffi_int16array_from_buffer(
  buffer : @js.Js,
  byte_offset : UInt,
  length : UInt?,
) -> @js.Js =
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
pub fn Int16Array::fill(
  self : Self,
  value : Int,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("fill", [value, start, e]) |> @js.unsafe_cast
    None => self.call2("fill", value, start) |> @js.unsafe_cast
  }
}

///|
pub fn Int16Array::includes(
  self : Self,
  search_element : Int,
  from_index? : Int = 0,
) -> Bool {
  self.call2("includes", search_element, from_index) |> @js.unsafe_cast
}

///|
pub(all) struct Int32Array {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
  length : UInt
}

///|
pub impl @js.JsImpl for Int32Array

///|
pub impl TypedArrayImpl for Int32Array

///|
#alias(copy_within)
pub fn Int32Array::copyWithin(
  self : Self,
  target : Int,
  start : Int,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("copyWithin", [target, start, e]) |> @js.unsafe_cast
    None => self.call2("copyWithin", target, start) |> @js.unsafe_cast
  }
}

///|
#alias(index_of)
pub fn Int32Array::indexOf(
  self : Self,
  search_element : Int,
  from_index? : Int = 0,
) -> Int {
  self.call2("indexOf", search_element, from_index) |> @js.unsafe_cast
}

///|
#alias(last_index_of)
pub fn Int32Array::lastIndexOf(
  self : Self,
  search_element : Int,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.call2("lastIndexOf", search_element, i) |> @js.unsafe_cast
    None => self.call("lastIndexOf", [search_element]) |> @js.unsafe_cast
  }
}

///|
#alias(to_string)
pub fn Int32Array::toString(self : Self) -> String {
  self.call0("toString") |> @js.unsafe_cast
}

///|
pub fn Int32Array::from_size(length : UInt) -> Int32Array {
  @js.unsafe_cast(ffi_int32array_from_size(length))
}

///|
extern "js" fn ffi_int32array_from_size(length : UInt) -> @js.Js =
  #| (len) => new Int32Array(len)

///|
pub fn Int32Array::from_array(array : Array[Int]) -> Int32Array {
  @js.unsafe_cast(ffi_int32array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_int32array_from_array(array : @js.Js) -> @js.Js =
  #| (arr) => new Int32Array(arr)

///|
pub fn Int32Array::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Int32Array {
  @js.unsafe_cast(
    ffi_int32array_from_buffer(buffer.to_js(), byte_offset, length),
  )
}

///|
extern "js" fn ffi_int32array_from_buffer(
  buffer : @js.Js,
  byte_offset : UInt,
  length : UInt?,
) -> @js.Js =
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
pub fn Int32Array::fill(
  self : Self,
  value : Int,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("fill", [value, start, e]) |> @js.unsafe_cast
    None => self.call2("fill", value, start) |> @js.unsafe_cast
  }
}

///|
pub fn Int32Array::includes(
  self : Self,
  search_element : Int,
  from_index? : Int = 0,
) -> Bool {
  self.call2("includes", search_element, from_index) |> @js.unsafe_cast
}

///|
pub(all) struct Float32Array {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
  length : UInt
}

///|
pub impl @js.JsImpl for Float32Array

///|
pub impl TypedArrayImpl for Float32Array

///|
#alias(copy_within)
pub fn Float32Array::copyWithin(
  self : Self,
  target : Int,
  start : Int,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("copyWithin", [target, start, e]) |> @js.unsafe_cast
    None => self.call2("copyWithin", target, start) |> @js.unsafe_cast
  }
}

///|
#alias(index_of)
pub fn Float32Array::indexOf(
  self : Self,
  search_element : Double,
  from_index? : Int = 0,
) -> Int {
  self.call2("indexOf", search_element, from_index) |> @js.unsafe_cast
}

///|
#alias(last_index_of)
pub fn Float32Array::lastIndexOf(
  self : Self,
  search_element : Double,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.call2("lastIndexOf", search_element, i) |> @js.unsafe_cast
    None => self.call("lastIndexOf", [search_element]) |> @js.unsafe_cast
  }
}

///|
#alias(to_string)
pub fn Float32Array::toString(self : Self) -> String {
  self.call0("toString") |> @js.unsafe_cast
}

///|
pub fn Float32Array::from_size(length : UInt) -> Float32Array {
  @js.unsafe_cast(ffi_float32array_from_size(length))
}

///|
extern "js" fn ffi_float32array_from_size(length : UInt) -> @js.Js =
  #| (len) => new Float32Array(len)

///|
pub fn Float32Array::from_array(array : Array[Double]) -> Float32Array {
  @js.unsafe_cast(ffi_float32array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_float32array_from_array(array : @js.Js) -> @js.Js =
  #| (arr) => new Float32Array(arr)

///|
pub fn Float32Array::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Float32Array {
  @js.unsafe_cast(
    ffi_float32array_from_buffer(buffer.to_js(), byte_offset, length),
  )
}

///|
extern "js" fn ffi_float32array_from_buffer(
  buffer : @js.Js,
  byte_offset : UInt,
  length : UInt?,
) -> @js.Js =
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
pub fn Float32Array::fill(
  self : Self,
  value : Double,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("fill", [value, start, e]) |> @js.unsafe_cast
    None => self.call2("fill", value, start) |> @js.unsafe_cast
  }
}

///|
pub fn Float32Array::includes(
  self : Self,
  search_element : Double,
  from_index? : Int = 0,
) -> Bool {
  self.call2("includes", search_element, from_index) |> @js.unsafe_cast
}

///|
pub(all) struct Float64Array {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
  length : UInt
}

///|
pub impl @js.JsImpl for Float64Array

///|
pub impl TypedArrayImpl for Float64Array

///|
#alias(copy_within)
pub fn Float64Array::copyWithin(
  self : Self,
  target : Int,
  start : Int,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("copyWithin", [target, start, e]) |> @js.unsafe_cast
    None => self.call2("copyWithin", target, start) |> @js.unsafe_cast
  }
}

///|
#alias(index_of)
pub fn Float64Array::indexOf(
  self : Self,
  search_element : Double,
  from_index? : Int = 0,
) -> Int {
  self.call2("indexOf", search_element, from_index) |> @js.unsafe_cast
}

///|
#alias(last_index_of)
pub fn Float64Array::lastIndexOf(
  self : Self,
  search_element : Double,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.call2("lastIndexOf", search_element, i) |> @js.unsafe_cast
    None => self.call("lastIndexOf", [search_element]) |> @js.unsafe_cast
  }
}

///|
#alias(to_string)
pub fn Float64Array::toString(self : Self) -> String {
  self.call0("toString") |> @js.unsafe_cast
}

///|
pub fn Float64Array::from_size(length : UInt) -> Float64Array {
  @js.unsafe_cast(ffi_float64array_from_size(length))
}

///|
extern "js" fn ffi_float64array_from_size(length : UInt) -> @js.Js =
  #| (len) => new Float64Array(len)

///|
pub fn Float64Array::from_array(array : Array[Double]) -> Float64Array {
  @js.unsafe_cast(ffi_float64array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_float64array_from_array(array : @js.Js) -> @js.Js =
  #| (arr) => new Float64Array(arr)

///|
pub fn Float64Array::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Float64Array {
  @js.unsafe_cast(
    ffi_float64array_from_buffer(buffer.to_js(), byte_offset, length),
  )
}

///|
extern "js" fn ffi_float64array_from_buffer(
  buffer : @js.Js,
  byte_offset : UInt,
  length : UInt?,
) -> @js.Js =
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
pub fn Float64Array::fill(
  self : Self,
  value : Double,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("fill", [value, start, e]) |> @js.unsafe_cast
    None => self.call2("fill", value, start) |> @js.unsafe_cast
  }
}

///|
pub fn Float64Array::includes(
  self : Self,
  search_element : Double,
  from_index? : Int = 0,
) -> Bool {
  self.call2("includes", search_element, from_index) |> @js.unsafe_cast
}

///|
pub(all) struct Uint8ClampedArray {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
  length : UInt
}

///|
pub impl @js.JsImpl for Uint8ClampedArray

///|
pub impl TypedArrayImpl for Uint8ClampedArray

///|
#alias(copy_within)
pub fn Uint8ClampedArray::copyWithin(
  self : Self,
  target : Int,
  start : Int,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("copyWithin", [target, start, e]) |> @js.unsafe_cast
    None => self.call2("copyWithin", target, start) |> @js.unsafe_cast
  }
}

///|
#alias(index_of)
pub fn Uint8ClampedArray::indexOf(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Int {
  self.call2("indexOf", search_element, from_index) |> @js.unsafe_cast
}

///|
#alias(last_index_of)
pub fn Uint8ClampedArray::lastIndexOf(
  self : Self,
  search_element : UInt,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.call2("lastIndexOf", search_element, i) |> @js.unsafe_cast
    None => self.call("lastIndexOf", [search_element]) |> @js.unsafe_cast
  }
}

///|
#alias(to_string)
pub fn Uint8ClampedArray::toString(self : Self) -> String {
  self.call0("toString") |> @js.unsafe_cast
}

///|
pub fn Uint8ClampedArray::from_size(length : UInt) -> Uint8ClampedArray {
  @js.unsafe_cast(ffi_uint8clampedarray_from_size(length))
}

///|
extern "js" fn ffi_uint8clampedarray_from_size(length : UInt) -> @js.Js =
  #| (len) => new Uint8ClampedArray(len)

///|
pub fn Uint8ClampedArray::from_array(array : Array[UInt]) -> Uint8ClampedArray {
  @js.unsafe_cast(ffi_uint8clampedarray_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_uint8clampedarray_from_array(array : @js.Js) -> @js.Js =
  #| (arr) => new Uint8ClampedArray(arr)

///|
pub fn Uint8ClampedArray::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> Uint8ClampedArray {
  @js.unsafe_cast(
    ffi_uint8clampedarray_from_buffer(buffer.to_js(), byte_offset, length),
  )
}

///|
extern "js" fn ffi_uint8clampedarray_from_buffer(
  buffer : @js.Js,
  byte_offset : UInt,
  length : UInt?,
) -> @js.Js =
  #| (buf, offset, len) => len !== undefined ? new Uint8ClampedArray(buf, offset, len) : new Uint8ClampedArray(buf, offset)

///|
#alias("_[_]=_")
pub extern "js" fn Uint8ClampedArray::set_at(
  self : Self,
  index : UInt,
  value : UInt,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn Uint8ClampedArray::get_at(self : Self, index : UInt) -> UInt =
  #| (arr, i) => arr[i]

///|
pub fn Uint8ClampedArray::set(
  self : Self,
  array : Array[UInt],
  offset? : UInt = 0,
) -> Unit {
  self.call2("set", @js.from_array(array), offset) |> ignore
}

///|
pub fn Uint8ClampedArray::fill(
  self : Self,
  value : UInt,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("fill", [value, start, e]) |> @js.unsafe_cast
    None => self.call2("fill", value, start) |> @js.unsafe_cast
  }
}

///|
pub fn Uint8ClampedArray::includes(
  self : Self,
  search_element : UInt,
  from_index? : Int = 0,
) -> Bool {
  self.call2("includes", search_element, from_index) |> @js.unsafe_cast
}

///|
#external
pub type BigUint64Array

///|
pub impl @js.JsImpl for BigUint64Array

///|
pub impl TypedArrayImpl for BigUint64Array

///|
#alias(byte_length)
pub fn BigUint64Array::byteLength(self : Self) -> UInt {
  self.get("byteLength") |> @js.unsafe_cast
}

///|
#alias(byte_offset)
pub fn BigUint64Array::byteOffset(self : Self) -> UInt {
  self.get("byteOffset") |> @js.unsafe_cast
}

///|
#alias(copy_within)
pub fn BigUint64Array::copyWithin(
  self : Self,
  target : Int,
  start : Int,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("copyWithin", [target, start, e]) |> @js.unsafe_cast
    None => self.call2("copyWithin", target, start) |> @js.unsafe_cast
  }
}

///|
#alias(index_of)
pub fn BigUint64Array::indexOf(
  self : Self,
  search_element : @bigint.JsBigInt,
  from_index? : Int = 0,
) -> Int {
  self.call2("indexOf", search_element, from_index) |> @js.unsafe_cast
}

///|
#alias(last_index_of)
pub fn BigUint64Array::lastIndexOf(
  self : Self,
  search_element : @bigint.JsBigInt,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.call2("lastIndexOf", search_element, i) |> @js.unsafe_cast
    None => self.call("lastIndexOf", [search_element]) |> @js.unsafe_cast
  }
}

///|
#alias(to_string)
pub fn BigUint64Array::toString(self : Self) -> String {
  self.call0("toString") |> @js.unsafe_cast
}

///|
pub fn BigUint64Array::from_size(length : UInt) -> BigUint64Array {
  @js.unsafe_cast(ffi_biguint64array_from_size(length))
}

///|
extern "js" fn ffi_biguint64array_from_size(length : UInt) -> @js.Js =
  #| (len) => new BigUint64Array(len)

///|
pub fn BigUint64Array::from_array(
  array : Array[@bigint.JsBigInt],
) -> BigUint64Array {
  @js.unsafe_cast(ffi_biguint64array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_biguint64array_from_array(array : @js.Js) -> @js.Js =
  #| (arr) => new BigUint64Array(arr)

///|
pub fn BigUint64Array::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> BigUint64Array {
  @js.unsafe_cast(
    ffi_biguint64array_from_buffer(buffer.to_js(), byte_offset, length),
  )
}

///|
extern "js" fn ffi_biguint64array_from_buffer(
  buffer : @js.Js,
  byte_offset : UInt,
  length : UInt?,
) -> @js.Js =
  #| (buf, offset, len) => len !== undefined ? new BigUint64Array(buf, offset, len) : new BigUint64Array(buf, offset)

///|
#alias("_[_]=_")
pub extern "js" fn BigUint64Array::set_at(
  self : Self,
  index : UInt,
  value : @bigint.JsBigInt,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn BigUint64Array::get_at(
  self : Self,
  index : UInt,
) -> @bigint.JsBigInt =
  #| (arr, i) => arr[i]

///|
pub fn BigUint64Array::set(
  self : Self,
  array : Array[@bigint.JsBigInt],
  offset? : UInt = 0,
) -> Unit {
  self.call2("set", @js.from_array(array), offset) |> ignore
}

///|
pub fn BigUint64Array::fill(
  self : Self,
  value : @bigint.JsBigInt,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("fill", [value, start, e]) |> @js.unsafe_cast
    None => self.call2("fill", value, start) |> @js.unsafe_cast
  }
}

///|
pub fn BigUint64Array::includes(
  self : Self,
  search_element : @bigint.JsBigInt,
  from_index? : Int = 0,
) -> Bool {
  self.call2("includes", search_element, from_index) |> @js.unsafe_cast
}

///|
#external
pub type BigInt64Array

///|
pub impl @js.JsImpl for BigInt64Array

///|
pub impl TypedArrayImpl for BigInt64Array

///|
#alias(byte_length)
pub fn BigInt64Array::byteLength(self : Self) -> UInt {
  self.get("byteLength") |> @js.unsafe_cast
}

///|
#alias(byte_offset)
pub fn BigInt64Array::byteOffset(self : Self) -> UInt {
  self.get("byteOffset") |> @js.unsafe_cast
}

///|
#alias(copy_within)
pub fn BigInt64Array::copyWithin(
  self : Self,
  target : Int,
  start : Int,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("copyWithin", [target, start, e]) |> @js.unsafe_cast
    None => self.call2("copyWithin", target, start) |> @js.unsafe_cast
  }
}

///|
#alias(index_of)
pub fn BigInt64Array::indexOf(
  self : Self,
  search_element : @bigint.JsBigInt,
  from_index? : Int = 0,
) -> Int {
  self.call2("indexOf", search_element, from_index) |> @js.unsafe_cast
}

///|
#alias(last_index_of)
pub fn BigInt64Array::lastIndexOf(
  self : Self,
  search_element : @bigint.JsBigInt,
  from_index? : Int,
) -> Int {
  match from_index {
    Some(i) => self.call2("lastIndexOf", search_element, i) |> @js.unsafe_cast
    None => self.call("lastIndexOf", [search_element]) |> @js.unsafe_cast
  }
}

///|
#alias(to_string)
pub fn BigInt64Array::toString(self : Self) -> String {
  self.call0("toString") |> @js.unsafe_cast
}

///|
pub fn BigInt64Array::from_size(length : UInt) -> BigInt64Array {
  @js.unsafe_cast(ffi_bigint64array_from_size(length))
}

///|
extern "js" fn ffi_bigint64array_from_size(length : UInt) -> @js.Js =
  #| (len) => new BigInt64Array(len)

///|
pub fn BigInt64Array::from_array(
  array : Array[@bigint.JsBigInt],
) -> BigInt64Array {
  @js.unsafe_cast(ffi_bigint64array_from_array(@js.from_array(array)))
}

///|
extern "js" fn ffi_bigint64array_from_array(array : @js.Js) -> @js.Js =
  #| (arr) => new BigInt64Array(arr)

///|
pub fn BigInt64Array::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  length? : UInt,
) -> BigInt64Array {
  @js.unsafe_cast(
    ffi_bigint64array_from_buffer(buffer.to_js(), byte_offset, length),
  )
}

///|
extern "js" fn ffi_bigint64array_from_buffer(
  buffer : @js.Js,
  byte_offset : UInt,
  length : UInt?,
) -> @js.Js =
  #| (buf, offset, len) => len !== undefined ? new BigInt64Array(buf, offset, len) : new BigInt64Array(buf, offset)

///|
#alias("_[_]=_")
pub extern "js" fn BigInt64Array::set_at(
  self : Self,
  index : UInt,
  value : @bigint.JsBigInt,
) -> Unit =
  #| (arr, i, v) => arr[i] = v

///|
#alias("_[_]")
pub extern "js" fn BigInt64Array::get_at(
  self : Self,
  index : UInt,
) -> @bigint.JsBigInt =
  #| (arr, i) => arr[i]

///|
pub fn BigInt64Array::set(
  self : Self,
  array : Array[@bigint.JsBigInt],
  offset? : UInt = 0,
) -> Unit {
  self.call2("set", @js.from_array(array), offset) |> ignore
}

///|
pub fn BigInt64Array::fill(
  self : Self,
  value : @bigint.JsBigInt,
  start? : Int = 0,
  end? : Int,
) -> Self {
  match end {
    Some(e) => self.call("fill", [value, start, e]) |> @js.unsafe_cast
    None => self.call2("fill", value, start) |> @js.unsafe_cast
  }
}

///|
pub fn BigInt64Array::includes(
  self : Self,
  search_element : @bigint.JsBigInt,
  from_index? : Int = 0,
) -> Bool {
  self.call2("includes", search_element, from_index) |> @js.unsafe_cast
}
