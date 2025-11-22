///| ArrayBuffer tests

///|
test "ArrayBuffer creation and properties" {
  let buffer = ArrayBuffer::new(16)
  assert_eq(buffer.byte_length(), 16)

  let zero_buffer = ArrayBuffer::new(0)
  assert_eq(zero_buffer.byte_length(), 0)
}

///|
test "ArrayBuffer::slice operations" {
  let buffer = ArrayBuffer::new(16)

  // Basic slice
  let sliced = buffer.slice(begin=4, end=12)
  assert_eq(sliced.byte_length(), 8)

  // Full slice
  let full = buffer.slice(begin=0, end=16)
  assert_eq(full.byte_length(), 16)

  // Without end parameter
  let from_middle = buffer.slice(begin=8)
  assert_eq(from_middle.byte_length(), 8)

  // Negative indices
  let negative = buffer.slice(begin=-8, end=-4)
  assert_eq(negative.byte_length(), 4)
}

///|
test "ArrayBuffer::is_view" {
  let buffer = ArrayBuffer::new(16)

  // Plain buffer is not a view
  assert_false(ArrayBuffer::is_view(buffer.to_js()))

  // Note: Testing with actual views requires typed_array package
  // which would create circular dependency.
  // The is_view implementation is tested in typed_array tests.
}

///| SharedArrayBuffer tests

///|
test "SharedArrayBuffer creation and properties" {
  let buffer = SharedArrayBuffer::new(16)
  assert_eq(buffer.byte_length(), 16)
}

///|
test "SharedArrayBuffer::slice operations" {
  let buffer = SharedArrayBuffer::new(16)

  // Basic slice
  let sliced = buffer.slice(begin=4, end=12)
  assert_eq(sliced.byte_length(), 8)

  // Without end parameter
  let from_middle = buffer.slice(begin=8)
  assert_eq(from_middle.byte_length(), 8)
}
