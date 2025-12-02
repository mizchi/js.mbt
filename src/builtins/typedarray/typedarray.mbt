///|
pub(all) struct Uint8Array {
  buffer : @js.ArrayBuffer
  byteLength : Int
  byteOffset : Int
  length : Int
}

///|
pub fn Uint8Array::as_any(self : Uint8Array) -> @nostd.Any = "%identity"

///|
pub fn Uint8Array::as_typed_array(self : Uint8Array) -> TypedArray = "%identity"

///|
extern "js" fn ffi_uint8array_from_size(length : Int) -> @nostd.Any =
  #| (len) => new Uint8Array(len)

///|
pub fn Uint8Array::from_size(length : Int) -> Uint8Array {
  @nostd.identity(ffi_uint8array_from_size(length))
}

///|
extern "js" fn ffi_uint8array_from_array(array : @nostd.Any) -> @nostd.Any =
  #| (arr) => new Uint8Array(arr)

///|
pub fn Uint8Array::from_array(array : Array[Int]) -> Uint8Array {
  @nostd.identity(ffi_uint8array_from_array(@nostd.any(array)))
}

///|
extern "js" fn ffi_uint8array_from_buffer(
  buffer : @nostd.Any,
  byte_offset : Int,
  length : Int?,
) -> @nostd.Any =
  #| (buf, offset, len) => len !== undefined ? new Uint8Array(buf, offset, len) : new Uint8Array(buf, offset)

///|
pub fn Uint8Array::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : Int = 0,
  length? : Int,
) -> Uint8Array {
  @nostd.identity(
    ffi_uint8array_from_buffer(
      buffer.to_any() |> @nostd.identity,
      byte_offset,
      length,
    ),
  )
}

// ///|

///|
pub(all) struct Uint16Array {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
  length : UInt
}

// ///|

///|
pub fn Uint16Array::as_any(self : Uint16Array) -> @nostd.Any = "%identity"

///|
pub fn Uint16Array::as_typed_array(self : Uint16Array) -> TypedArray = "%identity"

///|
pub fn Uint16Array::from_array_buffer(
  buffer : @js.ArrayBuffer,
  byte_offset? : Int = 0,
  length? : Int,
) -> Uint16Array {
  @nostd.identity(
    ffi_uint16array_from_buffer(
      buffer.to_any() |> @nostd.identity,
      byte_offset,
      length,
    ),
  )
}

///|
extern "js" fn ffi_uint16array_from_buffer(
  buffer : @nostd.Any,
  byte_offset : Int,
  length : Int?,
) -> @nostd.Any =
  #| (buf, offset, len) => len !== undefined ? new Uint16Array(buf, offset, len) : new Uint16Array(buf, offset)

// ///|

///|
pub(all) struct Uint32Array {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
  length : UInt
}

///|
pub extern "js" fn Uint32Array::as_typed_array(
  self : Uint32Array,
) -> TypedArray = "%identity"

// ///|
// pub fn Uint32Array::as_any(self : Uint32Array) -> @nostd.Any = "%identity"

///|
pub(all) struct Int8Array {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
  length : UInt
}

///|
pub extern "js" fn Int8Array::as_typed_array(self : Int8Array) -> TypedArray = "%identity"

///|
pub fn Int8Array::as_any(self : Int8Array) -> @nostd.Any = "%identity"

///|
pub(all) struct Int16Array {
  buffer : @js.ArrayBuffer
  byteLength : Int
  byteOffset : Int
  length : Int
}

///|
pub fn Int16Array::as_typed_array(self : Int16Array) -> TypedArray = "%identity"

///|
pub(all) struct Int32Array {
  buffer : @js.ArrayBuffer
  byteLength : Int
  byteOffset : Int
  length : Int
}

///|
pub fn Int32Array::as_typed_array(self : Int32Array) -> TypedArray = "%identity"

// ///|

///|
pub fn Int32Array::as_any(self : Int32Array) -> @nostd.Any = "%identity"

///|
pub(all) struct Float32Array {
  buffer : @js.ArrayBuffer
  byteLength : Int
  byteOffset : Int
  length : Int
}

///|
pub fn Float32Array::as_typed_array(self : Float32Array) -> TypedArray = "%identity"

///|
pub fn Float32Array::as_any(self : Float32Array) -> @nostd.Any = "%identity"

///|
pub(all) struct Float64Array {
  buffer : @js.ArrayBuffer
  byteLength : Int
  byteOffset : Int
  length : Int
}

///|
pub fn Float64Array::as_typed_array(self : Float64Array) -> TypedArray = "%identity"

///|
pub fn Float64Array::as_any(self : Float64Array) -> @nostd.Any = "%identity"

///|
pub(all) struct BigInt64Array {
  buffer : @js.ArrayBuffer
  byteLength : Int
  byteOffset : Int
  length : Int
}

///|
pub fn BigInt64Array::as_typed_array(self : BigInt64Array) -> TypedArray = "%identity"

///|
pub fn BigInt64Array::as_any(self : BigInt64Array) -> @nostd.Any = "%identity"

///|
pub(all) struct BigUint64Array {
  buffer : @js.ArrayBuffer
  byteLength : Int
  byteOffset : Int
  length : Int
}

///|
pub fn BigUint64Array::as_typed_array(self : BigUint64Array) -> TypedArray = "%identity"

///|
pub fn BigUint64Array::as_any(self : BigUint64Array) -> @nostd.Any = "%identity"
