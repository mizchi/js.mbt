///| SSR Renderer - Render VNode to HTML string

///|

///|
/// Render VNode to HTML string
pub fn render_to_string(vnode : VNode) -> String {
  match vnode {
    Empty => ""
    Text(content) => escape_html(content)
    Element({ tag, props, children, .. }) =>
      render_element_to_string(tag, props, children)
    Fragment(children) => {
      let mut html = ""
      for child in children {
        html = html + render_to_string(child)
      }
      html
    }
    Component(_) => abort("Components must be rendered to VNode before SSR")
  }
}

///|

///|
/// Render element to HTML string
fn render_element_to_string(
  tag : String,
  props : Props,
  children : Array[VNode],
) -> String {
  let mut html = "<" + tag

  // Add props as attributes
  let attrs = props_to_attributes(props)
  if attrs != "" {
    html = html + " " + attrs
  }
  html = html + ">"

  // Void elements don't have closing tags
  if is_void_element(tag) {
    return html
  }

  // Add children
  for child in children {
    html = html + render_to_string(child)
  }
  html = html + "</" + tag + ">"
  html
}

///|

///|
/// Convert props to HTML attributes string
fn props_to_attributes(props : Props) -> String {
  let mut attrs = ""
  let mut first = true
  for i = 0; i < props.length(); i = i + 1 {
    let (key, value) = props[i]
    match value {
      Str(s) =>
        // Handle className specially - convert to "class"
        if key == "className" {
          if not(first) {
            attrs = attrs + " "
          }
          attrs = attrs + "class=\"" + escape_html(s) + "\""
          first = false
        } else {
          if not(first) {
            attrs = attrs + " "
          }
          attrs = attrs + key + "=\"" + escape_html(s) + "\""
          first = false
        }
      Num(n) => {
        if not(first) {
          attrs = attrs + " "
        }
        attrs = attrs + key + "=\"" + n.to_string() + "\""
        first = false
      }
      Bool(b) =>
        // Boolean attributes: only add attribute name if true
        if b {
          if not(first) {
            attrs = attrs + " "
          }
          attrs = attrs + key
          first = false
        }
      Handler(_) =>
        // Skip event handlers in SSR
        continue
      StyleObj(styles) => {
        let style_str = style_array_to_string(styles)
        if style_str != "" {
          if not(first) {
            attrs = attrs + " "
          }
          attrs = attrs + "style=\"" + style_str + "\""
          first = false
        }
      }
    }
  }
  attrs
}

///|

///|
/// Convert style array to CSS string
fn style_array_to_string(styles : Array[(String, String)]) -> String {
  let mut css = ""
  let mut first = true
  for i = 0; i < styles.length(); i = i + 1 {
    let (key, value) = styles[i]
    if not(first) {
      css = css + "; "
    }
    css = css + key + ": " + value
    first = false
  }
  css
}

///|

///|
/// HTML escape - manually iterate to replace all occurrences
fn escape_html(text : String) -> String {
  let mut result = ""
  let iter = text.iter()
  for char in iter {
    match char {
      '&' => result = result + "&amp;"
      '<' => result = result + "&lt;"
      '>' => result = result + "&gt;"
      '"' => result = result + "&quot;"
      '\'' => result = result + "&#39;"
      _ => result = result + char.to_string()
    }
  }
  result
}

///|

///|
/// Check if tag is a void element (self-closing)
fn is_void_element(tag : String) -> Bool {
  tag == "area" ||
  tag == "base" ||
  tag == "br" ||
  tag == "col" ||
  tag == "embed" ||
  tag == "hr" ||
  tag == "img" ||
  tag == "input" ||
  tag == "link" ||
  tag == "meta" ||
  tag == "param" ||
  tag == "source" ||
  tag == "track" ||
  tag == "wbr"
}
