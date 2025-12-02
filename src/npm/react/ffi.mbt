///|
extern "js" fn ffi_create_element(
  tag : @core.Any,
  props : @core.Any,
  children : @core.Any,
) -> @core.Any =
  #|(tag, props, children) => {
  #|  return __ReactApi.createElement(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_react_use_state(initial : @core.Any) -> @core.Any =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_state_lazy(initial : () -> @core.Any) -> @core.Any =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_callback(
  initial : @core.Any,
  keys : Array[@core.Any],
) -> @core.Any =
  #| (initial, keys) => {
  #|   return __ReactApi.useCallback(initial, keys);
  #| }

///|
extern "js" fn ffi_react_use_ref(initial : @core.Any) -> @core.Any =
  #| (initial) => {
  #|   return __ReactApi.useRef(initial);
  #| }

///|
extern "js" fn ffi_react_use_context(ctx : @core.Any) -> @core.Any =
  #| (ctx) => globalThis.__ReactApi.useContext(ctx)

///|
extern "js" fn ffi_react_lazy(f : @core.Any) -> @core.Any =
  #| (f) => globalThis.__ReactApi.lazy(f)

///|
extern "js" fn ffi_react_create_context(initial : @core.Any) -> @core.Any =
  #| (initial) => {
  #|   if (globalThis.__ReactApi === undefined) {
  #|     throw new Error("React.createContext is not available");
  #|   }
  #|   return __ReactApi.createContext(initial);
  #| }

///|
extern "js" fn ffi_react_use_effect(
  f : () -> () -> Unit,
  keys : Array[@core.Any],
) -> Unit =
  #| (f, keys) => {
  #|   return __ReactApi.useEffect(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_layout_effect(
  f : () -> () -> Unit,
  keys : Array[@core.Any],
) -> Unit =
  #| (f, keys) => __ReactApi.useLayoutEffect(f, keys)

///|
extern "js" fn ffi_react_use_memo(
  f : () -> @core.Any,
  keys : Array[@core.Any],
) -> @core.Any =
  #| (f, keys) => {
  #|   return __ReactApi.useMemo(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_reducer(
  reducer : @core.Any,
  initial : @core.Any,
) -> @core.Any =
  #| (reducer, initial) => {
  #|   return __ReactApi.useReducer(reducer, initial);
  #| }

///|
extern "js" fn ffi_react_use(v : @core.Any) -> @core.Any =
  #| (v) => __ReactApi.use(v)

///|
extern "js" fn get_fragment() -> Component[Unit] =
  #| () => __ReactApi.Fragment

///|
extern "js" fn get_strict_mode() -> Component[Unit] =
  #| () => __ReactApi.StrictMode

///|
extern "js" fn get_suspense() -> @core.Any =
  #| () => __ReactApi.Suspense
