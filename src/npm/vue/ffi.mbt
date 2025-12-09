///|
#module("vue")
extern "js" fn ffi_h(
  tag : @core.Any,
  props : @core.Any,
  children : @core.Any,
) -> @core.Any = "h"

///|
#module("vue")
extern "js" fn ffi_create_app(
  root_component : @core.Any,
  props : @core.Any,
) -> @core.Any = "createApp"

///|
extern "js" fn ffi_mount(app : @core.Any, container : @core.Any) -> Unit =
  #|(app, container) => app.mount(container)

///|
/// Fragment from Vue - requires init_fragment() or init_global() to be called first
extern "js" fn get_fragment() -> @core.Any =
  #|() => globalThis.__VueFragment

///|
#module("vue")
extern "js" fn ffi_ref(initial : @core.Any) -> @core.Any = "ref"

///|
#module("vue")
extern "js" fn ffi_reactive(obj : @core.Any) -> @core.Any = "reactive"

///|
#module("vue")
extern "js" fn ffi_computed(getter_or_options : @core.Any) -> @core.Any = "computed"

///|
#module("vue")
extern "js" fn ffi_readonly(obj : @core.Any) -> @core.Any = "readonly"

///|
#module("vue")
extern "js" fn ffi_to_ref(obj : @core.Any, key : String) -> @core.Any = "toRef"

///|
#module("vue")
extern "js" fn ffi_to_refs(obj : @core.Any) -> @core.Any = "toRefs"

///|
#module("vue")
extern "js" fn ffi_unref(ref_ : @core.Any) -> @core.Any = "unref"

///|
#module("vue")
extern "js" fn ffi_is_ref(value : @core.Any) -> Bool = "isRef"

///|
#module("vue")
extern "js" fn ffi_is_reactive(value : @core.Any) -> Bool = "isReactive"

///|
#module("vue")
extern "js" fn ffi_is_readonly(value : @core.Any) -> Bool = "isReadonly"

///|
#module("vue")
extern "js" fn ffi_to_raw(proxy : @core.Any) -> @core.Any = "toRaw"

///|
#module("vue")
extern "js" fn ffi_mark_raw(obj : @core.Any) -> @core.Any = "markRaw"

///|
#module("vue")
extern "js" fn ffi_shallow_ref(initial : @core.Any) -> @core.Any = "shallowRef"

///|
#module("vue")
extern "js" fn ffi_shallow_reactive(obj : @core.Any) -> @core.Any = "shallowReactive"

///|
#module("vue")
extern "js" fn ffi_shallow_readonly(obj : @core.Any) -> @core.Any = "shallowReadonly"

///|
#module("vue")
extern "js" fn ffi_trigger_ref(ref_ : @core.Any) -> Unit = "triggerRef"

///|
#module("vue")
extern "js" fn ffi_watch(
  source : @core.Any,
  callback : @core.Any,
  options : @core.Any,
) -> @core.Any = "watch"

///|
#module("vue")
extern "js" fn ffi_watch_effect(
  effect : @core.Any,
  options : @core.Any,
) -> @core.Any = "watchEffect"

///|
#module("vue")
extern "js" fn ffi_watch_post_effect(effect : @core.Any) -> @core.Any = "watchPostEffect"

///|
#module("vue")
extern "js" fn ffi_watch_sync_effect(effect : @core.Any) -> @core.Any = "watchSyncEffect"

///|
#module("vue")
extern "js" fn ffi_on_mounted(callback : () -> Unit) -> Unit = "onMounted"

///|
#module("vue")
extern "js" fn ffi_on_updated(callback : () -> Unit) -> Unit = "onUpdated"

///|
#module("vue")
extern "js" fn ffi_on_unmounted(callback : () -> Unit) -> Unit = "onUnmounted"

///|
#module("vue")
extern "js" fn ffi_on_before_mount(callback : () -> Unit) -> Unit = "onBeforeMount"

///|
#module("vue")
extern "js" fn ffi_on_before_update(callback : () -> Unit) -> Unit = "onBeforeUpdate"

///|
#module("vue")
extern "js" fn ffi_on_before_unmount(callback : () -> Unit) -> Unit = "onBeforeUnmount"

///|
#module("vue")
extern "js" fn ffi_on_activated(callback : () -> Unit) -> Unit = "onActivated"

///|
#module("vue")
extern "js" fn ffi_on_deactivated(callback : () -> Unit) -> Unit = "onDeactivated"

///|
#module("vue")
extern "js" fn ffi_on_error_captured(callback : @core.Any) -> Unit = "onErrorCaptured"

///|
#module("vue")
extern "js" fn ffi_provide(key : @core.Any, value : @core.Any) -> Unit = "provide"

///|
#module("vue")
extern "js" fn ffi_inject(
  key : @core.Any,
  default_value : @core.Any,
) -> @core.Any = "inject"

///|
#module("vue")
extern "js" fn ffi_next_tick(callback : @core.Any) -> @core.Any = "nextTick"

///|
#module("vue")
extern "js" fn ffi_get_current_instance() -> @core.Any = "getCurrentInstance"

///|
#module("vue")
extern "js" fn ffi_use_attrs() -> @core.Any = "useAttrs"

///|
#module("vue")
extern "js" fn ffi_use_slots() -> @core.Any = "useSlots"
