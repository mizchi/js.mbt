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
  name? : String,
) -> @js.Value =
  #| (f, name) => {
  #|   const x = (...args) => f(...args)
  #|   if (name) {
  #|     Object.defineProperty(x, "name", { value: name })
  #|   }
  #|   return x
  #| }

///|
extern "js" fn render_internal(vdom : @js.Value, parent : @js.Value) -> Unit =
  #| (vdom, parent) => __ReactApi.render(vdom, parent)

///|
pub fn render(vdom : VirtualElement, parent : @dom.Element) -> Unit {
  render_internal(vdom |> @js.identity, parent.to_js_value())
}

///|
#external
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
  disabled? : Bool,
  attributes? : Map[String, @js.Value],
  children : Array[&@js.ToJsValue],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  ref_? : ReactRef[@dom.Element],
  key? : String,
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let tag = @js.Value::cast_from(tag)
  let children = @js.Value::from_array(children)
  let val : @js.Value = @js.new_object()
  if attributes is Some(props) {
    for k, v in props {
      val[k] = v
    }
  }
  if ref_ is Some(ref_) {
    val["ref"] = ref_ |> @js.Value::cast_from
  }
  if key is Some(key) {
    val["key"] = key
  }
  if id is Some(id) {
    val["id"] = id
  }
  if class is Some(class) {
    val["className"] = class
  }
  if className is Some(className) {
    val["className"] = className
  }
  if disabled is Some(disabled) {
    val["disabled"] = disabled |> @js.Value::cast_from
  }
  if style is Some(style) {
    let style_obj : @js.Value = @js.new_object()
    for k, v in style {
      style_obj[k] = @js.Value::cast_from(v)
    }
    val["style"] = style_obj
  }
  if on_click is Some(v) {
    let f : @js.Value = v |> @js.identity
    val["onClick"] = f
  }
  if on_change is Some(on_change) {
    let f : @js.Value = on_change |> @js.identity
    val["onChange"] = f
  }
  if on_keydown is Some(on_keydown) {
    let f : @js.Value = on_keydown |> @js.identity
    val["onKeyDown"] = f
  }
  if on_keyup is Some(on_keyup) {
    let f : @js.Value = on_keyup |> @js.identity
    val["onKeyUp"] = f
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
  let val : @js.Value = @js.new_object() |> @js.identity
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
  let val : @js.Value = @js.new_object() |> @js.identity
  val["fallback"] = fallback |> @js.Value::cast_from
  create_element_raw(tag, val, children) |> @js.identity
}

///|
pub fn[T] provider(
  tag : Context[T],
  children : Array[&@js.ToJsValue],
  value~ : T,
) -> VirtualElement {
  let tag = @js.Value::cast_from(tag)
  let children = @js.Value::from_array(children)
  let val : @js.Value = value |> @js.identity
  let props = @js.new_object()
  props["value"] = val
  create_element_raw(tag, props, children) |> @js.identity
}

///|
/// Examples
/// ```nocheck
/// /// Define props
/// struct MyProps {
///   name : String
/// }
/// let my_component : Component[MyProps] = component(props => {
///   let (cnt, set_cnt) = use_state(0)
///   h("div", [
///     "Hello, \{props.name}!",
///     h("button", on_click=(_) => set_cnt(cnt + 1), [cnt.to_string()]),
///   ])
/// })
/// c(my_component, MyProps::{ name: "Moonbit" })
/// ```
pub fn[T] component(f : (T) -> VirtualElement, name? : String) -> Component[T] {
  let f2 = props => props |> @js.identity |> f
  create_component_raw(f2, name?) |> @js.identity
}
