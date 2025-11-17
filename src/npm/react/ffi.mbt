///|
extern "js" fn ffi_react_use_state(initial : Val) -> Val =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_state_lazy(initial : () -> Val) -> Val =
  #| (initial) => {
  #|   return __ReactApi.useState(initial);
  #| }

///|
extern "js" fn ffi_react_use_callback(initial : Val, keys : Array[Val]) -> Val =
  #| (initial, keys) => {
  #|   return __ReactApi.useCallback(initial, keys);
  #| }

///|
extern "js" fn ffi_react_use_ref(initial : Val) -> Val =
  #| (initial) => {
  #|   return __ReactApi.useRef(initial);
  #| }

///|
extern "js" fn ffi_react_use_context(ctx : Val) -> Val =
  #| (ctx) => globalThis.__ReactApi.useContext(ctx)

///|
extern "js" fn ffi_react_lazy(f : Val) -> Promise[Val] =
  #| (f) => globalThis.__ReactApi.lazy(f)

///|
extern "js" fn ffi_react_create_context(initial : Val) -> Val =
  #| (initial) => {
  #|   if (globalThis.__ReactApi === undefined) {
  #|     throw new Error("React.createContext is not available");
  #|   }
  #|   return __ReactApi.createContext(initial);
  #| }

///|
extern "js" fn ffi_react_use_effect(
  f : () -> () -> Unit,
  keys : Array[Val],
) -> Unit =
  #| (f, keys) => {
  #|   return __ReactApi.useEffect(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_layout_effect(
  f : () -> () -> Unit,
  keys : Array[&Js],
) -> Unit =
  #| (f, keys) => __ReactApi.useLayoutEffect(f, keys)

///|
extern "js" fn ffi_react_use_memo(f : () -> Val, keys : Array[&Js]) -> Val =
  #| (f, keys) => {
  #|   return __ReactApi.useMemo(f, keys);
  #| }

///|
extern "js" fn ffi_react_use_reducer(reducer : Val, initial : Val) -> Val =
  #| (reducer, initial) => {
  #|   return __ReactApi.useReducer(reducer, initial);
  #| }

///|
extern "js" fn ffi_react_use(v : Val) -> Val =
  #| (v) => __ReactApi.use(v)
