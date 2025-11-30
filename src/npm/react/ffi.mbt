///|
extern "js" fn ffi_create_element(
  tag : @nostd.Any,
  props : @nostd.Any,
  children : @nostd.Any,
) -> @nostd.Any =
  #|(tag, props, children) => {
  #|  return __ReactApi.createElement(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_react_use_state(initial : @nostd.Any) -> @nostd.Any =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_state_lazy(
  initial : () -> @nostd.Any,
) -> @nostd.Any =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_callback(
  initial : @nostd.Any,
  keys : Array[@nostd.Any],
) -> @nostd.Any =
  #| (initial, keys) => {
  #|   return __ReactApi.useCallback(initial, keys);
  #| }

///|
extern "js" fn ffi_react_use_ref(initial : @nostd.Any) -> @nostd.Any =
  #| (initial) => {
  #|   return __ReactApi.useRef(initial);
  #| }

///|
extern "js" fn ffi_react_use_context(ctx : @nostd.Any) -> @nostd.Any =
  #| (ctx) => globalThis.__ReactApi.useContext(ctx)

///|
extern "js" fn ffi_react_lazy(f : @nostd.Any) -> @nostd.Promise[@nostd.Any] =
  #| (f) => globalThis.__ReactApi.lazy(f)

///|
extern "js" fn ffi_react_create_context(initial : @nostd.Any) -> @nostd.Any =
  #| (initial) => {
  #|   if (globalThis.__ReactApi === undefined) {
  #|     throw new Error("React.createContext is not available");
  #|   }
  #|   return __ReactApi.createContext(initial);
  #| }

///|
extern "js" fn ffi_react_use_effect(
  f : () -> () -> Unit,
  keys : Array[@nostd.Any],
) -> Unit =
  #| (f, keys) => {
  #|   return __ReactApi.useEffect(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_layout_effect(
  f : () -> () -> Unit,
  keys : Array[@nostd.Any],
) -> Unit =
  #| (f, keys) => __ReactApi.useLayoutEffect(f, keys)

///|
extern "js" fn ffi_react_use_memo(
  f : () -> @nostd.Any,
  keys : Array[@nostd.Any],
) -> @nostd.Any =
  #| (f, keys) => {
  #|   return __ReactApi.useMemo(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_reducer(
  reducer : @nostd.Any,
  initial : @nostd.Any,
) -> @nostd.Any =
  #| (reducer, initial) => {
  #|   return __ReactApi.useReducer(reducer, initial);
  #| }

///|
extern "js" fn ffi_react_use(v : @nostd.Any) -> @nostd.Any =
  #| (v) => __ReactApi.use(v)

///|
extern "js" fn get_fragment() -> Component[Unit] =
  #| () => __ReactApi.Fragment

///|
extern "js" fn get_strict_mode() -> Component[Unit] =
  #| () => __ReactApi.StrictMode

///|
extern "js" fn get_suspense() -> @nostd.Any =
  #| () => __ReactApi.Suspense
