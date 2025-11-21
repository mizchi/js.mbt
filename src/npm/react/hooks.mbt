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
  let js_val = self.current
  if ffi_is_nullish(js_val) {
    None
  } else {
    Some(@js.unsafe_cast(js_val))
  }
}

///|
extern "js" fn ffi_is_nullish(value : @js.Js) -> Bool =
  #| (value) => value == null || value === undefined

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
/// wip
/// ```moonbit skip
/// extern "js" fn load_my_lazy_component() -> @js.Promise[Js] =
///   #| () => import("./MyLazyComponent")
/// struct MyLazyComponentProps {}
/// let my_lazy_component: (props: MyLazyComponentProps) -> Element =
///   lazy_(load_my_lazy_component)
/// ```
pub fn[T] lazy_(f : async () -> ComponentFn[T]) -> (EmptyProps) -> Promise[Js] {
  f |> promisify0 |> @js.unsafe_js |> ffi_react_lazy() |> unsafe_cast
}
