///|
/// Vue.VNode - Virtual DOM node
#external
pub type VNode

///|
pub fn VNode::as_any(self : VNode) -> @core.Any = "%identity"

///|
/// Component function type (functional component)
pub type Component[T] = (T) -> VNode

///|
/// Vue.Ref<T> - Reactive reference
pub(all) struct Ref[T] {
  value : @core.Any
}

///|
pub fn[T] Ref::get_value(self : Ref[T]) -> T {
  @core.identity(self.value)
}

///|
pub fn[T] Ref::set_value(self : Ref[T], value : T) -> Unit {
  ffi_set_ref_value(self |> @core.identity, value |> @core.identity)
}

///|
extern "js" fn ffi_set_ref_value(
  ref_obj : @core.Any,
  value : @core.Any,
) -> Unit =
  #|(ref, value) => { ref.value = value; }

///|
pub fn[T] Ref::as_any(self : Ref[T]) -> @core.Any {
  self.value
}

///|
/// Vue.h - Creates a virtual DOM element
pub fn h(
  tag : String,
  children : Array[&VueNode],
  props? : Map[String, @core.Any],
  style? : Map[String, String],
  ref_? : Ref[@dom.Element],
  key? : String,
) -> VNode {
  let tag = @core.any(tag)
  let children = children.map(_.to_vue_node()) |> @core.any
  let val = @core.new_object()
  if props is Some(props) {
    for k, v in props {
      val._set(k, v)
    }
  }
  if ref_ is Some(ref_) {
    val._set("ref", ref_.as_any())
  }
  if key is Some(key) {
    val._set("key", key |> @core.any)
  }
  if style is Some(style) {
    let style_obj = @core.new_object()
    for k, v in style {
      style_obj._set(k, v |> @core.any)
    }
    val._set("style", style_obj)
  }
  @core.identity(ffi_h(tag, val, children))
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
  let tag = @core.identity(tag)
  let children = children.map(_.to_vue_node()) |> @core.any
  let val : @core.Any = props |> @core.identity
  if key is Some(key) {
    if @core.is_nullish(val) {
      let obj = @core.new_object()
      obj._set("key", key |> @core.any)
      return ffi_h(tag, obj, children) |> @core.identity
    }
    val._set("key", key |> @core.any)
  }
  ffi_h(tag, val, children) |> @core.identity
}

///|
/// Vue.Fragment
pub fn fragment(children : Array[&VueNode], key? : String) -> VNode {
  let tag = get_fragment()
  let children = children.map(_.to_vue_node()) |> @core.any
  let val = @core.new_object()
  if key is Some(key) {
    val._set("key", key |> @core.any)
  }
  ffi_h(tag, val, children) |> @core.identity
}

///|
/// Vue.render - Render a VNode to a DOM container using createApp
pub fn render(vnode : VNode, container : @dom.Element) -> Unit {
  ffi_render(vnode |> @core.identity, container |> @core.identity)
}

///|
/// Vue.createApp - Create a Vue application instance
pub fn createApp(rootComponent : @core.Any, props? : @core.Any) -> @core.Any {
  let p = match props {
    Some(p) => p
    None => @core.new_object()
  }
  ffi_create_app(rootComponent, p)
}

///|
/// Mount a Vue app to a container
pub fn mount(app : @core.Any, container : @dom.Element) -> Unit {
  ffi_mount(app, container |> @core.identity)
}

///|
/// Vue.ref - Create a reactive reference
#alias(create_ref)
pub fn[T] ref_(initial : T) -> Ref[T] {
  @core.identity(ffi_ref(initial |> @core.identity))
}

///|
/// Vue.reactive - Create a reactive object
pub fn[T] reactive(obj : T) -> T {
  @core.identity(ffi_reactive(obj |> @core.identity))
}

///|
/// Vue.computed - Create a computed property
pub fn[T] computed(getter : () -> T) -> Ref[T] {
  @core.identity(ffi_computed(getter |> @js.any))
}

///|
/// Vue.computed with getter and setter
pub fn[T] computedWritable(get : () -> T, set : (T) -> Unit) -> Ref[T] {
  let options = @core.new_object()
  options._set("get", get |> @js.any)
  options._set("set", set |> @js.any)
  @core.identity(ffi_computed(options))
}

///|
/// Vue.readonly - Create a readonly proxy
pub fn[T] readonly_(obj : T) -> T {
  @core.identity(ffi_readonly(obj |> @core.identity))
}

///|
/// Vue.toRef - Create a ref from a reactive object property
pub fn[T] toRef(obj : @core.Any, key : String) -> Ref[T] {
  @core.identity(ffi_to_ref(obj, key))
}

///|
/// Vue.toRefs - Create refs from all properties of a reactive object
pub fn toRefs(obj : @core.Any) -> @core.Any {
  ffi_to_refs(obj)
}

///|
/// Vue.unref - Unwrap a ref
pub fn[T] unref(ref_ : Ref[T]) -> T {
  @core.identity(ffi_unref(ref_ |> @core.identity))
}

///|
/// Vue.isRef - Check if a value is a ref
pub fn isRef(value : @core.Any) -> Bool {
  ffi_is_ref(value)
}

///|
/// Vue.isReactive - Check if a value is reactive
pub fn isReactive(value : @core.Any) -> Bool {
  ffi_is_reactive(value)
}

///|
/// Vue.isReadonly - Check if a value is readonly
pub fn isReadonly(value : @core.Any) -> Bool {
  ffi_is_readonly(value)
}

///|
/// Vue.toRaw - Get the raw object from a reactive proxy
pub fn[T] toRaw(proxy : T) -> T {
  @core.identity(ffi_to_raw(proxy |> @core.identity))
}

///|
/// Vue.markRaw - Mark an object so it won't be converted to reactive
pub fn[T] markRaw(obj : T) -> T {
  @core.identity(ffi_mark_raw(obj |> @core.identity))
}

///|
/// Vue.shallowRef - Create a shallow ref
pub fn[T] shallowRef(initial : T) -> Ref[T] {
  @core.identity(ffi_shallow_ref(initial |> @core.identity))
}

///|
/// Vue.shallowReactive - Create a shallow reactive object
pub fn[T] shallowReactive(obj : T) -> T {
  @core.identity(ffi_shallow_reactive(obj |> @core.identity))
}

///|
/// Vue.shallowReadonly - Create a shallow readonly proxy
pub fn[T] shallowReadonly(obj : T) -> T {
  @core.identity(ffi_shallow_readonly(obj |> @core.identity))
}

///|
/// Vue.triggerRef - Manually trigger effects for a shallow ref
pub fn[T] triggerRef(ref_ : Ref[T]) -> Unit {
  ffi_trigger_ref(ref_ |> @core.identity)
}
