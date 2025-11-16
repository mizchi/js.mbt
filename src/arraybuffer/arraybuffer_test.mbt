///|
test "ArrayBuffer::new - create with byte length" {
  let buffer = ArrayBuffer::new(16)
  assert_eq(buffer.byte_length(), 16)
}

///|
test "ArrayBuffer::new - zero length" {
  let buffer = ArrayBuffer::new(0)
  assert_eq(buffer.byte_length(), 0)
}

///|
test "ArrayBuffer::slice - basic slice" {
  let buffer = ArrayBuffer::new(16)
  let sliced = buffer.slice(begin=4, end=12)
  assert_eq(sliced.byte_length(), 8)
}

///|
test "ArrayBuffer::slice - from start to end" {
  let buffer = ArrayBuffer::new(16)
  let sliced = buffer.slice(begin=0, end=16)
  assert_eq(sliced.byte_length(), 16)
}

///|
test "ArrayBuffer::slice - without end parameter" {
  let buffer = ArrayBuffer::new(16)
  let sliced = buffer.slice(begin=8)
  assert_eq(sliced.byte_length(), 8)
}

///|
test "ArrayBuffer::slice - negative indices" {
  let buffer = ArrayBuffer::new(16)
  let sliced = buffer.slice(begin=-8, end=-4)
  assert_eq(sliced.byte_length(), 4)
}

///|
test "ArrayBuffer::is_view - with DataView" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  assert_true(ArrayBuffer::is_view(view.to_js()))
}

///|
test "ArrayBuffer::is_view - with Uint8Array" {
  let arr = Uint8Array::from_size(10)
  assert_true(ArrayBuffer::is_view(arr.to_js()))
}

///|
test "ArrayBuffer::is_view - with plain buffer" {
  let buffer = ArrayBuffer::new(16)
  assert_false(ArrayBuffer::is_view(buffer.to_js()))
}

///|
test "SharedArrayBuffer::new - create with byte length" {
  let buffer = SharedArrayBuffer::new(16)
  assert_eq(buffer.byte_length(), 16)
}

///|
test "SharedArrayBuffer::slice - basic slice" {
  let buffer = SharedArrayBuffer::new(16)
  let sliced = buffer.slice(begin=4, end=12)
  assert_eq(sliced.byte_length(), 8)
}

///|
test "DataView::new - basic creation" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  assert_eq(view.byte_length(), 16)
  assert_eq(view.byte_offset(), 0)
}

///|
test "DataView::new - with byte offset" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer, byte_offset=4)
  assert_eq(view.byte_length(), 12)
  assert_eq(view.byte_offset(), 4)
}

///|
test "DataView::new - with byte offset and length" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer, byte_offset=4, byte_length=8)
  assert_eq(view.byte_length(), 8)
  assert_eq(view.byte_offset(), 4)
}

///|
test "DataView::buffer - get underlying buffer" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  let retrieved = view.buffer()
  assert_eq(retrieved.byte_length(), 16)
}

///|
test "DataView - Int8 operations" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  view.set_int8(0, 42)
  view.set_int8(1, -42)
  assert_eq(view.get_int8(0), 42)
  assert_eq(view.get_int8(1), -42)
}

///|
test "DataView - Uint8 operations" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  view.set_uint8(0, 255)
  view.set_uint8(1, 0)
  assert_eq(view.get_uint8(0), 255)
  assert_eq(view.get_uint8(1), 0)
}

///|
test "DataView - Int16 operations little endian" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  view.set_int16(0, 32767, little_endian=true)
  view.set_int16(2, -32768, little_endian=true)
  assert_eq(view.get_int16(0, little_endian=true), 32767)
  assert_eq(view.get_int16(2, little_endian=true), -32768)
}

///|
test "DataView - Int16 operations big endian" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  view.set_int16(0, 12345, little_endian=false)
  assert_eq(view.get_int16(0, little_endian=false), 12345)
}

///|
test "DataView - Uint16 operations" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  view.set_uint16(0, 65535, little_endian=true)
  assert_eq(view.get_uint16(0, little_endian=true), 65535)
}

