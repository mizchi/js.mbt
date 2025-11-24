///|
extern "js" fn ffi_new_text_encoder() -> @js.Any =
  #| () => new TextEncoder()

///|
extern "js" fn ffi_new_text_decoder() -> @js.Any =
  #| () => new TextDecoder()

///|
#external
pub type TextEncoder

///|
pub impl @js.JsImpl for TextEncoder

///|
pub fn TextEncoder::new() -> TextEncoder {
  @js.identity(ffi_new_text_encoder())
}

///|
pub fn TextEncoder::encode(
  self : TextEncoder,
  input : String,
) -> @typedarray.Uint8Array {
  self.call("encode", [input]).cast()
}

///|
pub type TextDecoder

///|
pub impl @js.JsImpl for TextDecoder

///|
pub fn TextDecoder::new() -> TextDecoder {
  @js.identity(ffi_new_text_decoder())
}

///|
pub fn TextDecoder::decode(
  self : TextDecoder,
  input : @typedarray.Uint8Array,
) -> String {
  self.call("decode", [input]).cast()
}
