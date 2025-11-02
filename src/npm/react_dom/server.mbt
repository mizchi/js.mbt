///|
pub fn render_to_string(element : @react.Element) -> String {
  let react_dom_server : Val = @node.require("react-dom/server")
  react_dom_server.get("renderToString").call([element]).cast()
}
