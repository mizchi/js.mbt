///|
extern "js" fn use_state_internal(initial : @js.Value) -> @js.Value =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn use_state_lazy_internal(initial : () -> @js.Value) -> @js.Value =
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
  #| (ctx) => globalThis.__ReactApi.useContext(ctx)

///|
extern "js" fn lazy_internal(f : @js.Value) -> @js.Promise[@js.Value] =
  #| (f) => globalThis.__ReactApi.lazy(f)

///|
/// wip
/// ```nocheck
/// extern "js" fn load_my_lazy_component() -> @js.Promise[@js.Value] =
///   #| () => import("./MyLazyComponent")
/// struct MyLazyComponentProps {}
/// let my_lazy_component: (props: MyLazyComponentProps) -> Element =
///   lazy_(load_my_lazy_component)
/// ```
pub fn[T] lazy_(
  f : async () -> (T) -> Element,
) -> (EmptyProps) -> @js.Promise[@js.Value] {
  f |> @js.to_promise_fn0 |> @js.to_js |> lazy_internal() |> @js.identity
}

///|
extern "js" fn create_context_internal(initial : @js.Value) -> @js.Value =
  #| (initial) => {
  #|   if (globalThis.__ReactApi === undefined) {
  #|     throw new Error("React.createContext is not available");
  #|   }
  #|   return __ReactApi.createContext(initial);
  #| }

///|
extern "js" fn ffi_use_effect(
  f : () -> () -> Unit,
  keys : Array[@js.Value],
) -> Unit =
  #| (f, keys) => {
  #|   return __ReactApi.useEffect(f, keys);
  #| }

///|
extern "js" fn ffi_use_layout_effect(
  f : () -> () -> Unit,
  keys : Array[@js.Value],
) -> Unit =
  #| (f, keys) => __ReactApi.useLayoutEffect(f, keys)


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
/// React.useState
/// ```mbt
/// fn my_component (props: EmptyProps) -> Element {
///   let (count, set_count) = use_state(0)
///   ...
/// }
/// ```
pub fn[T : @js.ToJs] use_state(initial : T) -> (T, (T) -> Unit) {
  let result = use_state_internal(initial.to_js())
  let value : T = result.at(0).cast()
  let update_fn : (T) -> Unit = result.at(1).cast()
  (value, update_fn)
}

///|
/// React.useState(() => initial) with lazy initial value
/// ```
/// fn my_component(props: EmptyProps) -> Element {
///   let (count, set_count) = use_state_lazy(() => 42)
///   ...
/// }
pub fn[T] use_state_lazy(initial : () -> T) -> (T, (T) -> Unit) {
  let initial : () -> @js.Value = (initial |> @js.to_js).cast()
  let result = use_state_lazy_internal(initial)
  let value : T = result.at(0).cast()
  let update_fn : (T) -> Unit = result.at(1).cast()
  (value, update_fn)
}

///|
/// React.useCallback
/// ```mbt
/// fn my_component(props : EmptyProps) -> Element {
///   let on_click = use_callback(() => {
///     ()
///   }, [])
///   ...
/// }
/// ```
pub fn[F] use_callback(f : F, keys : Array[&@js.ToJs]) -> F {
  let keys = keys.map(k => k.to_js())
  use_callback_internal(f |> @js.identity, keys).cast()
}

///|
/// React.useEffect
/// ```mbt
/// fn my_component(props : EmptyProps) -> Element {
///   use_effect(() => {
///     println("mounted")
///     () => println("unmounted")
///   }, [])
///   create_element("div", ["Hello"])
/// }
/// ```
pub fn use_effect(f : () -> () -> Unit, keys : Array[&@js.ToJs]) -> Unit {
  ffi_use_effect(f, keys.map(_.to_js()))
}

///|
pub fn use_layout_effect(f : () -> () -> Unit, keys : Array[&@js.ToJs]) -> Unit {
  ffi_use_layout_effect(f, keys.map(_.to_js()))
}

///|
pub fn[T] use_memo(f : () -> T, keys : Array[@js.Value]) -> T {
  let f = () => f() |> @js.to_js
  let v : T = use_memo_internal(f, keys).cast()
  v
}

///|
/// React.useRef
/// ```mbt
/// fn my_component(props : EmptyProps) -> Element {
///   let my_ref : ReactRef[@dom.Element] = use_ref(None)
///   create_element("div", ref_=my_ref, ["Hello"])
/// }
/// ```
pub fn[T] use_ref(initial : T?) -> ReactRef[T] {
  use_ref_internal(
    if initial is Some(v) {
      v |> @js.identity
    } else {
      @js.js_undefined()
    },
  ).cast()
}

///|
/// React.Ref<T>
#external
pub type ReactRef[T]

///|
pub impl[T] @js.ToJs for ReactRef[T] with to_js(self) -> @js.Value {
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
/// React.useContext
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
/// React.useReducer
/// ```mbt
/// enum CounterAction {
///   Increment
/// }
/// fn my_component(props : EmptyProps) -> Element {
///   let (state, dispatch) = use_reducer((s: Int, a: CounterAction) => match a {
///     Increment => s + 1
///   }, 0)
///   create_element("div", [state])
/// }
/// ```
pub fn[T, U] use_reducer(
  reducer : (T, U) -> T,
  initial : T,
) -> (T, (U) -> Unit) {
  let val = use_reducer_internal(
    reducer |> @js.to_js,
    initial |> @js.to_js,
  )
  (val.at(0).cast(), val.at(1).cast())
}

///|
extern "js" fn use_action_state_internal(
  f : @js.Value,
  initial : @js.Value,
) -> @js.Value =
  #| (f, initial) => {
  #|   return __ReactApi.useActionState(f, initial);
  #| }

///|
pub fn[T, U] use_action_state(
  f : async (T, U) -> T noraise,
  initial : T,
) -> (T, (U) -> Unit, Bool) {
  let w = @js.to_promise_fn2((s, a) => f(s, a))
  let val : @js.Value = use_action_state_internal(
    w |> @js.identity,
    initial |> @js.identity,
  )
  (val.at(0).cast(), val.at(1).cast(), val.at(2).cast())
}

///|
extern "js" fn start_transition_internal(f : () -> Unit) -> Unit =
  #| (f) => {
  #|   return __ReactApi.startTransition(f);
  #| }

///|
pub fn start_transition(f : () -> Unit) -> Unit {
  start_transition_internal(f)
}
