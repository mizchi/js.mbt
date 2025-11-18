///|
/// React.Element
#external
pub type Element

///|
pub impl JsImpl for Element

///|
#alias(h)
pub fn createElement(
  tag : String,
  children : Array[&JsImpl],
  props? : Map[String, Val],
  style? : Map[String, String],
  ref_? : ReactRef[@dom.Element],
  key? : String,
) -> Element {
  let tag = safe_js(tag)
  let children = children.map(_.to_js()) |> @js.from_array
  let val = @js.Object::new()
  if props is Some(props) {
    for k, v in props {
      val.set(k, v)
    }
  }
  if ref_ is Some(ref_) {
    val.set("ref", ref_ |> safe_js)
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
  unsafe_cast(ffi_create_element(tag, val.to_js(), children))
}
