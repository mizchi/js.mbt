///|
extern "js" fn ffi_create_element(
  tag : @nostd.Any,
  props : @nostd.Any,
  children : @nostd.Any,
) -> @nostd.Any =
  #|(tag, props, children) => {
  #|  return __PreactApi.createElement(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_h(
  tag : @nostd.Any,
  props : @nostd.Any,
  children : @nostd.Any,
) -> @nostd.Any =
  #|(tag, props, children) => {
  #|  return __PreactApi.h(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_render(vnode : @nostd.Any, container : @nostd.Any) -> Unit =
  #|(vnode, container) => __PreactApi.render(vnode, container)

///|
extern "js" fn ffi_hydrate(vnode : @nostd.Any, container : @nostd.Any) -> Unit =
  #|(vnode, container) => __PreactApi.hydrate(vnode, container)

///|
extern "js" fn ffi_use_state(initial : @nostd.Any) -> @nostd.Any =
  #|(initial) => __PreactApi.useState(initial)

///|
extern "js" fn ffi_use_state_lazy(initial : () -> @nostd.Any) -> @nostd.Any =
  #|(initial) => __PreactApi.useState(initial)

///|
extern "js" fn ffi_use_effect(
  f : () -> () -> Unit,
  keys : Array[@nostd.Any],
) -> Unit =
  #|(f, keys) => __PreactApi.useEffect(f, keys)

///|
extern "js" fn ffi_use_layout_effect(
  f : () -> () -> Unit,
  keys : Array[@nostd.Any],
) -> Unit =
  #|(f, keys) => __PreactApi.useLayoutEffect(f, keys)

///|
extern "js" fn ffi_use_memo(
  f : () -> @nostd.Any,
  keys : Array[@nostd.Any],
) -> @nostd.Any =
  #|(f, keys) => __PreactApi.useMemo(f, keys)

///|
extern "js" fn ffi_use_callback(
  f : @nostd.Any,
  keys : Array[@nostd.Any],
) -> @nostd.Any =
  #|(f, keys) => __PreactApi.useCallback(f, keys)

///|
extern "js" fn ffi_use_ref(initial : @nostd.Any) -> @nostd.Any =
  #|(initial) => __PreactApi.useRef(initial)

///|
extern "js" fn ffi_use_reducer(
  reducer : @nostd.Any,
  initial : @nostd.Any,
) -> @nostd.Any =
  #|(reducer, initial) => __PreactApi.useReducer(reducer, initial)

///|
extern "js" fn ffi_use_context(ctx : @nostd.Any) -> @nostd.Any =
  #|(ctx) => __PreactApi.useContext(ctx)

///|
extern "js" fn ffi_create_context(initial : @nostd.Any) -> @nostd.Any =
  #|(initial) => __PreactApi.createContext(initial)

///|
extern "js" fn ffi_create_ref() -> @nostd.Any =
  #|() => __PreactApi.createRef()

///|
extern "js" fn ffi_clone_element(
  element : @nostd.Any,
  props : @nostd.Any,
) -> @nostd.Any =
  #|(element, props) => __PreactApi.cloneElement(element, props)

///|
extern "js" fn ffi_to_child_array(children : @nostd.Any) -> @nostd.Any =
  #|(children) => __PreactApi.toChildArray(children)

///|
extern "js" fn get_fragment() -> @nostd.Any =
  #|() => __PreactApi.Fragment

///|
extern "js" fn ffi_use_id() -> String =
  #|() => __PreactApi.useId()

///|
extern "js" fn ffi_use_error_boundary(callback : @nostd.Any) -> @nostd.Any =
  #|(callback) => __PreactApi.useErrorBoundary(callback)

///|
extern "js" fn ffi_use_imperative_handle(
  ref_ : @nostd.Any,
  create : @nostd.Any,
  deps : @nostd.Any,
) -> Unit =
  #|(ref, create, deps) => __PreactApi.useImperativeHandle(ref, create, deps)

///|
extern "js" fn ffi_use_debug_value(value : @nostd.Any) -> Unit =
  #|(value) => __PreactApi.useDebugValue(value)
