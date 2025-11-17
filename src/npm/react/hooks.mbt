///|
/// React.useState
/// ```mbt
/// fn my_component (props: EmptyProps) -> Element {
///   let (count, set_count) = useState(0)
///   ...
/// }
/// ```
#alias(use_state)
pub fn[T : Js] useState(initial : T) -> (T, (T) -> Unit) {
  let result = ffi_react_use_state(initial.to_js())
  let value : T = unsafe_cast(result.get(0))
  let update_fn : (T) -> Unit = unsafe_cast(result.get(1))
  (value, update_fn)
}

///|
/// JS: React.useState(() => initial)
/// ```
/// fn my_component(props: EmptyProps) -> Element {
///   let (count, set_count) = use_state_lazy(() => 42)
///   ...
/// }
pub fn[T] use_state_lazy(initial : () -> T) -> (T, (T) -> Unit) {
  let initial : () -> Val = unsafe_cast(initial)
  let result = ffi_react_use_state_lazy(initial)
  let value : T = unsafe_cast(result.get(0))
  let update_fn : (T) -> Unit = unsafe_cast(result.get(1))
  (value, update_fn)
}

///|
/// React.useCallback
/// ```mbt
/// fn my_component(props : EmptyProps) -> Element {
///   let on_click = useCallback(() => {
///     ()
///   }, [])
///   ...
/// }
/// ```
#alias(use_callback)
pub fn[F] useCallback(f : F, keys : Array[&Js]) -> F {
  let keys = keys.map(k => k.to_js())
  unsafe_cast(ffi_react_use_callback(f |> js, keys))
}

///|
/// JS: React.useEffect
/// ```mbt
/// fn my_component(props : EmptyProps) -> Element {
///   useEffect(() => {
///     println("mounted")
///     () => println("unmounted")
///   }, [])
///   createElement("div", ["Hello"])
/// }
/// ```
#alias(use_effect)
pub fn useEffect(f : () -> () -> Unit, keys : Array[&Js]) -> Unit {
  ffi_react_use_effect(f, keys.map(_.to_js()))
}

///|
#alias(use_layout_effect)
pub fn useLayoutEffect(f : () -> () -> Unit, keys : Array[&Js]) -> Unit {
  ffi_react_use_layout_effect(f, keys.map(_.to_js()))
}

///|
/// React.useMemo
/// ```mbt
/// fn my_component(props : EmptyProps) -> Element {
///   let result = useMemo(() => {
///     42
///   }, [])
///   createElement("div", [result])
/// }
/// ```
#alias(use_memo)
pub fn[T] useMemo(f : () -> T, keys : Array[&Js]) -> T {
  let f = () => f() |> unsafe_cast
  let v : T = unsafe_cast(ffi_react_use_memo(f, keys.map(_.to_js())))
  v
}

///|
/// JS: React.useRef
/// ```mbt
/// fn my_component(props : EmptyProps) -> Element {
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
#external
pub type ReactRef[T]

///|
pub impl[T] Js for ReactRef[T]

///|
extern "js" fn current_internal(v : Val) -> Val =
  #| (v) => v.current

///|
extern "js" fn set_current_internal(v : Val, o : Val) -> Unit =
  #| (v, o) => v.current = o

///|
pub fn[T] ReactRef::current(v : ReactRef[T]) -> T? {
  let v = current_internal(v |> js)
  if @js.is_undefined(v) || @js.is_null(v) {
    None
  } else {
    Some(unsafe_cast(v))
  }
}

///|
pub fn[T] ReactRef::set_current(v : ReactRef[T], o : T) -> Unit {
  set_current_internal(v |> unsafe_cast, o |> unsafe_cast)
}

///|
#external
pub type Context[T]

///|
#alias(createContext)
pub fn[T] create_context(initial : T?) -> Context[T] {
  let v = ffi_react_create_context(initial |> js)
  unsafe_cast(v)
}

///|
/// React.useContext
#alias(useContext)
pub fn[T] use_context(ctx : Context[T]) -> T {
  unsafe_cast(ffi_react_use_context(ctx |> unsafe_cast))
}

///|
/// React.use
pub fn[T] use_(promise : Promise[T]) -> T {
  unsafe_cast(ffi_react_use(promise |> unsafe_cast))
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
///   createElement("div", [state])
/// }
/// ```
#alias(useReducer)
pub fn[T, U] use_reducer(
  reducer : (T, U) -> T,
  initial : T,
) -> (T, (U) -> Unit) {
  let val = ffi_react_use_reducer(reducer |> js, initial |> js)
  (unsafe_cast(val.get(0)), unsafe_cast(val.get(1)))
}

///|
extern "js" fn use_action_state_internal(f : Val, initial : Val) -> Val =
  #| (f, initial) => {
  #|   return __ReactApi.useActionState(f, initial);
  #| }

///|
#alias(useActionState)
pub fn[T, U] use_action_state(
  f : async (T, U) -> T noraise,
  initial : T,
) -> (T, (U) -> Unit, Bool) {
  let w = @async.promisify2((s, a) => f(s, a))
  let val : Val = use_action_state_internal(w |> js, initial |> js)
  (unsafe_cast(val.get(0)), unsafe_cast(val.get(1)), unsafe_cast(val.get(2)))
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
/// wip
/// ```moonbit skip
/// extern "js" fn load_my_lazy_component() -> @js.Promise[Val] =
///   #| () => import("./MyLazyComponent")
/// struct MyLazyComponentProps {}
/// let my_lazy_component: (props: MyLazyComponentProps) -> Element =
///   lazy_(load_my_lazy_component)
/// ```
pub fn[T] lazy_(f : async () -> (T) -> Element) -> (EmptyProps) -> Promise[Val] {
  f |> @async.promisify0 |> js |> ffi_react_lazy() |> unsafe_cast
}
