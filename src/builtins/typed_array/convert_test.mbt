///| Conversion tests

///|
test "bytes_to_uint8array - basic conversion" {
  let bytes = Bytes::from_array([1, 2, 3, 4, 5])
  let uint8array = bytes_to_uint8array(bytes)
  assert_eq(uint8array.length(), 5)
  assert_eq(uint8array.get_at(0), 1)
  assert_eq(uint8array.get_at(4), 5)
}

///|
test "uint8array_to_bytes - basic conversion" {
  let uint8array = Uint8Array::from_array([10, 20, 30, 40, 50])
  let bytes = uint8array_to_bytes(uint8array)
  assert_eq(bytes.length(), 5)
  assert_eq(bytes[0], 10)
  assert_eq(bytes[4], 50)
}

///|
test "Uint8Array::from_bytes - static method" {
  let bytes = Bytes::from_array([100, 101, 102])
  let uint8array = Uint8Array::from_bytes(bytes)
  assert_eq(uint8array.length(), 3)
  assert_eq(uint8array.get_at(0), 100)
  assert_eq(uint8array.get_at(2), 102)
}

///|
test "Uint8Array::to_bytes - instance method" {
  let uint8array = Uint8Array::from_array([200, 201, 202])
  let bytes = uint8array.to_bytes()
  assert_eq(bytes.length(), 3)
  assert_eq(bytes[0], 200)
  assert_eq(bytes[2], 202)
}

///|
test "round-trip conversion - Bytes -> Uint8Array -> Bytes" {
  let original = Bytes::from_array([1, 2, 3, 4, 5, 6, 7, 8])
  let uint8array = bytes_to_uint8array(original)
  let result = uint8array_to_bytes(uint8array)
  assert_eq(result.length(), original.length())
  for i = 0; i < original.length(); i = i + 1 {
    assert_eq(result[i], original[i])
  }
}

///|
test "round-trip conversion - Uint8Array -> Bytes -> Uint8Array" {
  let original = Uint8Array::from_array([10, 20, 30, 40, 50, 60])
  let bytes = uint8array_to_bytes(original)
  let result = bytes_to_uint8array(bytes)
  assert_eq(result.length(), original.length())
  let len = original.length().reinterpret_as_int()
  for i = 0; i < len; i = i + 1 {
    assert_eq(
      result.get_at(i.reinterpret_as_uint()),
      original.get_at(i.reinterpret_as_uint()),
    )
  }
}

///|
test "empty Bytes to Uint8Array" {
  let bytes = Bytes::from_array([])
  let uint8array = bytes_to_uint8array(bytes)
  assert_eq(uint8array.length(), 0)
}

///|
test "empty Uint8Array to Bytes" {
  let uint8array = Uint8Array::from_array([])
  let bytes = uint8array_to_bytes(uint8array)
  assert_eq(bytes.length(), 0)
}

///|
test "modifications are shared - Bytes and Uint8Array share memory" {
  let bytes = Bytes::from_array([1, 2, 3])
  let uint8array = bytes_to_uint8array(bytes)

  // Modify via Uint8Array
  uint8array.set_at(1, 99)

  // Change should be visible in original Bytes
  assert_eq(bytes[1], 99)
  assert_eq(uint8array.get_at(1), 99)
}
