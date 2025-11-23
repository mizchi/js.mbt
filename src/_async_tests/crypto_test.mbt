///|
/// Web Crypto API Tests
/// Note: @test {it, describe} and @js {Promise} are already imported in deps.mbt

///|
/// Helper Functions
extern "js" fn ffi_text_encoder_encode(text : String) -> Js =
  #|(text) => new TextEncoder().encode(text)

///|
extern "js" fn ffi_text_decoder_decode(data : Js) -> String =
  #|(data) => new TextDecoder().decode(data)

///|
extern "js" fn ffi_array_buffer_to_hex(buffer : Js) -> String =
  #|(buffer) => Array.from(new Uint8Array(buffer)).map(b => b.toString(16).padStart(2, '0')).join('')

///|
extern "js" fn ffi_create_aes_algorithm(name : String, length : Int) -> Js =
  #|(name, length) => ({ name, length })

///|
extern "js" fn ffi_create_aes_gcm_params(name : String, iv : Js) -> Js =
  #|(name, iv) => ({ name, iv })

///|
extern "js" fn ffi_create_hmac_algorithm(name : String, hash : String) -> Js =
  #|(name, hash) => ({ name, hash })

///|
extern "js" fn ffi_random_values(length : Int) -> Js =
  #|(length) => crypto.getRandomValues(new Uint8Array(length))

///| Digest Tests

///|
test {
  @test.describe("Web Crypto API: Digest operations", _ => {
    it("SubtleCrypto digest SHA-256", _ => {
      let crypto = @crypto.Crypto::get()
      let subtle = crypto.subtle
      let data = ffi_text_encoder_encode("Hello, World!")
      let digest = subtle.digest("SHA-256", data).wait()
      let hex = ffi_array_buffer_to_hex(digest)
      assert_eq(hex.length(), 64)
    })
    it("SubtleCrypto digest SHA-384", _ => {
      let crypto = @crypto.Crypto::get()
      let subtle = crypto.subtle
      let data = ffi_text_encoder_encode("Hello, World!")
      let digest = subtle.digest("SHA-384", data).wait()
      let hex = ffi_array_buffer_to_hex(digest)
      assert_eq(hex.length(), 96)
    })
    it("SubtleCrypto digest SHA-512", _ => {
      let crypto = @crypto.Crypto::get()
      let subtle = crypto.subtle
      let data = ffi_text_encoder_encode("Hello, World!")
      let digest = subtle.digest("SHA-512", data).wait()
      let hex = ffi_array_buffer_to_hex(digest)
      assert_eq(hex.length(), 128)
    })
  })
}

///| Key Generation Tests

///|
test {
  @test.describe("Web Crypto API: Key generation", _ => {
    it("SubtleCrypto generateKey AES-GCM", _ => {
      let crypto = @crypto.Crypto::get()
      let subtle = crypto.subtle
      let algorithm = ffi_create_aes_algorithm("AES-GCM", 256)
      let key_usages = ["encrypt", "decrypt"]
      let key = subtle.generateKey(algorithm, true, key_usages).wait()
      let key_type : String = unsafe_cast(key.get("type"))
      assert_eq(key_type, "secret")
    })
    it("SubtleCrypto generateKey HMAC", _ => {
      let crypto = @crypto.Crypto::get()
      let subtle = crypto.subtle
      let algorithm = ffi_create_hmac_algorithm("HMAC", "SHA-256")
      let key_usages = ["sign", "verify"]
      let key = subtle.generateKey(algorithm, true, key_usages).wait()
      let key_type : String = unsafe_cast(key.get("type"))
      assert_eq(key_type, "secret")
    })
  })
}

///| Encryption/Decryption Tests

///|
test {
  @test.describe("Web Crypto API: Encryption and decryption", _ => it(
    "SubtleCrypto encrypt and decrypt with AES-GCM",
    _ => {
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
    },
  ))
}

///| Sign/Verify Tests

///|
test {
  @test.describe("Web Crypto API: Sign and verify", _ => it(
    "SubtleCrypto sign and verify with HMAC",
    _ => {
      let crypto = @crypto.Crypto::get()
      let subtle = crypto.subtle
      let algorithm = ffi_create_hmac_algorithm("HMAC", "SHA-256")
      let key_usages = ["sign", "verify"]
      let key = subtle.generateKey(algorithm, true, key_usages).wait()
      let data = ffi_text_encoder_encode("Message to sign")
      let signature = subtle.sign(algorithm, key, data).wait()
      let is_valid : Bool = unsafe_cast(
        subtle.verify(algorithm, key, signature, data).wait(),
      )
      assert_true(is_valid)
    },
  ))
}

///| Export/Import Tests

///|
test {
  @test.describe("Web Crypto API: Key export and import", _ => it(
    "SubtleCrypto exportKey and importKey with AES-GCM",
    _ => {
      let crypto = @crypto.Crypto::get()
      let subtle = crypto.subtle
      let algorithm = ffi_create_aes_algorithm("AES-GCM", 256)
      let key_usages = ["encrypt", "decrypt"]
      let original_key = subtle.generateKey(algorithm, true, key_usages).wait()
      let exported = subtle.exportKey("raw", original_key).wait()
      let imported_key = subtle
        .importKey("raw", exported, algorithm, true, key_usages)
        .wait()
      let key_type : String = unsafe_cast(imported_key.get("type"))
      assert_eq(key_type, "secret")
    },
  ))
}

///| Access Test

///|
test {
  @test.describe("Web Crypto API: Basic access", _ => it(
    "getCrypto returns Crypto instance",
    _ => {
      let crypto = @crypto.Crypto::get()
      let subtle = crypto.subtle
      let data = ffi_text_encoder_encode("test")
      let digest = subtle.digest("SHA-256", data).wait()
      let hex = ffi_array_buffer_to_hex(digest)
      assert_true(hex.length() > 0)
    },
  ))
}
