///|
extern "js" fn use_state_internal(initial : @js.Value) -> @js.Value =
  #| (initial) => {
  #|   return ReactLib.useState(initial);
  #| }

///|
extern "js" fn use_callback_internal(
  initial : @js.Value,
  keys : Array[@js.Value],
) -> @js.Value =
  #| (initial, keys) => {
  #|   return ReactLib.useCallback(initial, keys);
  #| }

///|
extern "js" fn use_ref_internal(initial : @js.Value) -> @js.Value =
  #| (initial) => {
  #|   return ReactLib.useRef(initial);
  #| }

///|
extern "js" fn use_effect_internal(
  f : () -> () -> Unit,
  keys : Array[@js.Value],
) -> Unit =
  #| (f, keys) => {
  #|   return ReactLib.useEffect(f, keys);
  #| }

///|
extern "js" fn use_memo_internal(
  f : () -> @js.Value,
  keys : Array[@js.Value],
) -> @js.Value =
  #| (f, keys) => {
  #|   return ReactLib.useMemo(f, keys);
  #| }

///|
pub fn[T : @js.ToJsValue] use_state(initial : T) -> (T, (T) -> Unit) {
  let result = use_state_internal(initial.to_js())
  let value : T = result.at(0).cast()
  let update_fn : (T) -> Unit = result.at(1).cast()
  (value, update_fn)
}

///|
pub fn[F] use_callback(f : F, keys : Array[&@js.ToJsValue]) -> F {
  let keys = keys.map(k => k.to_js())
  use_callback_internal(f |> @js.identity, keys).cast()
}

///|
pub fn use_effect(f : () -> () -> Unit, keys : Array[@js.Value]) -> Unit {
  use_effect_internal(f, keys)
}

///|
pub fn[T] use_memo(f : () -> T, keys : Array[@js.Value]) -> T {
  let f = () => f() |> @js.Value::cast_from
  let v : T = use_memo_internal(f, keys).cast()
  v
}

///|
pub fn[T] use_ref(initial : T?) -> ReactRef[T] {
  let result = use_ref_internal(
    if initial is Some(v) {
      v |> @js.identity
    } else {
      @js.Value::js_undefined()
    },
  )
  result.cast()
}

///|
#external
pub type ReactRef[T]

///|
extern "js" fn current_internal(v : @js.Value) -> @js.Value =
  #| (v) => v.current

///|
extern "js" fn set_current_internal(v : @js.Value, o : @js.Value) -> Unit =
  #| (v, o) => v.current = o

///|
pub fn[T] ReactRef::current(v : ReactRef[T]) -> T? {
  let v = current_internal(v |> @js.identity)
  if v.is_undefined() || v.is_null() {
    None
  } else {
    Some(v.cast())
  }
}

///|
pub fn[T] ReactRef::set_current(v : ReactRef[T], o : T) -> Unit {
  set_current_internal(v |> @js.identity, o |> @js.identity)
}
