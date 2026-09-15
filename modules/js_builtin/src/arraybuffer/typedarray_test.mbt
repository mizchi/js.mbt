///|
test "Uint8Array::from_size - create array" {
  let arr = Uint8Array::from_size(10).as_typed_array()
  assert_eq(arr.length(), 10)
  assert_eq(arr.byteLength(), 10)
}

///|
test "Uint8Array::from_array - create from array" {
  let arr = Uint8Array::from_array([1, 2, 3, 4, 5]).as_typed_array()
  assert_eq(arr.length(), 5)
  assert_eq(arr.get_at(0), 1)
  assert_eq(arr.get_at(4), 5)
}

///|
test "Uint8Array::from_array_buffer - basic" {
  let buffer = @arraybuffer.ArrayBuffer::new(16)
  let arr = Uint8Array::from_array_buffer(buffer).as_typed_array()
  assert_eq(arr.length(), 16)
  assert_eq(arr.byteLength(), 16)
  assert_eq(arr.byteOffset(), 0)
}

///|
test "Uint8Array::from_array_buffer - with offset" {
  let buffer = @arraybuffer.ArrayBuffer::new(16)
  let arr = Uint8Array::from_array_buffer(buffer, byte_offset=4).as_typed_array()
  assert_eq(arr.length(), 12)
  assert_eq(arr.byteOffset(), 4)
}

///|
test "Uint8Array::from_array_buffer - with offset and length" {
  let buffer = @arraybuffer.ArrayBuffer::new(16)
  let arr = Uint8Array::from_array_buffer(buffer, byte_offset=4, length=8).as_typed_array()
  assert_eq(arr.length(), 8)
  assert_eq(arr.byteOffset(), 4)
}

///|
test "Uint8Array::buffer - get underlying buffer" {
  let arr = Uint8Array::from_size(10)
  let buffer = arr.buffer
  assert_eq(buffer.byteLength, 10)
}

///|
test "Uint8Array - get and set operations" {
  let arr = Uint8Array::from_size(5).as_typed_array()
  arr.set_at(0, 10)
  arr.set_at(1, 20)
  arr.set_at(2, 30)
  assert_eq(arr.get_at(0), 10)
  assert_eq(arr.get_at(1), 20)
  assert_eq(arr.get_at(2), 30)
}

///|
test "Uint8Array::set - copy from array" {
  let arr = Uint8Array::from_size(10).as_typed_array()
  arr.set([1, 2, 3, 4, 5], offset=0)
  assert_eq(arr.get_at(0), 1)
  assert_eq(arr.get_at(4), 5)
}

///|
test "Uint8Array::set - with offset" {
  let arr = Uint8Array::from_size(10).as_typed_array()
  arr.set([1, 2, 3], offset=5)
  assert_eq(arr.get_at(5), 1)
  assert_eq(arr.get_at(7), 3)
}

///|
test "Uint8Array::slice - basic slice" {
  let arr = Uint8Array::from_array([0, 1, 2, 3, 4, 5]).as_typed_array()
  let sliced = arr.slice(start=2, end=5)
  assert_eq(sliced.length(), 3)
  assert_eq(sliced.get_at(0), 2)
  assert_eq(sliced.get_at(2), 4)
}

///|
test "Uint8Array::slice - without end" {
  let arr = Uint8Array::from_array([0, 1, 2, 3, 4, 5]).as_typed_array()
  let sliced = arr.slice(start=3)
  assert_eq(sliced.length(), 3)
  assert_eq(sliced.get_at(0), 3)
}

///|
test "Uint8Array::slice - negative indices" {
  let arr = Uint8Array::from_array([0, 1, 2, 3, 4, 5]).as_typed_array()
  let sliced = arr.slice(start=-3, end=-1)
  assert_eq(sliced.length(), 2)
  assert_eq(sliced.get_at(0), 3)
}

///|
test "Uint8Array::subarray - basic subarray" {
  let arr = Uint8Array::from_array([0, 1, 2, 3, 4, 5]).as_typed_array()
  let sub = arr.subarray(begin=2, end=5)
  assert_eq(sub.length(), 3)
  assert_eq(sub.get_at(0), 2)
}

///|
test "Uint8Array::fill - fill with value" {
  let arr = Uint8Array::from_size(5).as_typed_array()
  arr.fill(42) |> ignore
  assert_eq(arr.get_at(0), 42)
  assert_eq(arr.get_at(4), 42)
}

///|
test "Uint8Array::fill - fill with start and end" {
  let arr = Uint8Array::from_size(10).as_typed_array()
  arr.fill(99, start=3, end=7) |> ignore
  assert_eq(arr.get_at(2), 0)
  assert_eq(arr.get_at(3), 99)
  assert_eq(arr.get_at(6), 99)
  assert_eq(arr.get_at(7), 0)
}

///|
test "Uint8Array::copy_within - basic copy" {
  let arr = Uint8Array::from_array([1, 2, 3, 4, 5]).as_typed_array()
  arr.copyWithin(0, 3) |> ignore
  assert_eq(arr.get_at(0), 4)
  assert_eq(arr.get_at(1), 5)
}

///|
test "Uint8Array::reverse - reverse array" {
  let arr = Uint8Array::from_array([1, 2, 3, 4, 5]).as_typed_array()
  arr.reverse() |> ignore
  assert_eq(arr.get_at(0), 5)
  assert_eq(arr.get_at(4), 1)
}

///|
test "Uint8Array::sort - sort array" {
  let arr = Uint8Array::from_array([5, 2, 8, 1, 9]).as_typed_array()
  arr.sort() |> ignore
  assert_eq(arr.get_at(0), 1)
  assert_eq(arr.get_at(4), 9)
}

///|
test "Uint8Array::index_of - find element" {
  let arr = Uint8Array::from_array([10, 20, 30, 40, 50]).as_typed_array()
  assert_eq(arr.indexOf(30), 2)
  assert_eq(arr.indexOf(99), -1)
}

///|
test "Uint8Array::index_of - with from_index" {
  let arr = Uint8Array::from_array([10, 20, 30, 20, 50]).as_typed_array()
  assert_eq(arr.indexOf(20, from_index=2), 3)
}

///|
#skip("FIXME")
test "Uint8Array::last_index_of - find last occurrence" {
  let arr = Uint8Array::from_array([10, 20, 30, 20, 50]).as_typed_array()
  assert_eq(arr.lastIndexOf(20), 3)
}

///|
test "Uint8Array::includes - check if element exists" {
  let arr = Uint8Array::from_array([10, 20, 30, 40, 50]).as_typed_array()
  assert_true(arr.includes(30))
  assert_false(arr.includes(99))
}

///|
test "Uint8Array::join - join to string" {
  let arr = Uint8Array::from_array([1, 2, 3, 4, 5]).as_typed_array()
  let str = arr.join(separator=",")
  assert_eq(str, "1,2,3,4,5")
}

///|
test "Uint8Array::join - with custom separator" {
  let arr = Uint8Array::from_array([1, 2, 3]).as_typed_array()
  let str = arr.join(separator="-")
  assert_eq(str, "1-2-3")
}

///|
test "Uint8Array::to_string - convert to string" {
  let arr = Uint8Array::from_array([1, 2, 3]).as_typed_array()
  let str = arr.toString()
  assert_eq(str, "1,2,3")
}
