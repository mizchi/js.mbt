///|
/// React.Element
#external
pub type Element

///|
pub impl @js.JsImpl for Element

///|
#alias(h)
pub fn createElement(
  tag : String,
  children : Array[&ReactNode],
  props? : Map[String, @js.Any],
  style? : Map[String, String],
  ref_? : ReactRef[@dom.Element],
  key? : String,
) -> Element {
  let tag = @js.js(tag)
  let children = children.map(_.to_react_node()) |> @js.from_array
  let val = @js.Object::new()
  if props is Some(props) {
    for k, v in props {
      val.set(k, v)
    }
  }
  if ref_ is Some(ref_) {
    val.set("ref", ref_ |> @js.js)
  }
  if key is Some(key) {
    val.set("key", key)
  }
  if style is Some(style) {
    let style_obj = @js.Object::new()
    for k, v in style {
      style_obj.set(k, v)
    }
    val.set("style", style_obj)
  }
  @js.identity(ffi_create_element(tag, val.to_js(), children))
}

///|
/// Intenal FFI to create React element
/// Directly create a React element with given tag, props, and children.
pub fn createElementDirect(
  tag : String,
  props : @js.Any,
  children : @js.Any,
) -> Element {
  @js.identity(ffi_create_element(tag |> @js.js, props, children))
}
