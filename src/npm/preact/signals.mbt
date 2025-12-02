///|
/// Preact Signals - Reactive primitives for Preact
/// @preact/signals

///|
/// Signal<T> - A reactive value container
// #external
pub(all) struct Signal[T] {
  mut value : T
}

///|
pub fn[T] Signal::as_any(self : Signal[T]) -> @core.Any = "%identity"

///|
/// Get the current value of a signal

///|
/// Peek at the value without subscribing
pub fn[T] Signal::peek(self : Signal[T]) -> T {
  self.as_any()._call("peek", []).cast()
}

///|
/// Subscribe to signal changes
pub fn[T] Signal::subscribe(
  self : Signal[T],
  callback : (T) -> Unit,
) -> () -> Unit {
  let wrapped : (@core.Any) -> Unit = fn(v) { callback(v.cast()) }
  ffi_signal_subscribe(self.as_any(), wrapped).cast()
}

///|
extern "js" fn ffi_signal_subscribe(
  signal : @core.Any,
  callback : (@core.Any) -> Unit,
) -> @core.Any =
  #|(s, cb) => s.subscribe(cb)

///|
/// ReadonlySignal<T> - A computed signal that cannot be set directly
// #external
pub(all) struct ReadonlySignal[T] {
  value : T
}

///|
pub fn[T] ReadonlySignal::as_any(self : ReadonlySignal[T]) -> @core.Any = "%identity"

///|
/// Get the current value of a readonly signal
// pub fn[T] ReadonlySignal::value(self : ReadonlySignal[T]) -> T {
//   self._get("value").cast()
// }

///|
/// Peek at the value without subscribing
pub fn[T] ReadonlySignal::peek(self : ReadonlySignal[T]) -> T {
  self.as_any()._call("peek", []).cast()
}

///|
/// Subscribe to readonly signal changes
pub fn[T] ReadonlySignal::subscribe(
  self : ReadonlySignal[T],
  callback : (T) -> Unit,
) -> () -> Unit {
  let wrapped : (@core.Any) -> Unit = fn(v) { callback(v.cast()) }
  ffi_signal_subscribe(self.as_any(), wrapped).cast()
}

///|
/// Create a new signal with an initial value
#alias(create_signal)
pub fn[T] signal(initial : T) -> Signal[T] {
  ffi_signal(@core.any(initial)).cast()
}

///|
extern "js" fn ffi_signal(initial : @core.Any) -> @core.Any =
  #|(v) => globalThis.__PreactSignals.signal(v)

///|
/// Create a computed signal from a function
#alias(create_computed)
pub fn[T] computed(fn_ : () -> T) -> ReadonlySignal[T] {
  let wrapped : () -> @core.Any = fn() { @core.any(fn_()) }
  ffi_computed(@core.any(wrapped)).cast()
}

///|
extern "js" fn ffi_computed(fn_ : @core.Any) -> @core.Any =
  #|(fn) => globalThis.__PreactSignals.computed(fn)

///|
/// Create an effect that runs when its dependencies change
/// Returns a dispose function to stop the effect
#alias(create_effect)
pub fn effect(fn_ : () -> Unit) -> () -> Unit {
  ffi_effect(@core.any(fn_)).cast()
}

///|
/// Effect with cleanup function
#alias(create_effect_with_cleanup)
pub fn effectWithCleanup(fn_ : () -> () -> Unit) -> () -> Unit {
  ffi_effect(@core.any(fn_)).cast()
}

///|
extern "js" fn ffi_effect(fn_ : @core.Any) -> @core.Any =
  #|(fn) => globalThis.__PreactSignals.effect(fn)

///|
/// Batch multiple signal updates together
#alias(batch_updates)
pub fn batch(fn_ : () -> Unit) -> Unit {
  ffi_batch(@core.any(fn_))
}

///|
extern "js" fn ffi_batch(fn_ : @core.Any) -> Unit =
  #|(fn) => globalThis.__PreactSignals.batch(fn)

///|
/// Untracked read - read signals without subscribing
pub fn[T] untracked(fn_ : () -> T) -> T {
  let wrapped : () -> @core.Any = fn() { @core.any(fn_()) }
  ffi_untracked(@core.any(wrapped)).cast()
}

///|
extern "js" fn ffi_untracked(fn_ : @core.Any) -> @core.Any =
  #|(fn) => globalThis.__PreactSignals.untracked(fn)

///|
/// Initialize the Preact Signals API
pub fn init_preact_signals(signals : @core.Any) -> Unit {
  if @core.is_nullish(@core.global_this()["__PreactSignals"]) {
    @core.global_this()["__PreactSignals"] = signals
  }
}

///|
/// useSignal hook - Create a signal that persists across renders
#alias(use_signal)
pub fn[T] useSignal(initial : T) -> Signal[T] {
  ffi_use_signal(@core.any(initial)).cast()
}

///|
extern "js" fn ffi_use_signal(initial : @core.Any) -> @core.Any =
  #|(v) => globalThis.__PreactSignals.useSignal(v)

///|
/// useComputed hook - Create a computed signal in a component
#alias(use_computed)
pub fn[T] useComputed(fn_ : () -> T) -> ReadonlySignal[T] {
  let wrapped : () -> @core.Any = fn() { @core.any(fn_()) }
  ffi_use_computed(@core.any(wrapped)).cast()
}

///|
extern "js" fn ffi_use_computed(fn_ : @core.Any) -> @core.Any =
  #|(fn) => globalThis.__PreactSignals.useComputed(fn)

///|
/// useSignalEffect hook - Run an effect that tracks signal dependencies
#alias(use_signal_effect)
pub fn useSignalEffect(fn_ : () -> Unit) -> Unit {
  ffi_use_signal_effect(@core.any(fn_))
}

///|
extern "js" fn ffi_use_signal_effect(fn_ : @core.Any) -> Unit =
  #|(fn) => globalThis.__PreactSignals.useSignalEffect(fn)
