///|
#alias(render_to_string)
pub fn renderToString(element : @react.Element) -> String {
  let react_dom_server : Js = @node.require("react-dom/server")
  unsafe_cast(react_dom_server.get("renderToString").call_self([element]))
}
