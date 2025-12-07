///| DOM Renderer - Render VNode to actual DOM

///|

///|
/// DOM Renderer - manages rendering VNode to container element
pub struct DomRenderer {
  container : @dom.Element
  mut root_vnode : VNode?
  mut root_node : @dom.Node?
}

///|

///|
/// Create new DOM renderer
pub fn DomRenderer::new(container : @dom.Element) -> DomRenderer {
  { container, root_vnode: None, root_node: None }
}

///|

///|
/// Render VNode to container (Phase 4: Uses reconciliation for updates)
pub fn DomRenderer::render(self : DomRenderer, vnode : VNode) -> Unit {
  match self.root_vnode {
    None => {
      // Initial render - create new DOM tree
      self.container.as_node().setTextContent("")
      match vnode {
        Fragment(_) => {
          // For fragments, add children directly to container
          // and track container as root_node
          let dom_node = create_dom_node(vnode)
          self.container.as_node().appendChild(dom_node) |> ignore
          self.root_vnode = Some(vnode)
          self.root_node = Some(self.container.as_node())
        }
        _ => {
          let dom_node = create_dom_node(vnode)
          self.container.as_node().appendChild(dom_node) |> ignore
          self.root_vnode = Some(vnode)
          self.root_node = Some(dom_node)
        }
      }
    }
    Some(old_vnode) => {
      // Update - use reconciliation
      let patches = diff(
        Some(old_vnode),
        Some(vnode),
        self.root_node,
        Some(self.container.as_node()),
      )
      apply_patches(patches)
      self.root_vnode = Some(vnode)
    }
  }
}

///|

///|
/// Create DOM node from VNode
fn create_dom_node(vnode : VNode) -> @dom.Node {
  match vnode {
    Empty => @dom.document().createTextNode("").as_node()
    Text(content) => @dom.document().createTextNode(content).as_node()
    Element({ tag, props, children, .. }) => {
      let element = @dom.document().createElement(tag)
      apply_props(element, props)
      for child in children {
        let child_node = create_dom_node(child)
        element.as_node().appendChild(child_node) |> ignore
      }
      element.as_node()
    }
    Fragment(children) => {
      let fragment = @dom.document().createDocumentFragment()
      for child in children {
        let child_node = create_dom_node(child)
        fragment.as_node().appendChild(child_node) |> ignore
      }
      fragment.as_node()
    }
    Component(_) =>
      abort("Components must be rendered to VNode before DOM rendering")
  }
}

///|

///|
/// Apply props to DOM element (using typed Props)
fn apply_props(element : @dom.Element, props : Props) -> Unit {
  for i = 0; i < props.length(); i = i + 1 {
    let (key, value) = props[i]
    match value {
      Str(s) =>
        // Handle className specially
        if key == "className" {
          element.setClassName(s)
        } else {
          element.setAttribute(key, s)
        }
      Num(n) =>
        // Numeric attributes (tabIndex, maxLength, etc.)
        element.setAttribute(key, n.to_string())
      Bool(b) =>
        // Boolean attributes (disabled, checked, etc.)
        if b {
          element.setAttribute(key, "")
        } else {
          element.removeAttribute(key)
        }
      Handler(h) =>
        // Event handlers (onClick, onChange, etc.)
        set_event_handler(element, key, h)
      StyleObj(styles) =>
        // Style object
        apply_style(element, styles)
    }
  }
}

///|

///|
/// Set event handler on element
fn set_event_handler(
  element : @dom.Element,
  event_name : String,
  handler : EventHandler,
) -> Unit {
  // Convert "onClick" to "click", "onChange" to "change"
  // Simply lowercase the entire event name after removing "on" prefix
  let event_type = if event_name.length() >= 2 {
    let mut result = ""
    let iter = event_name.iter()
    let mut skip_count = 0
    for char in iter {
      if skip_count < 2 {
        // Skip "on" prefix
        skip_count = skip_count + 1
        continue
      }
      // Convert uppercase to lowercase
      let lower_char = if char >= 'A' && char <= 'Z' {
        (char.to_int() + 32).unsafe_to_char()
      } else {
        char
      }
      result = result + lower_char.to_string()
    }
    result
  } else {
    event_name
  }

  // Use addEventListener
  let handler_any : @core.Any = @core.any(handler)
  element.as_event_target().addEventListener(event_type, handler_any.cast())
}

///|

///|
/// Apply style object to element
fn apply_style(
  element : @dom.Element,
  styles : Array[(String, String)],
) -> Unit {
  let style_prop : @core.Any = element.as_any()._get("style")
  for i = 0; i < styles.length(); i = i + 1 {
    let (key, value) = styles[i]
    style_prop._set(key, @core.any(value)) |> ignore
  }
}
