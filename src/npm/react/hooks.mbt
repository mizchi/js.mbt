///|
/// React.useState
#alias(use_state)
pub fn[T : @js.JsImpl] useState(initial : T) -> (T, (T) -> Unit) {
  let result = ffi_react_use_state(initial.to_js())
  let value : T = result.get(0) |> @js.identity
  let update_fn : (T) -> Unit = result.get(1) |> @js.identity
  (value, update_fn)
}

///|
/// JS: React.useState(() => initial)
#alias(useStateLazy)
pub fn[T] use_state_lazy(initial : () -> T) -> (T, (T) -> Unit) {
  let initial : () -> @js.Js = @js.identity(initial)
  let result = ffi_react_use_state_lazy(initial)
  let value : T = result.get(0) |> @js.identity
  let update_fn : (T) -> Unit = result.get(1) |> @js.identity
  (value, update_fn)
}

///|
/// React.useCallback
#alias(use_callback)
pub fn[F] useCallback(f : F, keys : Array[&@js.JsImpl]) -> F {
  let keys = keys.map(k => k.to_js())
  @js.identity(ffi_react_use_callback(f |> @js.unsafe_js, keys))
}

///|
/// JS: React.useEffect
#alias(use_effect)
pub fn useEffect(f : () -> () -> Unit, keys : Array[&@js.JsImpl]) -> Unit {
  ffi_react_use_effect(f, keys.map(_.to_js()))
}

