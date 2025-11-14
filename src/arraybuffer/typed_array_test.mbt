///|
test "Uint8Array::from_size - create array" {
  let arr = Uint8Array::from_size(10)
  assert_eq(arr.length(), 10)
  assert_eq(arr.byte_length(), 10)
}

///|
test "Uint8Array::from_array - create from array" {
  let arr = Uint8Array::from_array([1, 2, 3, 4, 5])
  assert_eq(arr.length(), 5)
  assert_eq(arr.get_at(0), 1)
  assert_eq(arr.get_at(4), 5)
}

///|
test "Uint8Array::from_array_buffer - basic" {
  let buffer = ArrayBuffer::new(16)
  let arr = Uint8Array::from_array_buffer(buffer)
  assert_eq(arr.length(), 16)
  assert_eq(arr.byte_length(), 16)
  assert_eq(arr.byte_offset(), 0)
}

///|
test "Uint8Array::from_array_buffer - with offset" {
  let buffer = ArrayBuffer::new(16)
  let arr = Uint8Array::from_array_buffer(buffer, byte_offset=4)
  assert_eq(arr.length(), 12)
  assert_eq(arr.byte_offset(), 4)
}

///|
test "Uint8Array::from_array_buffer - with offset and length" {
  let buffer = ArrayBuffer::new(16)
  let arr = Uint8Array::from_array_buffer(buffer, byte_offset=4, length=8)
  assert_eq(arr.length(), 8)
  assert_eq(arr.byte_offset(), 4)
}

///|
test "Uint8Array::buffer - get underlying buffer" {
  let arr = Uint8Array::from_size(10)
  let buffer = arr.buffer()
  assert_eq(buffer.byte_length(), 10)
}

///|
test "Uint8Array - get and set operations" {
  let arr = Uint8Array::from_size(5)
  arr.set_at(0, 10)
  arr.set_at(1, 20)
  arr.set_at(2, 30)
  assert_eq(arr.get_at(0), 10)
  assert_eq(arr.get_at(1), 20)
  assert_eq(arr.get_at(2), 30)
}

///|
test "Uint8Array::set - copy from array" {
  let arr = Uint8Array::from_size(10)
  arr.set([1, 2, 3, 4, 5], offset=0)
  assert_eq(arr.get_at(0), 1)
  assert_eq(arr.get_at(4), 5)
}

///|
test "Uint8Array::set - with offset" {
  let arr = Uint8Array::from_size(10)
  arr.set([1, 2, 3], offset=5)
  assert_eq(arr.get_at(5), 1)
  assert_eq(arr.get_at(7), 3)
}

///|
test "Uint8Array::slice - basic slice" {
  let arr = Uint8Array::from_array([0, 1, 2, 3, 4, 5])
  let sliced = arr.slice(start=2, end=5)
  assert_eq(sliced.length(), 3)
  assert_eq(sliced.get_at(0), 2)
  assert_eq(sliced.get_at(2), 4)
}

///|
test "Uint8Array::slice - without end" {
  let arr = Uint8Array::from_array([0, 1, 2, 3, 4, 5])
  let sliced = arr.slice(start=3)
  assert_eq(sliced.length(), 3)
  assert_eq(sliced.get_at(0), 3)
}

///|
test "Uint8Array::slice - negative indices" {
  let arr = Uint8Array::from_array([0, 1, 2, 3, 4, 5])
  let sliced = arr.slice(start=-3, end=-1)
  assert_eq(sliced.length(), 2)
  assert_eq(sliced.get_at(0), 3)
}

///|
test "Uint8Array::subarray - basic subarray" {
  let arr = Uint8Array::from_array([0, 1, 2, 3, 4, 5])
  let sub = arr.subarray(begin=2, end=5)
  assert_eq(sub.length(), 3)
  assert_eq(sub.get_at(0), 2)
}

///|
test "Uint8Array::fill - fill with value" {
  let arr = Uint8Array::from_size(5)
  arr.fill(42) |> ignore
  assert_eq(arr.get_at(0), 42)
  assert_eq(arr.get_at(4), 42)
}

///|
test "Uint8Array::fill - fill with start and end" {
  let arr = Uint8Array::from_size(10)
  arr.fill(99, start=3, end=7) |> ignore
  assert_eq(arr.get_at(2), 0)
  assert_eq(arr.get_at(3), 99)
  assert_eq(arr.get_at(6), 99)
  assert_eq(arr.get_at(7), 0)
}

