///|
/// Preact.VNode - Virtual DOM node
#external
pub type VNode

///|
pub fn VNode::as_any(self : VNode) -> @nostd.Any = "%identity"

///|
/// Component function type
pub type Component[T] = (T) -> VNode

///|
/// Preact.Ref<T>
pub(all) struct Ref[T] {
  current : @nostd.Any
}

///|
pub fn[T] Ref::as_any(self : Ref[T]) -> @nostd.Any = "%identity"

///|
pub fn[T] Ref::get_current(self : Ref[T]) -> T? {
  if @nostd.is_nullish(self.current) {
    None
  } else {
    Some(self.current.cast())
  }
}

///|
pub fn[T] Ref::set_current(self : Ref[T], value : T?) -> Unit {
  let js_val : @nostd.Any = match value {
    Some(v) => @nostd.any(v)
    None => @nostd.undefined()
  }
  ffi_set_ref_current(self.as_any(), js_val)
}

///|
extern "js" fn ffi_set_ref_current(
  ref_obj : @nostd.Any,
  value : @nostd.Any,
) -> Unit =
  #|(ref, value) => { ref.current = value; }

///|
/// Preact.Context<T>
#external
pub type Context[T]

///|
pub fn[T] Context::as_any(self : Context[T]) -> @nostd.Any = "%identity"

///|
/// Preact.h / createElement
/// Creates a virtual DOM element
#alias(createElement)
pub fn h(
  tag : String,
  children : Array[&PreactNode],
  props? : Map[String, @nostd.Any],
  style? : Map[String, String],
  ref_? : Ref[@dom.Element],
  key? : String,
) -> VNode {
  let tag = @nostd.any(tag)
  let children = @nostd.any(children.map(_.to_preact_node()))
  let val = @nostd.Object::new()
  if props is Some(props) {
    for k, v in props {
      val[k] = v
    }
  }
  if ref_ is Some(ref_) {
    val["ref"] = ref_.as_any()
  }
  if key is Some(key) {
    val["key"] = @nostd.any(key)
  }
  if style is Some(style) {
    let style_obj = @nostd.Object::new()
    for k, v in style {
      style_obj[k] = @nostd.any(v)
    }
    val["style"] = style_obj
  }
  ffi_h(tag, val, children).cast()
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
  let tag = @nostd.any(tag)
  let children = @nostd.any(children.map(_.to_preact_node()))
  let val : @nostd.Any = @nostd.any(props)
  if key is Some(key) {
    if @nostd.is_nullish(val) {
      let obj = @nostd.Object::new()
      obj["key"] = @nostd.any(key)
      return ffi_h(tag, obj, children).cast()
    }
    val["key"] = @nostd.any(key)
  }
  ffi_h(tag, val, children).cast()
}

///|
/// Preact.Fragment
pub fn fragment(children : Array[&PreactNode], key? : String) -> VNode {
  let tag = get_fragment()
  let children = @nostd.any(children.map(_.to_preact_node()))
  let val = @nostd.Object::new()
  if key is Some(key) {
    val["key"] = @nostd.any(key)
  }
  ffi_h(tag, val, children).cast()
}

///|
/// Preact.render - Render a VNode to a DOM container
pub fn render(vnode : VNode, container : @dom.Element) -> Unit {
  ffi_render(vnode.as_any(), @nostd.any(container))
}

///|
/// Preact.hydrate - Hydrate a server-rendered DOM tree
pub fn hydrate(vnode : VNode, container : @dom.Element) -> Unit {
  ffi_hydrate(vnode.as_any(), @nostd.any(container))
}

///|
/// Preact.createContext
#alias(create_context)
pub fn[T] createContext(initial : T?) -> Context[T] {
  let v = ffi_create_context(@nostd.any(initial))
  v.cast()
}

///|
/// Preact.createRef
#alias(create_ref)
pub fn[T] createRef() -> Ref[T] {
  ffi_create_ref().cast()
}

///|
/// Preact.cloneElement
#alias(clone_element)
pub fn cloneElement(element : VNode, props? : @nostd.Any) -> VNode {
  let props = match props {
    Some(p) => p
    None => @nostd.Object::new()
  }
  ffi_clone_element(element.as_any(), props).cast()
}

///|
/// Preact.toChildArray - Converts children to a flat array
#alias(to_child_array)
pub fn toChildArray(children : @nostd.Any) -> Array[VNode] {
  ffi_to_child_array(children).cast()
}

///|
/// Context.Provider
pub fn[T] provider(
  ctx : Context[T],
  children : Array[&PreactNode],
  value~ : T,
) -> VNode {
  let children = @nostd.any(children.map(_.to_preact_node()))
  let props = @nostd.Object::new()
  props["value"] = @nostd.any(value)
  ffi_h(ctx.as_any(), props, children).cast()
}
