///|
/// WatchStopHandle - Function to stop watching
pub type WatchStopHandle = () -> Unit

///|
/// Vue.watch - Watch a reactive source
pub fn[T] watch(
  source : Ref[T],
  callback : (T, T) -> Unit,
  immediate? : Bool,
  deep? : Bool,
) -> WatchStopHandle {
  let options = @nostd.Object::new()
  if immediate is Some(v) {
    options.set("immediate", v)
  }
  if deep is Some(v) {
    options.set("deep", v)
  }
  @js.identity(
    ffi_watch(
      source |> @js.identity,
      callback |> @js.unsafe_any,
      options.as_any(),
    ),
  )
}

///|
/// Vue.watchEffect - Watch with automatic dependency tracking
pub fn watchEffect(effect : () -> Unit, flush? : String) -> WatchStopHandle {
  let options = @nostd.Object::new()
  if flush is Some(v) {
    options.set("flush", v)
  }
  @js.identity(ffi_watch_effect(effect |> @js.unsafe_any, options.as_any()))
}

///|
/// Vue.watchPostEffect - watchEffect with flush: 'post'
pub fn watchPostEffect(effect : () -> Unit) -> WatchStopHandle {
  @js.identity(ffi_watch_post_effect(effect |> @js.unsafe_any))
}

///|
/// Vue.watchSyncEffect - watchEffect with flush: 'sync'
pub fn watchSyncEffect(effect : () -> Unit) -> WatchStopHandle {
  @js.identity(ffi_watch_sync_effect(effect |> @js.unsafe_any))
}

///|
/// Vue.onMounted - Lifecycle hook
#alias(on_mounted)
pub fn onMounted(callback : () -> Unit) -> Unit {
  ffi_on_mounted(callback)
}

///|
/// Vue.onUpdated - Lifecycle hook
#alias(on_updated)
pub fn onUpdated(callback : () -> Unit) -> Unit {
  ffi_on_updated(callback)
}

///|
/// Vue.onUnmounted - Lifecycle hook
#alias(on_unmounted)
pub fn onUnmounted(callback : () -> Unit) -> Unit {
  ffi_on_unmounted(callback)
}

///|
/// Vue.onBeforeMount - Lifecycle hook
#alias(on_before_mount)
pub fn onBeforeMount(callback : () -> Unit) -> Unit {
  ffi_on_before_mount(callback)
}

///|
/// Vue.onBeforeUpdate - Lifecycle hook
#alias(on_before_update)
pub fn onBeforeUpdate(callback : () -> Unit) -> Unit {
  ffi_on_before_update(callback)
}

///|
/// Vue.onBeforeUnmount - Lifecycle hook
#alias(on_before_unmount)
pub fn onBeforeUnmount(callback : () -> Unit) -> Unit {
  ffi_on_before_unmount(callback)
}

///|
/// Vue.onActivated - Lifecycle hook for keep-alive
#alias(on_activated)
pub fn onActivated(callback : () -> Unit) -> Unit {
  ffi_on_activated(callback)
}

///|
/// Vue.onDeactivated - Lifecycle hook for keep-alive
#alias(on_deactivated)
pub fn onDeactivated(callback : () -> Unit) -> Unit {
  ffi_on_deactivated(callback)
}

///|
/// Vue.onErrorCaptured - Error handling hook
#alias(on_error_captured)
pub fn onErrorCaptured(
  callback : (@nostd.Any, @nostd.Any, String) -> Bool?,
) -> Unit {
  ffi_on_error_captured(callback |> @js.unsafe_any)
}

///|
/// Vue.provide - Provide value for injection
pub fn[T] provide(key : String, value : T) -> Unit {
  ffi_provide(@nostd.any(key), value |> @js.identity)
}

///|
/// Vue.inject - Inject provided value
pub fn[T] inject(key : String, default_value? : T) -> T {
  let default_val = match default_value {
    Some(v) => v |> @js.identity
    None => @global.undefined()
  }
  @js.identity(ffi_inject(@nostd.any(key), default_val))
}

///|
/// Vue.nextTick - Execute callback after DOM update
#alias(next_tick)
pub async fn nextTick() -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(
    ffi_next_tick(@global.undefined()),
  )
  promise.wait()
}

///|
/// Vue.nextTick with callback
#alias(next_tick_with_callback)
pub fn nextTickCallback(callback : () -> Unit) -> Unit {
  let _ = ffi_next_tick(callback |> @js.unsafe_any)

}

///|
/// Vue.getCurrentInstance - Get current component instance
#alias(get_current_instance)
pub fn getCurrentInstance() -> @nostd.Any? {
  let inst = ffi_get_current_instance()
  if @js.is_nullish(inst) {
    None
  } else {
    Some(inst)
  }
}

///|
/// Vue.useAttrs - Get current component's attrs
#alias(use_attrs)
pub fn useAttrs() -> @nostd.Any {
  ffi_use_attrs()
}

///|
/// Vue.useSlots - Get current component's slots
#alias(use_slots)
pub fn useSlots() -> @nostd.Any {
  ffi_use_slots()
}
