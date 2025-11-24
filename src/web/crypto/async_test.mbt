///|
/// Web Crypto API Tests
/// Note: @test {it, describe} and @js {Promise} are already imported in deps.mbt

///|
/// Helper Functions
extern "js" fn ffi_text_encoder_encode(text : String) -> @js.Js =
  #|(text) => new TextEncoder().encode(text)

///|
extern "js" fn ffi_text_decoder_decode(data : @js.Js) -> String =
  #|(data) => new TextDecoder().decode(data)

///|
extern "js" fn ffi_array_buffer_to_hex(buffer : @js.Js) -> String =
  #|(buffer) => Array.from(new Uint8Array(buffer)).map(b => b.toString(16).padStart(2, '0')).join('')

///|
extern "js" fn ffi_create_aes_algorithm(name : String, length : Int) -> @js.Js =
  #|(name, length) => ({ name, length })

///|
extern "js" fn ffi_create_aes_gcm_params(name : String, iv : @js.Js) -> @js.Js =
  #|(name, iv) => ({ name, iv })

///|
extern "js" fn ffi_create_hmac_algorithm(
  name : String,
  hash : String,
) -> @js.Js =
  #|(name, hash) => ({ name, hash })

///|
extern "js" fn ffi_random_values(length : Int) -> @js.Js =
  #|(length) => crypto.getRandomValues(new Uint8Array(length))

///| Digest Tests

///|
async test "Web Crypto API: SubtleCrypto digest SHA-256" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let data = ffi_text_encoder_encode("Hello, World!")
  let digest = subtle.digest("SHA-256", data).wait()
  let hex = ffi_array_buffer_to_hex(digest)
  assert_eq(hex.length(), 64)
}

///|
async test "Web Crypto API: SubtleCrypto digest SHA-384" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let data = ffi_text_encoder_encode("Hello, World!")
  let digest = subtle.digest("SHA-384", data).wait()
  let hex = ffi_array_buffer_to_hex(digest)
  assert_eq(hex.length(), 96)
}

///|
async test "Web Crypto API: SubtleCrypto digest SHA-512" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let data = ffi_text_encoder_encode("Hello, World!")
  let digest = subtle.digest("SHA-512", data).wait()
  let hex = ffi_array_buffer_to_hex(digest)
  assert_eq(hex.length(), 128)
}

///| Key Generation Tests

///|
async test "Web Crypto API: SubtleCrypto generateKey AES-GCM" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let algorithm = ffi_create_aes_algorithm("AES-GCM", 256)
  let key_usages = ["encrypt", "decrypt"]
  let key = subtle.generateKey(algorithm, true, key_usages).wait()
  let key_type : String = @js.identity(key.get("type"))
  assert_eq(key_type, "secret")
}

///|
async test "Web Crypto API: SubtleCrypto generateKey HMAC" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let algorithm = ffi_create_hmac_algorithm("HMAC", "SHA-256")
  let key_usages = ["sign", "verify"]
  let key = subtle.generateKey(algorithm, true, key_usages).wait()
  let key_type : String = @js.identity(key.get("type"))
  assert_eq(key_type, "secret")
}

///| Encryption/Decryption Tests

///|
async test "Web Crypto API: SubtleCrypto encrypt and decrypt with AES-GCM" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let algorithm = ffi_create_aes_algorithm("AES-GCM", 256)
  let key_usages = ["encrypt", "decrypt"]
  let key = subtle.generateKey(algorithm, true, key_usages).wait()
  let iv = ffi_random_values(12)
  let plaintext = ffi_text_encoder_encode("Secret message")
  let enc_algorithm = ffi_create_aes_gcm_params("AES-GCM", iv)
  let encrypted = subtle.encrypt(enc_algorithm, key, plaintext).wait()
  let decrypted = subtle.decrypt(enc_algorithm, key, encrypted).wait()
  let result = ffi_text_decoder_decode(decrypted)
  assert_eq(result, "Secret message")
}

///| Sign/Verify Tests

///|
async test "Web Crypto API: SubtleCrypto sign and verify with HMAC" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let algorithm = ffi_create_hmac_algorithm("HMAC", "SHA-256")
  let key_usages = ["sign", "verify"]
  let key = subtle.generateKey(algorithm, true, key_usages).wait()
  let data = ffi_text_encoder_encode("Message to sign")
  let signature = subtle.sign(algorithm, key, data).wait()
  let is_valid : Bool = @js.identity(
    subtle.verify(algorithm, key, signature, data).wait(),
  )
  assert_true(is_valid)
}

///| Export/Import Tests

///|
async test "Web Crypto API: SubtleCrypto exportKey and importKey with AES-GCM" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let algorithm = ffi_create_aes_algorithm("AES-GCM", 256)
  let key_usages = ["encrypt", "decrypt"]
  let original_key = subtle.generateKey(algorithm, true, key_usages).wait()
  let exported = subtle.exportKey("raw", original_key).wait()
  let imported_key = subtle
    .importKey("raw", exported, algorithm, true, key_usages)
    .wait()
  let key_type : String = @js.identity(imported_key.get("type"))
  assert_eq(key_type, "secret")
}

///| Access Test

///|
async test "Web Crypto API: getCrypto returns Crypto instance" {
  let crypto = @crypto.Crypto::get()
  let subtle = crypto.subtle
  let data = ffi_text_encoder_encode("test")
  let digest = subtle.digest("SHA-256", data).wait()
  let hex = ffi_array_buffer_to_hex(digest)
  assert_true(hex.length() > 0)
}
