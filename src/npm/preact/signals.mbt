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
pub impl[T] @js.JsImpl for Signal[T]

///|
/// Get the current value of a signal

///|
/// Peek at the value without subscribing
pub fn[T] Signal::peek(self : Signal[T]) -> T {
  self.call0("peek").cast()
}

///|
/// Subscribe to signal changes
pub fn[T] Signal::subscribe(
  self : Signal[T],
  callback : (T) -> Unit,
) -> () -> Unit {
  let wrapped : (@js.Any) -> Unit = fn(v) { callback(v.cast()) }
  ffi_signal_subscribe(self.to_any(), wrapped).cast()
}

///|
extern "js" fn ffi_signal_subscribe(
  signal : @js.Any,
  callback : (@js.Any) -> Unit,
) -> @js.Any =
  #|(s, cb) => s.subscribe(cb)

///|
/// ReadonlySignal<T> - A computed signal that cannot be set directly
// #external
pub(all) struct ReadonlySignal[T] {
  value : T
}

///|
pub impl[T] @js.JsImpl for ReadonlySignal[T]

///|
/// Get the current value of a readonly signal
// pub fn[T] ReadonlySignal::value(self : ReadonlySignal[T]) -> T {
//   self.get("value").cast()
// }

///|
/// Peek at the value without subscribing
pub fn[T] ReadonlySignal::peek(self : ReadonlySignal[T]) -> T {
  self.call0("peek").cast()
}

///|
/// Subscribe to readonly signal changes
pub fn[T] ReadonlySignal::subscribe(
  self : ReadonlySignal[T],
  callback : (T) -> Unit,
) -> () -> Unit {
  let wrapped : (@js.Any) -> Unit = fn(v) { callback(v.cast()) }
  ffi_signal_subscribe(self.to_any(), wrapped).cast()
}

///|
/// Create a new signal with an initial value
#alias(create_signal)
pub fn[T : @js.JsImpl] signal(initial : T) -> Signal[T] {
  ffi_signal(initial.to_any()).cast()
}

///|
extern "js" fn ffi_signal(initial : @js.Any) -> @js.Any =
  #|(v) => globalThis.__PreactSignals.signal(v)

///|
/// Create a computed signal from a function
#alias(create_computed)
pub fn[T] computed(fn_ : () -> T) -> ReadonlySignal[T] {
  let wrapped : () -> @js.Any = fn() { fn_() |> @js.identity }
  ffi_computed(wrapped |> @js.identity).cast()
}

///|
extern "js" fn ffi_computed(fn_ : @js.Any) -> @js.Any =
  #|(fn) => globalThis.__PreactSignals.computed(fn)

///|
/// Create an effect that runs when its dependencies change
/// Returns a dispose function to stop the effect
#alias(create_effect)
pub fn effect(fn_ : () -> Unit) -> () -> Unit {
  ffi_effect(fn_ |> @js.identity).cast()
}

///|
/// Effect with cleanup function
#alias(create_effect_with_cleanup)
pub fn effectWithCleanup(fn_ : () -> () -> Unit) -> () -> Unit {
  ffi_effect(fn_ |> @js.identity).cast()
}

///|
extern "js" fn ffi_effect(fn_ : @js.Any) -> @js.Any =
  #|(fn) => globalThis.__PreactSignals.effect(fn)

///|
/// Batch multiple signal updates together
#alias(batch_updates)
pub fn batch(fn_ : () -> Unit) -> Unit {
  ffi_batch(fn_ |> @js.identity)
}

///|
extern "js" fn ffi_batch(fn_ : @js.Any) -> Unit =
  #|(fn) => globalThis.__PreactSignals.batch(fn)

///|
/// Untracked read - read signals without subscribing
pub fn[T] untracked(fn_ : () -> T) -> T {
  let wrapped : () -> @js.Any = fn() { fn_() |> @js.identity }
  ffi_untracked(wrapped |> @js.identity).cast()
}

///|
extern "js" fn ffi_untracked(fn_ : @js.Any) -> @js.Any =
  #|(fn) => globalThis.__PreactSignals.untracked(fn)

///|
/// Initialize the Preact Signals API
pub fn init_preact_signals(signals : @js.Any) -> Unit {
  if @js.is_nullish(@js.global_this().get("__PreactSignals")) {
    @js.global_this().set("__PreactSignals", signals)
  }
}

///|
/// useSignal hook - Create a signal that persists across renders
#alias(use_signal)
pub fn[T : @js.JsImpl] useSignal(initial : T) -> Signal[T] {
  ffi_use_signal(initial.to_any()).cast()
}

///|
extern "js" fn ffi_use_signal(initial : @js.Any) -> @js.Any =
  #|(v) => globalThis.__PreactSignals.useSignal(v)

///|
/// useComputed hook - Create a computed signal in a component
#alias(use_computed)
pub fn[T] useComputed(fn_ : () -> T) -> ReadonlySignal[T] {
  let wrapped : () -> @js.Any = fn() { fn_() |> @js.identity }
  ffi_use_computed(wrapped |> @js.identity).cast()
}

///|
extern "js" fn ffi_use_computed(fn_ : @js.Any) -> @js.Any =
  #|(fn) => globalThis.__PreactSignals.useComputed(fn)

///|
/// useSignalEffect hook - Run an effect that tracks signal dependencies
#alias(use_signal_effect)
pub fn useSignalEffect(fn_ : () -> Unit) -> Unit {
  ffi_use_signal_effect(fn_ |> @js.identity)
}

///|
extern "js" fn ffi_use_signal_effect(fn_ : @js.Any) -> Unit =
  #|(fn) => globalThis.__PreactSignals.useSignalEffect(fn)
