///|
/// Preact.VNode - Virtual DOM node
#external
pub type VNode

///|
pub impl @js.JsImpl for VNode

///|
/// Component function type
pub type Component[T] = (T) -> VNode

///|
/// Preact.Ref<T>
pub(all) struct Ref[T] {
  current : @js.Any
}

///|
pub fn[T] Ref::get_current(self : Ref[T]) -> T? {
  @js.identity_option(self.current)
}

///|
pub fn[T] Ref::set_current(self : Ref[T], value : T?) -> Unit {
  let js_val : @js.Any = match value {
    Some(v) => @js.identity(v)
    None => @js.undefined()
  }
  ffi_set_ref_current(self |> @js.identity, js_val)
}

///|
extern "js" fn ffi_set_ref_current(ref_obj : @js.Any, value : @js.Any) -> Unit =
  #|(ref, value) => { ref.current = value; }

///|
pub impl[T] @js.JsImpl for Ref[T]

///|
/// Preact.Context<T>
#external
pub type Context[T]

///|
pub impl[T] @js.JsImpl for Context[T]

///|
/// Preact.h / createElement
/// Creates a virtual DOM element
#alias(createElement)
pub fn h(
  tag : String,
  children : Array[&PreactNode],
  props? : Map[String, @js.Any],
  style? : Map[String, String],
  ref_? : Ref[@dom.Element],
  key? : String,
) -> VNode {
  let tag = @js.any(tag)
  let children = children.map(_.to_preact_node()) |> @js.from_array
  let val = @js.Object::new()
  if props is Some(props) {
    for k, v in props {
      val.set(k, v)
    }
  }
  if ref_ is Some(ref_) {
    val.set("ref", ref_ |> @js.any)
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
  @js.identity(ffi_h(tag, val.as_any(), children))
}

///|
/// Create element with component function
#alias(c)
pub fn[T] component(
  tag : Component[T],
  props : T,
  children? : Array[&PreactNode] = [],
  key? : String,
) -> VNode {
  let tag = @js.identity(tag)
  let children = children.map(_.to_preact_node()) |> @js.from_array
  let val : @js.Any = props |> @js.identity
  if key is Some(key) {
    if @js.is_nullish(val) {
      let obj = @js.Object::new()
      obj.set("key", key)
      return ffi_h(tag, obj.as_any(), children) |> @js.identity
    }
    val.set("key", key)
  }
  ffi_h(tag, val, children) |> @js.identity
}

///|
/// Preact.Fragment
pub fn fragment(children : Array[&PreactNode], key? : String) -> VNode {
  let tag = get_fragment()
  let children = children.map(_.to_preact_node()) |> @js.from_array
  let val = @js.Object::new()
  if key is Some(key) {
    val.set("key", key)
  }
  ffi_h(tag, val.as_any(), children) |> @js.identity
}

///|
/// Preact.render - Render a VNode to a DOM container
pub fn render(vnode : VNode, container : @dom.Element) -> Unit {
  ffi_render(vnode |> @js.identity, container |> @js.identity)
}

///|
/// Preact.hydrate - Hydrate a server-rendered DOM tree
pub fn hydrate(vnode : VNode, container : @dom.Element) -> Unit {
  ffi_hydrate(vnode |> @js.identity, container |> @js.identity)
}

///|
/// Preact.createContext
#alias(create_context)
pub fn[T] createContext(initial : T?) -> Context[T] {
  let v = ffi_create_context(initial |> @js.unsafe_any)
  @js.identity(v)
}

///|
/// Preact.createRef
#alias(create_ref)
pub fn[T] createRef() -> Ref[T] {
  @js.identity(ffi_create_ref())
}

///|
/// Preact.cloneElement
#alias(clone_element)
pub fn cloneElement(element : VNode, props? : @js.Any) -> VNode {
  let props = match props {
    Some(p) => p
    None => @js.Object::new().as_any()
  }
  ffi_clone_element(element |> @js.identity, props) |> @js.identity
}

///|
/// Preact.toChildArray - Converts children to a flat array
#alias(to_child_array)
pub fn toChildArray(children : @js.Any) -> Array[VNode] {
  ffi_to_child_array(children) |> @js.identity
}

///|
/// Context.Provider
pub fn[T] provider(
  ctx : Context[T],
  children : Array[&PreactNode],
  value~ : T,
) -> VNode {
  let children = children.map(_.to_preact_node()) |> @js.from_array
  let props = @js.from_map({ "value": value |> @js.identity })
  @js.identity(ffi_h(ctx |> @js.identity, props, children))
}
