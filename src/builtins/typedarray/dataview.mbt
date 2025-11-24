///|
pub(all) struct DataView {
  buffer : @js.ArrayBuffer
  byteLength : UInt
  byteOffset : UInt
}

///|
pub impl @js.JsImpl for DataView

///|
extern "js" fn ffi_new_dataview(
  buffer : @js.Any,
  byte_offset : UInt,
  byte_length : UInt?,
) -> @js.Any =
  #| (buf, offset, len) => len !== undefined ? new DataView(buf, offset, len) : new DataView(buf, offset)

///|
pub fn DataView::new(
  buffer : @js.ArrayBuffer,
  byte_offset? : UInt = 0,
  byte_length? : UInt,
) -> DataView {
  @js.identity(ffi_new_dataview(buffer.to_any(), byte_offset, byte_length))
}

///|
#alias(getInt8)
pub fn DataView::get_int8(self : DataView, byte_offset : UInt) -> Int {
  self.call("getInt8", [byte_offset]).cast()
}

///|
#alias(getUint8)
pub fn DataView::get_uint8(self : DataView, byte_offset : UInt) -> UInt {
  self.call1("getUint8", byte_offset).cast()
}

///|
#alias(getInt16)
pub fn DataView::get_int16(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Int {
  self.call2("getInt16", byte_offset, little_endian).cast()
}

///|
#alias(getUint16)
pub fn DataView::get_uint16(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> UInt {
  self.call2("getUint16", byte_offset, little_endian).cast()
}

///|
#alias(getInt32)
pub fn DataView::get_int32(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Int {
  self.call2("getInt32", byte_offset, little_endian).cast()
}

///|
#alias(getUint32)
pub fn DataView::get_uint32(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> UInt {
  self.call2("getUint32", byte_offset, little_endian).cast()
}

///|
#alias(getFloat32)
pub fn DataView::get_float32(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Double {
  self.call2("getFloat32", byte_offset, little_endian).cast()
}

///|
#alias(getFloat64)
pub fn DataView::get_float64(
  self : DataView,
  byte_offset : UInt,
  little_endian? : Bool = false,
) -> Double {
  self.call2("getFloat64", byte_offset, little_endian).cast()
}

///|
#alias(setInt8)
pub fn DataView::set_int8(
  self : DataView,
  byte_offset : UInt,
  value : Int,
) -> Unit {
  self.call2("setInt8", byte_offset, value) |> ignore
}

///|
#alias(setUint8)
pub fn DataView::set_uint8(
  self : DataView,
  byte_offset : UInt,
  value : UInt,
) -> Unit {
  self.call2("setUint8", byte_offset, value) |> ignore
}

///|
#alias(setInt16)
pub fn DataView::set_int16(
  self : DataView,
  byte_offset : UInt,
  value : Int,
  little_endian? : Bool = false,
) -> Unit {
  self.call("setInt16", [byte_offset, value, little_endian]) |> ignore
}

///|
#alias(setUint16)
pub fn DataView::set_uint16(
  self : DataView,
  byte_offset : UInt,
  value : UInt,
  little_endian? : Bool = false,
) -> Unit {
  self.call("setUint16", [byte_offset, value, little_endian]) |> ignore
}

///|
#alias(setInt32)
pub fn DataView::set_int32(
  self : DataView,
  byte_offset : UInt,
  value : Int,
  little_endian? : Bool = false,
) -> Unit {
  self.call("setInt32", [byte_offset, value, little_endian]) |> ignore
}

///|
#alias(setUint32)
pub fn DataView::set_uint32(
  self : DataView,
  byte_offset : UInt,
  value : UInt,
  little_endian? : Bool = false,
) -> Unit {
  self.call("setUint32", [byte_offset, value, little_endian]) |> ignore
}

///|
#alias(setFloat32)
pub fn DataView::set_float32(
  self : DataView,
  byte_offset : UInt,
  value : Double,
  little_endian? : Bool = false,
) -> Unit {
  self.call("setFloat32", [byte_offset, value, little_endian]) |> ignore
}

///|
#alias(setFloat64)
pub fn DataView::set_float64(
  self : DataView,
  byte_offset : UInt,
  value : Double,
  little_endian? : Bool = false,
) -> Unit {
  self.call("setFloat64", [byte_offset, value, little_endian]) |> ignore
}
