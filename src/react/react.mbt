///|
using @js {type Value}

///|
pub struct EmptyProps {} derive(Eq)

///|
pub fn EmptyProps::new() -> Self {
  EmptyProps::{  }
}

///|
extern "js" fn create_element_raw(
  tag : @js.Value,
  props : @js.Value,
  children : @js.Value,
) -> @js.Value =
  #| (tag, props, children) => {
  #|   return __ReactApi.createElement(tag, props, ...children)
  #| }

///|
extern "js" fn get_fragment() -> Component[EmptyProps] =
  #| () => __ReactApi.Fragment

///|
extern "js" fn get_suspense() -> @js.Value =
  #| () => __ReactApi.Suspense

///|
pub extern "js" fn create_component_raw(
  f : (@js.Value) -> VirtualElement,
) -> @js.Value =
  #| (f) => (...args) => f(...args)

///|
extern "js" fn render_internal(vdom : @js.Value, parent : @js.Value) -> Unit =
  #| (vdom, parent) => __ReactApi.render(vdom, parent)

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
pub fn fragment(
  children : Array[&@js.ToJsValue],
  key? : String,
) -> VirtualElement {
  let tag = @js.Value::cast_from(get_fragment())
  let children = @js.Value::from_array(children)
  let val : @js.Value = @js.Value::new_object() |> @js.identity
  if key is Some(key) {
    val["key"] = key
  }
  create_element_raw(tag, val, children) |> @js.identity
}

///|
pub fn suspense(
  children : Array[&@js.ToJsValue],
  fallback~ : VirtualElement,
) -> VirtualElement {
  let tag = get_suspense() |> @js.Value::cast_from
  let children = @js.Value::from_array(children)
  let val : @js.Value = @js.Value::new_object() |> @js.identity
  val["fallback"] = fallback |> @js.Value::cast_from
  create_element_raw(tag, val, children) |> @js.identity
}

///|
pub fn[T] provider(
  tag : Context[T],
  props : T,
  children : Array[&@js.ToJsValue],
  key? : String,
) -> VirtualElement {
  let tag = @js.Value::cast_from(tag)
  let children = @js.Value::from_array(children)
  let val : @js.Value = props |> @js.identity
  if key is Some(key) {
    val["key"] = key
  }
  let props = @js.Value::new_object()
  props["value"] = val
  create_element_raw(tag, props, children) |> @js.identity
}

///|
pub fn[T] component(f : (T) -> VirtualElement) -> Component[T] {
  create_component_raw(props => props |> @js.identity |> f) |> @js.identity
}

///|
pub fn props(
  id? : String,
  class? : String,
  style? : Map[String, String],
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> Map[String, @js.Value] {
  let props : Map[String, @js.Value] = Map::new()
  if id is Some(id) {
    props["id"] = id |> @js.identity
  }
  if class is Some(class) {
    props["className"] = class |> @js.identity
  }
  if style is Some(style) {
    let style_obj : @js.Value = @js.Value::new_object()
    for k, v in style {
      style_obj[k] = v |> @js.identity
    }
    props["style"] = style_obj
  }
  if on_click is Some(on_click) {
    props["onClick"] = on_click |> @js.identity
  }
  if on_change is Some(on_change) {
    props["onChange"] = on_change |> @js.identity
  }
  if on_keydown is Some(on_keydown) {
    props["onKeyDown"] = on_keydown |> @js.identity
  }
  if on_keyup is Some(on_keyup) {
    props["onKeyUp"] = on_keyup |> @js.identity
  }
  props
}
