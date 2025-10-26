///|
extern "js" fn use_state_internal(initial : @js.Value) -> @js.Value =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn use_callback_internal(
  initial : @js.Value,
  keys : Array[@js.Value],
) -> @js.Value =
  #| (initial, keys) => {
  #|   return __ReactApi.useCallback(initial, keys);
  #| }

///|
extern "js" fn use_ref_internal(initial : @js.Value) -> @js.Value =
  #| (initial) => {
  #|   return __ReactApi.useRef(initial);
  #| }

///|
extern "js" fn use_context_internal(ctx : @js.Value) -> @js.Value =
  #| (ctx) => {
  #|   return __ReactApi.useContext(ctx);
  #| }

///|
extern "js" fn create_context_internal(initial : @js.Value) -> @js.Value =
  #| (initial) => {
  #|   return __ReactApi.createContext(initial);
  #| }

///|
extern "js" fn use_effect_internal(
  f : () -> () -> Unit,
  keys : Array[@js.Value],
) -> Unit =
  #| (f, keys) => {
  #|   return __ReactApi.useEffect(f, keys);
  #| }

///|
extern "js" fn use_memo_internal(
  f : () -> @js.Value,
  keys : Array[@js.Value],
) -> @js.Value =
  #| (f, keys) => {
  #|   return __ReactApi.useMemo(f, keys);
  #| }

///|
extern "js" fn use_reducer_internal(
  reducer : @js.Value,
  initial : @js.Value,
) -> @js.Value =
  #| (reducer, initial) => {
  #|   return __ReactApi.useReducer(reducer, initial);
  #| }

///|
extern "js" fn use_action_state_internal(
  action : @js.Value,
  initial : @js.Value,
  permalink? : String,
) -> @js.Value =
  #| (action, initial, permalink) => {
  #|   return __ReactApi.useActionState(action, initial, permalink);
  #| }

///|
// async fn[T, E : Error] suspend(
//   f : ((T) -> Unit, (E) -> Unit) -> Unit,
// ) -> T raise E = "%async.suspend"

// ///|
// fn run_async(f : async () -> Unit noraise) -> Unit = "%async.run"

///|
/// WIP: Not works yet
fn[S, A] _use_action_state(
  action : async (S, A) -> S noraise,
  initial : S,
  permalink? : String,
) -> (S, (A) -> Unit, Bool) {
  let val = use_action_state_internal(
    action |> @js.identity,
    initial |> @js.identity,
    permalink?,
  )
  (val.at(0).cast(), val.at(1).cast(), val.at(2).cast())
}

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
pub fn use_effect(f : () -> () -> Unit, keys : Array[&@js.ToJsValue]) -> Unit {
  let keys = keys.map(k => k |> @js.identity)
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
      @js.js_undefined()
    },
  )
  result.cast()
}

///|
#external
pub type ReactRef[T]

///|
pub impl[T] @js.ToJsValue for ReactRef[T] with to_js(self) -> @js.Value {
  self |> @js.identity
}

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

///|
#external
pub type Context[T]

///|
pub fn[T] create_context(initial : T?) -> Context[T] {
  let v = create_context_internal(initial |> @js.identity)
  v.cast()
}

///|
pub fn[T] use_context(ctx : Context[T]) -> T {
  use_context_internal(ctx |> @js.identity).cast()
}

///|
extern "js" fn use_internal(v : @js.Value) -> @js.Value =
  #| (v) => __ReactApi.use(v)

///|
pub fn[T] use_(promise : @js.Promise[T]) -> T {
  use_internal(promise |> @js.identity).cast()
}

///|
pub fn[T, U] use_reducer(
  reducer : (T, U) -> T,
  initial : T,
) -> (T, (U) -> Unit) {
  let val = use_reducer_internal(
    reducer |> @js.identity,
    initial |> @js.identity,
  )
  (val.at(0).cast(), val.at(1).cast())
}
