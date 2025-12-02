///|
/// CryptoKey Type
/// https://developer.mozilla.org/en-US/docs/Web/API/CryptoKey
#external
pub type CryptoKey

///|
pub fn CryptoKey::as_any(self : CryptoKey) -> @core.Any = "%identity"

///|
/// CryptoKeyPair - returned by generateKey for asymmetric algorithms
/// https://developer.mozilla.org/en-US/docs/Web/API/CryptoKeyPair
pub(all) struct CryptoKeyPair {
  publicKey : CryptoKey
  privateKey : CryptoKey
}

///|
pub fn CryptoKeyPair::as_any(self : CryptoKeyPair) -> @core.Any = "%identity"

///|
/// SubtleCrypto Type
/// https://developer.mozilla.org/ja/docs/Web/API/SubtleCrypto
#external
pub type SubtleCrypto

///|
pub fn SubtleCrypto::as_any(self : SubtleCrypto) -> @core.Any = "%identity"

///|
/// SubtleCrypto - Encryption/Decryption
pub async fn SubtleCrypto::encrypt(
  self : Self,
  algorithm : @core.Any,
  key : @core.Any,
  data : @core.Any,
) -> @js.ArrayBuffer {
  let promise : @core.Promise[@js.ArrayBuffer] = self
    .as_any()
    ._call("encrypt", [algorithm, key, data])
    .cast()
  promise.wait()
}

///|
pub async fn SubtleCrypto::decrypt(
  self : Self,
  algorithm : @core.Any,
  key : @core.Any,
  data : @core.Any,
) -> @js.ArrayBuffer {
  let promise : @core.Promise[@js.ArrayBuffer] = self
    .as_any()
    ._call("decrypt", [algorithm, key, data])
    .cast()
  promise.wait()
}

///|
/// SubtleCrypto - Signing/Verification
pub async fn SubtleCrypto::sign(
  self : Self,
  algorithm : @core.Any,
  key : @core.Any,
  data : @core.Any,
) -> @js.ArrayBuffer {
  let promise : @core.Promise[@js.ArrayBuffer] = self
    .as_any()
    ._call("sign", [algorithm, key, data])
    .cast()
  promise.wait()
}

///|
pub async fn SubtleCrypto::verify(
  self : Self,
  algorithm : @core.Any,
  key : @core.Any,
  signature : @core.Any,
  data : @core.Any,
) -> Bool {
  let promise : @core.Promise[Bool] = self
    .as_any()
    ._call("verify", [algorithm, key, signature, data])
    .cast()
  promise.wait()
}

///|
/// SubtleCrypto - Digest
pub async fn SubtleCrypto::digest(
  self : Self,
  algorithm : String,
  data : @core.Any,
) -> @js.ArrayBuffer {
  let promise : @core.Promise[@js.ArrayBuffer] = self
    .as_any()
    ._call("digest", [@core.any(algorithm), data])
    .cast()
  promise.wait()
}

///|
/// SubtleCrypto - Key Generation
/// Returns CryptoKey for symmetric algorithms, CryptoKeyPair for asymmetric algorithms
#alias(generate_key)
pub async fn SubtleCrypto::generateKey(
  self : Self,
  algorithm : @core.Any,
  extractable : Bool,
  key_usages : Array[String],
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = self
    .as_any()
    ._call("generateKey", [
      algorithm,
      @core.any(extractable),
      @core.any(key_usages),
    ])
    .cast()
  promise.wait()
}

///|
#alias(derive_key)
pub async fn SubtleCrypto::deriveKey(
  self : Self,
  algorithm : @core.Any,
  base_key : @core.Any,
  derived_key_type : @core.Any,
  extractable : Bool,
  key_usages : Array[String],
) -> CryptoKey {
  let promise : @core.Promise[CryptoKey] = self
    .as_any()
    ._call("deriveKey", [
      algorithm,
      base_key,
      derived_key_type,
      @core.any(extractable),
      @core.any(key_usages),
    ])
    .cast()
  promise.wait()
}

///|
#alias(derive_bits)
pub async fn SubtleCrypto::deriveBits(
  self : Self,
  algorithm : @core.Any,
  base_key : @core.Any,
  length : Int,
) -> @js.ArrayBuffer {
  let promise : @core.Promise[@js.ArrayBuffer] = self
    .as_any()
    ._call("deriveBits", [algorithm, base_key, @core.any(length)])
    .cast()
  promise.wait()
}

///|
/// SubtleCrypto - Key Import/Export
#alias(import_key)
pub async fn SubtleCrypto::importKey(
  self : Self,
  format : String,
  key_data : @core.Any,
  algorithm : @core.Any,
  extractable : Bool,
  key_usages : Array[String],
) -> CryptoKey {
  let promise : @core.Promise[CryptoKey] = self
    .as_any()
    ._call("importKey", [
      @core.any(format),
      key_data,
      algorithm,
      @core.any(extractable),
      @core.any(key_usages),
    ])
    .cast()
  promise.wait()
}

