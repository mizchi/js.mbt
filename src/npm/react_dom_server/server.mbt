///|
#alias(render_to_string)
pub fn renderToString(element : @react.Element) -> String {
  let react_dom_server = @node.require("react-dom/server")
  let element_js : @nostd.Any = element.as_any().cast()
  react_dom_server._get("renderToString").call_self([element_js]).cast()
}

///|
#alias(render_to_readable_stream)
pub async fn renderToReadableStream(
  element : @react.Element,
) -> @streams.ReadableStream {
  let react_dom_server = @node.require("react-dom/server")
  let element_js : @nostd.Any = element.as_any().cast()
  let promise : @js.Promise[@streams.ReadableStream] = react_dom_server
    ._get("renderToReadableStream")
    .call_self([element_js])
    .cast()
  promise.wait()
}
