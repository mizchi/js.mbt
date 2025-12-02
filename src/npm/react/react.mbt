///|
/// React.Element
#external
pub type Element

///|
pub fn Element::as_any(self : Element) -> @core.Any = "%identity"

///|
#alias(h)
pub fn createElement(
  tag : String,
  children : Array[&ReactNode],
  props? : Map[String, @core.Any],
  style? : Map[String, String],
  ref_? : ReactRef[@dom.Element],
  key? : String,
) -> Element {
  let tag = @core.any(tag)
  let children = @core.any(children.map(_.to_react_node()))
  let val = @core.new_object()
  if props is Some(props) {
    for k, v in props {
      val[k] = v
    }
  }
  if ref_ is Some(ref_) {
    val["ref"] = ref_.as_any()
  }
  if key is Some(key) {
    val["key"] = @core.any(key)
  }
  if style is Some(style) {
    let style_obj = @core.new_object()
    for k, v in style {
      style_obj[k] = @core.any(v)
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
  props : @core.Any,
  children : @core.Any,
) -> Element {
  ffi_create_element(@core.any(tag), props, children).cast()
}
