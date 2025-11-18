///|
extern "js" fn ffi_new_text_encoder() -> Js =
  #| () => new TextEncoder()

///|
extern "js" fn ffi_new_text_decoder() -> Js =
  #| () => new TextDecoder()

///|
#external
pub type TextEncoder

///|
pub impl JsImpl for TextEncoder

///|
pub fn TextEncoder::new() -> TextEncoder {
  unsafe_cast(ffi_new_text_encoder())
}

///|
pub fn TextEncoder::encode(self : TextEncoder, input : String) -> Uint8Array {
  self.invoke("encode", [input]) |> unsafe_cast
}

///|
pub type TextDecoder

///|
pub impl JsImpl for TextDecoder

///|
pub fn TextDecoder::new() -> TextDecoder {
  unsafe_cast(ffi_new_text_decoder())
}

///|
pub fn TextDecoder::decode(self : TextDecoder, input : Uint8Array) -> String {
  self.invoke("decode", [input]) |> unsafe_cast
}