///|
#alias(use_layout_effect)
pub fn useLayoutEffect(f : () -> () -> Unit, keys : Array[&@js.JsImpl]) -> Unit {
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
pub fn[T] useMemo(f : () -> T, keys : Array[&@js.JsImpl]) -> T {
  let f = () => f() |> @js.identity
  let v : T = @js.identity(ffi_react_use_memo(f, keys.map(_.to_js())))
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
  @js.identity(
    ffi_react_use_ref(
      if initial is Some(v) {
        v |> @js.identity
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
  @js.identity_option(self.current)
}

///|
pub fn[T] ReactRef::set_current(self : ReactRef[T], value : T?) -> Unit {
  let js_val : @js.Js = match value {
    Some(v) => @js.identity(v)
    None => @js.undefined()
  }
  // Direct assignment to JS field
  ffi_set_ref_current(self |> @js.identity, js_val)
}

///|
extern "js" fn ffi_set_ref_current(ref_obj : @js.Js, value : @js.Js) -> Unit =
  #| (ref, value) => {
  #|   ref.current = value;
  #| }

///|
pub impl[T] @js.JsImpl for ReactRef[T]

///|
#external
pub type Context[T]

///|
#alias(createContext)
pub fn[T] create_context(initial : T?) -> Context[T] {
  let v = ffi_react_create_context(initial |> @js.unsafe_js)
  @js.identity(v)
}

///|
/// React.useContext - internally uses React.use()
#alias(useContext)
pub fn[T] use_context(ctx : Context[T]) -> T {
  @js.identity(ffi_react_use(ctx |> @js.identity))
}

///|
/// React.use - Use a Promise with React.use()
/// Note: This uses React.use() internally
#alias(usePromise)
pub fn[T] use_promise(promise : @js.Promise[T]) -> T {
  @js.identity(ffi_react_use(promise |> @js.identity))
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
    initial |> @js.identity,
  )
  (val.get(0) |> @js.identity, val.get(1).cast())
}

///|
extern "js" fn use_action_state_internal(
  f : @js.Js,
  initial : @js.Js,
) -> @js.Js =
  #| (f, initial) => {
  #|   return __ReactApi.useActionState(f, initial);
  #| }

///|
#alias(useActionState)
pub fn[T, U] use_action_state(
  f : async (T, U) -> T noraise,
  initial : T,
) -> (T, (U) -> Unit, Bool) {
  let w = @js.promisify2((s, a) => f(s, a))
  let val : @js.Js = use_action_state_internal(
    w |> @js.unsafe_js,
    initial |> @js.unsafe_js,
  )
  (
    val.get(0) |> @js.identity,
    val.get(1) |> @js.identity,
    val.get(2) |> @js.identity,
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
pub fn[T] lazy_(f : () -> @js.Promise[@js.Js]) -> Component[T] {
  ffi_react_lazy(f |> @js.unsafe_js) |> @js.identity
}

///|
extern "js" fn ffi_use_deferred_value(
  value : @js.Js,
  initial_value : @js.Js,
) -> @js.Js =
  #| (value, initialValue) => globalThis.__ReactApi.useDeferredValue(value, initialValue)

///|
/// React.useDeferredValue - Defer updating a part of the UI
/// TypeScript: function useDeferredValue<T>(value: T, initialValue?: T): T
/// see: https://react.dev/reference/react/useDeferredValue
#alias(useDeferredValue)
pub fn[T] use_deferred_value(value : T, initial_value? : T) -> T {
  let initial = match initial_value {
    Some(v) => v |> @js.unsafe_js
    None => @js.undefined()
  }
  ffi_use_deferred_value(value |> @js.unsafe_js, initial) |> @js.identity
}

///|
extern "js" fn ffi_use_debug_value(value : @js.Js, formatter : @js.Js) -> Unit =
  #| (value, formatter) => globalThis.__ReactApi.useDebugValue(value, formatter)

///|
/// React.useDebugValue - Add a label to a custom hook in React DevTools
/// TypeScript: function useDebugValue<T>(value: T, format?: (value: T) => any): void
/// see: https://react.dev/reference/react/useDebugValue
#alias(useDebugValue)
pub fn[T, R] use_debug_value(value : T, format? : (T) -> R) -> Unit {
  match format {
    Some(f) => ffi_use_debug_value(value |> @js.unsafe_js, f |> @js.unsafe_js)
    None => ffi_use_debug_value(value |> @js.unsafe_js, @js.undefined())
  }
}

///|
extern "js" fn ffi_use_id() -> String =
  #| () => globalThis.__ReactApi.useId()

///|
/// React.useId - Generate unique IDs for accessibility attributes
/// TypeScript: function useId(): string
/// see: https://react.dev/reference/react/useId
#alias(useId)
pub fn use_id() -> String {
  ffi_use_id()
}

///|
extern "js" fn ffi_use_transition() -> @js.Js =
  #| () => globalThis.__ReactApi.useTransition()

///|
/// React.useTransition - Update state without blocking the UI
/// TypeScript: function useTransition(): [boolean, (callback: () => void) => void]
/// see: https://react.dev/reference/react/useTransition
#alias(useTransition)
pub fn use_transition() -> (Bool, (() -> Unit) -> Unit) {
  let result = ffi_use_transition()
  (result.get(0) |> @js.identity, result.get(1).cast())
}

///|
extern "js" fn ffi_use_optimistic(state : @js.Js, update_fn : @js.Js) -> @js.Js =
  #| (state, updateFn) => globalThis.__ReactApi.useOptimistic(state, updateFn)

///|
/// React.useOptimistic - Show optimistic state while async action is underway
/// TypeScript: function useOptimistic<S, A>(state: S, updateFn: (currentState: S, optimisticValue: A) => S): [S, (optimisticValue: A) => void]
/// see: https://react.dev/reference/react/useOptimistic
#alias(useOptimistic)
pub fn[S, A] use_optimistic(
  state : S,
  update_fn : (S, A) -> S,
) -> (S, (A) -> Unit) {
  let result = ffi_use_optimistic(
    state |> @js.unsafe_js,
    update_fn |> @js.unsafe_js,
  )
  (result.get(0) |> @js.identity, result.get(1).cast())
}

///|
extern "js" fn ffi_use_insertion_effect(effect : @js.Js, deps : @js.Js) -> Unit =
  #| (effect, deps) => globalThis.__ReactApi.useInsertionEffect(effect, deps)

///|
/// React.useInsertionEffect - Insert elements into the DOM before layout effects
/// TypeScript: function useInsertionEffect(effect: EffectCallback, deps?: DependencyList): void
/// see: https://react.dev/reference/react/useInsertionEffect
#alias(useInsertionEffect)
pub fn use_insertion_effect(
  f : () -> () -> Unit,
  keys : Array[&@js.JsImpl],
) -> Unit {
  let deps = keys.map(_.to_js()) |> @js.from_array
  ffi_use_insertion_effect(f |> @js.unsafe_js, deps)
}

///|
extern "js" fn ffi_use_sync_external_store(
  subscribe : @js.Js,
  get_snapshot : @js.Js,
  get_server_snapshot : @js.Js,
) -> @js.Js =
  #| (subscribe, getSnapshot, getServerSnapshot) => globalThis.__ReactApi.useSyncExternalStore(subscribe, getSnapshot, getServerSnapshot)

///|
/// React.useSyncExternalStore - Subscribe to an external store
/// TypeScript: function useSyncExternalStore<Snapshot>(subscribe: (onStoreChange: () => void) => () => void, getSnapshot: () => Snapshot, getServerSnapshot?: () => Snapshot): Snapshot
/// see: https://react.dev/reference/react/useSyncExternalStore
#alias(useSyncExternalStore)
pub fn[Snapshot] use_sync_external_store(
  subscribe : (() -> Unit) -> () -> Unit,
  get_snapshot : () -> Snapshot,
  get_server_snapshot? : () -> Snapshot,
) -> Snapshot {
  let server_snapshot = match get_server_snapshot {
    Some(f) => f |> @js.unsafe_js
    None => @js.undefined()
  }
  ffi_use_sync_external_store(
    subscribe |> @js.unsafe_js,
    get_snapshot |> @js.unsafe_js,
    server_snapshot,
  )
  |> @js.identity
}

///|
extern "js" fn ffi_use_imperative_handle(
  ref_ : @js.Js,
  create : @js.Js,
  deps : @js.Js,
) -> Unit =
  #| (ref, create, deps) => globalThis.__ReactApi.useImperativeHandle(ref, create, deps)

///|
/// React.useImperativeHandle - Customize the ref handle exposed to parent
/// TypeScript: function useImperativeHandle<T, R extends T>(ref: Ref<T> | undefined, init: () => R, deps?: DependencyList): void
/// see: https://react.dev/reference/react/useImperativeHandle
#alias(useImperativeHandle)
pub fn[T] use_imperative_handle(
  ref_ : ReactRef[T],
  create : () -> T,
  keys : Array[&@js.JsImpl],
) -> Unit {
  let deps = keys.map(_.to_js()) |> @js.from_array
  ffi_use_imperative_handle(
    ref_ |> @js.unsafe_js,
    create |> @js.unsafe_js,
    deps,
  )
}

///|
extern "js" fn ffi_capture_owner_stack() -> @js.Js =
  #| () => globalThis.__ReactApi.captureOwnerStack ? globalThis.__ReactApi.captureOwnerStack() : null

///|
/// React.captureOwnerStack - Capture component stack for debugging (DEV only)
/// see: https://react.dev/reference/react/captureOwnerStack
#alias(captureOwnerStack)
pub fn capture_owner_stack() -> @js.Js? {
  let result = ffi_capture_owner_stack()
  if @js.is_nullish(result) {
    None
  } else {
    Some(result)
  }
}

///|
extern "js" fn ffi_cache_signal() -> @js.Js =
  #| () => globalThis.__ReactApi.cacheSignal ? globalThis.__ReactApi.cacheSignal() : { current: null }

///|
/// React.cacheSignal - Create cache signal for use with cache()
/// see: https://react.dev/reference/react/cacheSignal
#alias(cacheSignal)
pub fn cache_signal() -> @js.Js {
  ffi_cache_signal()
}

///|
extern "js" fn ffi_react_cache(fn_ : @js.Js) -> @js.Js =
  #| (fn) => globalThis.__ReactApi.cache ? globalThis.__ReactApi.cache(fn) : fn

///|
/// React.cache - Cache data fetching or computation results
/// TypeScript: function cache<CachedFunction extends Function>(fn: CachedFunction): CachedFunction
/// see: https://react.dev/reference/react/cache
#alias(reactCache)
pub fn[T, R] react_cache(f : (T) -> R) -> (T) -> R {
  ffi_react_cache(f |> @js.unsafe_js) |> @js.identity
}

///|
extern "js" fn ffi_act(callback : @js.Js) -> @js.Js =
  #| (callback) => globalThis.__ReactApi.act(callback)

///|
/// React.act - Wrap test code to apply updates before assertions
/// see: https://react.dev/reference/react/act
pub fn act(callback : () -> Unit) -> @js.Promise[Unit] {
  ffi_act(callback |> @js.unsafe_js) |> @js.identity
}

///|
extern "js" fn ffi_act_async(callback : @js.Js) -> @js.Promise[Unit] =
  #| async (callback) => await globalThis.__ReactApi.act(callback)

///|
/// React.act (async) - Wrap async test code to apply updates before assertions
/// see: https://react.dev/reference/react/act
#alias(actAsync)
pub async fn act_async(callback : async () -> Unit) -> Unit {
  let promise_fn = @js.promisify0(callback)
  ffi_act_async(promise_fn |> @js.unsafe_js).wait()
}
