// TODO: ErrorBoundary is temporarily disabled until #module supports class value imports
// React.Component cannot be imported via Symbol.for, needs dynamic import or #module enhancement
//
// Original implementation (to be restored when React.Component import is available):
//
// ///|
// /// Create ErrorBoundary class by extending React.Component
// extern "js" fn ffi_create_error_boundary_class(component : @core.Any) -> @core.Any =
//   #| (Component) => {
//   #|   if (!Component || typeof Component !== 'function') {
//   #|     throw new Error("React.Component is not available.");
//   #|   }
//   #|   class ErrorBoundary extends Component {
//   #|     constructor(props) {
//   #|       super(props);
//   #|       this.state = { hasError: false, error: null };
//   #|       this.reset = this.reset.bind(this);
//   #|     }
//   #|     static getDerivedStateFromError(error) {
//   #|       return { hasError: true, error };
//   #|     }
//   #|     componentDidCatch(error, errorInfo) {
//   #|       if (this.props.on_error) {
//   #|         this.props.on_error(error, errorInfo);
//   #|       }
//   #|     }
//   #|     reset() {
//   #|       this.setState({ hasError: false, error: null });
//   #|     }
//   #|     render() {
//   #|       if (this.state.hasError) {
//   #|         return this.props.fallback(this.state.error, this.reset);
//   #|       }
//   #|       return this.props.children;
//   #|     }
//   #|   }
//   #|   return ErrorBoundary;
//   #| }
//
// let error_boundary_class : Ref[@core.Any?] = Ref::new(None)
//
// fn get_error_boundary_class() -> @core.Any {
//   match error_boundary_class.val {
//     Some(cls) => cls
//     None => {
//       let cls = ffi_create_error_boundary_class(get_react_component())
//       error_boundary_class.val = Some(cls)
//       cls
//     }
//   }
// }

///|
/// Default fallback that renders nothing
fn default_fallback(_error : @core.Any, _reset : () -> Unit) -> Element {
  @core.null().cast()
}

///|
/// @deprecated Temporarily disabled - returns children without error boundary wrapper
/// Create an ErrorBoundary element that catches errors in its children
pub fn error_boundary(
  children~ : Array[&ReactNode],
  fallback? : (@core.Any, () -> Unit) -> Element,
  on_error? : (@core.Any, @core.Any) -> Unit,
) -> Element {
  let _ = fallback
  let _ = on_error
  // Temporarily just return a fragment with children (no error catching)
  fragment(children)
}
