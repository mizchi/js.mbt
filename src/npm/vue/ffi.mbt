///|
extern "js" fn ffi_h(
  tag : @core.Any,
  props : @core.Any,
  children : @core.Any,
) -> @core.Any =
  #|(tag, props, children) => {
  #|  return __VueApi.h(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_render(vnode : @core.Any, container : @core.Any) -> Unit =
  #|(vnode, container) => {
  #|  const app = __VueApi.createApp({ render: () => vnode });
  #|  app.mount(container);
  #|}

///|
extern "js" fn ffi_create_app(
  root_component : @core.Any,
  props : @core.Any,
) -> @core.Any =
  #|(root, props) => __VueApi.createApp(root, props)

///|
extern "js" fn ffi_mount(app : @core.Any, container : @core.Any) -> Unit =
  #|(app, container) => app.mount(container)

///|
extern "js" fn get_fragment() -> @core.Any =
  #|() => __VueApi.Fragment

///|
extern "js" fn ffi_ref(initial : @core.Any) -> @core.Any =
  #|(initial) => __VueApi.ref(initial)

///|
extern "js" fn ffi_reactive(obj : @core.Any) -> @core.Any =
  #|(obj) => __VueApi.reactive(obj)

///|
extern "js" fn ffi_computed(getter_or_options : @core.Any) -> @core.Any =
  #|(getterOrOptions) => __VueApi.computed(getterOrOptions)

///|
extern "js" fn ffi_readonly(obj : @core.Any) -> @core.Any =
  #|(obj) => __VueApi.readonly(obj)

///|
extern "js" fn ffi_to_ref(obj : @core.Any, key : String) -> @core.Any =
  #|(obj, key) => __VueApi.toRef(obj, key)

///|
extern "js" fn ffi_to_refs(obj : @core.Any) -> @core.Any =
  #|(obj) => __VueApi.toRefs(obj)

///|
extern "js" fn ffi_unref(ref_ : @core.Any) -> @core.Any =
  #|(ref) => __VueApi.unref(ref)

///|
extern "js" fn ffi_is_ref(value : @core.Any) -> Bool =
  #|(value) => __VueApi.isRef(value)

///|
extern "js" fn ffi_is_reactive(value : @core.Any) -> Bool =
  #|(value) => __VueApi.isReactive(value)

///|
extern "js" fn ffi_is_readonly(value : @core.Any) -> Bool =
  #|(value) => __VueApi.isReadonly(value)

///|
extern "js" fn ffi_to_raw(proxy : @core.Any) -> @core.Any =
  #|(proxy) => __VueApi.toRaw(proxy)

///|
extern "js" fn ffi_mark_raw(obj : @core.Any) -> @core.Any =
  #|(obj) => __VueApi.markRaw(obj)

///|
extern "js" fn ffi_shallow_ref(initial : @core.Any) -> @core.Any =
  #|(initial) => __VueApi.shallowRef(initial)

///|
extern "js" fn ffi_shallow_reactive(obj : @core.Any) -> @core.Any =
  #|(obj) => __VueApi.shallowReactive(obj)

///|
extern "js" fn ffi_shallow_readonly(obj : @core.Any) -> @core.Any =
  #|(obj) => __VueApi.shallowReadonly(obj)

///|
extern "js" fn ffi_trigger_ref(ref_ : @core.Any) -> Unit =
  #|(ref) => __VueApi.triggerRef(ref)

///|
extern "js" fn ffi_watch(
  source : @core.Any,
  callback : @core.Any,
  options : @core.Any,
) -> @core.Any =
  #|(source, callback, options) => __VueApi.watch(source, callback, options)

///|
extern "js" fn ffi_watch_effect(
  effect : @core.Any,
  options : @core.Any,
) -> @core.Any =
  #|(effect, options) => __VueApi.watchEffect(effect, options)

///|
extern "js" fn ffi_watch_post_effect(effect : @core.Any) -> @core.Any =
  #|(effect) => __VueApi.watchPostEffect(effect)

///|
extern "js" fn ffi_watch_sync_effect(effect : @core.Any) -> @core.Any =
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
extern "js" fn ffi_on_error_captured(callback : @core.Any) -> Unit =
  #|(callback) => __VueApi.onErrorCaptured(callback)

///|
extern "js" fn ffi_provide(key : @core.Any, value : @core.Any) -> Unit =
  #|(key, value) => __VueApi.provide(key, value)

///|
extern "js" fn ffi_inject(
  key : @core.Any,
  default_value : @core.Any,
) -> @core.Any =
  #|(key, defaultValue) => __VueApi.inject(key, defaultValue)

///|
extern "js" fn ffi_next_tick(callback : @core.Any) -> @core.Any =
  #|(callback) => __VueApi.nextTick(callback)

///|
extern "js" fn ffi_get_current_instance() -> @core.Any =
  #|() => __VueApi.getCurrentInstance()

///|
extern "js" fn ffi_use_attrs() -> @core.Any =
  #|() => __VueApi.useAttrs()

///|
extern "js" fn ffi_use_slots() -> @core.Any =
  #|() => __VueApi.useSlots()
