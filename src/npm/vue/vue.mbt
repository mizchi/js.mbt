///|
/// Vue.VNode - Virtual DOM node
#external
pub type VNode

///|
pub fn VNode::as_any(self : VNode) -> @nostd.Any = "%identity"

///|
/// Component function type (functional component)
pub type Component[T] = (T) -> VNode

///|
/// Vue.Ref<T> - Reactive reference
pub(all) struct Ref[T] {
  value : @nostd.Any
}

///|
pub fn[T] Ref::get_value(self : Ref[T]) -> T {
  @nostd.identity(self.value)
}

///|
pub fn[T] Ref::set_value(self : Ref[T], value : T) -> Unit {
  ffi_set_ref_value(self |> @nostd.identity, value |> @nostd.identity)
}

///|
extern "js" fn ffi_set_ref_value(
  ref_obj : @nostd.Any,
  value : @nostd.Any,
) -> Unit =
  #|(ref, value) => { ref.value = value; }

///|
pub fn[T] Ref::as_any(self : Ref[T]) -> @nostd.Any {
  self.value
}

///|
/// Vue.h - Creates a virtual DOM element
pub fn h(
  tag : String,
  children : Array[&VueNode],
  props? : Map[String, @nostd.Any],
  style? : Map[String, String],
  ref_? : Ref[@dom.Element],
  key? : String,
) -> VNode {
  let tag = @nostd.any(tag)
  let children = children.map(_.to_vue_node()) |> @nostd.any
  let val = @nostd.Object::new()
  if props is Some(props) {
    for k, v in props {
      val._set(k, v)
    }
  }
  if ref_ is Some(ref_) {
    val._set("ref", ref_.as_any())
  }
  if key is Some(key) {
    val._set("key", key |> @nostd.any)
  }
  if style is Some(style) {
    let style_obj = @nostd.Object::new()
    for k, v in style {
      style_obj._set(k, v |> @nostd.any)
    }
    val._set("style", style_obj)
  }
  @nostd.identity(ffi_h(tag, val, children))
}

///|
/// Create element with component function
#alias(c)
pub fn[T] component(
  tag : Component[T],
  props : T,
  children? : Array[&VueNode] = [],
  key? : String,
) -> VNode {
  let tag = @nostd.identity(tag)
  let children = children.map(_.to_vue_node()) |> @nostd.any
  let val : @nostd.Any = props |> @nostd.identity
  if key is Some(key) {
    if @nostd.is_nullish(val) {
      let obj = @nostd.Object::new()
      obj._set("key", key |> @nostd.any)
      return ffi_h(tag, obj, children) |> @nostd.identity
    }
    val._set("key", key |> @nostd.any)
  }
  ffi_h(tag, val, children) |> @nostd.identity
}

///|
/// Vue.Fragment
pub fn fragment(children : Array[&VueNode], key? : String) -> VNode {
  let tag = get_fragment()
  let children = children.map(_.to_vue_node()) |> @nostd.any
  let val = @nostd.Object::new()
  if key is Some(key) {
    val._set("key", key |> @nostd.any)
  }
  ffi_h(tag, val, children) |> @nostd.identity
}

///|
/// Vue.render - Render a VNode to a DOM container using createApp
pub fn render(vnode : VNode, container : @dom.Element) -> Unit {
  ffi_render(vnode |> @nostd.identity, container |> @nostd.identity)
}

///|
/// Vue.createApp - Create a Vue application instance
pub fn createApp(rootComponent : @nostd.Any, props? : @nostd.Any) -> @nostd.Any {
  let p = match props {
    Some(p) => p
    None => @nostd.Object::new()
  }
  ffi_create_app(rootComponent, p)
}

///|
/// Mount a Vue app to a container
pub fn mount(app : @nostd.Any, container : @dom.Element) -> Unit {
  ffi_mount(app, container |> @nostd.identity)
}

///|
/// Vue.ref - Create a reactive reference
#alias(create_ref)
pub fn[T] ref_(initial : T) -> Ref[T] {
  @nostd.identity(ffi_ref(initial |> @nostd.identity))
}

///|
/// Vue.reactive - Create a reactive object
pub fn[T] reactive(obj : T) -> T {
  @nostd.identity(ffi_reactive(obj |> @nostd.identity))
}

///|
/// Vue.computed - Create a computed property
pub fn[T] computed(getter : () -> T) -> Ref[T] {
  @nostd.identity(ffi_computed(getter |> @js.unsafe_any))
}

///|
/// Vue.computed with getter and setter
pub fn[T] computedWritable(get : () -> T, set : (T) -> Unit) -> Ref[T] {
  let options = @nostd.Object::new()
  options._set("get", get |> @js.unsafe_any)
  options._set("set", set |> @js.unsafe_any)
  @nostd.identity(ffi_computed(options))
}

///|
/// Vue.readonly - Create a readonly proxy
pub fn[T] readonly_(obj : T) -> T {
  @nostd.identity(ffi_readonly(obj |> @nostd.identity))
}

///|
/// Vue.toRef - Create a ref from a reactive object property
pub fn[T] toRef(obj : @nostd.Any, key : String) -> Ref[T] {
  @nostd.identity(ffi_to_ref(obj, key))
}

///|
/// Vue.toRefs - Create refs from all properties of a reactive object
pub fn toRefs(obj : @nostd.Any) -> @nostd.Any {
  ffi_to_refs(obj)
}

///|
/// Vue.unref - Unwrap a ref
pub fn[T] unref(ref_ : Ref[T]) -> T {
  @nostd.identity(ffi_unref(ref_ |> @nostd.identity))
}

///|
/// Vue.isRef - Check if a value is a ref
pub fn isRef(value : @nostd.Any) -> Bool {
  ffi_is_ref(value)
}

///|
/// Vue.isReactive - Check if a value is reactive
pub fn isReactive(value : @nostd.Any) -> Bool {
  ffi_is_reactive(value)
}

///|
/// Vue.isReadonly - Check if a value is readonly
pub fn isReadonly(value : @nostd.Any) -> Bool {
  ffi_is_readonly(value)
}

///|
/// Vue.toRaw - Get the raw object from a reactive proxy
pub fn[T] toRaw(proxy : T) -> T {
  @nostd.identity(ffi_to_raw(proxy |> @nostd.identity))
}

///|
/// Vue.markRaw - Mark an object so it won't be converted to reactive
pub fn[T] markRaw(obj : T) -> T {
  @nostd.identity(ffi_mark_raw(obj |> @nostd.identity))
}

///|
/// Vue.shallowRef - Create a shallow ref
pub fn[T] shallowRef(initial : T) -> Ref[T] {
  @nostd.identity(ffi_shallow_ref(initial |> @nostd.identity))
}

///|
/// Vue.shallowReactive - Create a shallow reactive object
pub fn[T] shallowReactive(obj : T) -> T {
  @nostd.identity(ffi_shallow_reactive(obj |> @nostd.identity))
}

///|
/// Vue.shallowReadonly - Create a shallow readonly proxy
pub fn[T] shallowReadonly(obj : T) -> T {
  @nostd.identity(ffi_shallow_readonly(obj |> @nostd.identity))
}

///|
/// Vue.triggerRef - Manually trigger effects for a shallow ref
pub fn[T] triggerRef(ref_ : Ref[T]) -> Unit {
  ffi_trigger_ref(ref_ |> @nostd.identity)
}
