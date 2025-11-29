///|
extern "js" fn ffi_h(
  tag : @js.Any,
  props : @js.Any,
  children : @js.Any,
) -> @js.Any =
  #|(tag, props, children) => {
  #|  return __VueApi.h(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_render(vnode : @js.Any, container : @js.Any) -> Unit =
  #|(vnode, container) => {
  #|  const app = __VueApi.createApp({ render: () => vnode });
  #|  app.mount(container);
  #|}

///|
extern "js" fn ffi_create_app(
  root_component : @js.Any,
  props : @js.Any,
) -> @js.Any =
  #|(root, props) => __VueApi.createApp(root, props)

///|
extern "js" fn ffi_mount(app : @js.Any, container : @js.Any) -> Unit =
  #|(app, container) => app.mount(container)

///|
extern "js" fn get_fragment() -> @js.Any =
  #|() => __VueApi.Fragment

///|
extern "js" fn ffi_ref(initial : @js.Any) -> @js.Any =
  #|(initial) => __VueApi.ref(initial)

///|
extern "js" fn ffi_reactive(obj : @js.Any) -> @js.Any =
  #|(obj) => __VueApi.reactive(obj)

///|
extern "js" fn ffi_computed(getter_or_options : @js.Any) -> @js.Any =
  #|(getterOrOptions) => __VueApi.computed(getterOrOptions)

///|
extern "js" fn ffi_readonly(obj : @js.Any) -> @js.Any =
  #|(obj) => __VueApi.readonly(obj)

///|
extern "js" fn ffi_to_ref(obj : @js.Any, key : String) -> @js.Any =
  #|(obj, key) => __VueApi.toRef(obj, key)

///|
extern "js" fn ffi_to_refs(obj : @js.Any) -> @js.Any =
  #|(obj) => __VueApi.toRefs(obj)

///|
extern "js" fn ffi_unref(ref_ : @js.Any) -> @js.Any =
  #|(ref) => __VueApi.unref(ref)

///|
extern "js" fn ffi_is_ref(value : @js.Any) -> Bool =
  #|(value) => __VueApi.isRef(value)

///|
extern "js" fn ffi_is_reactive(value : @js.Any) -> Bool =
  #|(value) => __VueApi.isReactive(value)

///|
extern "js" fn ffi_is_readonly(value : @js.Any) -> Bool =
  #|(value) => __VueApi.isReadonly(value)

///|
extern "js" fn ffi_to_raw(proxy : @js.Any) -> @js.Any =
  #|(proxy) => __VueApi.toRaw(proxy)

///|
extern "js" fn ffi_mark_raw(obj : @js.Any) -> @js.Any =
  #|(obj) => __VueApi.markRaw(obj)

///|
extern "js" fn ffi_shallow_ref(initial : @js.Any) -> @js.Any =
  #|(initial) => __VueApi.shallowRef(initial)

///|
extern "js" fn ffi_shallow_reactive(obj : @js.Any) -> @js.Any =
  #|(obj) => __VueApi.shallowReactive(obj)

///|
extern "js" fn ffi_shallow_readonly(obj : @js.Any) -> @js.Any =
  #|(obj) => __VueApi.shallowReadonly(obj)

///|
extern "js" fn ffi_trigger_ref(ref_ : @js.Any) -> Unit =
  #|(ref) => __VueApi.triggerRef(ref)

///|
extern "js" fn ffi_watch(
  source : @js.Any,
  callback : @js.Any,
  options : @js.Any,
) -> @js.Any =
  #|(source, callback, options) => __VueApi.watch(source, callback, options)

///|
extern "js" fn ffi_watch_effect(effect : @js.Any, options : @js.Any) -> @js.Any =
  #|(effect, options) => __VueApi.watchEffect(effect, options)

///|
extern "js" fn ffi_watch_post_effect(effect : @js.Any) -> @js.Any =
  #|(effect) => __VueApi.watchPostEffect(effect)

///|
extern "js" fn ffi_watch_sync_effect(effect : @js.Any) -> @js.Any =
  #|(effect) => __VueApi.watchSyncEffect(effect)

///|
extern "js" fn ffi_on_mounted(callback : () -> Unit) -> Unit =
  #|(callback) => __VueApi.onMounted(callback)

///|
extern "js" fn ffi_on_updated(callback : () -> Unit) -> Unit =
  #|(callback) => __VueApi.onUpdated(callback)

///|
extern "js" fn ffi_on_unmounted(callback : () -> Unit) -> Unit =
  #|(callback) => __VueApi.onUnmounted(callback)

///|
extern "js" fn ffi_on_before_mount(callback : () -> Unit) -> Unit =
  #|(callback) => __VueApi.onBeforeMount(callback)

///|
extern "js" fn ffi_on_before_update(callback : () -> Unit) -> Unit =
  #|(callback) => __VueApi.onBeforeUpdate(callback)

///|
extern "js" fn ffi_on_before_unmount(callback : () -> Unit) -> Unit =
  #|(callback) => __VueApi.onBeforeUnmount(callback)

///|
extern "js" fn ffi_on_activated(callback : () -> Unit) -> Unit =
  #|(callback) => __VueApi.onActivated(callback)

///|
extern "js" fn ffi_on_deactivated(callback : () -> Unit) -> Unit =
  #|(callback) => __VueApi.onDeactivated(callback)

///|
extern "js" fn ffi_on_error_captured(callback : @js.Any) -> Unit =
  #|(callback) => __VueApi.onErrorCaptured(callback)

///|
extern "js" fn ffi_provide(key : @js.Any, value : @js.Any) -> Unit =
  #|(key, value) => __VueApi.provide(key, value)

///|
extern "js" fn ffi_inject(key : @js.Any, default_value : @js.Any) -> @js.Any =
  #|(key, defaultValue) => __VueApi.inject(key, defaultValue)

///|
extern "js" fn ffi_next_tick(callback : @js.Any) -> @js.Any =
  #|(callback) => __VueApi.nextTick(callback)

///|
extern "js" fn ffi_get_current_instance() -> @js.Any =
  #|() => __VueApi.getCurrentInstance()

///|
extern "js" fn ffi_use_attrs() -> @js.Any =
  #|() => __VueApi.useAttrs()

///|
extern "js" fn ffi_use_slots() -> @js.Any =
  #|() => __VueApi.useSlots()
