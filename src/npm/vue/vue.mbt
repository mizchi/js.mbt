///|
/// Vue.VNode - Virtual DOM node
#external
pub type VNode

///|
pub fn VNode::as_any(self : VNode) -> @js.Any = "%identity"

///|
/// Component function type (functional component)
pub type Component[T] = (T) -> VNode

///|
/// Vue.Ref<T> - Reactive reference
pub(all) struct Ref[T] {
  value : @js.Any
}

///|
pub fn[T] Ref::get_value(self : Ref[T]) -> T {
  @js.identity(self.value)
}

///|
pub fn[T] Ref::set_value(self : Ref[T], value : T) -> Unit {
  ffi_set_ref_value(self |> @js.identity, value |> @js.identity)
}

///|
extern "js" fn ffi_set_ref_value(ref_obj : @js.Any, value : @js.Any) -> Unit =
  #|(ref, value) => { ref.value = value; }

///|
pub fn[T] Ref::as_any(self : Ref[T]) -> @js.Any {
  self.value
}

///|
/// Vue.h - Creates a virtual DOM element
pub fn h(
  tag : String,
  children : Array[&VueNode],
  props? : Map[String, @js.Any],
  style? : Map[String, String],
  ref_? : Ref[@dom.Element],
  key? : String,
) -> VNode {
  let tag = @js.any(tag)
  let children = children.map(_.to_vue_node()) |> @js.from_array
  let val = @js.Object::new()
  if props is Some(props) {
    for k, v in props {
      val.set(k, v)
    }
  }
  if ref_ is Some(ref_) {
    val.set("ref", ref_.as_any())
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
  children? : Array[&VueNode] = [],
  key? : String,
) -> VNode {
  let tag = @js.identity(tag)
  let children = children.map(_.to_vue_node()) |> @js.from_array
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
/// Vue.Fragment
pub fn fragment(children : Array[&VueNode], key? : String) -> VNode {
  let tag = get_fragment()
  let children = children.map(_.to_vue_node()) |> @js.from_array
  let val = @js.Object::new()
  if key is Some(key) {
    val.set("key", key)
  }
  ffi_h(tag, val.as_any(), children) |> @js.identity
}

///|
/// Vue.render - Render a VNode to a DOM container using createApp
pub fn render(vnode : VNode, container : @dom.Element) -> Unit {
  ffi_render(vnode |> @js.identity, container |> @js.identity)
}

///|
/// Vue.createApp - Create a Vue application instance
pub fn createApp(rootComponent : @js.Any, props? : @js.Any) -> @js.Any {
  let p = match props {
    Some(p) => p
    None => @js.Object::new().as_any()
  }
  ffi_create_app(rootComponent, p)
}

///|
/// Mount a Vue app to a container
pub fn mount(app : @js.Any, container : @dom.Element) -> Unit {
  ffi_mount(app, container |> @js.identity)
}

///|
/// Vue.ref - Create a reactive reference
#alias(create_ref)
pub fn[T] ref_(initial : T) -> Ref[T] {
  @js.identity(ffi_ref(initial |> @js.identity))
}

///|
/// Vue.reactive - Create a reactive object
pub fn[T] reactive(obj : T) -> T {
  @js.identity(ffi_reactive(obj |> @js.identity))
}

///|
/// Vue.computed - Create a computed property
pub fn[T] computed(getter : () -> T) -> Ref[T] {
  @js.identity(ffi_computed(getter |> @js.unsafe_any))
}

///|
/// Vue.computed with getter and setter
pub fn[T] computedWritable(get : () -> T, set : (T) -> Unit) -> Ref[T] {
  let options = @js.Object::new()
  options.set("get", get |> @js.unsafe_any)
  options.set("set", set |> @js.unsafe_any)
  @js.identity(ffi_computed(options.as_any()))
}

///|
/// Vue.readonly - Create a readonly proxy
pub fn[T] readonly_(obj : T) -> T {
  @js.identity(ffi_readonly(obj |> @js.identity))
}

///|
/// Vue.toRef - Create a ref from a reactive object property
pub fn[T] toRef(obj : @js.Any, key : String) -> Ref[T] {
  @js.identity(ffi_to_ref(obj, key))
}

///|
/// Vue.toRefs - Create refs from all properties of a reactive object
pub fn toRefs(obj : @js.Any) -> @js.Any {
  ffi_to_refs(obj)
}

///|
/// Vue.unref - Unwrap a ref
pub fn[T] unref(ref_ : Ref[T]) -> T {
  @js.identity(ffi_unref(ref_ |> @js.identity))
}

///|
/// Vue.isRef - Check if a value is a ref
pub fn isRef(value : @js.Any) -> Bool {
  ffi_is_ref(value)
}

///|
/// Vue.isReactive - Check if a value is reactive
pub fn isReactive(value : @js.Any) -> Bool {
  ffi_is_reactive(value)
}

///|
/// Vue.isReadonly - Check if a value is readonly
pub fn isReadonly(value : @js.Any) -> Bool {
  ffi_is_readonly(value)
}

///|
/// Vue.toRaw - Get the raw object from a reactive proxy
pub fn[T] toRaw(proxy : T) -> T {
  @js.identity(ffi_to_raw(proxy |> @js.identity))
}

///|
/// Vue.markRaw - Mark an object so it won't be converted to reactive
pub fn[T] markRaw(obj : T) -> T {
  @js.identity(ffi_mark_raw(obj |> @js.identity))
}

///|
/// Vue.shallowRef - Create a shallow ref
pub fn[T] shallowRef(initial : T) -> Ref[T] {
  @js.identity(ffi_shallow_ref(initial |> @js.identity))
}

///|
/// Vue.shallowReactive - Create a shallow reactive object
pub fn[T] shallowReactive(obj : T) -> T {
  @js.identity(ffi_shallow_reactive(obj |> @js.identity))
}

///|
/// Vue.shallowReadonly - Create a shallow readonly proxy
pub fn[T] shallowReadonly(obj : T) -> T {
  @js.identity(ffi_shallow_readonly(obj |> @js.identity))
}

///|
/// Vue.triggerRef - Manually trigger effects for a shallow ref
pub fn[T] triggerRef(ref_ : Ref[T]) -> Unit {
  ffi_trigger_ref(ref_ |> @js.identity)
}
