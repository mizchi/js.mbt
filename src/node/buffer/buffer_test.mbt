///|
using @js {js, unsafe_cast}

///|
test "Buffer.from_string" {
  let buf = Buffer::from_string("Hello")
  assert_eq(buf.length(), 5)
  assert_eq(buf.toString(), "Hello")
  let buf_utf8 = Buffer::from_string("こんにちは", encoding="utf-8")
  assert_eq(buf_utf8.toString(encoding="utf-8"), "こんにちは")
}

///|
test "Buffer.from_array" {
  let buf = Buffer::from_array([72, 101, 108, 108, 111]) // "Hello"
  assert_eq(buf.length(), 5)
  assert_eq(buf.toString(), "Hello")
}

///|
test "Buffer.alloc" {
  let buf = Buffer::alloc(10)
  assert_eq(buf.length(), 10)
  // Zero-filled buffer
  assert_eq(buf.get(0), 0)
  assert_eq(buf.get(9), 0)
  let buf_filled = Buffer::alloc(5, fill=js(0x41)) // Fill with 'A'
  assert_eq(buf_filled.toString(), "AAAAA")
}

///|
test "Buffer.allocUnsafe" {
  let buf = Buffer::allocUnsafe(10)
  assert_eq(buf.length(), 10)
}

///|
test "Buffer.isBuffer" {
  let buf = Buffer::from_string("test")
  assert_eq(Buffer::isBuffer(buf.to_js()), true)
  assert_eq(Buffer::isBuffer(js("hello")), false)
}

///|
test "Buffer.isEncoding" {
  assert_eq(Buffer::isEncoding("utf-8"), true)
  assert_eq(Buffer::isEncoding("utf8"), true)
  assert_eq(Buffer::isEncoding("hex"), true)
  assert_eq(Buffer::isEncoding("base64"), true)
  assert_eq(Buffer::isEncoding("invalid"), false)
}

///|
test "Buffer.concat" {
  let buf1 = Buffer::from_string("Hello")
  let buf2 = Buffer::from_string(" ")
  let buf3 = Buffer::from_string("World")
  let result = Buffer::concat([buf1, buf2, buf3])
  assert_eq(result.toString(), "Hello World")
  assert_eq(result.length(), 11)
}

///|
test "Buffer.byteLength" {
  assert_eq(Buffer::byteLength("Hello"), 5)
  assert_eq(Buffer::byteLength("こんにちは", encoding="utf-8"), 15) // 3 bytes per char
}

///|
test "Buffer.compare" {
  let buf1 = Buffer::from_string("abc")
  let buf2 = Buffer::from_string("abc")
  let buf3 = Buffer::from_string("abd")
  assert_eq(Buffer::compare(buf1, buf2), 0)
  assert_eq(Buffer::compare(buf1, buf3) < 0, true)
  assert_eq(Buffer::compare(buf3, buf1) > 0, true)
}

///|
test "Buffer write and read" {
  let buf = Buffer::alloc(10)
  let written = buf.write("Hello")
  assert_eq(written, 5)
  assert_eq(buf.toString(start=0, end=5), "Hello")
  buf.write("World", offset=5) |> ignore
  assert_eq(buf.toString(), "HelloWorld")
}

///|
test "Buffer slice and subarray" {
  let buf = Buffer::from_string("Hello World")
  let slice1 = buf.slice(start=0, end=5)
  assert_eq(slice1.toString(), "Hello")
  let slice2 = buf.slice(start=6)
  assert_eq(slice2.toString(), "World")
  let sub = buf.subarray(start=0, end=5)
  assert_eq(sub.toString(), "Hello")
}

///|
test "Buffer copy" {
  let source = Buffer::from_string("Hello")
  let target = Buffer::alloc(10)
  let bytes_copied = source.copy(target)
  assert_eq(bytes_copied, 5)
  assert_eq(target.toString(start=0, end=5), "Hello")

  // Copy with offset
  let target2 = Buffer::alloc(10)
  source.copy(target2, target_start=2) |> ignore
  assert_eq(target2.toString(start=2, end=7), "Hello")
}

///|
test "Buffer fill" {
  let buf = Buffer::alloc(5)
  buf.fill(js(0x41)) |> ignore // Fill with 'A'
  assert_eq(buf.toString(), "AAAAA")
  let buf2 = Buffer::alloc(10)
  buf2.fill(js(0x42), offset=2, end=7) |> ignore // Fill with 'B'
  assert_eq(buf2.get(1), 0)
  assert_eq(buf2.get(2), 0x42) // 'B'
  assert_eq(buf2.get(6), 0x42) // 'B'
  assert_eq(buf2.get(7), 0)
}

///|
test "Buffer equals" {
  let buf1 = Buffer::from_string("Hello")
  let buf2 = Buffer::from_string("Hello")
  let buf3 = Buffer::from_string("World")
  assert_eq(buf1.equals(buf2), true)
  assert_eq(buf1.equals(buf3), false)
}

///|
test "Buffer includes and indexOf" {
  let buf = Buffer::from_string("Hello World")
  assert_eq(buf.includes(js("World")), true)
  assert_eq(buf.includes(js("Foo")), false)
  assert_eq(buf.indexOf(js("World")), 6)
  assert_eq(buf.indexOf(js("Foo")), -1)
  assert_eq(buf.indexOf(js("o")), 4)
}

///|
test "Buffer get and set" {
  let buf = Buffer::alloc(5)
  buf.set(0, 72) // 'H'
  buf.set(1, 101) // 'e'
  buf.set(2, 108) // 'l'
  buf.set(3, 108) // 'l'
  buf.set(4, 111) // 'o'
  assert_eq(buf.get(0), 72)
  assert_eq(buf.toString(), "Hello")
}

///|
test "Buffer toJSON" {
  let buf = Buffer::from_array([1, 2, 3, 4, 5])
  let json = buf.toJSON()

  // JSON representation has type and data fields
  let json_type : String = unsafe_cast(json.get("type"))
  assert_eq(json_type, "Buffer")
  // The data field is an array, verify it has the correct length
  let data = json.get("data")
  let data_length : Int = unsafe_cast(data.get("length"))
  assert_eq(data_length, 5)
}

///|
test "Buffer encoding conversions" {
  let buf = Buffer::from_string("Hello World")

  // Different string encodings
  assert_eq(buf.toString(encoding="utf-8"), "Hello World")

  // Hex encoding
  let hex_str = buf.toString(encoding="hex")
  assert_eq(hex_str.length() > 0, true)

  // Base64 encoding
  let base64_str = buf.toString(encoding="base64")
  assert_eq(base64_str.length() > 0, true)
}

///|
test "Buffer from_buffer (copy)" {
  let original = Buffer::from_string("Hello")
  let copy = Buffer::from_buffer(original)
  assert_eq(copy.toString(), "Hello")
  assert_eq(copy.equals(original), true)

  // Modify copy shouldn't affect original
  copy.write("World") |> ignore
  assert_eq(copy.toString(), "World")
  assert_eq(original.toString(), "Hello")
}
