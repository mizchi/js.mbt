///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
extern "js" fn ffi_new_text_encoder() -> Val =
  #| () => new TextEncoder()

///|
extern "js" fn ffi_new_text_decoder() -> Val =
  #| () => new TextDecoder()

///|
#external
pub type TextEncoder

///|
pub impl Js for TextEncoder with to_js(self) -> Val {
  self |> js
}

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
pub impl Js for TextDecoder with to_js(self) -> Val {
  self |> js
}

///|
pub fn TextDecoder::new() -> TextDecoder {
  unsafe_cast(ffi_new_text_decoder())
}

///|
pub fn TextDecoder::decode(self : TextDecoder, input : Uint8Array) -> String {
  self.invoke("decode", [input]) |> unsafe_cast
}
