///|
/// Web Crypto API Tests

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
  it("SubtleCrypto digest SHA-256", _ => {
    let crypto = @crypto.getCrypto()
    let subtle = crypto.subtle()
    let data = ffi_text_encoder_encode("Hello, World!")
    let digest = subtle.digest("SHA-256", data).unwrap()
    let hex = ffi_array_buffer_to_hex(digest)
    assert_eq(hex.length(), 64)
  })
}

///|
test {
  it("SubtleCrypto digest SHA-384", _ => {
    let crypto = @crypto.getCrypto()
    let subtle = crypto.subtle()
    let data = ffi_text_encoder_encode("Hello, World!")
    let digest = subtle.digest("SHA-384", data).unwrap()
    let hex = ffi_array_buffer_to_hex(digest)
    assert_eq(hex.length(), 96)
  })
}

///|
test {
  it("SubtleCrypto digest SHA-512", _ => {
    let crypto = @crypto.getCrypto()
    let subtle = crypto.subtle()
    let data = ffi_text_encoder_encode("Hello, World!")
    let digest = subtle.digest("SHA-512", data).unwrap()
    let hex = ffi_array_buffer_to_hex(digest)
    assert_eq(hex.length(), 128)
  })
}

///| Key Generation Tests

///|
test {
  it("SubtleCrypto generateKey AES-GCM", _ => {
    let crypto = @crypto.getCrypto()
    let subtle = crypto.subtle()
    let algorithm = ffi_create_aes_algorithm("AES-GCM", 256)
    let key_usages = ["encrypt", "decrypt"]
    let key = subtle.generateKey(algorithm, true, key_usages).unwrap()
    let key_type : String = unsafe_cast(key.get("type"))
    assert_eq(key_type, "secret")
  })
}

///|
test {
  it("SubtleCrypto generateKey HMAC", _ => {
    let crypto = @crypto.getCrypto()
    let subtle = crypto.subtle()
    let algorithm = ffi_create_hmac_algorithm("HMAC", "SHA-256")
    let key_usages = ["sign", "verify"]
    let key = subtle.generateKey(algorithm, true, key_usages).unwrap()
    let key_type : String = unsafe_cast(key.get("type"))
    assert_eq(key_type, "secret")
  })
}

///| Encryption/Decryption Tests

///|
test {
  it("SubtleCrypto encrypt and decrypt with AES-GCM", _ => {
    let crypto = @crypto.getCrypto()
    let subtle = crypto.subtle()
    let algorithm = ffi_create_aes_algorithm("AES-GCM", 256)
    let key_usages = ["encrypt", "decrypt"]
    let key = subtle.generateKey(algorithm, true, key_usages).unwrap()
    let iv = ffi_random_values(12)
    let plaintext = ffi_text_encoder_encode("Secret message")
    let enc_algorithm = ffi_create_aes_gcm_params("AES-GCM", iv)
    let encrypted = subtle.encrypt(enc_algorithm, key, plaintext).unwrap()
    let decrypted = subtle.decrypt(enc_algorithm, key, encrypted).unwrap()
    let result = ffi_text_decoder_decode(decrypted)
    assert_eq(result, "Secret message")
  })
}

///| Sign/Verify Tests

///|
test {
  it("SubtleCrypto sign and verify with HMAC", _ => {
    let crypto = @crypto.getCrypto()
    let subtle = crypto.subtle()
    let algorithm = ffi_create_hmac_algorithm("HMAC", "SHA-256")
    let key_usages = ["sign", "verify"]
    let key = subtle.generateKey(algorithm, true, key_usages).unwrap()
    let data = ffi_text_encoder_encode("Message to sign")
    let signature = subtle.sign(algorithm, key, data).unwrap()
    let is_valid : Bool = unsafe_cast(
      subtle.verify(algorithm, key, signature, data).unwrap(),
    )
    assert_true(is_valid)
  })
}

///| Export/Import Tests

///|
test {
  it("SubtleCrypto exportKey and importKey with AES-GCM", _ => {
    let crypto = @crypto.getCrypto()
    let subtle = crypto.subtle()
    let algorithm = ffi_create_aes_algorithm("AES-GCM", 256)
    let key_usages = ["encrypt", "decrypt"]
    let original_key = subtle.generateKey(algorithm, true, key_usages).unwrap()
    let exported = subtle.exportKey("raw", original_key).unwrap()
    let imported_key = subtle
      .importKey("raw", exported, algorithm, true, key_usages)
      .unwrap()
    let key_type : String = unsafe_cast(imported_key.get("type"))
    assert_eq(key_type, "secret")
  })
}

///| Access Test

///|
test {
  it("getCrypto returns Crypto instance", _ => {
    let crypto = @crypto.getCrypto()
    let subtle = crypto.subtle()
    let data = ffi_text_encoder_encode("test")
    let digest = subtle.digest("SHA-256", data).unwrap()
    let hex = ffi_array_buffer_to_hex(digest)
    assert_true(hex.length() > 0)
  })
}
