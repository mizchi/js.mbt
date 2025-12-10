///|
/// createElement - pass children via props.children to avoid spread operator
#module("react")
extern "js" fn ffi_create_element(
  tag : @core.Any,
  props : @core.Any,
) -> @core.Any = "createElement"

///|
#module("react")
extern "js" fn ffi_react_use_state(initial : @core.Any) -> @core.Any = "useState"

///|
/// useState with lazy initializer (same function, just different MoonBit signature)
#module("react")
extern "js" fn ffi_react_use_state_lazy(initial : () -> @core.Any) -> @core.Any = "useState"

///|
#module("react")
extern "js" fn ffi_react_use_callback(
  initial : @core.Any,
  keys : Array[@core.Any],
) -> @core.Any = "useCallback"

///|
#module("react")
extern "js" fn ffi_react_use_ref(initial : @core.Any) -> @core.Any = "useRef"

///|
#module("react")
extern "js" fn ffi_react_use_context(ctx : @core.Any) -> @core.Any = "useContext"

///|
#module("react")
extern "js" fn ffi_react_lazy(f : @core.Any) -> @core.Any = "lazy"

///|
#module("react")
extern "js" fn ffi_react_create_context(initial : @core.Any) -> @core.Any = "createContext"

///|
#module("react")
extern "js" fn ffi_react_use_effect(
  f : () -> () -> Unit,
  keys : Array[@core.Any],
) -> Unit = "useEffect"

///|
#module("react")
extern "js" fn ffi_react_use_layout_effect(
  f : () -> () -> Unit,
  keys : Array[@core.Any],
) -> Unit = "useLayoutEffect"

///|
#module("react")
extern "js" fn ffi_react_use_memo(
  f : () -> @core.Any,
  keys : Array[@core.Any],
) -> @core.Any = "useMemo"

///|
#module("react")
extern "js" fn ffi_react_use_reducer(
  reducer : @core.Any,
  initial : @core.Any,
) -> @core.Any = "useReducer"

///|
#module("react")
extern "js" fn ffi_react_use(v : @core.Any) -> @core.Any = "use"

///|
/// React symbols using Symbol.for - no initialization needed
/// See: https://github.com/facebook/react/blob/main/packages/shared/ReactSymbols.js
extern "js" fn ffi_react_fragment() -> @core.Any =
  #| () => Symbol.for('react.fragment')

///|
extern "js" fn ffi_react_strict_mode() -> @core.Any =
  #| () => Symbol.for('react.strict_mode')

///|
extern "js" fn ffi_react_suspense() -> @core.Any =
  #| () => Symbol.for('react.suspense')

///|
extern "js" fn ffi_react_profiler() -> @core.Any =
  #| () => Symbol.for('react.profiler')

// TODO: ErrorBoundary support requires React.Component initialization
// These functions are temporarily disabled until proper #module support for class values

///|
/// @deprecated Temporarily disabled - no-op
pub async fn init_react_symbols() -> Unit {
  // No-op
}

///|
/// @deprecated Temporarily disabled - no-op
pub fn init_react_from_module(_react : @core.Any) -> Unit {
  // No-op
}

///|
fn get_fragment() -> Component[Unit] {
  ffi_react_fragment().cast()
}

///|
fn get_strict_mode() -> Component[Unit] {
  ffi_react_strict_mode().cast()
}

///|
fn get_suspense() -> @core.Any {
  ffi_react_suspense()
}
