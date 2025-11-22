///|
/// SubtleCrypto Type
/// https://developer.mozilla.org/ja/docs/Web/API/SubtleCrypto
#external
pub type SubtleCrypto

///|
pub impl JsImpl for SubtleCrypto

///|
/// SubtleCrypto - Encryption/Decryption
pub fn SubtleCrypto::encrypt(
  self : Self,
  algorithm : &JsImpl,
  key : &JsImpl,
  data : &JsImpl,
) -> Promise[Js] {
  self.call("encrypt", [algorithm, key, data]) |> unsafe_cast
}

///|
pub fn SubtleCrypto::decrypt(
  self : Self,
  algorithm : &JsImpl,
  key : &JsImpl,
  data : &JsImpl,
) -> Promise[Js] {
  self.call("decrypt", [algorithm, key, data]) |> unsafe_cast
}

///|
/// SubtleCrypto - Signing/Verification
pub fn SubtleCrypto::sign(
  self : Self,
  algorithm : &JsImpl,
  key : &JsImpl,
  data : &JsImpl,
) -> Promise[Js] {
  self.call("sign", [algorithm, key, data]) |> unsafe_cast
}

///|
pub fn SubtleCrypto::verify(
  self : Self,
  algorithm : &JsImpl,
  key : &JsImpl,
  signature : &JsImpl,
  data : &JsImpl,
) -> Promise[Bool] {
  self.call("verify", [algorithm, key, signature, data]) |> unsafe_cast
}

///|
/// SubtleCrypto - Digest
pub fn SubtleCrypto::digest(
  self : Self,
  algorithm : String,
  data : &JsImpl,
) -> Promise[Js] {
  self.call2("digest", algorithm |> js, data.to_js()) |> unsafe_cast
}

///|
/// SubtleCrypto - Key Generation
#alias(generate_key)
pub fn SubtleCrypto::generateKey(
  self : Self,
  algorithm : &JsImpl,
  extractable : Bool,
  key_usages : Array[String],
) -> Promise[Js] {
  self.call("generateKey", [
    algorithm,
    extractable,
    key_usages |> @js.from_array,
  ])
  |> unsafe_cast
}

///|
#alias(derive_key)
pub fn SubtleCrypto::deriveKey(
  self : Self,
  algorithm : &JsImpl,
  base_key : &JsImpl,
  derived_key_type : &JsImpl,
  extractable : Bool,
  key_usages : Array[String],
) -> Promise[Js] {
  self.call("deriveKey", [
    algorithm,
    base_key,
    derived_key_type,
    extractable,
    key_usages |> @js.from_array,
  ])
  |> unsafe_cast
}

///|
#alias(derive_bits)
pub fn SubtleCrypto::deriveBits(
  self : Self,
  algorithm : &JsImpl,
  base_key : &JsImpl,
  length : Int,
) -> Promise[Js] {
  self.call("deriveBits", [algorithm, base_key, length]) |> unsafe_cast
}

///|
/// SubtleCrypto - Key Import/Export
#alias(import_key)
pub fn SubtleCrypto::importKey(
  self : Self,
  format : String,
  key_data : &JsImpl,
  algorithm : &JsImpl,
  extractable : Bool,
  key_usages : Array[String],
) -> Promise[Js] {
  self.call("importKey", [
    format,
    key_data,
    algorithm,
    extractable,
    key_usages |> @js.from_array,
  ])
  |> unsafe_cast
}

///|
#alias(export_key)
pub fn SubtleCrypto::exportKey(
  self : Self,
  format : String,
  key : &JsImpl,
) -> Promise[Js] {
  self.call2("exportKey", format, key) |> unsafe_cast
}

///|
/// SubtleCrypto - Key Wrapping
#alias(wrap_key)
pub fn SubtleCrypto::wrapKey(
  self : Self,
  format : String,
  key : &JsImpl,
  wrapping_key : &JsImpl,
  wrap_algorithm : &JsImpl,
) -> Promise[Js] {
  self.call("wrapKey", [format, key, wrapping_key, wrap_algorithm])
  |> unsafe_cast
}

///|
#alias(unwrap_key)
pub fn SubtleCrypto::unwrapKey(
  self : Self,
  format : String,
  wrapped_key : &JsImpl,
  unwrapping_key : &JsImpl,
  unwrap_algorithm : &JsImpl,
  unwrapped_key_algorithm : &JsImpl,
  extractable : Bool,
  key_usages : Array[String],
) -> Promise[Js] {
  self.call("unwrapKey", [
    format,
    wrapped_key,
    unwrapping_key,
    unwrap_algorithm,
    unwrapped_key_algorithm,
    extractable,
    key_usages |> @js.from_array,
  ])
  |> unsafe_cast
}

///|
/// WebCrypto
/// JS: Crypto
pub(all) struct Crypto {
  subtle : SubtleCrypto
}

///|
pub impl JsImpl for Crypto

///|
/// Global Crypto Access
extern "js" fn ffi_get_crypto() -> Js =
  #|() => globalThis.crypto

///|
#alias(get_crypto)
pub fn getCrypto() -> Crypto {
  ffi_get_crypto() |> @js.unsafe_cast
}