///|
#alias(export_key)
pub async fn SubtleCrypto::exportKey(
  self : Self,
  format : String,
  key : @core.Any,
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = self
    .as_any()
    ._call("exportKey", [@core.any(format), key])
    .cast()
  promise.wait()
}

///|
/// SubtleCrypto - Key Wrapping
#alias(wrap_key)
pub async fn SubtleCrypto::wrapKey(
  self : Self,
  format : String,
  key : @core.Any,
  wrapping_key : @core.Any,
  wrap_algorithm : @core.Any,
) -> @js.ArrayBuffer {
  let promise : @core.Promise[@js.ArrayBuffer] = self
    .as_any()
    ._call("wrapKey", [@core.any(format), key, wrapping_key, wrap_algorithm])
    .cast()
  promise.wait()
}

///|
#alias(unwrap_key)
pub async fn SubtleCrypto::unwrapKey(
  self : Self,
  format : String,
  wrapped_key : @core.Any,
  unwrapping_key : @core.Any,
  unwrap_algorithm : @core.Any,
  unwrapped_key_algorithm : @core.Any,
  extractable : Bool,
  key_usages : Array[String],
) -> CryptoKey {
  let promise : @core.Promise[CryptoKey] = self
    .as_any()
    ._call("unwrapKey", [
      @core.any(format),
      wrapped_key,
      unwrapping_key,
      unwrap_algorithm,
      unwrapped_key_algorithm,
      @core.any(extractable),
      @core.any(key_usages),
    ])
    .cast()
  promise.wait()
}

///|
/// WebCrypto
/// JS: Crypto
pub(all) struct Crypto {
  subtle : SubtleCrypto
}

///|
pub fn Crypto::as_any(self : Crypto) -> @core.Any = "%identity"

///|
/// Crypto::getRandomValues()
/// Fills the passed Uint8Array with cryptographically secure random values.
pub fn Crypto::getRandomValues(
  self : Self,
  array : @typedarray.Uint8Array,
) -> @typedarray.Uint8Array {
  self.as_any()._call("getRandomValues", [@core.any(array)]).cast()
}

///|
/// Crypto::getRandomValuesU16()
/// Fills the passed Uint16Array with cryptographically secure random values.
pub fn Crypto::getRandomValuesU16(
  self : Self,
  array : @typedarray.Uint16Array,
) -> @typedarray.Uint16Array {
  self.as_any()._call("getRandomValues", [@core.any(array)]).cast()
}

///|
/// Crypto::getRandomValuesU32()
/// Fills the passed Uint32Array with cryptographically secure random values.
pub fn Crypto::getRandomValuesU32(
  self : Self,
  array : @typedarray.Uint32Array,
) -> @typedarray.Uint32Array {
  self.as_any()._call("getRandomValues", [@core.any(array)]).cast()
}

///|
/// Crypto::getRandomValuesI8()
/// Fills the passed Int8Array with cryptographically secure random values.
pub fn Crypto::getRandomValuesI8(
  self : Self,
  array : @typedarray.Int8Array,
) -> @typedarray.Int8Array {
  self.as_any()._call("getRandomValues", [@core.any(array)]).cast()
}

///|
/// Crypto::getRandomValuesI16()
/// Fills the passed Int16Array with cryptographically secure random values.
pub fn Crypto::getRandomValuesI16(
  self : Self,
  array : @typedarray.Int16Array,
) -> @typedarray.Int16Array {
  self.as_any()._call("getRandomValues", [@core.any(array)]).cast()
}

///|
/// Crypto::getRandomValuesI32()
/// Fills the passed Int32Array with cryptographically secure random values.
pub fn Crypto::getRandomValuesI32(
  self : Self,
  array : @typedarray.Int32Array,
) -> @typedarray.Int32Array {
  self.as_any()._call("getRandomValues", [@core.any(array)]).cast()
}

///|
/// Crypto::getRandomValuesClamped()
/// Fills the passed Uint8ClampedArray with cryptographically secure random values.
// pub fn Crypto::getRandomValuesClamped(
//   self : Self,
//   array : @typedarray.Uint8ClampedArray,
// ) -> @typedarray.Uint8ClampedArray {
//   self.as_any()._call("getRandomValues", [@core.any(array)]).cast()
// }

///|
/// Crypto::randomUUID()
/// Generates a v4 UUID using a cryptographically secure random number generator.
///
/// Returns a string in the format: "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
#alias(random_uuid)
pub fn Crypto::randomUUID(self : Self) -> String {
  self.as_any()._call("randomUUID", []).cast()
}

///|
/// Global Crypto Access
extern "js" fn ffi_get_crypto() -> @core.Any =
  #|() => globalThis.crypto

///|
/// Get the global Crypto instance
pub fn Crypto::get() -> Crypto {
  ffi_get_crypto().cast()
}
