///|
/// Create ErrorBoundary class by extending React.Component
/// This must be called after React is initialized
extern "js" fn ffi_create_error_boundary_class() -> @js.Any =
  #| () => {
  #|   const React = globalThis.__ReactApi;
  #|   if (!React || !React.Component) {
  #|     throw new Error("React must be initialized before creating ErrorBoundary");
  #|   }
  #|   class ErrorBoundary extends React.Component {
  #|     constructor(props) {
  #|       super(props);
  #|       this.state = { hasError: false, error: null };
  #|       this.reset = this.reset.bind(this);
  #|     }
  #|     static getDerivedStateFromError(error) {
  #|       return { hasError: true, error };
  #|     }
  #|     componentDidCatch(error, errorInfo) {
  #|       if (this.props.on_error) {
  #|         this.props.on_error(error, errorInfo);
  #|       }
  #|     }
  #|     reset() {
  #|       this.setState({ hasError: false, error: null });
  #|     }
  #|     render() {
  #|       if (this.state.hasError) {
  #|         return this.props.fallback(this.state.error, this.reset);
  #|       }
  #|       return this.props.children;
  #|     }
  #|   }
  #|   return ErrorBoundary;
  #| }

///|
let error_boundary_class : Ref[@js.Any?] = Ref::new(None)

///|
/// Get or create the ErrorBoundary component class
/// This lazily creates the class on first use
fn get_error_boundary_class() -> @js.Any {
  match error_boundary_class.val {
    Some(cls) => cls
    None => {
      let cls = ffi_create_error_boundary_class()
      error_boundary_class.val = Some(cls)
      cls
    }
  }
}

///|
/// Default fallback that renders nothing
fn default_fallback(_error : @js.Any, _reset : () -> Unit) -> Element {
  @js.null_() |> @js.identity
}

///|
/// Create an ErrorBoundary element that catches errors in its children
///
/// Example:
/// ```text
/// error_boundary(
///   children=[your_component],
///   fallback=fn(error, reset) {
///     createElement("div", [
///       createElement("p", ["Something went wrong"]),
///       createElement("button", ["Retry"], props={"onClick": @js.identity(reset)})
///     ])
///   }
/// )
/// ```
pub fn error_boundary(
  children~ : Array[&ReactNode],
  fallback? : (@js.Any, () -> Unit) -> Element,
  on_error? : (@js.Any, @js.Any) -> Unit,
) -> Element {
  let tag = get_error_boundary_class()
  let children_js = children.map(_.to_react_node()) |> @js.from_array
  let props : Map[String, @js.Any] = {
    "fallback": fallback.unwrap_or(default_fallback) |> @js.identity,
  }
  if on_error is Some(f) {
    props["on_error"] = f |> @js.identity
  }
  ffi_create_element(tag, @js.from_map(props), children_js) |> @js.identity
}
