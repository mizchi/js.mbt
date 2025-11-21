///|
using @arraybuffer { type Uint8Array }

///|
test "TextEncoder::new - create encoder" {
  let encoder = TextEncoder::new()
  assert_true(encoder |> @js.is_object())
}

///|
test "TextEncoder::encode - basic ASCII text" {
  let encoder = TextEncoder::new()
  let result = encoder.encode("hello")
  assert_eq(result.length(), 5)
  assert_eq(result.get_at(0), 104) // 'h'
  assert_eq(result.get_at(1), 101) // 'e'
  assert_eq(result.get_at(2), 108) // 'l'
  assert_eq(result.get_at(3), 108) // 'l'
  assert_eq(result.get_at(4), 111) // 'o'
}

///|
test "TextEncoder::encode - empty string" {
  let encoder = TextEncoder::new()
  let result = encoder.encode("")
  assert_eq(result.length(), 0)
}

///|
test "TextEncoder::encode - UTF-8 multibyte characters" {
  let encoder = TextEncoder::new()
  let result = encoder.encode("こんにちは")
  assert_eq(result.length(), 15) // 5 characters * 3 bytes each
}

///|
test "TextEncoder::encode - emoji" {
  let encoder = TextEncoder::new()
  let result = encoder.encode("😀")
  assert_eq(result.length(), 4)
}

///|
test "TextEncoder::encode - mixed ASCII and UTF-8" {
  let encoder = TextEncoder::new()
  let result = encoder.encode("Hello 世界")
  assert_eq(result.length(), 12) // "Hello " (6 bytes) + "世界" (6 bytes)
}

///|
test "TextEncoder::encode - special characters" {
  let encoder = TextEncoder::new()
  let result = encoder.encode("Hello\nWorld\t!")
  assert_eq(result.get_at(5), 10) // '\n'
  assert_eq(result.get_at(11), 9) // '\t'
}

///|
test "TextDecoder::new - create decoder" {
  let decoder = TextDecoder::new()
  assert_true(decoder |> @js.is_object())
}

///|
test "TextDecoder::decode - basic ASCII text" {
  let decoder = TextDecoder::new()
  let arr = Uint8Array::from_array([104, 101, 108, 108, 111])
  let result = decoder.decode(arr)
  assert_eq(result, "hello")
}

///|
test "TextDecoder::decode - empty array" {
  let decoder = TextDecoder::new()
  let arr = Uint8Array::from_size(0)
  let result = decoder.decode(arr)
  assert_eq(result, "")
}

///|
test "TextDecoder::decode - UTF-8 characters" {
  let decoder = TextDecoder::new()
  // UTF-8 encoding of "世" (0xE4 0xB8 0x96)
  let arr = Uint8Array::from_array([228, 184, 150])
  let result = decoder.decode(arr)
  assert_eq(result, "世")
}

///|
test "TextEncoder and TextDecoder - round trip ASCII" {
  let encoder = TextEncoder::new()
  let decoder = TextDecoder::new()
  let original = "Hello, World!"
  let encoded = encoder.encode(original)
  let decoded = decoder.decode(encoded)
  assert_eq(decoded, original)
}

///|
test "TextEncoder and TextDecoder - round trip UTF-8" {
  let encoder = TextEncoder::new()
  let decoder = TextDecoder::new()
  let original = "こんにちは世界"
  let encoded = encoder.encode(original)
  let decoded = decoder.decode(encoded)
  assert_eq(decoded, original)
}

///|
test "TextEncoder and TextDecoder - round trip emoji" {
  let encoder = TextEncoder::new()
  let decoder = TextDecoder::new()
  let original = "Hello 😀 World 🌍"
  let encoded = encoder.encode(original)
  let decoded = decoder.decode(encoded)
  assert_eq(decoded, original)
}

///|
test "TextEncoder and TextDecoder - round trip mixed content" {
  let encoder = TextEncoder::new()
  let decoder = TextDecoder::new()
  let original = "ASCII + 日本語 + Emoji 🎉 + Numbers 123"
  let encoded = encoder.encode(original)
  let decoded = decoder.decode(encoded)
  assert_eq(decoded, original)
}

///|
test "TextEncoder and TextDecoder - special characters round trip" {
  let encoder = TextEncoder::new()
  let decoder = TextDecoder::new()
  let original = "Line1\nLine2\tTabbed\rCarriage"
  let encoded = encoder.encode(original)
  let decoded = decoder.decode(encoded)
  assert_eq(decoded, original)
}

///|
test "TextEncoder::encode - long text" {
  let encoder = TextEncoder::new()
  let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
  let result = encoder.encode(text)
  assert_eq(result.length(), 123)
}

///|
test "TextEncoder::encode - numbers as text" {
  let encoder = TextEncoder::new()
  let result = encoder.encode("0123456789")
  assert_eq(result.length(), 10)
  assert_eq(result.get_at(0), 48) // '0'
  assert_eq(result.get_at(9), 57) // '9'
}

///|
test "TextDecoder::decode - numbers from bytes" {
  let decoder = TextDecoder::new()
  let arr = Uint8Array::from_array([48, 49, 50, 51, 52, 53, 54, 55, 56, 57])
  let result = decoder.decode(arr)
  assert_eq(result, "0123456789")
}

///|
test "TextEncoder - multiple encode calls" {
  let encoder = TextEncoder::new()
  let result1 = encoder.encode("First")
  let result2 = encoder.encode("Second")
  assert_eq(result1.length(), 5)
  assert_eq(result2.length(), 6)
  assert_eq(result1.get_at(0), 70) // 'F'
  assert_eq(result2.get_at(0), 83) // 'S'
}

///|
test "TextDecoder - multiple decode calls" {
  let decoder = TextDecoder::new()
  let arr1 = Uint8Array::from_array([70, 105, 114, 115, 116])
  let arr2 = Uint8Array::from_array([83, 101, 99, 111, 110, 100])
  let result1 = decoder.decode(arr1)
  let result2 = decoder.decode(arr2)
  assert_eq(result1, "First")
  assert_eq(result2, "Second")
}
