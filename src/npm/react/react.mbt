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
pub fn createElement(
  tag : String,
  children : Array[&Js],
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

///|
/// render component
#alias(c)
pub fn[T] component(
  tag : ComponentFn[T],
  props : T,
  children? : Array[&Js] = [],
  key? : String,
) -> Element {
  let tag = unsafe_cast(tag)
  let children = @js.from_array(children)
  let val : Val = props |> unsafe_cast
  if key is Some(key) {
    val.set("key", key)
  }
  ffi_create_element(tag, val, children) |> unsafe_cast
}

///|
pub fn fragment(children : Array[&Js], key? : String) -> Element {
  let tag = unsafe_cast(get_fragment())
  let children = @js.from_array(children)
  let val = @js.Object::new()
  if key is Some(key) {
    val.set("key", key)
  }
  ffi_create_element(tag, val.to_js(), children) |> unsafe_cast
}

///|
pub fn suspense(children : Array[&Js], fallback~ : Element) -> Element {
  let tag = get_suspense() |> unsafe_cast
  let children = @js.from_array(children)
  let props = @js.from_map({ "fallback": fallback |> unsafe_cast })
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
