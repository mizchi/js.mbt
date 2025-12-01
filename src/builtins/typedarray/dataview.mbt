///|
pub(all) struct DataView {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
}

///|
pub fn DataView::as_any(self : DataView) -> @nostd.Any = "%identity"

///|
extern "js" fn ffi_new_dataview(
  buffer : @nostd.Any,
  byte_offset : UInt,
  byte_length : UInt?,
) -> @nostd.Any =
  #| (buf, offset, len) => len !== undefined ? new DataView(buf, offset, len) : new DataView(buf, offset)

///|
pub fn DataView::new(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  byte_length? : UInt,
) -> DataView {
  @js.identity(ffi_new_dataview(buffer.to_any() |> @js.identity, byte_offset, byte_length))
}

///|
#alias(getInt8)
pub fn DataView::get_int8(self : DataView, byte_offset : UInt) -> Int {
  self.as_any()._call("getInt8", [@nostd.any(byte_offset)]).cast()
}

///|
#alias(getUint8)
pub fn DataView::get_uint8(self : DataView, byte_offset : UInt) -> UInt {
  self.as_any()._call("getUint8", [@nostd.any(byte_offset)]).cast()
}

///|
#alias(getInt16)
pub fn DataView::get_int16(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Int {
  self
  .as_any()
  ._call("getInt16", [@nostd.any(byte_offset), @nostd.any(little_endian)])
  .cast()
}

///|
#alias(getUint16)
pub fn DataView::get_uint16(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> UInt {
  self
  .as_any()
  ._call("getUint16", [@nostd.any(byte_offset), @nostd.any(little_endian)])
  .cast()
}

///|
#alias(getInt32)
pub fn DataView::get_int32(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Int {
  self
  .as_any()
  ._call("getInt32", [@nostd.any(byte_offset), @nostd.any(little_endian)])
  .cast()
}

///|
#alias(getUint32)
pub fn DataView::get_uint32(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> UInt {
  self
  .as_any()
  ._call("getUint32", [@nostd.any(byte_offset), @nostd.any(little_endian)])
  .cast()
}

///|
#alias(getFloat32)
pub fn DataView::get_float32(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Double {
  self
  .as_any()
  ._call("getFloat32", [@nostd.any(byte_offset), @nostd.any(little_endian)])
  .cast()
}

///|
#alias(getFloat64)
pub fn DataView::get_float64(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Double {
  self
  .as_any()
  ._call("getFloat64", [@nostd.any(byte_offset), @nostd.any(little_endian)])
  .cast()
}

///|
#alias(setInt8)
pub fn DataView::set_int8(
  self : DataView,
  byte_offset : UInt,
  value : Int,
) -> Unit {
  self.as_any()._call("setInt8", [@nostd.any(byte_offset), @nostd.any(value)])
  |> ignore
}

///|
#alias(setUint8)
pub fn DataView::set_uint8(
  self : DataView,
  byte_offset : UInt,
  value : UInt,
) -> Unit {
  self.as_any()._call("setUint8", [@nostd.any(byte_offset), @nostd.any(value)])
  |> ignore
}

///|
#alias(setInt16)
pub fn DataView::set_int16(
  self : DataView,
  byte_offset : UInt,
  value : Int,
  little_endian? : Bool = false,
) -> Unit {
  self
  .as_any()
  ._call("setInt16", [
    @nostd.any(byte_offset),
    @nostd.any(value),
    @nostd.any(little_endian),
  ])
  |> ignore
}

///|
#alias(setUint16)
pub fn DataView::set_uint16(
  self : DataView,
  byte_offset : UInt,
  value : UInt,
  little_endian? : Bool = false,
) -> Unit {
  self
  .as_any()
  ._call("setUint16", [
    @nostd.any(byte_offset),
    @nostd.any(value),
    @nostd.any(little_endian),
  ])
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
  self
  .as_any()
  ._call("setInt32", [
    @nostd.any(byte_offset),
    @nostd.any(value),
    @nostd.any(little_endian),
  ])
  |> ignore
}

///|
#alias(setUint32)
pub fn DataView::set_uint32(
  self : DataView,
  byte_offset : UInt,
  value : UInt,
  little_endian? : Bool = false,
) -> Unit {
  self
  .as_any()
  ._call("setUint32", [
    @nostd.any(byte_offset),
    @nostd.any(value),
    @nostd.any(little_endian),
  ])
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
  self
  .as_any()
  ._call("setFloat32", [
    @nostd.any(byte_offset),
    @nostd.any(value),
    @nostd.any(little_endian),
  ])
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
  self
  .as_any()
  ._call("setFloat64", [
    @nostd.any(byte_offset),
    @nostd.any(value),
    @nostd.any(little_endian),
  ])
  |> ignore
}
