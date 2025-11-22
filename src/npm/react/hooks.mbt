///|
/// React.useState
/// ```mbt
/// fn my_component (props: EmptyProps) -> Element {
///   let (_count, _set_count) = useState(0)
///   ...
/// }
/// ```
#alias(use_state)
pub fn[T : JsImpl] useState(initial : T) -> (T, (T) -> Unit) {
  let result = ffi_react_use_state(initial.to_js())
  let value : T = result.get(0) |> unsafe_cast
  let update_fn : (T) -> Unit = result.get(1) |> unsafe_cast
  (value, update_fn)
}

///|
/// JS: React.useState(() => initial)
/// ```
/// fn my_component(props: EmptyProps) -> Element {
///   let (_count, _set_count) = use_state_lazy(() => 42)
///   ...
/// }
#alias(useStateLazy)
pub fn[T] use_state_lazy(initial : () -> T) -> (T, (T) -> Unit) {
  let initial : () -> Js = unsafe_cast(initial)
  let result = ffi_react_use_state_lazy(initial)
  let value : T = result.get(0) |> unsafe_cast
  let update_fn : (T) -> Unit = result.get(1) |> unsafe_cast
  (value, update_fn)
}

///|
/// React.useCallback
/// ```mbt
/// fn my_component(_props : EmptyProps) -> Element {
///   let _on_click = useCallback(() => {
///     ()
///   }, [])
///   ...
/// }
/// ```
#alias(use_callback)
pub fn[F] useCallback(f : F, keys : Array[&JsImpl]) -> F {
  let keys = keys.map(k => k.to_js())
  unsafe_cast(ffi_react_use_callback(f |> @js.unsafe_js, keys))
}

///|
/// JS: React.useEffect
/// ```mbt
/// fn my_component(_props : EmptyProps) -> Element {
///   useEffect(() => {
///     println("mounted")
///     () => println("unmounted")
///   }, [])
///   createElement("div", ["Hello"])
/// }
/// ```
#alias(use_effect)
pub fn useEffect(f : () -> () -> Unit, keys : Array[&JsImpl]) -> Unit {
  ffi_react_use_effect(f, keys.map(_.to_js()))
}

///|
#alias(use_layout_effect)
pub fn useLayoutEffect(f : () -> () -> Unit, keys : Array[&JsImpl]) -> Unit {
  ffi_react_use_layout_effect(f, keys.map(_.to_js()))
}

///|
/// React.useMemo
/// ```mbt
/// fn my_component(_props : EmptyProps) -> Element {
///   let _result = useMemo(() => {
///     42
///   }, [])
///   createElement("div", [_result])
/// }
/// ```
#alias(use_memo)
pub fn[T] useMemo(f : () -> T, keys : Array[&JsImpl]) -> T {
  let f = () => f() |> unsafe_cast
  let v : T = unsafe_cast(ffi_react_use_memo(f, keys.map(_.to_js())))
  v
}

///|
/// JS: React.useRef
/// ```mbt
/// fn my_component(_props : EmptyProps) -> Element {
///   let my_ref : ReactRef[@dom.Element] = useRef(None)
///   createElement("div", ref_=my_ref, ["Hello"])
/// }
/// ```
#alias(use_ref)
pub fn[T] useRef(initial : T?) -> ReactRef[T] {
  unsafe_cast(
    ffi_react_use_ref(
      if initial is Some(v) {
        v |> unsafe_cast
      } else {
        @js.undefined()
      },
    ),
  )
}

///|
/// React.Ref<T>
pub(all) struct ReactRef[T] {
  current : @js.Js
}

///|
pub fn[T] ReactRef::get_current(self : ReactRef[T]) -> T? {
  @js.unsafe_cast_option(self.current)
}

///|
pub fn[T] ReactRef::set_current(self : ReactRef[T], value : T?) -> Unit {
  let js_val : @js.Js = match value {
    Some(v) => @js.unsafe_cast(v)
    None => @js.undefined()
  }
  // Direct assignment to JS field
  ffi_set_ref_current(self |> @js.unsafe_cast, js_val)
}

///|
extern "js" fn ffi_set_ref_current(ref_obj : @js.Js, value : @js.Js) -> Unit =
  #| (ref, value) => {
  #|   ref.current = value;
  #| }

