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
) -> Promise[Val] {
  unsafe_cast(
    self
    .to_js()
    .invoke("encrypt", [algorithm.to_js(), key.to_js(), data.to_js()]),
  )
}

///|
pub fn SubtleCrypto::decrypt(
  self : Self,
  algorithm : &JsImpl,
  key : &JsImpl,
  data : &JsImpl,
) -> Promise[Val] {
  unsafe_cast(
    self
    .to_js()
    .invoke("decrypt", [algorithm.to_js(), key.to_js(), data.to_js()]),
  )
}

///|
/// SubtleCrypto - Signing/Verification
pub fn SubtleCrypto::sign(
  self : Self,
  algorithm : &JsImpl,
  key : &JsImpl,
  data : &JsImpl,
) -> Promise[Val] {
  unsafe_cast(
    self.invoke("sign", [algorithm.to_js(), key.to_js(), data.to_js()]),
  )
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
    .invoke("verify", [
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
) -> Promise[Val] {
  self.invoke("digest", [algorithm |> js, data.to_js()]) |> unsafe_cast
}

///|
/// SubtleCrypto - Key Generation
#alias(generate_key)
pub fn SubtleCrypto::generateKey(
  self : Self,
  algorithm : &JsImpl,
  extractable : Bool,
  key_usages : Array[String],
) -> Promise[Val] {
  unsafe_cast(
    self
    .to_js()
    .invoke("generateKey", [
      algorithm.to_js(),
      extractable |> js,
      key_usages |> js,
    ]),
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
) -> Promise[Val] {
  unsafe_cast(
    self
    .to_js()
    .invoke("deriveKey", [
      algorithm.to_js(),
      base_key.to_js(),
      derived_key_type.to_js(),
      extractable |> js,
      key_usages |> js,
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
) -> Promise[Val] {
  unsafe_cast(
    self
    .to_js()
    .invoke("deriveBits", [algorithm.to_js(), base_key.to_js(), length |> js]),
  )
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
) -> Promise[Val] {
  unsafe_cast(
    self
    .to_js()
    .invoke("importKey", [
      format |> js,
      key_data.to_js(),
      algorithm.to_js(),
      extractable |> js,
      key_usages |> js,
    ]),
  )
}

///|
#alias(export_key)
pub fn SubtleCrypto::exportKey(
  self : Self,
  format : String,
  key : &JsImpl,
) -> Promise[Val] {
  self.invoke("exportKey", [format |> js, key.to_js()]) |> unsafe_cast
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
) -> Promise[Val] {
  unsafe_cast(
    self
    .to_js()
    .invoke("wrapKey", [
      format |> js,
      key.to_js(),
      wrapping_key.to_js(),
      wrap_algorithm.to_js(),
    ]),
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
) -> Promise[Val] {
  unsafe_cast(
    self
    .to_js()
    .invoke("unwrapKey", [
      format |> js,
      wrapped_key.to_js(),
      unwrapping_key.to_js(),
      unwrap_algorithm.to_js(),
      unwrapped_key_algorithm.to_js(),
      extractable |> js,
      key_usages |> js,
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
extern "js" fn ffi_get_crypto() -> Val =
  #|() => globalThis.crypto

///|
#alias(get_crypto)
pub fn getCrypto() -> Crypto {
  unsafe_cast(ffi_get_crypto())
}
