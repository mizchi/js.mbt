///|
#module("react-dom/server")
extern "js" fn ffi_render_to_string(element : @core.Any) -> String = "renderToString"

///|
#alias(render_to_string)
pub fn renderToString(element : @react.Element) -> String {
  ffi_render_to_string(element.as_any())
}

///|
#module("react-dom/server")
extern "js" fn ffi_render_to_readable_stream(
  element : @core.Any,
) -> @js.Promise[@streams.ReadableStream] = "renderToReadableStream"

///|
#alias(render_to_readable_stream)
pub async fn renderToReadableStream(
  element : @react.Element,
) -> @streams.ReadableStream {
  ffi_render_to_readable_stream(element.as_any()).wait()
}
