///|
/// React.useState
#alias(use_state)
pub fn[T] useState(initial : T) -> (T, (T) -> Unit) {
  let result = ffi_react_use_state(@core.any(initial))
  let value : T = result["0"].cast()
  let update_fn : (T) -> Unit = result["1"].cast()
  (value, update_fn)
}

///|
/// JS: React.useState(() => initial)
#alias(useStateLazy)
pub fn[T] use_state_lazy(initial : () -> T) -> (T, (T) -> Unit) {
  let initial : () -> @core.Any = fn() { @core.any(initial()) }
  let result = ffi_react_use_state_lazy(initial)
  let value : T = result["0"].cast()
  let update_fn : (T) -> Unit = result["1"].cast()
  (value, update_fn)
}

///|
/// React.useCallback
#alias(use_callback)
pub fn[F] useCallback(f : F, keys : Array[@core.Any]) -> F {
  ffi_react_use_callback(@core.any(f), keys).cast()
}

///|
/// JS: React.useEffect
#alias(use_effect)
pub fn useEffect(f : () -> () -> Unit, keys : Array[@core.Any]) -> Unit {
  ffi_react_use_effect(f, keys)
}

///|
#alias(use_layout_effect)
pub fn useLayoutEffect(f : () -> () -> Unit, keys : Array[@core.Any]) -> Unit {
  ffi_react_use_layout_effect(f, keys)
}

///|
/// React.useMemo
/// ```mbt
/// fn my_component(_props : Unit) -> Element {
///   let _result = useMemo(() => 42, [])
///   createElement("div", [_result])
/// }
/// ```
#alias(use_memo)
pub fn[T] useMemo(f : () -> T, keys : Array[@core.Any]) -> T {
  let f = fn() { @core.any(f()) }
  ffi_react_use_memo(f, keys).cast()
}

///|
/// JS: React.useRef
/// ```mbt
/// fn my_component(_props : Unit) -> Element {
///   let my_ref : ReactRef[@dom.Element] = useRef(None)
///   createElement("div", ref_=my_ref, ["Hello"])
/// }
/// ```
#alias(use_ref)
pub fn[T] useRef(initial : T?) -> ReactRef[T] {
  ffi_react_use_ref(
    if initial is Some(v) {
      @core.any(v)
    } else {
      @core.undefined()
    },
  ).cast()
}

///|
/// React.Ref<T>
pub(all) struct ReactRef[T] {
  current : @core.Any
}

///|
pub fn[T] ReactRef::as_any(self : ReactRef[T]) -> @core.Any = "%identity"

///|
pub fn[T] ReactRef::get_current(self : ReactRef[T]) -> T? {
  if @core.is_nullish(self.current) {
    None
  } else {
    Some(self.current.cast())
  }
}

///|
pub fn[T] ReactRef::set_current(self : ReactRef[T], value : T?) -> Unit {
  let js_val : @core.Any = match value {
    Some(v) => @core.any(v)
    None => @core.undefined()
  }
  ffi_set_ref_current(self.as_any(), js_val)
}

///|
extern "js" fn ffi_set_ref_current(
  ref_obj : @core.Any,
  value : @core.Any,
) -> Unit =
  #| (ref, value) => {
  #|   ref.current = value;
  #| }

///|
#external
pub type Context[T]

///|
pub fn[T] Context::as_any(self : Context[T]) -> @core.Any = "%identity"

///|
#alias(createContext)
pub fn[T] create_context(initial : T?) -> Context[T] {
  ffi_react_create_context(@core.any(initial)).cast()
}

///|
/// React.useContext - internally uses React.use()
#alias(useContext)
pub fn[T] use_context(ctx : Context[T]) -> T {
  ffi_react_use(ctx.as_any()).cast()
}

///|
/// React.use - Use a Promise with React.use()
/// Note: This uses React.use() internally
#alias(usePromise)
pub fn[T] use_promise(promise : @core.Promise[T]) -> T {
  ffi_react_use(@core.any(promise)).cast()
}

