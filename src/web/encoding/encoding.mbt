///|
extern "js" fn ffi_new_text_encoder() -> @core.Any =
  #| () => new TextEncoder()

///|
extern "js" fn ffi_new_text_decoder() -> @core.Any =
  #| () => new TextDecoder()

///|
#external
pub type TextEncoder

///|
pub fn TextEncoder::as_any(self : TextEncoder) -> @core.Any = "%identity"

///|
pub fn TextEncoder::new() -> TextEncoder {
  @core.identity(ffi_new_text_encoder())
}

///|
pub fn TextEncoder::encode(
  self : TextEncoder,
  input : String,
) -> @arraybuffer.Uint8Array {
  self.as_any()._call("encode", [@core.any(input)]).cast()
}

///|
pub type TextDecoder

///|
pub fn TextDecoder::as_any(self : TextDecoder) -> @core.Any = "%identity"

///|
pub fn TextDecoder::new() -> TextDecoder {
  @core.identity(ffi_new_text_decoder())
}

///|
pub fn TextDecoder::decode(
  self : TextDecoder,
  input : @arraybuffer.Uint8Array,
) -> String {
  self.as_any()._call("decode", [@core.any(input)]).cast()
}
