///|
pub(all) struct DataView {
  buffer : @js.ArrayBuffer
  byteLength : Int
  byteOffset : Int
}

///|
pub fn DataView::as_any(self : DataView) -> @core.Any = "%identity"

///|
extern "js" fn ffi_new_dataview(
  buffer : @core.Any,
  byte_offset : Int,
  byte_length : Int?,
) -> @core.Any =
  #| (buf, offset, len) => len !== undefined ? new DataView(buf, offset, len) : new DataView(buf, offset)

///|
pub fn DataView::new(
  buffer : @js.ArrayBuffer,
  byte_offset? : Int = 0,
  byte_length? : Int,
) -> DataView {
  @core.identity(
    ffi_new_dataview(
      buffer.to_any() |> @core.identity,
      byte_offset,
      byte_length,
    ),
  )
}

///|
#alias(getInt8)
pub fn DataView::get_int8(self : DataView, byte_offset : Int) -> Int {
  self.as_any()._call("getInt8", [@core.any(byte_offset)]).cast()
}

///|
#alias(getUint8)
pub fn DataView::get_uint8(self : DataView, byte_offset : Int) -> Int {
  self.as_any()._call("getUint8", [@core.any(byte_offset)]).cast()
}

///|
#alias(getInt16)
pub fn DataView::get_int16(
  self : DataView,
  byte_offset : Int,
  little_endian? : Bool = false,
) -> Int {
  self
  .as_any()
  ._call("getInt16", [@core.any(byte_offset), @core.any(little_endian)])
  .cast()
}

///|
#alias(getUint16)
pub fn DataView::get_uint16(
  self : DataView,
  byte_offset : Int,
  little_endian? : Bool = false,
) -> Int {
  self
  .as_any()
  ._call("getUint16", [@core.any(byte_offset), @core.any(little_endian)])
  .cast()
}

///|
#alias(getInt32)
pub fn DataView::get_int32(
  self : DataView,
  byte_offset : Int,
  little_endian? : Bool = false,
) -> Int {
  self
  .as_any()
  ._call("getInt32", [@core.any(byte_offset), @core.any(little_endian)])
  .cast()
}

///|
#alias(getUint32)
pub fn DataView::get_uint32(
  self : DataView,
  byte_offset : Int,
  little_endian? : Bool = false,
) -> Int {
  self
  .as_any()
  ._call("getUint32", [@core.any(byte_offset), @core.any(little_endian)])
  .cast()
}

///|
#alias(getFloat32)
pub fn DataView::get_float32(
  self : DataView,
  byte_offset : Int,
  little_endian? : Bool = false,
) -> Double {
  self
  .as_any()
  ._call("getFloat32", [@core.any(byte_offset), @core.any(little_endian)])
  .cast()
}

///|
#alias(getFloat64)
pub fn DataView::get_float64(
  self : DataView,
  byte_offset : Int,
  little_endian? : Bool = false,
) -> Double {
  self
  .as_any()
  ._call("getFloat64", [@core.any(byte_offset), @core.any(little_endian)])
  .cast()
}

///|
#alias(setInt8)
pub fn DataView::set_int8(
  self : DataView,
  byte_offset : Int,
  value : Int,
) -> Unit {
  self.as_any()._call("setInt8", [@core.any(byte_offset), @core.any(value)])
  |> ignore
}

///|
#alias(setUint8)
pub fn DataView::set_uint8(
  self : DataView,
  byte_offset : Int,
  value : Int,
) -> Unit {
  self.as_any()._call("setUint8", [@core.any(byte_offset), @core.any(value)])
  |> ignore
}

///|
#alias(setInt16)
pub fn DataView::set_int16(
  self : DataView,
  byte_offset : Int,
  value : Int,
  little_endian? : Bool = false,
) -> Unit {
  self
  .as_any()
  ._call("setInt16", [
    @core.any(byte_offset),
    @core.any(value),
    @core.any(little_endian),
  ])
  |> ignore
}

///|
#alias(setUint16)
pub fn DataView::set_uint16(
  self : DataView,
  byte_offset : Int,
  value : Int,
  little_endian? : Bool = false,
) -> Unit {
  self
  .as_any()
  ._call("setUint16", [
    @core.any(byte_offset),
    @core.any(value),
    @core.any(little_endian),
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
    @core.any(byte_offset),
    @core.any(value),
    @core.any(little_endian),
  ])
  |> ignore
}

///|
#alias(setUint32)
pub fn DataView::set_uint32(
  self : DataView,
  byte_offset : Int,
  value : Int,
  little_endian? : Bool = false,
) -> Unit {
  self
  .as_any()
  ._call("setUint32", [
    @core.any(byte_offset),
    @core.any(value),
    @core.any(little_endian),
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
    @core.any(byte_offset),
    @core.any(value),
    @core.any(little_endian),
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
    @core.any(byte_offset),
    @core.any(value),
    @core.any(little_endian),
  ])
  |> ignore
}