///|
pub impl[T] JsImpl for ReactRef[T]

///|
#external
pub type Context[T]

///|
#alias(createContext)
pub fn[T] create_context(initial : T?) -> Context[T] {
  let v = ffi_react_create_context(initial |> @js.unsafe_js)
  unsafe_cast(v)
}

///|
/// React.useContext - internally uses React.use()
#alias(useContext)
pub fn[T] use_context(ctx : Context[T]) -> T {
  unsafe_cast(ffi_react_use(ctx |> unsafe_cast))
}

///|
/// React.use - Use a Promise with React.use()
/// Note: This uses React.use() internally
#alias(usePromise)
pub fn[T] use_promise(promise : Promise[T]) -> T {
  unsafe_cast(ffi_react_use(promise |> unsafe_cast))
}

///|
/// React.useReducer
/// ```mbt
/// enum CounterAction {
///   Increment
/// }
/// fn my_component(_props : EmptyProps) -> Element {
///   let (_state, _dispatch) = use_reducer((s: Int, a: CounterAction) => match a {
///     Increment => s + 1
///   }, 0)
///   createElement("div", [_state])
/// }
/// ```
#alias(useReducer)
pub fn[T, U] use_reducer(
  reducer : (T, U) -> T,
  initial : T,
) -> (T, (U) -> Unit) {
  let val = ffi_react_use_reducer(
    reducer |> @js.unsafe_js,
    initial |> @js.unsafe_cast,
  )
  (val.get(0) |> unsafe_cast, val.get(1) |> unsafe_cast)
}

///|
extern "js" fn use_action_state_internal(f : Js, initial : Js) -> Js =
  #| (f, initial) => {
  #|   return __ReactApi.useActionState(f, initial);
  #| }

///|
#alias(useActionState)
pub fn[T, U] use_action_state(
  f : async (T, U) -> T noraise,
  initial : T,
) -> (T, (U) -> Unit, Bool) {
  let w = promisify2((s, a) => f(s, a))
  let val : Js = use_action_state_internal(
    w |> @js.unsafe_js,
    initial |> @js.unsafe_js,
  )
  (
    val.get(0) |> unsafe_cast,
    val.get(1) |> unsafe_cast,
    val.get(2) |> unsafe_cast,
  )
}

///|
extern "js" fn start_transition_internal(f : () -> Unit) -> Unit =
  #| (f) => {
  #|   return __ReactApi.startTransition(f);
  #| }

///|
#alias(startTransition)
pub fn start_transition(f : () -> Unit) -> Unit {
  start_transition_internal(f)
}

///|
/// Create a lazy-loaded component from a dynamic import function.
/// The import function should return a module with a `default` export of ComponentType[T].
///
/// ```moonbit skip
/// // For components with EmptyProps
/// extern "js" fn load_my_component() -> @js.Promise[@js.Js] =
///   #| () => import("./MyComponent")
///
/// let my_component : ComponentType[EmptyProps] = lazy_(load_my_component)
///
/// // For components with custom props
/// struct MyProps { name : String }
///
/// extern "js" fn load_custom_component() -> @js.Promise[@js.Js] =
///   #| () => import("./CustomComponent")
///
/// let custom_component : ComponentType[MyProps] = lazy_(load_custom_component)
/// ```
pub fn[T] lazy_(f : () -> Promise[Js]) -> ComponentType[T] {
  ffi_react_lazy(f |> @js.unsafe_js) |> unsafe_cast
}

///|
extern "js" fn ffi_use_deferred_value(value : Js) -> Js =
  #| (value) => globalThis.__ReactApi.useDeferredValue(value)

///|
/// React.useDeferredValue - Defer updating a part of the UI
/// see: https://react.dev/reference/react/useDeferredValue
#alias(useDeferredValue)
pub fn[T] use_deferred_value(value : T) -> T {
  ffi_use_deferred_value(value |> @js.unsafe_js) |> unsafe_cast
}

///|
extern "js" fn ffi_use_debug_value(value : Js, formatter : Js) -> Unit =
  #| (value, formatter) => globalThis.__ReactApi.useDebugValue(value, formatter)

