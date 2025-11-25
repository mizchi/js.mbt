///|
/// SubtleCrypto Type
/// https://developer.mozilla.org/ja/docs/Web/API/SubtleCrypto
#external
pub type SubtleCrypto

///|
pub impl @js.JsImpl for SubtleCrypto

///|
/// SubtleCrypto - Encryption/Decryption
pub async fn SubtleCrypto::encrypt(
  self : Self,
  algorithm : &@js.JsImpl,
  key : &@js.JsImpl,
  data : &@js.JsImpl,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call("encrypt", [algorithm, key, data])
    .cast()
  promise.wait()
}

///|
pub async fn SubtleCrypto::decrypt(
  self : Self,
  algorithm : &@js.JsImpl,
  key : &@js.JsImpl,
  data : &@js.JsImpl,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call("decrypt", [algorithm, key, data])
    .cast()
  promise.wait()
}

///|
/// SubtleCrypto - Signing/Verification
pub async fn SubtleCrypto::sign(
  self : Self,
  algorithm : &@js.JsImpl,
  key : &@js.JsImpl,
  data : &@js.JsImpl,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call("sign", [algorithm, key, data])
    .cast()
  promise.wait()
}

///|
pub async fn SubtleCrypto::verify(
  self : Self,
  algorithm : &@js.JsImpl,
  key : &@js.JsImpl,
  signature : &@js.JsImpl,
  data : &@js.JsImpl,
) -> Bool {
  let promise : @js.Promise[Bool] = self
    .call("verify", [algorithm, key, signature, data])
    .cast()
  promise.wait()
}

///|
/// SubtleCrypto - Digest
pub async fn SubtleCrypto::digest(
  self : Self,
  algorithm : String,
  data : &@js.JsImpl,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call2("digest", algorithm |> @js.any, data.to_any())
    .cast()
  promise.wait()
}

///|
/// SubtleCrypto - Key Generation
#alias(generate_key)
pub async fn SubtleCrypto::generateKey(
  self : Self,
  algorithm : &@js.JsImpl,
  extractable : Bool,
  key_usages : Array[String],
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call("generateKey", [algorithm, extractable, key_usages |> @js.from_array])
    .cast()
  promise.wait()
}

///|
#alias(derive_key)
pub async fn SubtleCrypto::deriveKey(
  self : Self,
  algorithm : &@js.JsImpl,
  base_key : &@js.JsImpl,
  derived_key_type : &@js.JsImpl,
  extractable : Bool,
  key_usages : Array[String],
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call("deriveKey", [
      algorithm,
      base_key,
      derived_key_type,
      extractable,
      key_usages |> @js.from_array,
    ])
    .cast()
  promise.wait()
}

///|
#alias(derive_bits)
pub async fn SubtleCrypto::deriveBits(
  self : Self,
  algorithm : &@js.JsImpl,
  base_key : &@js.JsImpl,
  length : Int,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call("deriveBits", [algorithm, base_key, length])
    .cast()
  promise.wait()
}

///|
/// SubtleCrypto - Key Import/Export
#alias(import_key)
pub async fn SubtleCrypto::importKey(
  self : Self,
  format : String,
  key_data : &@js.JsImpl,
  algorithm : &@js.JsImpl,
  extractable : Bool,
  key_usages : Array[String],
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call("importKey", [
      format,
      key_data,
      algorithm,
      extractable,
      key_usages |> @js.from_array,
    ])
    .cast()
  promise.wait()
}

///|
#alias(export_key)
pub async fn SubtleCrypto::exportKey(
  self : Self,
  format : String,
  key : &@js.JsImpl,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call2("exportKey", format, key)
    .cast()
  promise.wait()
}

///|
/// SubtleCrypto - Key Wrapping
#alias(wrap_key)
pub async fn SubtleCrypto::wrapKey(
  self : Self,
  format : String,
  key : &@js.JsImpl,
  wrapping_key : &@js.JsImpl,
  wrap_algorithm : &@js.JsImpl,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call("wrapKey", [format, key, wrapping_key, wrap_algorithm])
    .cast()
  promise.wait()
}

///|
#alias(unwrap_key)
pub async fn SubtleCrypto::unwrapKey(
  self : Self,
  format : String,
  wrapped_key : &@js.JsImpl,
  unwrapping_key : &@js.JsImpl,
  unwrap_algorithm : &@js.JsImpl,
  unwrapped_key_algorithm : &@js.JsImpl,
  extractable : Bool,
  key_usages : Array[String],
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call("unwrapKey", [
      format,
      wrapped_key,
      unwrapping_key,
      unwrap_algorithm,
      unwrapped_key_algorithm,
      extractable,
      key_usages |> @js.from_array,
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
pub impl @js.JsImpl for Crypto

///|
/// Crypto::getRandomValues()
/// Fills the passed Uint8Array with cryptographically secure random values.
pub fn Crypto::getRandomValues(
  self : Self,
  array : @typedarray.Uint8Array,
) -> @typedarray.Uint8Array {
  self.call("getRandomValues", [array]).cast()
}

///|
/// Crypto::getRandomValuesU16()
/// Fills the passed Uint16Array with cryptographically secure random values.
pub fn Crypto::getRandomValuesU16(
  self : Self,
  array : @typedarray.Uint16Array,
) -> @typedarray.Uint16Array {
  self.call("getRandomValues", [array]).cast()
}

///|
/// Crypto::getRandomValuesU32()
/// Fills the passed Uint32Array with cryptographically secure random values.
pub fn Crypto::getRandomValuesU32(
  self : Self,
  array : @typedarray.Uint32Array,
) -> @typedarray.Uint32Array {
  self.call("getRandomValues", [array]).cast()
}

///|
/// Crypto::getRandomValuesI8()
/// Fills the passed Int8Array with cryptographically secure random values.
pub fn Crypto::getRandomValuesI8(
  self : Self,
  array : @typedarray.Int8Array,
) -> @typedarray.Int8Array {
  self.call("getRandomValues", [array]).cast()
}

///|
/// Crypto::getRandomValuesI16()
/// Fills the passed Int16Array with cryptographically secure random values.
pub fn Crypto::getRandomValuesI16(
  self : Self,
  array : @typedarray.Int16Array,
) -> @typedarray.Int16Array {
  self.call("getRandomValues", [array]).cast()
}

///|
/// Crypto::getRandomValuesI32()
/// Fills the passed Int32Array with cryptographically secure random values.
pub fn Crypto::getRandomValuesI32(
  self : Self,
  array : @typedarray.Int32Array,
) -> @typedarray.Int32Array {
  self.call("getRandomValues", [array]).cast()
}

///|
/// Crypto::getRandomValuesClamped()
/// Fills the passed Uint8ClampedArray with cryptographically secure random values.
pub fn Crypto::getRandomValuesClamped(
  self : Self,
  array : @typedarray.Uint8ClampedArray,
) -> @typedarray.Uint8ClampedArray {
  self.call("getRandomValues", [array]).cast()
}

///|
/// Crypto::randomUUID()
/// Generates a v4 UUID using a cryptographically secure random number generator.
///
/// Returns a string in the format: "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
#alias(random_uuid)
pub fn Crypto::randomUUID(self : Self) -> String {
  self.call("randomUUID", []).cast()
}

///|
/// Global Crypto Access
extern "js" fn ffi_get_crypto() -> @js.Any =
  #|() => globalThis.crypto

///|
/// Get the global Crypto instance
pub fn Crypto::get() -> Crypto {
  ffi_get_crypto().cast()
}
