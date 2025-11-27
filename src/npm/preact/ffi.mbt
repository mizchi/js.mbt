///|
extern "js" fn ffi_create_element(
  tag : @js.Any,
  props : @js.Any,
  children : @js.Any,
) -> @js.Any =
  #|(tag, props, children) => {
  #|  return __PreactApi.createElement(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_h(
  tag : @js.Any,
  props : @js.Any,
  children : @js.Any,
) -> @js.Any =
  #|(tag, props, children) => {
  #|  return __PreactApi.h(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_render(vnode : @js.Any, container : @js.Any) -> Unit =
  #|(vnode, container) => __PreactApi.render(vnode, container)

///|
extern "js" fn ffi_hydrate(vnode : @js.Any, container : @js.Any) -> Unit =
  #|(vnode, container) => __PreactApi.hydrate(vnode, container)

///|
extern "js" fn ffi_use_state(initial : @js.Any) -> @js.Any =
  #|(initial) => __PreactApi.useState(initial)

///|
extern "js" fn ffi_use_state_lazy(initial : () -> @js.Any) -> @js.Any =
  #|(initial) => __PreactApi.useState(initial)

///|
extern "js" fn ffi_use_effect(
  f : () -> () -> Unit,
  keys : Array[@js.Any],
) -> Unit =
  #|(f, keys) => __PreactApi.useEffect(f, keys)

///|
extern "js" fn ffi_use_layout_effect(
  f : () -> () -> Unit,
  keys : Array[@js.Any],
) -> Unit =
  #|(f, keys) => __PreactApi.useLayoutEffect(f, keys)

///|
extern "js" fn ffi_use_memo(
  f : () -> @js.Any,
  keys : Array[@js.Any],
) -> @js.Any =
  #|(f, keys) => __PreactApi.useMemo(f, keys)

///|
extern "js" fn ffi_use_callback(f : @js.Any, keys : Array[@js.Any]) -> @js.Any =
  #|(f, keys) => __PreactApi.useCallback(f, keys)

///|
extern "js" fn ffi_use_ref(initial : @js.Any) -> @js.Any =
  #|(initial) => __PreactApi.useRef(initial)

///|
extern "js" fn ffi_use_reducer(reducer : @js.Any, initial : @js.Any) -> @js.Any =
  #|(reducer, initial) => __PreactApi.useReducer(reducer, initial)

///|
extern "js" fn ffi_use_context(ctx : @js.Any) -> @js.Any =
  #|(ctx) => __PreactApi.useContext(ctx)

///|
extern "js" fn ffi_create_context(initial : @js.Any) -> @js.Any =
  #|(initial) => __PreactApi.createContext(initial)

///|
extern "js" fn ffi_create_ref() -> @js.Any =
  #|() => __PreactApi.createRef()

///|
extern "js" fn ffi_clone_element(element : @js.Any, props : @js.Any) -> @js.Any =
  #|(element, props) => __PreactApi.cloneElement(element, props)

///|
extern "js" fn ffi_to_child_array(children : @js.Any) -> @js.Any =
  #|(children) => __PreactApi.toChildArray(children)

///|
extern "js" fn get_fragment() -> @js.Any =
  #|() => __PreactApi.Fragment

///|
extern "js" fn ffi_use_id() -> String =
  #|() => __PreactApi.useId()

///|
extern "js" fn ffi_use_error_boundary(callback : @js.Any) -> @js.Any =
  #|(callback) => __PreactApi.useErrorBoundary(callback)

///|
extern "js" fn ffi_use_imperative_handle(
  ref_ : @js.Any,
  create : @js.Any,
  deps : @js.Any,
) -> Unit =
  #|(ref, create, deps) => __PreactApi.useImperativeHandle(ref, create, deps)

///|
extern "js" fn ffi_use_debug_value(value : @js.Any) -> Unit =
  #|(value) => __PreactApi.useDebugValue(value)
