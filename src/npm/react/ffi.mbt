///|
extern "js" fn ffi_create_element(
  tag : @js.Js,
  props : @js.Js,
  children : @js.Js,
) -> @js.Js =
  #|(tag, props, children) => {
  #|  return __ReactApi.createElement(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_react_use_state(initial : @js.Js) -> @js.Js =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_state_lazy(initial : () -> @js.Js) -> @js.Js =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_callback(
  initial : @js.Js,
  keys : Array[@js.Js],
) -> @js.Js =
  #| (initial, keys) => {
  #|   return __ReactApi.useCallback(initial, keys);
  #| }

///|
extern "js" fn ffi_react_use_ref(initial : @js.Js) -> @js.Js =
  #| (initial) => {
  #|   return __ReactApi.useRef(initial);
  #| }

///|
extern "js" fn ffi_react_use_context(ctx : @js.Js) -> @js.Js =
  #| (ctx) => globalThis.__ReactApi.useContext(ctx)

///|
extern "js" fn ffi_react_lazy(f : @js.Js) -> @js.Promise[@js.Js] =
  #| (f) => globalThis.__ReactApi.lazy(f)

///|
extern "js" fn ffi_react_create_context(initial : @js.Js) -> @js.Js =
  #| (initial) => {
  #|   if (globalThis.__ReactApi === undefined) {
  #|     throw new Error("React.createContext is not available");
  #|   }
  #|   return __ReactApi.createContext(initial);
  #| }

///|
extern "js" fn ffi_react_use_effect(
  f : () -> () -> Unit,
  keys : Array[@js.Js],
) -> Unit =
  #| (f, keys) => {
  #|   return __ReactApi.useEffect(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_layout_effect(
  f : () -> () -> Unit,
  keys : Array[&@js.JsImpl],
) -> Unit =
  #| (f, keys) => __ReactApi.useLayoutEffect(f, keys)

///|
extern "js" fn ffi_react_use_memo(
  f : () -> @js.Js,
  keys : Array[&@js.JsImpl],
) -> @js.Js =
  #| (f, keys) => {
  #|   return __ReactApi.useMemo(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_reducer(
  reducer : @js.Js,
  initial : @js.Js,
) -> @js.Js =
  #| (reducer, initial) => {
  #|   return __ReactApi.useReducer(reducer, initial);
  #| }

///|
extern "js" fn ffi_react_use(v : @js.Js) -> @js.Js =
  #| (v) => __ReactApi.use(v)

///|
extern "js" fn get_fragment() -> Component[EmptyProps] =
  #| () => __ReactApi.Fragment

///|
extern "js" fn get_strict_mode() -> Component[EmptyProps] =
  #| () => __ReactApi.StrictMode

///|
extern "js" fn get_suspense() -> @js.Js =
  #| () => __ReactApi.Suspense
