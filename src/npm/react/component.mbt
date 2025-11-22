///|
pub(all) struct EmptyProps {} derive(Default)

///|
#external
pub type Component[T]

///|
pub type ComponentFn[T] = (T) -> Element

///|
/// render component
/// JS: React.createElement(component, props, ...children)
#alias(c)
pub fn[T] component(
  tag : ComponentFn[T],
  props : T,
  children? : Array[&ReactNode] = [],
  key? : String,
) -> Element {
  let tag = unsafe_cast(tag)
  let children = children.map(_.to_react_node()) |> @js.from_array
  let val : Js = props |> unsafe_cast
  if key is Some(key) {
    val.set("key", key)
  }
  ffi_create_element(tag, val, children) |> unsafe_cast
}

///|
/// JS: <React.Fragment key=...>{children}</React.Fragment>
pub fn strict_mode(children : Array[&ReactNode]) -> Element {
  let tag = unsafe_cast(get_strict_mode())
  let children = children.map(_.to_react_node()) |> @js.from_array
  ffi_create_element(tag, @js.undefined(), children) |> unsafe_cast
}

///|
/// JS: <React.Fragment key=...>{children}</React.Fragment>
pub fn fragment(children : Array[&ReactNode], key? : String) -> Element {
  let tag = unsafe_cast(get_fragment())
  let children = children.map(_.to_react_node()) |> @js.from_array
  let val = @js.Object::new()
  if key is Some(key) {
    val.set("key", key)
  }
  ffi_create_element(tag, val.to_js(), children) |> unsafe_cast
}

///|
/// JS: <React.Suspense fallback=...>{children}</React.Suspense>
pub fn suspense(children : Array[&ReactNode], fallback~ : Element) -> Element {
  let tag = get_suspense() |> unsafe_cast
  let children = children.map(_.to_react_node()) |> @js.from_array
  let props = @js.from_map({ "fallback": fallback |> unsafe_cast })
  unsafe_cast(ffi_create_element(tag, props, children))
}

///|
/// React.Provider
/// JS: <Context.Provider value=...>{children}</Context.Provider>
pub fn[T] provider(
  tag : Context[T],
  children : Array[&ReactNode],
  value~ : T,
) -> Element {
  let children = children.map(_.to_react_node()) |> @js.from_array
  let props = @js.from_map({ "value": value |> unsafe_cast })
  unsafe_cast(ffi_create_element(tag |> unsafe_cast, props, children))
}
