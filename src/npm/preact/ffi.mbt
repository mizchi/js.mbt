///|
#module("preact")
extern "js" fn ffi_create_element(
  tag : @core.Any,
  props : @core.Any,
  children : @core.Any,
) -> @core.Any = "createElement"

///|
#module("preact")
extern "js" fn ffi_h(
  tag : @core.Any,
  props : @core.Any,
  children : @core.Any,
) -> @core.Any = "h"

///|
#module("preact")
extern "js" fn ffi_render(vnode : @core.Any, container : @core.Any) -> Unit = "render"

///|
#module("preact")
extern "js" fn ffi_hydrate(vnode : @core.Any, container : @core.Any) -> Unit = "hydrate"

///|
#module("preact/hooks")
extern "js" fn ffi_use_state(initial : @core.Any) -> @core.Any = "useState"

///|
#module("preact/hooks")
extern "js" fn ffi_use_state_lazy(initial : () -> @core.Any) -> @core.Any = "useState"

///|
#module("preact/hooks")
extern "js" fn ffi_use_effect(
  f : () -> () -> Unit,
  keys : Array[@core.Any],
) -> Unit = "useEffect"

///|
#module("preact/hooks")
extern "js" fn ffi_use_layout_effect(
  f : () -> () -> Unit,
  keys : Array[@core.Any],
) -> Unit = "useLayoutEffect"

///|
#module("preact/hooks")
extern "js" fn ffi_use_memo(
  f : () -> @core.Any,
  keys : Array[@core.Any],
) -> @core.Any = "useMemo"

///|
#module("preact/hooks")
extern "js" fn ffi_use_callback(
  f : @core.Any,
  keys : Array[@core.Any],
) -> @core.Any = "useCallback"

///|
#module("preact/hooks")
extern "js" fn ffi_use_ref(initial : @core.Any) -> @core.Any = "useRef"

///|
#module("preact/hooks")
extern "js" fn ffi_use_reducer(
  reducer : @core.Any,
  initial : @core.Any,
) -> @core.Any = "useReducer"

///|
#module("preact/hooks")
extern "js" fn ffi_use_context(ctx : @core.Any) -> @core.Any = "useContext"

///|
#module("preact")
extern "js" fn ffi_create_context(initial : @core.Any) -> @core.Any = "createContext"

///|
#module("preact")
extern "js" fn ffi_create_ref() -> @core.Any = "createRef"

///|
#module("preact")
extern "js" fn ffi_clone_element(
  element : @core.Any,
  props : @core.Any,
) -> @core.Any = "cloneElement"

///|
#module("preact")
extern "js" fn ffi_to_child_array(children : @core.Any) -> @core.Any = "toChildArray"

///|
/// Fragment equivalent - returns props.children (same as Preact's Fragment)
extern "js" fn get_fragment() -> @core.Any =
  #|() => (props) => props.children

///|
#module("preact/hooks")
extern "js" fn ffi_use_id() -> String = "useId"

///|
#module("preact/hooks")
extern "js" fn ffi_use_error_boundary(callback : @core.Any) -> @core.Any = "useErrorBoundary"

///|
#module("preact/hooks")
extern "js" fn ffi_use_imperative_handle(
  ref_ : @core.Any,
  create : @core.Any,
  deps : @core.Any,
) -> Unit = "useImperativeHandle"

///|
#module("preact/hooks")
extern "js" fn ffi_use_debug_value(value : @core.Any) -> Unit = "useDebugValue"
