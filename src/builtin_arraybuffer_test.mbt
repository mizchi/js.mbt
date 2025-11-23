///| ArrayBuffer tests

///|
test "ArrayBuffer creation and properties" {
  let buffer = @js.ArrayBuffer::new(16)
  assert_eq(buffer.byteLength(), 16)
  let zero_buffer = @js.ArrayBuffer::new(0)
  assert_eq(zero_buffer.byteLength(), 0)
}

///|
test "ArrayBuffer with maxByteLength" {
  let buffer = @js.ArrayBuffer::new(8, max_byte_length=16)
  assert_eq(buffer.byteLength(), 8)
  assert_eq(buffer.maxByteLength(), 16)
  assert_true(buffer.resizable())

  // Resize the buffer
  buffer.resize(12)
  assert_eq(buffer.byteLength(), 12)

  // Non-resizable buffer
  let fixed_buffer = @js.ArrayBuffer::new(8)
  assert_false(fixed_buffer.resizable())
}

///|
test "@js.ArrayBuffer::slice operations" {
  let buffer = @js.ArrayBuffer::new(16)

  // Basic slice
  let sliced = buffer.slice(begin=4, end=12)
  assert_eq(sliced.byteLength(), 8)

  // Full slice
  let full = buffer.slice(begin=0, end=16)
  assert_eq(full.byteLength(), 16)

  // Without end parameter
  let from_middle = buffer.slice(begin=8)
  assert_eq(from_middle.byteLength(), 8)

  // Negative indices
  let negative = buffer.slice(begin=-8, end=-4)
  assert_eq(negative.byteLength(), 4)
}

///|
test "@js.ArrayBuffer::is_view" {
  let buffer = @js.ArrayBuffer::new(16)

  // Plain buffer is not a view
  assert_false(@js.ArrayBuffer::isView(buffer.to_js()))

  // Note: Testing with actual views requires typedarray package
  // which would create circular dependency.
  // The is_view implementation is tested in typedarray tests.
}

///| SharedArrayBuffer tests

///|
test "SharedArrayBuffer creation and properties" {
  let buffer = SharedArrayBuffer::new(16)
  assert_eq(buffer.byteLength(), 16)
}

///|
test "Shared@js.ArrayBuffer::slice operations" {
  let buffer = SharedArrayBuffer::new(16)

  // Basic slice
  let sliced = buffer.slice(begin=4, end=12)
  assert_eq(sliced.byteLength(), 8)

  // Without end parameter
  let from_middle = buffer.slice(begin=8)
  assert_eq(from_middle.byteLength(), 8)
}
