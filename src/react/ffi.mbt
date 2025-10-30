///|
extern "js" fn ffi_react_use_state(initial : @js.Value) -> @js.Value =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_state_lazy(initial : () -> @js.Value) -> @js.Value =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_callback(
  initial : @js.Value,
  keys : Array[@js.Value],
) -> @js.Value =
  #| (initial, keys) => {
  #|   return __ReactApi.useCallback(initial, keys);
  #| }

///|
extern "js" fn ffi_react_use_ref(initial : @js.Value) -> @js.Value =
  #| (initial) => {
  #|   return __ReactApi.useRef(initial);
  #| }

///|
extern "js" fn ffi_react_use_context(ctx : @js.Value) -> @js.Value =
  #| (ctx) => globalThis.__ReactApi.useContext(ctx)

///|
extern "js" fn ffi_react_lazy(f : @js.Value) -> @js.Promise[@js.Value] =
  #| (f) => globalThis.__ReactApi.lazy(f)

///|
extern "js" fn ffi_react_create_context(initial : @js.Value) -> @js.Value =
  #| (initial) => {
  #|   if (globalThis.__ReactApi === undefined) {
  #|     throw new Error("React.createContext is not available");
  #|   }
  #|   return __ReactApi.createContext(initial);
  #| }

///|
extern "js" fn ffi_react_use_effect(
  f : () -> () -> Unit,
  keys : Array[@js.Value],
) -> Unit =
  #| (f, keys) => {
  #|   return __ReactApi.useEffect(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_layout_effect(
  f : () -> () -> Unit,
  keys : Array[@js.Value],
) -> Unit =
  #| (f, keys) => __ReactApi.useLayoutEffect(f, keys)

///|
extern "js" fn ffi_react_use_memo(
  f : () -> @js.Value,
  keys : Array[@js.Value],
) -> @js.Value =
  #| (f, keys) => {
  #|   return __ReactApi.useMemo(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_reducer(
  reducer : @js.Value,
  initial : @js.Value,
) -> @js.Value =
  #| (reducer, initial) => {
  #|   return __ReactApi.useReducer(reducer, initial);
  #| }
