///|
/// Create ErrorBoundary class by extending React.Component
/// This must be called after React is initialized
extern "js" fn ffi_create_error_boundary_class() -> @core.Any =
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
let error_boundary_class : Ref[@core.Any?] = Ref::new(None)

///|
/// Get or create the ErrorBoundary component class
/// This lazily creates the class on first use
fn get_error_boundary_class() -> @core.Any {
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
fn default_fallback(_error : @core.Any, _reset : () -> Unit) -> Element {
  @core.null().cast()
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
///       createElement("button", ["Retry"], props={"onClick": @core.any(reset)})
///     ])
///   }
/// )
/// ```
pub fn error_boundary(
  children~ : Array[&ReactNode],
  fallback? : (@core.Any, () -> Unit) -> Element,
  on_error? : (@core.Any, @core.Any) -> Unit,
) -> Element {
  let tag = get_error_boundary_class()
  let children_js = @core.any(children.map(_.to_react_node()))
  let props = @core.new_object()
  props["fallback"] = @core.any(fallback.unwrap_or(default_fallback))
  if on_error is Some(f) {
    props["on_error"] = @core.any(f)
  }
  ffi_create_element(tag, props, children_js).cast()
}
