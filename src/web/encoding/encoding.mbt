///|
extern "js" fn ffi_new_text_encoder() -> @nostd.Any =
  #| () => new TextEncoder()

///|
extern "js" fn ffi_new_text_decoder() -> @nostd.Any =
  #| () => new TextDecoder()

///|
#external
pub type TextEncoder

///|
pub fn TextEncoder::as_any(self : TextEncoder) -> @nostd.Any = "%identity"

///|
pub fn TextEncoder::new() -> TextEncoder {
  @nostd.identity(ffi_new_text_encoder())
}

///|
pub fn TextEncoder::encode(
  self : TextEncoder,
  input : String,
) -> @typedarray.Uint8Array {
  self.as_any()._call("encode", [@nostd.any(input)]).cast()
}

///|
pub type TextDecoder

///|
pub fn TextDecoder::as_any(self : TextDecoder) -> @nostd.Any = "%identity"

///|
pub fn TextDecoder::new() -> TextDecoder {
  @nostd.identity(ffi_new_text_decoder())
}

///|
pub fn TextDecoder::decode(
  self : TextDecoder,
  input : @typedarray.Uint8Array,
) -> String {
  self.as_any()._call("decode", [@nostd.any(input)]).cast()
}