///|
test "Uint8Array::copy_within - basic copy" {
  let arr = Uint8Array::from_array([1, 2, 3, 4, 5])
  arr.copy_within(0, 3) |> ignore
  assert_eq(arr.get_at(0), 4)
  assert_eq(arr.get_at(1), 5)
}

///|
test "Uint8Array::reverse - reverse array" {
  let arr = Uint8Array::from_array([1, 2, 3, 4, 5])
  arr.reverse() |> ignore
  assert_eq(arr.get_at(0), 5)
  assert_eq(arr.get_at(4), 1)
}

///|
test "Uint8Array::sort - sort array" {
  let arr = Uint8Array::from_array([5, 2, 8, 1, 9])
  arr.sort() |> ignore
  assert_eq(arr.get_at(0), 1)
  assert_eq(arr.get_at(4), 9)
}

///|
test "Uint8Array::index_of - find element" {
  let arr = Uint8Array::from_array([10, 20, 30, 40, 50])
  assert_eq(arr.index_of(30), 2)
  assert_eq(arr.index_of(99), -1)
}

///|
test "Uint8Array::index_of - with from_index" {
  let arr = Uint8Array::from_array([10, 20, 30, 20, 50])
  assert_eq(arr.index_of(20, from_index=2), 3)
}

///|
test "Uint8Array::last_index_of - find last occurrence" {
  let arr = Uint8Array::from_array([10, 20, 30, 20, 50])
  assert_eq(arr.last_index_of(20), 3)
}

///|
test "Uint8Array::includes - check if element exists" {
  let arr = Uint8Array::from_array([10, 20, 30, 40, 50])
  assert_true(arr.includes(30))
  assert_false(arr.includes(99))
}

///|
test "Uint8Array::join - join to string" {
  let arr = Uint8Array::from_array([1, 2, 3, 4, 5])
  let str = arr.join(separator=",")
  assert_eq(str, "1,2,3,4,5")
}

///|
test "Uint8Array::join - with custom separator" {
  let arr = Uint8Array::from_array([1, 2, 3])
  let str = arr.join(separator="-")
  assert_eq(str, "1-2-3")
}

///|
test "Uint8Array::to_string - convert to string" {
  let arr = Uint8Array::from_array([1, 2, 3])
  let str = arr.to_string()
  assert_eq(str, "1,2,3")
}

///|
test "Uint16Array::from_size - create array" {
  let arr = Uint16Array::from_size(10)
  assert_eq(arr.length(), 10)
  assert_eq(arr.byte_length(), 20)
}

///|
test "Uint16Array::from_array - create from array" {
  let arr = Uint16Array::from_array([1000, 2000, 3000])
  assert_eq(arr.length(), 3)
  assert_eq(arr.get_at(0), 1000)
  assert_eq(arr.get_at(2), 3000)
}

///|
test "Uint16Array::from_array_buffer - basic" {
  let buffer = ArrayBuffer::new(16)
  let arr = Uint16Array::from_array_buffer(buffer)
  assert_eq(arr.length(), 8)
  assert_eq(arr.byte_length(), 16)
}

///|
test "Uint16Array - get and set operations" {
  let arr = Uint16Array::from_size(5)
  arr.set_at(0, 65535)
  arr.set_at(1, 32768)
  assert_eq(arr.get_at(0), 65535)
  assert_eq(arr.get_at(1), 32768)
}

///|
test "Uint32Array::from_size - create array" {
  let arr = Uint32Array::from_size(10)
  assert_eq(arr.length(), 10)
  assert_eq(arr.byte_length(), 40)
}

///|
test "Uint32Array::from_array - create from array" {
  let arr = Uint32Array::from_array([100000, 200000, 300000])
  assert_eq(arr.length(), 3)
  assert_eq(arr.get_at(0), 100000)
}

///|
test "Uint32Array - get and set operations" {
  let arr = Uint32Array::from_size(5)
  let val1 : UInt = 100000000
  let val2 : UInt = 200000000
  arr.set_at(0, val1)
  arr.set_at(1, val2)
  assert_eq(arr.get_at(0).to_int(), val1.to_int())
  assert_eq(arr.get_at(1).to_int(), val2.to_int())
}

