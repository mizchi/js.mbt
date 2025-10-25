///|
using @js {type Value}

///|
extern "js" fn create_element_raw(
  tag : @js.Value,
  props : @js.Value,
  children : @js.Value,
) -> @js.Value =
  #| (tag, props, children) => {
  #|   return ReactLib.createElement(tag, props, ...children)
  #| }

///|
pub extern "js" fn create_component_raw(
  f : (@js.Value) -> VirtualElement,
) -> @js.Value =
  #| (f) => (...args) => f(...args)

///|
extern "js" fn render_internal(vdom : @js.Value, parent : @js.Value) -> Unit =
  #| (vdom, parent) => ReactLib.render(vdom, parent)

///|
pub fn render(vdom : VirtualElement, parent : @dom.Element) -> Unit {
  render_internal(vdom |> @js.identity, parent.to_js_value())
}

///|
pub type Component[T]

///|
#external
pub type VirtualElement

///|
pub fn VirtualElement::from_js_value(v : @js.Value) -> Self = "%identity"

///|
pub impl @js.ToJsValue for VirtualElement with to_js(self) -> @js.Value {
  self |> @js.identity
}

///|
pub fn h(
  tag : String,
  props : Map[String, @js.Value],
  children : Array[&@js.ToJsValue],
  ref_? : ReactRef[&@js.ToJsValue],
  key? : String,
) -> VirtualElement {
  let tag = @js.Value::cast_from(tag)
  let children = @js.Value::from_array(children)
  let val = @js.Value::new_object()
  for k, v in props {
    val[k] = v
  }
  if ref_ is Some(ref_) {
    val["ref"] = ref_ |> @js.Value::cast_from
  }
  if key is Some(key) {
    val["key"] = key
  }
  create_element_raw(tag, val, children) |> @js.identity
}

///|
pub fn[T] c(
  tag : Component[T],
  props : T,
  children? : Array[&@js.ToJsValue],
  key? : String,
) -> VirtualElement {
  let tag = @js.Value::cast_from(tag)
  let children = @js.Value::from_array(children.unwrap_or([]))
  let val : @js.Value = props |> @js.identity
  if key is Some(key) {
    val["key"] = key
  }
  create_element_raw(tag, val, children) |> @js.identity
}

///|
pub fn[T] component(f : (T) -> VirtualElement) -> Component[T] {
  create_component_raw(props => props |> @js.identity |> f) |> @js.identity
}
