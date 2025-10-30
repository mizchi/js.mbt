///|
pub(all) struct EmptyProps {}

///|
extern "js" fn ffi_create_element(
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
#external
pub type Component[T]

///|
/// React.Element
#external
pub type Element

///|
pub fn Element::from_js_value(v : @js.Value) -> Self = "%identity"

///|
pub impl @js.ToJs for Element with to_js(self) -> @js.Value {
  self |> @js.identity
}

///|
pub fn create_element(
  tag : String,
  children : Array[&@js.ToJs],
  disabled? : Bool,
  attributes? : Map[String, @js.Value],
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
) -> Element {
  let tag = @js.to_js(tag)
  let children = @js.Value::from_array(children)
  let val : @js.Value = @js.new_object()
  if attributes is Some(props) {
    for k, v in props {
      val[k] = v
    }
  }
  if ref_ is Some(ref_) {
    val["ref"] = ref_ |> @js.to_js
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
    val["disabled"] = disabled |> @js.to_js
  }
  if style is Some(style) {
    let style_obj : @js.Value = @js.new_object()
    for k, v in style {
      style_obj[k] = @js.to_js(v)
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
  ffi_create_element(tag, val, children) |> @js.identity
}

///|
pub fnalias create_element as h

///|
pub fn[T] c(
  tag : (T) -> Element,
  props : T,
  children? : Array[&@js.ToJs],
  key? : String,
) -> Element {
  let tag = @js.to_js(tag)
  let children = @js.Value::from_array(children.unwrap_or([]))
  let val : @js.Value = props |> @js.identity
  if key is Some(key) {
    val["key"] = key
  }
  ffi_create_element(tag, val, children) |> @js.identity
}

///|
pub fn fragment(children : Array[&@js.ToJs], key? : String) -> Element {
  let tag = @js.to_js(get_fragment())
  let children = @js.Value::from_array(children)
  let val : @js.Value = @js.new_object() |> @js.identity
  if key is Some(key) {
    val["key"] = key
  }
  ffi_create_element(tag, val, children) |> @js.identity
}

///|
pub fn suspense(children : Array[&@js.ToJs], fallback~ : Element) -> Element {
  let tag = get_suspense() |> @js.to_js
  let children = @js.Value::from_array(children)
  let val : @js.Value = @js.new_object() |> @js.to_js
  val["fallback"] = fallback |> @js.to_js
  ffi_create_element(tag, val, children).cast()
}

///|
pub fn[T] provider(
  tag : Context[T],
  children : Array[&@js.ToJs],
  value~ : T,
) -> Element {
  let tag = @js.to_js(tag)
  let children = @js.Value::from_array(children)
  let props = @js.new_object()
  props["value"] = value |> @js.to_js
  ffi_create_element(tag, props, children).cast()
}
