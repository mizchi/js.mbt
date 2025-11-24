///|
#alias(render_to_string)
pub fn renderToString(element : @react.Element) -> String {
  let react_dom_server = @node.require("react-dom/server")
  react_dom_server.get("renderToString").call_self([element]) |> @js.identity
}

///|
#alias(render_to_readable_stream)
pub fn renderToReadableStream(
  element : @react.Element,
) -> @js.Promise[@streams.ReadableStream] {
  let react_dom_server = @node.require("react-dom/server")
  react_dom_server.get("renderToReadableStream").call_self([element])
  |> @js.identity
}
