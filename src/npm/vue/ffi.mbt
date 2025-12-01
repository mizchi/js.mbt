///|
extern "js" fn ffi_h(
  tag : @nostd.Any,
  props : @nostd.Any,
  children : @nostd.Any,
) -> @nostd.Any =
  #|(tag, props, children) => {
  #|  return __VueApi.h(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_render(vnode : @nostd.Any, container : @nostd.Any) -> Unit =
  #|(vnode, container) => {
  #|  const app = __VueApi.createApp({ render: () => vnode });
  #|  app.mount(container);
  #|}

///|
extern "js" fn ffi_create_app(
  root_component : @nostd.Any,
  props : @nostd.Any,
) -> @nostd.Any =
  #|(root, props) => __VueApi.createApp(root, props)

///|
extern "js" fn ffi_mount(app : @nostd.Any, container : @nostd.Any) -> Unit =
  #|(app, container) => app.mount(container)

///|
extern "js" fn get_fragment() -> @nostd.Any =
  #|() => __VueApi.Fragment

///|
extern "js" fn ffi_ref(initial : @nostd.Any) -> @nostd.Any =
  #|(initial) => __VueApi.ref(initial)

///|
extern "js" fn ffi_reactive(obj : @nostd.Any) -> @nostd.Any =
  #|(obj) => __VueApi.reactive(obj)

///|
extern "js" fn ffi_computed(getter_or_options : @nostd.Any) -> @nostd.Any =
  #|(getterOrOptions) => __VueApi.computed(getterOrOptions)

///|
extern "js" fn ffi_readonly(obj : @nostd.Any) -> @nostd.Any =
  #|(obj) => __VueApi.readonly(obj)

///|
extern "js" fn ffi_to_ref(obj : @nostd.Any, key : String) -> @nostd.Any =
  #|(obj, key) => __VueApi.toRef(obj, key)

///|
extern "js" fn ffi_to_refs(obj : @nostd.Any) -> @nostd.Any =
  #|(obj) => __VueApi.toRefs(obj)

///|
extern "js" fn ffi_unref(ref_ : @nostd.Any) -> @nostd.Any =
  #|(ref) => __VueApi.unref(ref)

///|
extern "js" fn ffi_is_ref(value : @nostd.Any) -> Bool =
  #|(value) => __VueApi.isRef(value)

///|
extern "js" fn ffi_is_reactive(value : @nostd.Any) -> Bool =
  #|(value) => __VueApi.isReactive(value)

///|
extern "js" fn ffi_is_readonly(value : @nostd.Any) -> Bool =
  #|(value) => __VueApi.isReadonly(value)

///|
extern "js" fn ffi_to_raw(proxy : @nostd.Any) -> @nostd.Any =
  #|(proxy) => __VueApi.toRaw(proxy)

///|
extern "js" fn ffi_mark_raw(obj : @nostd.Any) -> @nostd.Any =
  #|(obj) => __VueApi.markRaw(obj)

///|
extern "js" fn ffi_shallow_ref(initial : @nostd.Any) -> @nostd.Any =
  #|(initial) => __VueApi.shallowRef(initial)

///|
extern "js" fn ffi_shallow_reactive(obj : @nostd.Any) -> @nostd.Any =
  #|(obj) => __VueApi.shallowReactive(obj)

///|
extern "js" fn ffi_shallow_readonly(obj : @nostd.Any) -> @nostd.Any =
  #|(obj) => __VueApi.shallowReadonly(obj)

///|
extern "js" fn ffi_trigger_ref(ref_ : @nostd.Any) -> Unit =
  #|(ref) => __VueApi.triggerRef(ref)

///|
extern "js" fn ffi_watch(
  source : @nostd.Any,
  callback : @nostd.Any,
  options : @nostd.Any,
) -> @nostd.Any =
  #|(source, callback, options) => __VueApi.watch(source, callback, options)

///|
extern "js" fn ffi_watch_effect(effect : @nostd.Any, options : @nostd.Any) -> @nostd.Any =
  #|(effect, options) => __VueApi.watchEffect(effect, options)

///|
extern "js" fn ffi_watch_post_effect(effect : @nostd.Any) -> @nostd.Any =
  #|(effect) => __VueApi.watchPostEffect(effect)

///|
extern "js" fn ffi_watch_sync_effect(effect : @nostd.Any) -> @nostd.Any =
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
extern "js" fn ffi_on_error_captured(callback : @nostd.Any) -> Unit =
  #|(callback) => __VueApi.onErrorCaptured(callback)

///|
extern "js" fn ffi_provide(key : @nostd.Any, value : @nostd.Any) -> Unit =
  #|(key, value) => __VueApi.provide(key, value)

///|
extern "js" fn ffi_inject(key : @nostd.Any, default_value : @nostd.Any) -> @nostd.Any =
  #|(key, defaultValue) => __VueApi.inject(key, defaultValue)

///|
extern "js" fn ffi_next_tick(callback : @nostd.Any) -> @nostd.Any =
  #|(callback) => __VueApi.nextTick(callback)

///|
extern "js" fn ffi_get_current_instance() -> @nostd.Any =
  #|() => __VueApi.getCurrentInstance()

///|
extern "js" fn ffi_use_attrs() -> @nostd.Any =
  #|() => __VueApi.useAttrs()

///|
extern "js" fn ffi_use_slots() -> @nostd.Any =
  #|() => __VueApi.useSlots()
