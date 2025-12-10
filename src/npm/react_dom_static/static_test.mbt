// FFI with #module

///|
#module("react-dom/static")
extern "js" fn ffi_prerender(
  element : @core.Any,
  options : @core.Any,
) -> @core.Promise[@core.Any] = "prerender"

///|
#module("react-dom/static")
extern "js" fn ffi_prerender_to_node_stream(
  element : @core.Any,
  options : @core.Any,
) -> @core.Promise[@core.Any] = "prerenderToNodeStream"

///|
priv struct SimpleProps {
  message : String
}

///|
fn simple_component(props : SimpleProps) -> @react.Element {
  @react_element.div(id="content", [props.message])
}

///|
test "prerenderToNodeStream returns Promise" {
  let element : @core.Any = @react.component(simple_component, {
      message: "Hello SSR",
    })
    .as_any()
    .cast()
  let promise : @core.Any = ffi_prerender_to_node_stream(
      element,
      @core.undefined(),
    )
    |> @core.identity
  // Verify it returns a Promise (object with then method)
  @core.typeof_(promise) |> assert_eq("object")
  @core.typeof_(promise._get("then")) |> assert_eq("function")
}

///|
test "build_options with all parameters" {
  // Create options object similar to what build_options would create
  let opts = @core.new_object()
  opts._set("bootstrapScriptContent", "console.log('bootstrap')" |> @core.any)
  opts._set("bootstrapScripts", @core.any(["/main.js"]))
  opts._set("identifierPrefix", "test-" |> @core.any)
  // Verify react-dom/static.prerenderToNodeStream accepts options
  let element : @core.Any = @react.component(simple_component, {
      message: "Options Test",
    })
    .as_any()
    .cast()
  let promise : @core.Any = ffi_prerender_to_node_stream(element, opts)
    |> @core.identity
  @core.typeof_(promise) |> assert_eq("object")
  @core.typeof_(promise._get("then")) |> assert_eq("function")
}

///|
test "prerender returns Promise" {
  let element : @core.Any = @react.component(simple_component, {
      message: "Web Stream Test",
    })
    .as_any()
    .cast()
  let promise : @core.Any = ffi_prerender(element, @core.undefined())
    |> @core.identity
  // Verify it returns a Promise
  @core.typeof_(promise) |> assert_eq("object")
  @core.typeof_(promise._get("then")) |> assert_eq("function")
}
