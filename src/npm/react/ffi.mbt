///|
extern "js" fn ffi_create_element(
  tag : @js.Any,
  props : @js.Any,
  children : @js.Any,
) -> @js.Any =
  #|(tag, props, children) => {
  #|  return __ReactApi.createElement(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_react_use_state(initial : @js.Any) -> @js.Any =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_state_lazy(initial : () -> @js.Any) -> @js.Any =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_callback(
  initial : @js.Any,
  keys : Array[@js.Any],
) -> @js.Any =
  #| (initial, keys) => {
  #|   return __ReactApi.useCallback(initial, keys);
  #| }

///|
extern "js" fn ffi_react_use_ref(initial : @js.Any) -> @js.Any =
  #| (initial) => {
  #|   return __ReactApi.useRef(initial);
  #| }

///|
extern "js" fn ffi_react_use_context(ctx : @js.Any) -> @js.Any =
  #| (ctx) => globalThis.__ReactApi.useContext(ctx)

///|
extern "js" fn ffi_react_lazy(f : @js.Any) -> @js.Promise[@js.Any] =
  #| (f) => globalThis.__ReactApi.lazy(f)

///|
extern "js" fn ffi_react_create_context(initial : @js.Any) -> @js.Any =
  #| (initial) => {
  #|   if (globalThis.__ReactApi === undefined) {
  #|     throw new Error("React.createContext is not available");
  #|   }
  #|   return __ReactApi.createContext(initial);
  #| }

///|
extern "js" fn ffi_react_use_effect(
  f : () -> () -> Unit,
  keys : Array[@js.Any],
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
  f : () -> @js.Any,
  keys : Array[&@js.JsImpl],
) -> @js.Any =
  #| (f, keys) => {
  #|   return __ReactApi.useMemo(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_reducer(
  reducer : @js.Any,
  initial : @js.Any,
) -> @js.Any =
  #| (reducer, initial) => {
  #|   return __ReactApi.useReducer(reducer, initial);
  #| }

///|
extern "js" fn ffi_react_use(v : @js.Any) -> @js.Any =
  #| (v) => __ReactApi.use(v)

///|
extern "js" fn get_fragment() -> Component[Unit] =
  #| () => __ReactApi.Fragment

///|
extern "js" fn get_strict_mode() -> Component[Unit] =
  #| () => __ReactApi.StrictMode

///|
extern "js" fn get_suspense() -> @js.Any =
  #| () => __ReactApi.Suspense
