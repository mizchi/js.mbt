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
) -> Element {
  let tag = js(tag)
  let children = @val.from_builtin_array(children)
  let val : Val = @val.new_object()
  if attributes is Some(props) {
    for k, v in props {
      val[k] = v
    }
  }
  if ref_ is Some(ref_) {
    val["ref"] = ref_ |> js
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
    val["disabled"] = disabled |> js
  }
  if style is Some(style) {
    let style_obj : Val = @val.new_object()
    for k, v in style {
      style_obj[k] = js(v)
    }
    val["style"] = style_obj
  }
  if on_click is Some(v) {
    let f : Val = v |> js
    val["onClick"] = f
  }
  if on_change is Some(on_change) {
    let f : Val = on_change |> js
    val["onChange"] = f
  }
  if on_keydown is Some(on_keydown) {
    let f : Val = on_keydown |> js
    val["onKeyDown"] = f
  }
  if on_keyup is Some(on_keyup) {
    let f : Val = on_keyup |> js
    val["onKeyUp"] = f
  }
  ffi_create_element(tag, val, children) |> unsafe_cast
}

///|
pub fn[T] c(
  tag : (T) -> Element,
  props : T,
  children? : Array[&Js],
  key? : String,
) -> Element {
  let tag = js(tag)
  let children = @val.from_builtin_array(children.unwrap_or([]))
  let val : Val = props |> js
  if key is Some(key) {
    val["key"] = key
  }
  ffi_create_element(tag, val, children) |> unsafe_cast
}

///|
pub fn fragment(children : Array[&Js], key? : String) -> Element {
  let tag = js(get_fragment())
  let children = @val.from_builtin_array(children)
  let val : Val = @val.new_object()
  if key is Some(key) {
    val["key"] = key
  }
  ffi_create_element(tag, val, children) |> unsafe_cast
}

///|
pub fn suspense(children : Array[&Js], fallback~ : Element) -> Element {
  let tag = get_suspense() |> js
  let children = @val.from_builtin_array(children)
  let val : Val = @val.new_object()
  val["fallback"] = fallback |> js
  ffi_create_element(tag, val, children).cast()
}

///|
pub fn[T] provider(
  tag : Context[T],
  children : Array[&Js],
  value~ : T,
) -> Element {
  let tag = js(tag)
  let children = @val.from_builtin_array(children)
  let props = @val.new_object()
  props["value"] = value |> js
  ffi_create_element(tag, props, children).cast()
}
