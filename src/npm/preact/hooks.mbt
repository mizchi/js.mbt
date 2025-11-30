///|
/// Preact.useState
#alias(use_state)
pub fn[T] useState(initial : T) -> (T, (T) -> Unit) {
  let result = ffi_use_state(@nostd.any(initial))
  let value : T = result["0"].cast()
  let update_fn : (T) -> Unit = result["1"].cast()
  (value, update_fn)
}

///|
/// Preact.useState with lazy initializer
#alias(use_state_lazy)
pub fn[T] useStateLazy(initial : () -> T) -> (T, (T) -> Unit) {
  let initial : () -> @nostd.Any = fn() { @nostd.any(initial()) }
  let result = ffi_use_state_lazy(initial)
  let value : T = result["0"].cast()
  let update_fn : (T) -> Unit = result["1"].cast()
  (value, update_fn)
}

///|
/// Preact.useEffect
#alias(use_effect)
pub fn useEffect(f : () -> () -> Unit, keys : Array[@nostd.Any]) -> Unit {
  ffi_use_effect(f, keys)
}

///|
/// Preact.useLayoutEffect
#alias(use_layout_effect)
pub fn useLayoutEffect(f : () -> () -> Unit, keys : Array[@nostd.Any]) -> Unit {
  ffi_use_layout_effect(f, keys)
}

///|
/// Preact.useMemo
#alias(use_memo)
pub fn[T] useMemo(f : () -> T, keys : Array[@nostd.Any]) -> T {
  let f = fn() { @nostd.any(f()) }
  ffi_use_memo(f, keys).cast()
}

///|
/// Preact.useCallback
#alias(use_callback)
pub fn[F] useCallback(f : F, keys : Array[@nostd.Any]) -> F {
  ffi_use_callback(@nostd.any(f), keys).cast()
}

///|
/// Preact.useRef
#alias(use_ref)
pub fn[T] useRef(initial : T?) -> Ref[T] {
  ffi_use_ref(
    if initial is Some(v) {
      @nostd.any(v)
    } else {
      @nostd.undefined()
    },
  ).cast()
}

///|
/// Preact.useReducer
#alias(use_reducer)
pub fn[T, U] useReducer(reducer : (T, U) -> T, initial : T) -> (T, (U) -> Unit) {
  let val = ffi_use_reducer(@nostd.any(reducer), @nostd.any(initial))
  (val["0"].cast(), val["1"].cast())
}

///|
/// Preact.useContext
#alias(use_context)
pub fn[T] useContext(ctx : Context[T]) -> T {
  ffi_use_context(ctx.as_any()).cast()
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
  callback? : (@nostd.Any) -> Unit,
) -> (@nostd.Any?, () -> Unit) {
  let cb = match callback {
    Some(f) => @nostd.any(f)
    None => @nostd.undefined()
  }
  let result = ffi_use_error_boundary(cb)
  let error = if @nostd.is_nullish(result["0"]) {
    None
  } else {
    Some(result["0"])
  }
  let reset : () -> Unit = result["1"].cast()
  (error, reset)
}

///|
/// Preact.useImperativeHandle
#alias(use_imperative_handle)
pub fn[T] useImperativeHandle(
  ref_ : Ref[T],
  create : () -> T,
  keys : Array[@nostd.Any],
) -> Unit {
  ffi_use_imperative_handle(ref_.as_any(), @nostd.any(create), @nostd.any(keys))
}

///|
/// Preact.useDebugValue
#alias(use_debug_value)
pub fn[T] useDebugValue(value : T) -> Unit {
  ffi_use_debug_value(@nostd.any(value))
}
