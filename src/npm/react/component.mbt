///|
pub(all) struct EmptyProps {} derive(Default)

///|
pub type Component[T] = (T) -> Element

///|
/// render component
/// JS: React.createElement(component, props, ...children)
#alias(c)
pub fn[T] component(
  tag : Component[T],
  props : T,
  children? : Array[&ReactNode] = [],
  key? : String,
) -> Element {
  let tag = @js.identity(tag)
  let children = children.map(_.to_react_node()) |> @js.from_array
  let val : @js.Js = props |> @js.identity
  if key is Some(key) {
    val.set("key", key)
  }
  ffi_create_element(tag, val, children) |> @js.identity
}

///|
/// JS: <React.Fragment key=...>{children}</React.Fragment>
pub fn strict_mode(children : Array[&ReactNode]) -> Element {
  let tag = @js.identity(get_strict_mode())
  let children = children.map(_.to_react_node()) |> @js.from_array
  ffi_create_element(tag, @js.undefined(), children) |> @js.identity
}

///|
/// JS: <React.Fragment key=...>{children}</React.Fragment>
pub fn fragment(children : Array[&ReactNode], key? : String) -> Element {
  let tag = @js.identity(get_fragment())
  let children = children.map(_.to_react_node()) |> @js.from_array
  let val = @js.Object::new()
  if key is Some(key) {
    val.set("key", key)
  }
  ffi_create_element(tag, val.to_js(), children) |> @js.identity
}

///|
/// JS: <React.Suspense fallback=...>{children}</React.Suspense>
pub fn suspense(children : Array[&ReactNode], fallback~ : Element) -> Element {
  let tag = get_suspense() |> @js.identity
  let children = children.map(_.to_react_node()) |> @js.from_array
  let props = @js.from_map({ "fallback": fallback |> @js.identity })
  @js.identity(ffi_create_element(tag, props, children))
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
  let props = @js.from_map({ "value": value |> @js.identity })
  @js.identity(ffi_create_element(tag |> @js.identity, props, children))
}