///|
test "Int8Array::from_size - create array" {
  let arr = Int8Array::from_size(10)
  assert_eq(arr.length(), 10)
  assert_eq(arr.byte_length(), 10)
}

///|
test "Int8Array::from_array - create from array" {
  let arr = Int8Array::from_array([-128, -1, 0, 1, 127])
  assert_eq(arr.length(), 5)
  assert_eq(arr.get_at(0), -128)
  assert_eq(arr.get_at(4), 127)
}

///|
test "Int8Array - get and set operations" {
  let arr = Int8Array::from_size(5)
  arr.set_at(0, 127)
  arr.set_at(1, -128)
  arr.set_at(2, 0)
  assert_eq(arr.get_at(0), 127)
  assert_eq(arr.get_at(1), -128)
  assert_eq(arr.get_at(2), 0)
}

///|
test "Int16Array::from_size - create array" {
  let arr = Int16Array::from_size(10)
  assert_eq(arr.length(), 10)
  assert_eq(arr.byte_length(), 20)
}

///|
test "Int16Array::from_array - create from array" {
  let arr = Int16Array::from_array([-32768, 0, 32767])
  assert_eq(arr.length(), 3)
  assert_eq(arr.get_at(0), -32768)
  assert_eq(arr.get_at(2), 32767)
}

///|
test "Int32Array::from_size - create array" {
  let arr = Int32Array::from_size(10)
  assert_eq(arr.length(), 10)
  assert_eq(arr.byte_length(), 40)
}

///|
test "Int32Array::from_array - create from array" {
  let arr = Int32Array::from_array([-2147483648, 0, 2147483647])
  assert_eq(arr.length(), 3)
  assert_eq(arr.get_at(0), -2147483648)
  assert_eq(arr.get_at(2), 2147483647)
}

///|
test "Float32Array::from_size - create array" {
  let arr = Float32Array::from_size(10)
  assert_eq(arr.length(), 10)
  assert_eq(arr.byte_length(), 40)
}

///|
test "Float32Array::from_array - create from array" {
  let arr = Float32Array::from_array([1.5, 2.5, 3.5])
  assert_eq(arr.length(), 3)
  let v0 = arr.get_at(0)
  assert_true(v0 > 1.4 && v0 < 1.6)
}

///|
test "Float32Array - get and set operations" {
  let arr = Float32Array::from_size(5)
  arr.set_at(0, 3.14159)
  arr.set_at(1, -2.71828)
  let v0 = arr.get_at(0)
  let v1 = arr.get_at(1)
  assert_true(v0 > 3.14 && v0 < 3.15)
  assert_true(v1 > -2.72 && v1 < -2.71)
}

///|
test "Float64Array::from_size - create array" {
  let arr = Float64Array::from_size(10)
  assert_eq(arr.length(), 10)
  assert_eq(arr.byte_length(), 80)
}

///|
test "Float64Array::from_array - create from array" {
  let arr = Float64Array::from_array([1.23456789, 2.34567890, 3.45678901])
  assert_eq(arr.length(), 3)
  let v0 = arr.get_at(0)
  assert_true(v0 > 1.23 && v0 < 1.24)
}

///|
test "Float64Array - get and set operations" {
  let arr = Float64Array::from_size(5)
  arr.set_at(0, 3.141592653589793)
  arr.set_at(1, -2.718281828459045)
  let v0 = arr.get_at(0)
  let v1 = arr.get_at(1)
  assert_true(v0 > 3.14 && v0 < 3.15)
  assert_true(v1 > -2.72 && v1 < -2.71)
}

///|
test "TypedArray - shared buffer" {
  let buffer = ArrayBuffer::new(16)
  let u8 = Uint8Array::from_array_buffer(buffer)
  let u16 = Uint16Array::from_array_buffer(buffer)
  u8.set_at(0, 255)
  u8.set_at(1, 0)
  assert_eq(u16.get_at(0), 255)
}

///|
test "TypedArray - byte offset alignment" {
  let buffer = ArrayBuffer::new(16)
  let arr1 = Uint8Array::from_array_buffer(buffer, byte_offset=0, length=4)
  let arr2 = Uint8Array::from_array_buffer(buffer, byte_offset=4, length=4)
  arr1.set_at(0, 1)
  arr2.set_at(0, 2)
  assert_eq(arr1.get_at(0), 1)
  assert_eq(arr2.get_at(0), 2)
}