///|
/// React.useReducer
/// ```mbt
/// enum CounterAction {
///   Increment
/// }
///
/// fn my_component(_props : Unit) -> Element {
///   let (_state, _dispatch) = use_reducer(
///     (s : Int, a : CounterAction) => match a {
///       Increment => s + 1
///     },
///     0,
///   )
///   createElement("div", [_state])
/// }
/// ```
#alias(useReducer)
pub fn[T, U] use_reducer(
  reducer : (T, U) -> T,
  initial : T,
) -> (T, (U) -> Unit) {
  let val = ffi_react_use_reducer(@core.any(reducer), @core.any(initial))
  (val["0"].cast(), val["1"].cast())
}

///|
extern "js" fn use_action_state_internal(
  f : @core.Any,
  initial : @core.Any,
) -> @core.Any =
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
  let val = use_action_state_internal(@core.any(w), @core.any(initial))
  (val["0"].cast(), val["1"].cast(), val["2"].cast())
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
/// // For components with Unit
/// extern "js" fn load_my_component() -> @core.Promise[@core.Any] =
///   #| () => import("./MyComponent")
///
/// let my_component : ComponentType[Unit] = lazy_(load_my_component)
///
/// // For components with custom props
///
/// struct MyProps {
///   name : String
/// }
///
/// extern "js" fn load_custom_component() -> @core.Promise[@core.Any] =
///   #| () => import("./CustomComponent")
///
/// let custom_component : ComponentType[MyProps] = lazy_(load_custom_component)
/// ```
pub fn[T] lazy_(f : () -> @core.Promise[@core.Any]) -> Component[T] {
  ffi_react_lazy(@core.any(f)).cast()
}

///|
extern "js" fn ffi_use_deferred_value(
  value : @core.Any,
  initial_value : @core.Any,
) -> @core.Any =
  #| (value, initialValue) => globalThis.__ReactApi.useDeferredValue(value, initialValue)

///|
/// React.useDeferredValue - Defer updating a part of the UI
/// TypeScript: function useDeferredValue<T>(value: T, initialValue?: T): T
/// see: https://react.dev/reference/react/useDeferredValue
#alias(useDeferredValue)
pub fn[T] use_deferred_value(value : T, initial_value? : T) -> T {
  let initial = match initial_value {
    Some(v) => @core.any(v)
    None => @core.undefined()
  }
  ffi_use_deferred_value(@core.any(value), initial).cast()
}

///|
extern "js" fn ffi_use_debug_value(
  value : @core.Any,
  formatter : @core.Any,
) -> Unit =
  #| (value, formatter) => globalThis.__ReactApi.useDebugValue(value, formatter)

///|
/// React.useDebugValue - Add a label to a custom hook in React DevTools
/// TypeScript: function useDebugValue<T>(value: T, format?: (value: T) => any): void
/// see: https://react.dev/reference/react/useDebugValue
#alias(useDebugValue)
pub fn[T, R] use_debug_value(value : T, format? : (T) -> R) -> Unit {
  match format {
    Some(f) => ffi_use_debug_value(@core.any(value), @core.any(f))
    None => ffi_use_debug_value(@core.any(value), @core.undefined())
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
extern "js" fn ffi_use_transition() -> @core.Any =
  #| () => globalThis.__ReactApi.useTransition()

///|
/// React.useTransition - Update state without blocking the UI
/// TypeScript: function useTransition(): [boolean, (callback: () => void) => void]
/// see: https://react.dev/reference/react/useTransition
#alias(useTransition)
pub fn use_transition() -> (Bool, (() -> Unit) -> Unit) {
  let result = ffi_use_transition()
  (result["0"].cast(), result["1"].cast())
}

///|
extern "js" fn ffi_use_optimistic(
  state : @core.Any,
  update_fn : @core.Any,
) -> @core.Any =
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
  let result = ffi_use_optimistic(@core.any(state), @core.any(update_fn))
  (result["0"].cast(), result["1"].cast())
}

///|
extern "js" fn ffi_use_insertion_effect(
  effect : @core.Any,
  deps : @core.Any,
) -> Unit =
  #| (effect, deps) => globalThis.__ReactApi.useInsertionEffect(effect, deps)

///|
/// React.useInsertionEffect - Insert elements into the DOM before layout effects
/// TypeScript: function useInsertionEffect(effect: EffectCallback, deps?: DependencyList): void
/// see: https://react.dev/reference/react/useInsertionEffect
#alias(useInsertionEffect)
pub fn use_insertion_effect(
  f : () -> () -> Unit,
  keys : Array[@core.Any],
) -> Unit {
  ffi_use_insertion_effect(@core.any(f), @core.any(keys))
}

///|
extern "js" fn ffi_use_sync_external_store(
  subscribe : @core.Any,
  get_snapshot : @core.Any,
  get_server_snapshot : @core.Any,
) -> @core.Any =
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
    Some(f) => @core.any(f)
    None => @core.undefined()
  }
  ffi_use_sync_external_store(
    @core.any(subscribe),
    @core.any(get_snapshot),
    server_snapshot,
  ).cast()
}

