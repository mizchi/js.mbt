///|
#external
pub type TextEncoder

///|
pub fn TextEncoder::as_any(self : TextEncoder) -> @core.Any = "%identity"

///|
pub extern "js" fn TextEncoder::new() -> TextEncoder =
  #| () => new TextEncoder()

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
pub extern "js" fn TextDecoder::new() -> TextDecoder =
  #| () => new TextDecoder()

///|
pub fn TextDecoder::decode(
  self : TextDecoder,
  input : @arraybuffer.Uint8Array,
) -> String {
  self.as_any()._call("decode", [@core.any(input)]).cast()
}
