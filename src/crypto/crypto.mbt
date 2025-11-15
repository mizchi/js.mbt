///|
using @js {trait Js, type Val, js}

///|
using @async {type Promise}

///|
/// SubtleCrypto Type
#external
pub type SubtleCrypto

///|
pub impl Js for SubtleCrypto with to_js(self) {
  self |> js
}

///|
/// SubtleCrypto - Encryption/Decryption
pub fn SubtleCrypto::encrypt(
  self : Self,
  algorithm : &Js,
  key : &Js,
  data : &Js,
) -> Promise[Val] {
  self
  .to_js()
  .call_method("encrypt", [algorithm.to_js(), key.to_js(), data.to_js()])
  .cast()
}

///|
pub fn SubtleCrypto::decrypt(
  self : Self,
  algorithm : &Js,
  key : &Js,
  data : &Js,
) -> Promise[Val] {
  self
  .to_js()
  .call_method("decrypt", [algorithm.to_js(), key.to_js(), data.to_js()])
  .cast()
}

///|
/// SubtleCrypto - Signing/Verification
pub fn SubtleCrypto::sign(
  self : Self,
  algorithm : &Js,
  key : &Js,
  data : &Js,
) -> Promise[Val] {
  self
  .to_js()
  .call_method("sign", [algorithm.to_js(), key.to_js(), data.to_js()])
  .cast()
}

///|
pub fn SubtleCrypto::verify(
  self : Self,
  algorithm : &Js,
  key : &Js,
  signature : &Js,
  data : &Js,
) -> Promise[Bool] {
  self
  .to_js()
  .call_method("verify", [
    algorithm.to_js(),
    key.to_js(),
    signature.to_js(),
    data.to_js(),
  ])
  .cast()
}

///|
/// SubtleCrypto - Digest
pub fn SubtleCrypto::digest(
  self : Self,
  algorithm : String,
  data : &Js,
) -> Promise[Val] {
  self.to_js().call_method("digest", [algorithm |> js, data.to_js()]).cast()
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
  self
  .to_js()
  .call_method("generateKey", [
    algorithm.to_js(),
    extractable |> js,
    key_usages |> js,
  ])
  .cast()
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
  self
  .to_js()
  .call_method("deriveKey", [
    algorithm.to_js(),
    base_key.to_js(),
    derived_key_type.to_js(),
    extractable |> js,
    key_usages |> js,
  ])
  .cast()
}

///|
#alias(deriveBits)
pub fn SubtleCrypto::derive_bits(
  self : Self,
  algorithm : &Js,
  base_key : &Js,
  length : Int,
) -> Promise[Val] {
  self
  .to_js()
  .call_method("deriveBits", [algorithm.to_js(), base_key.to_js(), length |> js])
  .cast()
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
  self
  .to_js()
  .call_method("importKey", [
    format |> js,
    key_data.to_js(),
    algorithm.to_js(),
    extractable |> js,
    key_usages |> js,
  ])
  .cast()
}

///|
#alias(exportKey)
pub fn SubtleCrypto::export_key(
  self : Self,
  format : String,
  key : &Js,
) -> Promise[Val] {
  self.to_js().call_method("exportKey", [format |> js, key.to_js()]).cast()
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
  self
  .to_js()
  .call_method("wrapKey", [
    format |> js,
    key.to_js(),
    wrapping_key.to_js(),
    wrap_algorithm.to_js(),
  ])
  .cast()
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
  self
  .to_js()
  .call_method("unwrapKey", [
    format |> js,
    wrapped_key.to_js(),
    unwrapping_key.to_js(),
    unwrap_algorithm.to_js(),
    unwrapped_key_algorithm.to_js(),
    extractable |> js,
    key_usages |> js,
  ])
  .cast()
}

///|
/// Crypto Type
#external
pub type Crypto

///|
pub impl Js for Crypto with to_js(self) {
  self |> js
}

///|
pub fn Crypto::subtle(self : Self) -> SubtleCrypto {
  self.to_js().get("subtle").cast()
}

///|
/// Global Crypto Access
extern "js" fn ffi_get_crypto() -> Val =
  #|() => globalThis.crypto

///|
pub fn get_crypto() -> Crypto {
  ffi_get_crypto().cast()
}
