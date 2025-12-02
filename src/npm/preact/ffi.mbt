///|
extern "js" fn ffi_create_element(
  tag : @core.Any,
  props : @core.Any,
  children : @core.Any,
) -> @core.Any =
  #|(tag, props, children) => {
  #|  return __PreactApi.createElement(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_h(
  tag : @core.Any,
  props : @core.Any,
  children : @core.Any,
) -> @core.Any =
  #|(tag, props, children) => {
  #|  return __PreactApi.h(tag, props, ...children)
  #|}

///|
extern "js" fn ffi_render(vnode : @core.Any, container : @core.Any) -> Unit =
  #|(vnode, container) => __PreactApi.render(vnode, container)

///|
extern "js" fn ffi_hydrate(vnode : @core.Any, container : @core.Any) -> Unit =
  #|(vnode, container) => __PreactApi.hydrate(vnode, container)

///|
extern "js" fn ffi_use_state(initial : @core.Any) -> @core.Any =
  #|(initial) => __PreactApi.useState(initial)

///|
extern "js" fn ffi_use_state_lazy(initial : () -> @core.Any) -> @core.Any =
  #|(initial) => __PreactApi.useState(initial)

///|
extern "js" fn ffi_use_effect(
  f : () -> () -> Unit,
  keys : Array[@core.Any],
) -> Unit =
  #|(f, keys) => __PreactApi.useEffect(f, keys)

///|
extern "js" fn ffi_use_layout_effect(
  f : () -> () -> Unit,
  keys : Array[@core.Any],
) -> Unit =
  #|(f, keys) => __PreactApi.useLayoutEffect(f, keys)

///|
extern "js" fn ffi_use_memo(
  f : () -> @core.Any,
  keys : Array[@core.Any],
) -> @core.Any =
  #|(f, keys) => __PreactApi.useMemo(f, keys)

///|
extern "js" fn ffi_use_callback(
  f : @core.Any,
  keys : Array[@core.Any],
) -> @core.Any =
  #|(f, keys) => __PreactApi.useCallback(f, keys)

///|
extern "js" fn ffi_use_ref(initial : @core.Any) -> @core.Any =
  #|(initial) => __PreactApi.useRef(initial)

///|
extern "js" fn ffi_use_reducer(
  reducer : @core.Any,
  initial : @core.Any,
) -> @core.Any =
  #|(reducer, initial) => __PreactApi.useReducer(reducer, initial)

///|
extern "js" fn ffi_use_context(ctx : @core.Any) -> @core.Any =
  #|(ctx) => __PreactApi.useContext(ctx)

///|
extern "js" fn ffi_create_context(initial : @core.Any) -> @core.Any =
  #|(initial) => __PreactApi.createContext(initial)

///|
extern "js" fn ffi_create_ref() -> @core.Any =
  #|() => __PreactApi.createRef()

///|
extern "js" fn ffi_clone_element(
  element : @core.Any,
  props : @core.Any,
) -> @core.Any =
  #|(element, props) => __PreactApi.cloneElement(element, props)

///|
extern "js" fn ffi_to_child_array(children : @core.Any) -> @core.Any =
  #|(children) => __PreactApi.toChildArray(children)

///|
extern "js" fn get_fragment() -> @core.Any =
  #|() => __PreactApi.Fragment

///|
extern "js" fn ffi_use_id() -> String =
  #|() => __PreactApi.useId()

///|
extern "js" fn ffi_use_error_boundary(callback : @core.Any) -> @core.Any =
  #|(callback) => __PreactApi.useErrorBoundary(callback)

///|
extern "js" fn ffi_use_imperative_handle(
  ref_ : @core.Any,
  create : @core.Any,
  deps : @core.Any,
) -> Unit =
  #|(ref, create, deps) => __PreactApi.useImperativeHandle(ref, create, deps)

///|
extern "js" fn ffi_use_debug_value(value : @core.Any) -> Unit =
  #|(value) => __PreactApi.useDebugValue(value)
