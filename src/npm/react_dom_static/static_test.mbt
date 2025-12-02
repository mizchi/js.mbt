///|
fn init_react() -> Unit {
  @react.init_react_api(@node.require("react"))
}

///|
fn get_react_dom_static() -> ReactDOMStatic {
  @node.require("react-dom/static") |> @core.identity
}

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
  init_react()
  let static_ = get_react_dom_static()
  // Use dynamic import to get Promise, then wait
  let element : @core.Any = @react.component(simple_component, {
      message: "Hello SSR",
    })
    .as_any()
    .cast()
  let promise : @core.Any = static_
    .as_any()
    ._call("prerenderToNodeStream", [element])
  // Verify it returns a Promise (object with then method)
  @core.typeof_(promise) |> assert_eq("object")
  @core.typeof_(promise._get("then")) |> assert_eq("function")
}

///|
test "prerender function exists" {
  init_react()
  let static_ = get_react_dom_static()
  // Verify prerender function exists
  let prerender_fn = static_.as_any()._get("prerender")
  @core.typeof_(prerender_fn) |> assert_eq("function")
}

///|
test "prerenderToNodeStream function exists" {
  init_react()
  let static_ = get_react_dom_static()
  // Verify prerenderToNodeStream function exists
  let fn_ = static_.as_any()._get("prerenderToNodeStream")
  @core.typeof_(fn_) |> assert_eq("function")
}

///|
test "build_options with all parameters" {
  // Test internal build_options function by checking react-dom/static accepts our options format
  init_react()
  let static_ = get_react_dom_static()
  // Create options object similar to what build_options would create
  let opts = @core.Object::new()
  opts._set("bootstrapScriptContent", "console.log('bootstrap')" |> @core.any)
  opts._set("bootstrapScripts", @core.any(["/main.js"]))
  opts._set("identifierPrefix", "test-" |> @core.any)
  // Verify react-dom/static.prerenderToNodeStream accepts options
  let element : @core.Any = @react.component(simple_component, {
      message: "Options Test",
    })
    .as_any()
    .cast()
  let promise : @core.Any = static_
    .as_any()
    ._call("prerenderToNodeStream", [element, opts])
  @core.typeof_(promise) |> assert_eq("object")
  @core.typeof_(promise._get("then")) |> assert_eq("function")
}

///|
test "prerender returns Promise" {
  init_react()
  let static_ = get_react_dom_static()
  let element : @core.Any = @react.component(simple_component, {
      message: "Web Stream Test",
    })
    .as_any()
    .cast()
  let promise : @core.Any = static_.as_any()._call("prerender", [element])
  // Verify it returns a Promise
  @core.typeof_(promise) |> assert_eq("object")
  @core.typeof_(promise._get("then")) |> assert_eq("function")
}
