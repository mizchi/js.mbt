///|
extern "js" fn ffi_new_text_encoder() -> @js.Js =
  #| () => new TextEncoder()

///|
extern "js" fn ffi_new_text_decoder() -> @js.Js =
  #| () => new TextDecoder()

///|
#external
pub type TextEncoder

///|
pub impl @js.JsImpl for TextEncoder

///|
pub fn TextEncoder::new() -> TextEncoder {
  @js.unsafe_cast(ffi_new_text_encoder())
}

///|
pub fn TextEncoder::encode(
  self : TextEncoder,
  input : String,
) -> @typed_array.Uint8Array {
  self.call("encode", [input]) |> @js.unsafe_cast
}

///|
pub type TextDecoder

///|
pub impl @js.JsImpl for TextDecoder

///|
pub fn TextDecoder::new() -> TextDecoder {
  @js.unsafe_cast(ffi_new_text_decoder())
}

///|
pub fn TextDecoder::decode(
  self : TextDecoder,
  input : @typed_array.Uint8Array,
) -> String {
  self.call("decode", [input]) |> @js.unsafe_cast
}
