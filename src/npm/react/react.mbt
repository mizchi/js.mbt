///|
/// React.Element
#external
pub type Element

///|
pub fn Element::as_any(self : Element) -> @nostd.Any = "%identity"

///|
#alias(h)
pub fn createElement(
  tag : String,
  children : Array[&ReactNode],
  props? : Map[String, @nostd.Any],
  style? : Map[String, String],
  ref_? : ReactRef[@dom.Element],
  key? : String,
) -> Element {
  let tag = @nostd.any(tag)
  let children = @nostd.any(children.map(_.to_react_node()))
  let val = @nostd.Object::new()
  if props is Some(props) {
    for k, v in props {
      val[k] = v
    }
  }
  if ref_ is Some(ref_) {
    val["ref"] = ref_.as_any()
  }
  if key is Some(key) {
    val["key"] = @nostd.any(key)
  }
  if style is Some(style) {
    let style_obj = @nostd.Object::new()
    for k, v in style {
      style_obj[k] = @nostd.any(v)
    }
    val["style"] = style_obj
  }
  ffi_create_element(tag, val, children).cast()
}

///|
/// Intenal FFI to create React element
/// Directly create a React element with given tag, props, and children.
pub fn createElementDirect(
  tag : String,
  props : @nostd.Any,
  children : @nostd.Any,
) -> Element {
  ffi_create_element(@nostd.any(tag), props, children).cast()
}