///|
extern "js" fn ffi_use_imperative_handle(
  ref_ : @core.Any,
  create : @core.Any,
  deps : @core.Any,
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
  keys : Array[@core.Any],
) -> Unit {
  ffi_use_imperative_handle(ref_.as_any(), @core.any(create), @core.any(keys))
}

///|
extern "js" fn ffi_capture_owner_stack() -> @core.Any =
  #| () => globalThis.__ReactApi.captureOwnerStack ? globalThis.__ReactApi.captureOwnerStack() : null

///|
/// React.captureOwnerStack - Capture component stack for debugging (DEV only)
/// see: https://react.dev/reference/react/captureOwnerStack
#alias(captureOwnerStack)
pub fn capture_owner_stack() -> @core.Any? {
  let result = ffi_capture_owner_stack()
  if @core.is_nullish(result) {
    None
  } else {
    Some(result)
  }
}

///|
extern "js" fn ffi_cache_signal() -> @core.Any =
  #| () => globalThis.__ReactApi.cacheSignal ? globalThis.__ReactApi.cacheSignal() : { current: null }

///|
/// React.cacheSignal - Create cache signal for use with cache()
/// see: https://react.dev/reference/react/cacheSignal
#alias(cacheSignal)
pub fn cache_signal() -> @core.Any {
  ffi_cache_signal()
}

///|
extern "js" fn ffi_react_cache(fn_ : @core.Any) -> @core.Any =
  #| (fn) => globalThis.__ReactApi.cache ? globalThis.__ReactApi.cache(fn) : fn

///|
/// React.cache - Cache data fetching or computation results
/// TypeScript: function cache<CachedFunction extends Function>(fn: CachedFunction): CachedFunction
/// see: https://react.dev/reference/react/cache
#alias(reactCache)
pub fn[T, R] react_cache(f : (T) -> R) -> (T) -> R {
  ffi_react_cache(@core.any(f)).cast()
}

///|
extern "js" fn ffi_act(callback : @core.Any) -> @core.Any =
  #| (callback) => globalThis.__ReactApi.act(callback)

///|
/// React.act - Wrap test code to apply updates before assertions
/// see: https://react.dev/reference/react/act
pub async fn act(callback : () -> Unit) -> Unit {
  let promise : @core.Promise[Unit] = ffi_act(@core.any(callback)).cast()
  promise.wait()
}

///|
extern "js" fn ffi_act_async(callback : @core.Any) -> @core.Promise[Unit] =
  #| async (callback) => await globalThis.__ReactApi.act(callback)

///|
/// React.act (async) - Wrap async test code to apply updates before assertions
/// see: https://react.dev/reference/react/act
#alias(actAsync)
pub async fn act_async(callback : async () -> Unit) -> Unit {
  let promise_fn = @js.promisify0(callback)
  ffi_act_async(@core.any(promise_fn)).wait()
}