///|
test "DataView - Int32 operations" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  view.set_int32(0, 2147483647, little_endian=true)
  view.set_int32(4, -2147483648, little_endian=true)
  assert_eq(view.get_int32(0, little_endian=true), 2147483647)
  assert_eq(view.get_int32(4, little_endian=true), -2147483648)
}

///|
test "DataView - Uint32 operations" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  let val : UInt = 100000000
  view.set_uint32(0, val, little_endian=true)
  assert_eq(view.get_uint32(0, little_endian=true).to_int(), val.to_int())
}

///|
test "DataView - Float32 operations" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  view.set_float32(0, 3.14, little_endian=true)
  let result = view.get_float32(0, little_endian=true)
  assert_true(result > 3.13 && result < 3.15)
}

///|
test "DataView - Float64 operations" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  view.set_float64(0, 3.141592653589793, little_endian=true)
  let result = view.get_float64(0, little_endian=true)
  assert_true(result > 3.14 && result < 3.15)
}

///|
test "DataView - mixed data types" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  view.set_uint8(0, 255)
  view.set_int16(1, -1000, little_endian=true)
  view.set_uint32(3, 123456, little_endian=true)
  view.set_float32(7, 2.5, little_endian=true)
  assert_eq(view.get_uint8(0), 255)
  assert_eq(view.get_int16(1, little_endian=true), -1000)
  assert_eq(view.get_uint32(3, little_endian=true), 123456)
  let f = view.get_float32(7, little_endian=true)
  assert_true(f > 2.4 && f < 2.6)
}

///|
test "DataView - endianness difference" {
  let buffer = ArrayBuffer::new(16)
  let view = DataView::new(buffer)
  view.set_uint16(0, 256, little_endian=true)
  let little = view.get_uint16(0, little_endian=true)
  let big = view.get_uint16(0, little_endian=false)
  assert_eq(little, 256)
  assert_eq(big, 1)
}

///|
test "SharedArrayBuffer::slice - without end parameter" {
  let buffer = SharedArrayBuffer::new(16)
  let sliced = buffer.slice(begin=8)
  assert_eq(sliced.byte_length(), 8)
}

///|
test "Uint8Array::subarray - without end parameter" {
  let arr = Uint8Array::from_size(10)
  let sub = arr.subarray(begin=5)
  assert_eq(sub.length(), 5)
}

///|
test "Uint8Array::copy_within - with end parameter" {
  let arr = Uint8Array::from_array([1, 2, 3, 4, 5])
  arr.copy_within(0, 3, end=5) |> ignore
  assert_eq(arr.get_at(0), 4)
  assert_eq(arr.get_at(1), 5)
}

///|
test "Uint8Array::last_index_of - with from_index parameter" {
  let arr = Uint8Array::from_array([1, 2, 3, 2, 1])
  let idx = arr.last_index_of(2, from_index=3)
  assert_eq(idx, 3)
}

///|
test "Uint16Array::byte_offset - basic test" {
  let buffer = ArrayBuffer::new(16)
  let arr = Uint16Array::from_array_buffer(buffer, byte_offset=4)
  assert_eq(arr.byte_offset(), 4)
}

///|
test "Uint16Array::buffer - get underlying buffer" {
  let buffer = ArrayBuffer::new(16)
  let arr = Uint16Array::from_array_buffer(buffer)
  let retrieved = arr.buffer()
  assert_eq(retrieved.byte_length(), 16)
}

///|
test "Uint32Array::from_array_buffer - with length parameter" {
  let buffer = ArrayBuffer::new(16)
  let arr = Uint32Array::from_array_buffer(buffer, byte_offset=0, length=2)
  assert_eq(arr.length(), 2)
}

///|
test "Uint32Array::byte_offset - basic test" {
  let buffer = ArrayBuffer::new(16)
  let arr = Uint32Array::from_array_buffer(buffer, byte_offset=4)
  assert_eq(arr.byte_offset(), 4)
}