///|
/// React.useDebugValue - Add a label to a custom hook in React DevTools
/// see: https://react.dev/reference/react/useDebugValue
#alias(useDebugValue)
pub fn[T] use_debug_value(value : T, formatter? : (T) -> String) -> Unit {
  match formatter {
    Some(f) => ffi_use_debug_value(value |> @js.unsafe_js, f |> @js.unsafe_js)
    None => ffi_use_debug_value(value |> @js.unsafe_js, @js.undefined())
  }
}

///|
extern "js" fn ffi_use_id() -> String =
  #| () => globalThis.__ReactApi.useId()

///|
/// React.useId - Generate unique IDs for accessibility attributes
/// see: https://react.dev/reference/react/useId
#alias(useId)
pub fn use_id() -> String {
  ffi_use_id()
}

///|
extern "js" fn ffi_use_transition() -> Js =
  #| () => globalThis.__ReactApi.useTransition()

///|
/// React.useTransition - Update state without blocking the UI
/// see: https://react.dev/reference/react/useTransition
#alias(useTransition)
pub fn use_transition() -> (Bool, (() -> Unit) -> Unit) {
  let result = ffi_use_transition()
  (result.get(0) |> unsafe_cast, result.get(1) |> unsafe_cast)
}

///|
extern "js" fn ffi_use_optimistic(state : Js, update_fn : Js) -> Js =
  #| (state, updateFn) => globalThis.__ReactApi.useOptimistic(state, updateFn)

///|
/// React.useOptimistic - Show optimistic state while async action is underway
/// see: https://react.dev/reference/react/useOptimistic
#alias(useOptimistic)
pub fn[T, U] use_optimistic(
  state : T,
  update_fn : (T, U) -> T
) -> (T, (U) -> Unit) {
  let result = ffi_use_optimistic(
    state |> @js.unsafe_js,
    update_fn |> @js.unsafe_js,
  )
  (result.get(0) |> unsafe_cast, result.get(1) |> unsafe_cast)
}

///|
extern "js" fn ffi_use_insertion_effect(effect : Js, deps : Js) -> Unit =
  #| (effect, deps) => globalThis.__ReactApi.useInsertionEffect(effect, deps)

///|
/// React.useInsertionEffect - Insert elements into the DOM before layout effects
/// see: https://react.dev/reference/react/useInsertionEffect
#alias(useInsertionEffect)
pub fn use_insertion_effect(f : () -> () -> Unit, keys : Array[&JsImpl]) -> Unit {
  let deps = keys.map(_.to_js()) |> @js.from_array
  ffi_use_insertion_effect(f |> @js.unsafe_js, deps)
}

///|
extern "js" fn ffi_use_sync_external_store(
  subscribe : Js,
  get_snapshot : Js,
  get_server_snapshot : Js
) -> Js =
  #| (subscribe, getSnapshot, getServerSnapshot) => globalThis.__ReactApi.useSyncExternalStore(subscribe, getSnapshot, getServerSnapshot)

///|
/// React.useSyncExternalStore - Subscribe to an external store
/// see: https://react.dev/reference/react/useSyncExternalStore
#alias(useSyncExternalStore)
pub fn[T] use_sync_external_store(
  subscribe : ((Js) -> Unit) -> () -> Unit,
  get_snapshot : () -> T,
  get_server_snapshot? : () -> T
) -> T {
  let server_snapshot = match get_server_snapshot {
    Some(f) => f |> @js.unsafe_js
    None => @js.undefined()
  }
  ffi_use_sync_external_store(
    subscribe |> @js.unsafe_js,
    get_snapshot |> @js.unsafe_js,
    server_snapshot,
  )
  |> unsafe_cast
}

///|
extern "js" fn ffi_use_imperative_handle(ref_ : Js, create : Js, deps : Js) -> Unit =
  #| (ref, create, deps) => globalThis.__ReactApi.useImperativeHandle(ref, create, deps)

///|
/// React.useImperativeHandle - Customize the ref handle exposed to parent
/// see: https://react.dev/reference/react/useImperativeHandle
#alias(useImperativeHandle)
pub fn[T] use_imperative_handle(
  ref_ : ReactRef[T],
  create : () -> T,
  keys : Array[&JsImpl]
) -> Unit {
  let deps = keys.map(_.to_js()) |> @js.from_array
  ffi_use_imperative_handle(ref_ |> @js.unsafe_js, create |> @js.unsafe_js, deps)
}
