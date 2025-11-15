///|
/// SubtleCrypto Type
#external
pub type SubtleCrypto

///|
pub impl Js for SubtleCrypto

///|
/// SubtleCrypto - Encryption/Decryption
pub fn SubtleCrypto::encrypt(
  self : Self,
  algorithm : &Js,
  key : &Js,
  data : &Js,
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
  algorithm : &Js,
  key : &Js,
  data : &Js,
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
  algorithm : &Js,
  key : &Js,
  data : &Js,
) -> Promise[Val] {
  unsafe_cast(
    self.invoke("sign", [algorithm.to_js(), key.to_js(), data.to_js()]),
  )
}

///|
pub fn SubtleCrypto::verify(
  self : Self,
  algorithm : &Js,
  key : &Js,
  signature : &Js,
  data : &Js,
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
  data : &Js,
) -> Promise[Val] {
  self.invoke("digest", [algorithm |> js, data.to_js()]) |> unsafe_cast
}

///|
/// SubtleCrypto - Key Generation
#alias(generateKey)
pub fn SubtleCrypto::generate_key(
  self : Self,
  algorithm : &Js,
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
#alias(deriveKey)
pub fn SubtleCrypto::derive_key(
  self : Self,
  algorithm : &Js,
  base_key : &Js,
  derived_key_type : &Js,
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
#alias(deriveBits)
pub fn SubtleCrypto::derive_bits(
  self : Self,
  algorithm : &Js,
  base_key : &Js,
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
#alias(importKey)
pub fn SubtleCrypto::import_key(
  self : Self,
  format : String,
  key_data : &Js,
  algorithm : &Js,
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
#alias(exportKey)
pub fn SubtleCrypto::export_key(
  self : Self,
  format : String,
  key : &Js,
) -> Promise[Val] {
  self.invoke("exportKey", [format |> js, key.to_js()]) |> unsafe_cast
}

///|
/// SubtleCrypto - Key Wrapping
#alias(wrapKey)
pub fn SubtleCrypto::wrap_key(
  self : Self,
  format : String,
  key : &Js,
  wrapping_key : &Js,
  wrap_algorithm : &Js,
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
#alias(unwrapKey)
pub fn SubtleCrypto::unwrap_key(
  self : Self,
  format : String,
  wrapped_key : &Js,
  unwrapping_key : &Js,
  unwrap_algorithm : &Js,
  unwrapped_key_algorithm : &Js,
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
/// Crypto Type
#external
pub type Crypto

///|
pub impl Js for Crypto

///|
pub fn Crypto::subtle(self : Self) -> SubtleCrypto {
  unsafe_cast(self.get("subtle"))
}

///|
/// Global Crypto Access
extern "js" fn ffi_get_crypto() -> Val =
  #|() => globalThis.crypto

///|
pub fn get_crypto() -> Crypto {
  unsafe_cast(ffi_get_crypto())
}
