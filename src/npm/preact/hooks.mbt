///|
/// Preact.useState
#alias(use_state)
pub fn[T : @js.JsImpl] useState(initial : T) -> (T, (T) -> Unit) {
  let result = ffi_use_state(initial.to_any())
  let value : T = result.get(0).cast()
  let update_fn : (T) -> Unit = result.get(1).cast()
  (value, update_fn)
}

///|
/// Preact.useState with lazy initializer
#alias(use_state_lazy)
pub fn[T] useStateLazy(initial : () -> T) -> (T, (T) -> Unit) {
  let initial : () -> @js.Any = @js.identity(initial)
  let result = ffi_use_state_lazy(initial)
  let value : T = result.get(0).cast()
  let update_fn : (T) -> Unit = result.get(1).cast()
  (value, update_fn)
}

///|
/// Preact.useEffect
#alias(use_effect)
pub fn useEffect(f : () -> () -> Unit, keys : Array[&@js.JsImpl]) -> Unit {
  ffi_use_effect(f, keys.map(_.to_any()))
}

///|
/// Preact.useLayoutEffect
#alias(use_layout_effect)
pub fn useLayoutEffect(f : () -> () -> Unit, keys : Array[&@js.JsImpl]) -> Unit {
  ffi_use_layout_effect(f, keys.map(_.to_any()))
}

///|
/// Preact.useMemo
#alias(use_memo)
pub fn[T] useMemo(f : () -> T, keys : Array[&@js.JsImpl]) -> T {
  let f = () => f() |> @js.identity
  @js.identity(ffi_use_memo(f, keys.map(_.to_any())))
}

///|
/// Preact.useCallback
#alias(use_callback)
pub fn[F] useCallback(f : F, keys : Array[&@js.JsImpl]) -> F {
  let keys = keys.map(k => k.to_any())
  @js.identity(ffi_use_callback(f |> @js.unsafe_any, keys))
}

///|
/// Preact.useRef
#alias(use_ref)
pub fn[T] useRef(initial : T?) -> Ref[T] {
  @js.identity(
    ffi_use_ref(
      if initial is Some(v) {
        v |> @js.identity
      } else {
        @js.undefined()
      },
    ),
  )
}

///|
/// Preact.useReducer
#alias(use_reducer)
pub fn[T, U] useReducer(reducer : (T, U) -> T, initial : T) -> (T, (U) -> Unit) {
  let val = ffi_use_reducer(reducer |> @js.unsafe_any, initial |> @js.identity)
  (val.get(0).cast(), val.get(1).cast())
}

///|
/// Preact.useContext
#alias(use_context)
pub fn[T] useContext(ctx : Context[T]) -> T {
  @js.identity(ffi_use_context(ctx |> @js.identity))
}

///|
/// Preact.useId
#alias(use_id)
pub fn useId() -> String {
  ffi_use_id()
}

///|
/// Preact.useErrorBoundary
/// Returns a tuple of (error, resetError)
#alias(use_error_boundary)
pub fn useErrorBoundary(
  callback? : (@js.Any) -> Unit,
) -> (@js.Any?, () -> Unit) {
  let cb = match callback {
    Some(f) => f |> @js.unsafe_any
    None => @js.undefined()
  }
  let result = ffi_use_error_boundary(cb)
  let error = @js.identity_option(result.get(0))
  let reset : () -> Unit = result.get(1).cast()
  (error, reset)
}

///|
/// Preact.useImperativeHandle
#alias(use_imperative_handle)
pub fn[T] useImperativeHandle(
  ref_ : Ref[T],
  create : () -> T,
  keys : Array[&@js.JsImpl],
) -> Unit {
  let deps = keys.map(_.to_any()) |> @js.from_array
  ffi_use_imperative_handle(
    ref_ |> @js.unsafe_any,
    create |> @js.unsafe_any,
    deps,
  )
}

///|
/// Preact.useDebugValue
#alias(use_debug_value)
pub fn[T] useDebugValue(value : T) -> Unit {
  ffi_use_debug_value(value |> @js.unsafe_any)
}
