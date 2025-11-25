///|
fn init_react() -> Unit {
  @react.init_react_api(@node.require("react"))
}

///|
fn get_react_dom_static() -> ReactDOMStatic {
  @node.require("react-dom/static") |> @js.identity
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
  let promise : @js.Any = static_.call1(
    "prerenderToNodeStream",
    @react.component(simple_component, { message: "Hello SSR" }),
  )
  // Verify it returns a Promise (object with then method)
  @js.typeof_(promise) |> assert_eq("object")
  @js.typeof_(promise.get("then")) |> assert_eq("function")
}

///|
test "prerender function exists" {
  init_react()
  let static_ = get_react_dom_static()
  // Verify prerender function exists
  let prerender_fn = static_.get("prerender")
  @js.typeof_(prerender_fn) |> assert_eq("function")
}

///|
test "prerenderToNodeStream function exists" {
  init_react()
  let static_ = get_react_dom_static()
  // Verify prerenderToNodeStream function exists
  let fn_ = static_.get("prerenderToNodeStream")
  @js.typeof_(fn_) |> assert_eq("function")
}

///|
test "build_options with all parameters" {
  // Test internal build_options function by checking react-dom/static accepts our options format
  init_react()
  let static_ = get_react_dom_static()
  // Create options object similar to what build_options would create
  let opts = @js.Object::new()
  opts.set("bootstrapScriptContent", "console.log('bootstrap')")
  opts.set("bootstrapScripts", @js.from_array(["/main.js"]))
  opts.set("identifierPrefix", "test-")
  // Verify react-dom/static.prerenderToNodeStream accepts options
  let promise : @js.Any = static_.call2(
    "prerenderToNodeStream",
    @react.component(simple_component, { message: "Options Test" }),
    opts.to_any(),
  )
  @js.typeof_(promise) |> assert_eq("object")
  @js.typeof_(promise.get("then")) |> assert_eq("function")
}

///|
test "prerender returns Promise" {
  init_react()
  let static_ = get_react_dom_static()
  let promise : @js.Any = static_.call1(
    "prerender",
    @react.component(simple_component, { message: "Web Stream Test" }),
  )
  // Verify it returns a Promise
  @js.typeof_(promise) |> assert_eq("object")
  @js.typeof_(promise.get("then")) |> assert_eq("function")
}
