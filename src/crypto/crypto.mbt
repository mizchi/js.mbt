///|
/// SubtleCrypto Type
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
  unsafe_cast(
    self.to_js().call("encrypt", [algorithm.to_js(), key.to_js(), data.to_js()]),
  )
}

///|
pub fn SubtleCrypto::decrypt(
  self : Self,
  algorithm : &JsImpl,
  key : &JsImpl,
  data : &JsImpl,
) -> Promise[Js] {
  unsafe_cast(
    self.to_js().call("decrypt", [algorithm.to_js(), key.to_js(), data.to_js()]),
  )
}

///|
/// SubtleCrypto - Signing/Verification
pub fn SubtleCrypto::sign(
  self : Self,
  algorithm : &JsImpl,
  key : &JsImpl,
  data : &JsImpl,
) -> Promise[Js] {
  unsafe_cast(self.call("sign", [algorithm.to_js(), key.to_js(), data.to_js()]))
}

///|
pub fn SubtleCrypto::verify(
  self : Self,
  algorithm : &JsImpl,
  key : &JsImpl,
  signature : &JsImpl,
  data : &JsImpl,
) -> Promise[Bool] {
  unsafe_cast(
    self
    .to_js()
    .call("verify", [
      algorithm.to_js(),
      key.to_js(),
      signature.to_js(),
      data.to_js(),
    ]),
  )
}

///|
/// SubtleCrypto - Digest
pub fn SubtleCrypto::digest(
  self : Self,
  algorithm : String,
  data : &JsImpl,
) -> Promise[Js] {
  self.call("digest", [algorithm |> js, data.to_js()]) |> unsafe_cast
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
  unsafe_cast(
    self
    .to_js()
    .call("generateKey", [algorithm, extractable, key_usages |> @js.from_array]),
  )
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
  unsafe_cast(
    self
    .to_js()
    .call("deriveKey", [
      algorithm,
      base_key,
      derived_key_type,
      extractable,
      key_usages |> @js.from_array,
    ]),
  )
}

///|
#alias(derive_bits)
pub fn SubtleCrypto::deriveBits(
  self : Self,
  algorithm : &JsImpl,
  base_key : &JsImpl,
  length : Int,
) -> Promise[Js] {
  unsafe_cast(self.call("deriveBits", [algorithm, base_key, length]))
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
  unsafe_cast(
    self
    .to_js()
    .call("importKey", [
      format,
      key_data,
      algorithm,
      extractable,
      key_usages |> @js.from_array,
    ]),
  )
}

///|
#alias(export_key)
pub fn SubtleCrypto::exportKey(
  self : Self,
  format : String,
  key : &JsImpl,
) -> Promise[Js] {
  self.call("exportKey", [format, key]) |> unsafe_cast
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
  unsafe_cast(
    self.to_js().call("wrapKey", [format, key, wrapping_key, wrap_algorithm]),
  )
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
  unsafe_cast(
    self
    .to_js()
    .call("unwrapKey", [
      format,
      wrapped_key,
      unwrapping_key,
      unwrap_algorithm,
      unwrapped_key_algorithm,
      extractable,
      key_usages |> @js.from_array,
    ]),
  )
}

///|
/// WebCrypto
/// JS: Crypto
#external
pub type Crypto

///|
pub impl JsImpl for Crypto

///|
pub fn Crypto::subtle(self : Self) -> SubtleCrypto {
  unsafe_cast(self.get("subtle"))
}

///|
/// Global Crypto Access
extern "js" fn ffi_get_crypto() -> Js =
  #|() => globalThis.crypto

///|
#alias(get_crypto)
pub fn getCrypto() -> Crypto {
  unsafe_cast(ffi_get_crypto())
}
