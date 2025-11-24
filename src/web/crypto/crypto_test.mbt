///|
test "Crypto::getRandomValues fills Uint8Array" {
  let crypto = Crypto::get()
  let array = @typedarray.Uint8Array::from_size(16)
  let result = crypto.getRandomValues(array)

  // Verify it returns the same array
  assert_eq(result.length, 16)

  // Verify at least some values are non-zero (extremely unlikely all zeros)
  let mut has_nonzero = false
  for i = 0; i < 16; i = i + 1 {
    let val : UInt = result.get(i).cast()
    if val != 0 {
      has_nonzero = true
      break
    }
  }
  assert_true(has_nonzero)
}

///|
test "Crypto::getRandomValuesU32 fills Uint32Array" {
  let crypto = Crypto::get()
  let array = @typedarray.Uint32Array::from_size(4)
  let result = crypto.getRandomValuesU32(array)
  assert_eq(result.length, 4)

  // Verify randomness
  let mut has_nonzero = false
  for i = 0; i < 4; i = i + 1 {
    let val : UInt = result.get(i).cast()
    if val != 0 {
      has_nonzero = true
      break
    }
  }
  assert_true(has_nonzero)
}

///|
test "Crypto::randomUUID generates valid UUID" {
  let crypto = Crypto::get()
  let uuid = crypto.randomUUID()

  // UUID v4 format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
  // Length should be 36 characters
  assert_eq(uuid.length(), 36)

  // Should contain hyphens at specific positions
  assert_eq(uuid.get(8), Some('-'))
  assert_eq(uuid.get(13), Some('-'))
  assert_eq(uuid.get(18), Some('-'))
  assert_eq(uuid.get(23), Some('-'))

  // Version should be 4 (at position 14)
  assert_eq(uuid.get(14), Some('4'))
}

///|
test "Crypto::randomUUID generates unique values" {
  let crypto = Crypto::get()
  let uuid1 = crypto.randomUUID()
  let uuid2 = crypto.randomUUID()

  // Two UUIDs should be different
  assert_true(uuid1 != uuid2)
}

///|
test "Crypto::get returns Crypto instance" {
  let crypto = Crypto::get()
  let js_val : @js.Any = crypto.to_js()
  assert_eq(@js.typeof_(js_val), "object")
}
