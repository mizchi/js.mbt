///|
pub(all) struct EmptyProps {} derive(Default)

///|
extern "js" fn ffi_create_element(
  tag : Val,
  props : Val,
  children : Val,
) -> Val =
  #|(tag, props, children) => {
  #|  return __ReactApi.createElement(tag, props, ...children)
  #|}

///|
extern "js" fn get_fragment() -> Component[EmptyProps] =
  #| () => __ReactApi.Fragment

///|
extern "js" fn get_suspense() -> Val =
  #| () => __ReactApi.Suspense

///|
#external
pub type Component[T]

///|
pub type ComponentFn[T] = (T) -> Element

///|
/// React.Element
#external
pub type Element

///|
pub impl Js for Element with to_js(self) -> Val {
  self |> js
}

///|
#alias(h)
pub fn create_element(
  tag : String,
  children : Array[&Js],
  disabled? : Bool,
  attributes? : Map[String, Val],
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
  on_drag? : (@dom.DragEvent) -> Unit,
  on_dragstart? : (@dom.DragEvent) -> Unit,
  on_dragend? : (@dom.DragEvent) -> Unit,
  on_dragleave? : (@dom.DragEvent) -> Unit,
  on_dragenter? : (@dom.DragEvent) -> Unit,
  on_dragover? : (@dom.DragEvent) -> Unit,
  on_drop? : (@dom.DragEvent) -> Unit,
) -> Element {
  let tag = js(tag)
  let children = children.map(_.to_js()) |> @js.from_builtin_array
  let val : Val = @js.new_empty_object()
  if attributes is Some(props) {
    for k, v in props {
      val.set(k, v)
    }
  }
  if ref_ is Some(ref_) {
    val.set("ref", ref_ |> js)
  }
  if key is Some(key) {
    val.set("key", key)
  }
  if id is Some(id) {
    val.set("id", id)
  }
  if class is Some(class) {
    val.set("className", class)
  }
  if className is Some(className) {
    val.set("className", className)
  }
  if disabled is Some(disabled) {
    val.set("disabled", disabled |> js)
  }
  if style is Some(style) {
    let style_obj : Val = @js.new_empty_object()
    for k, v in style {
      style_obj.set(k, js(v))
    }
    val.set("style", style_obj)
  }
  if on_click is Some(v) {
    val.set("onClick", v |> js)
  }
  if on_change is Some(on_change) {
    val.set("onChange", on_change |> js)
  }
  if on_keydown is Some(on_keydown) {
    val.set("onKeyDown", on_keydown |> js)
  }
  if on_keyup is Some(on_keyup) {
    val.set("onKeyUp", on_keyup |> js)
  }
  if on_drag is Some(v) {
    val.set("onDrag", v |> js)
  }
  if on_dragstart is Some(v) {
    val.set("onDragStart", v |> js)
  }
  if on_dragend is Some(v) {
    val.set("onDragStart", v |> js)
  }
  if on_drop is Some(v) {
    val.set("onDragStart", v |> js)
  }
  if on_dragover is Some(v) {
    val.set("onDragOver", v |> js)
  }
  if on_dragleave is Some(v) {
    val.set("onDragLeave", v |> js)
  }
  if on_dragenter is Some(v) {
    val.set("onDragEnter", v |> js)
  }
  unsafe_cast(ffi_create_element(tag, val, children))
}

///|
/// render component
#alias(component)
pub fn[T] c(
  tag : ComponentFn[T],
  props : T,
  children? : Array[&Js] = [],
  key? : String,
) -> Element {
  let tag = js(tag)
  let children = children.map(_.to_js())
  let val : Val = props |> js
  if key is Some(key) {
    val.set("key", key)
  }
  ffi_create_element(tag, val, children |> @js.from_builtin_array())
  |> unsafe_cast
}

///|
pub fn fragment(children : Array[&Js], key? : String) -> Element {
  let tag = js(get_fragment())
  let children = @js.from_builtin_array(children.map(_.to_js()))
  let val : Val = @js.new_empty_object()
  if key is Some(key) {
    val.set("key", key)
  }
  ffi_create_element(tag, val, children) |> unsafe_cast
}

///|
pub fn suspense(children : Array[&Js], fallback~ : Element) -> Element {
  let tag = get_suspense() |> js
  let children = @js.from_builtin_array(children.map(_.to_js()))
  let props = @js.from_builtin_map({ "fallback": fallback |> js })
  unsafe_cast(ffi_create_element(tag, props, children))
}

///|
pub fn[T] provider(
  tag : Context[T],
  children : Array[&Js],
  value~ : T,
) -> Element {
  let tag = js(tag)
  let children = @js.from_builtin_array(children.map(_.to_js()))
  let props = @js.from_builtin_map({ "value": value |> js })
  unsafe_cast(ffi_create_element(tag, props, children))
}
