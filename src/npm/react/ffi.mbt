///|
extern "js" fn ffi_create_element(tag : Js, props : Js, children : Js) -> Js =
  #|(tag, props, children) => {
  #|  return __ReactApi.createElement(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_react_use_state(initial : Js) -> Js =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_state_lazy(initial : () -> Js) -> Js =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_callback(initial : Js, keys : Array[Js]) -> Js =
  #| (initial, keys) => {
  #|   return __ReactApi.useCallback(initial, keys);
  #| }

///|
extern "js" fn ffi_react_use_ref(initial : Js) -> Js =
  #| (initial) => {
  #|   return __ReactApi.useRef(initial);
  #| }

///|
extern "js" fn ffi_react_use_context(ctx : Js) -> Js =
  #| (ctx) => globalThis.__ReactApi.useContext(ctx)

///|
extern "js" fn ffi_react_lazy(f : Js) -> Promise[Js] =
  #| (f) => globalThis.__ReactApi.lazy(f)

///|
extern "js" fn ffi_react_create_context(initial : Js) -> Js =
  #| (initial) => {
  #|   if (globalThis.__ReactApi === undefined) {
  #|     throw new Error("React.createContext is not available");
  #|   }
  #|   return __ReactApi.createContext(initial);
  #| }

///|
extern "js" fn ffi_react_use_effect(
  f : () -> () -> Unit,
  keys : Array[Js],
) -> Unit =
  #| (f, keys) => {
  #|   return __ReactApi.useEffect(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_layout_effect(
  f : () -> () -> Unit,
  keys : Array[&JsImpl],
) -> Unit =
  #| (f, keys) => __ReactApi.useLayoutEffect(f, keys)

///|
extern "js" fn ffi_react_use_memo(f : () -> Js, keys : Array[&JsImpl]) -> Js =
  #| (f, keys) => {
  #|   return __ReactApi.useMemo(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_reducer(reducer : Js, initial : Js) -> Js =
  #| (reducer, initial) => {
  #|   return __ReactApi.useReducer(reducer, initial);
  #| }

///|
extern "js" fn ffi_react_use(v : Js) -> Js =
  #| (v) => __ReactApi.use(v)

///|
extern "js" fn get_fragment() -> Component[EmptyProps] =
  #| () => __ReactApi.Fragment

///|
extern "js" fn get_suspense() -> Js =
  #| () => __ReactApi.Suspense
