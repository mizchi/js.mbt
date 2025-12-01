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
    let val : UInt = result._get(i).cast()
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
    let val : UInt = result._get(i).cast()
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
  assert_eq(uuid._get(8), Some('-'))
  assert_eq(uuid._get(13), Some('-'))
  assert_eq(uuid._get(18), Some('-'))
  assert_eq(uuid._get(23), Some('-'))

  // Version should be 4 (at position 14)
  assert_eq(uuid._get(14), Some('4'))
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
  let js_val : @nostd.Any = crypto.as_any()
  assert_eq(@nostd.typeof_(js_val), "object")
}

///|
/// Web Crypto API Tests

// =============================================================================
// Test Helper FFI Functions
// =============================================================================
// These FFI functions are used ONLY for testing purposes.
// They create algorithm parameter objects for Web Crypto API methods.
//
// For TextEncoder/TextDecoder, use @encoding package instead of FFI.
// =============================================================================

///|
/// [Test Helper] Converts ArrayBuffer to hex string for verification.
/// Useful for comparing digest/hash outputs.
extern "js" fn test_ffi_array_buffer_to_hex(buffer : @js.ArrayBuffer) -> String =
  #|(buffer) => Array.from(new Uint8Array(buffer)).map(b => b.toString(16).padStart(2, '0')).join('')

///|
/// [Test Helper] Creates an AES algorithm parameter object.
/// Web Crypto API requires algorithm objects, not just strings.
extern "js" fn test_ffi_aes_algorithm(
  name : String,
  length : Int,
) -> @nostd.Any =
  #|(name, length) => ({ name, length })

///|
/// [Test Helper] Creates AES-GCM encryption parameters with IV.
extern "js" fn test_ffi_aes_gcm_params(
  name : String,
  iv : @nostd.Any,
) -> @nostd.Any =
  #|(name, iv) => ({ name, iv })

///|
/// [Test Helper] Creates HMAC algorithm parameters.
extern "js" fn test_ffi_hmac_algorithm(
  name : String,
  hash : String,
) -> @nostd.Any =
  #|(name, hash) => ({ name, hash })

///|
/// [Test Helper] Generates random bytes for IV (initialization vector).
extern "js" fn test_ffi_random_bytes(length : Int) -> @nostd.Any =
  #|(length) => crypto.getRandomValues(new Uint8Array(length))

///| Digest Tests

///|
async test "Web Crypto API: SubtleCrypto digest SHA-256" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let data : @nostd.Any = @nostd.identity(
    @encoding.TextEncoder::new().encode("Hello, World!").as_any(),
  )
  let digest = subtle.digest("SHA-256", data)
  let hex = test_ffi_array_buffer_to_hex(digest)
  assert_eq(hex.length(), 64)
}

///|
async test "Web Crypto API: SubtleCrypto digest SHA-384" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let data : @nostd.Any = @nostd.identity(
    @encoding.TextEncoder::new().encode("Hello, World!").as_any(),
  )
  let digest = subtle.digest("SHA-384", data)
  let hex = test_ffi_array_buffer_to_hex(digest)
  assert_eq(hex.length(), 96)
}

///|
async test "Web Crypto API: SubtleCrypto digest SHA-512" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let data : @nostd.Any = @nostd.identity(
    @encoding.TextEncoder::new().encode("Hello, World!").as_any(),
  )
  let digest = subtle.digest("SHA-512", data)
  let hex = test_ffi_array_buffer_to_hex(digest)
  assert_eq(hex.length(), 128)
}

///| Key Generation Tests

///|
async test "Web Crypto API: SubtleCrypto generateKey AES-GCM" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let algorithm : @nostd.Any = test_ffi_aes_algorithm("AES-GCM", 256)
  let key_usages = ["encrypt", "decrypt"]
  let key = subtle.generateKey(algorithm, true, key_usages)
  let key_type : String = @nostd.identity(key["type"])
  assert_eq(key_type, "secret")
}

///|
async test "Web Crypto API: SubtleCrypto generateKey HMAC" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let algorithm : @nostd.Any = test_ffi_hmac_algorithm("HMAC", "SHA-256")
  let key_usages = ["sign", "verify"]
  let key = subtle.generateKey(algorithm, true, key_usages)
  let key_type : String = @nostd.identity(key["type"])
  assert_eq(key_type, "secret")
}

///| Encryption/Decryption Tests

///|
async test "Web Crypto API: SubtleCrypto encrypt and decrypt with AES-GCM" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let algorithm : @nostd.Any = test_ffi_aes_algorithm("AES-GCM", 256)
  let key_usages = ["encrypt", "decrypt"]
  let key = subtle.generateKey(algorithm, true, key_usages)
  let iv : @nostd.Any = test_ffi_random_bytes(12)
  let plaintext : @nostd.Any = @nostd.identity(
    @encoding.TextEncoder::new().encode("Secret message").as_any(),
  )
  let enc_algorithm : @nostd.Any = test_ffi_aes_gcm_params("AES-GCM", iv)
  let encrypted = subtle.encrypt(enc_algorithm, key, plaintext)
  let decrypted = subtle.decrypt(enc_algorithm, key, @nostd.any(encrypted))
  // Convert ArrayBuffer to Uint8Array for TextDecoder
  let decrypted_bytes = @typedarray.Uint8Array::from_array_buffer(decrypted)
  let result = @encoding.TextDecoder::new().decode(decrypted_bytes)
  assert_eq(result, "Secret message")
}

///| Sign/Verify Tests

///|
async test "Web Crypto API: SubtleCrypto sign and verify with HMAC" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let algorithm : @nostd.Any = test_ffi_hmac_algorithm("HMAC", "SHA-256")
  let key_usages = ["sign", "verify"]
  let key = subtle.generateKey(algorithm, true, key_usages)
  let data : @nostd.Any = @nostd.identity(
    @encoding.TextEncoder::new().encode("Message to sign").as_any(),
  )
  let signature = subtle.sign(algorithm, key, data)
  let is_valid = subtle.verify(algorithm, key, @nostd.any(signature), data)
  assert_true(is_valid)
}

///| Export/Import Tests

///|
async test "Web Crypto API: SubtleCrypto exportKey and importKey with AES-GCM" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let algorithm : @nostd.Any = test_ffi_aes_algorithm("AES-GCM", 256)
  let key_usages = ["encrypt", "decrypt"]
  let original_key = subtle.generateKey(algorithm, true, key_usages)
  let exported = subtle.exportKey("raw", original_key)
  let imported_key = subtle.importKey(
    "raw", exported, algorithm, true, key_usages,
  )
  let key_type : String = @nostd.identity(imported_key.as_any()["type"])
  assert_eq(key_type, "secret")
}

///| Access Test

///|
async test "Web Crypto API: getCrypto returns Crypto instance" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let data : @nostd.Any = @nostd.identity(
    @encoding.TextEncoder::new().encode("test").as_any(),
  )
  let digest = subtle.digest("SHA-256", data)
  let hex = test_ffi_array_buffer_to_hex(digest)
  assert_true(hex.length() > 0)
}
