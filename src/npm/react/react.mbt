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
pub impl Js for Element

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
  let children = children.map(_.to_js()) |> @js.from_array
  let val = @js.Object::new()
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
    let style_obj = @js.Object::new()
    for k, v in style {
      style_obj.set(k, v)
    }
    val.set("style", style_obj)
  }
  if on_click is Some(v) {
    val.set("onClick", v |> @js.from_fn1)
  }
  if on_change is Some(on_change) {
    val.set("onChange", on_change |> @js.from_fn1)
  }
  if on_keydown is Some(on_keydown) {
    val.set("onKeyDown", on_keydown |> @js.from_fn1)
  }
  if on_keyup is Some(on_keyup) {
    val.set("onKeyUp", on_keyup |> @js.from_fn1)
  }
  if on_drag is Some(v) {
    val.set("onDrag", v |> @js.from_fn1)
  }
  if on_dragstart is Some(v) {
    val.set("onDragStart", v |> @js.from_fn1)
  }
  if on_dragend is Some(v) {
    val.set("onDragStart", v |> @js.from_fn1)
  }
  if on_drop is Some(v) {
    val.set("onDragStart", v |> @js.from_fn1)
  }
  if on_dragover is Some(v) {
    val.set("onDragOver", v |> @js.from_fn1)
  }
  if on_dragleave is Some(v) {
    val.set("onDragLeave", v |> @js.from_fn1)
  }
  if on_dragenter is Some(v) {
    val.set("onDragEnter", v |> @js.from_fn1)
  }
  unsafe_cast(ffi_create_element(tag, val.to_js(), children))
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
  let children = @js.from_array(children)
  let val : Val = props |> js
  if key is Some(key) {
    val.set("key", key)
  }
  ffi_create_element(tag, val, children) |> unsafe_cast
}

///|
pub fn fragment(children : Array[&Js], key? : String) -> Element {
  let tag = js(get_fragment())
  let children = @js.from_array(children)
  let val = @js.Object::new()
  if key is Some(key) {
    val.set("key", key)
  }
  ffi_create_element(tag, val.to_js(), children) |> unsafe_cast
}

///|
pub fn suspense(children : Array[&Js], fallback~ : Element) -> Element {
  let tag = get_suspense() |> js
  let children = @js.from_array(children)
  let props = @js.from_map({ "fallback": fallback |> js })
  unsafe_cast(ffi_create_element(tag, props, children))
}

///|
pub fn[T] provider(
  tag : Context[T],
  children : Array[&Js],
  value~ : T,
) -> Element {
  let children = @js.from_array(children)
  let props = @js.from_map({ "value": value |> unsafe_cast })
  unsafe_cast(ffi_create_element(tag |> unsafe_cast, props, children))
}
