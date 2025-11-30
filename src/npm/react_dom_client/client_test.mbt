///|
fn init_jsdom() -> Unit {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  @testing_library_react.setup_matchers()
  @testing_library_react.cleanup()
}

///|
fn get_react_dom_client() -> ReactDOMClient {
  @node.require("react-dom/client") |> @js.identity
}

///|
priv struct SimpleProps {
  text : String
}

///|
fn simple_component(props : SimpleProps) -> @react.Element {
  @react_element.div(id="root-content", [props.text])
}

///|
test "createRoot exists on ReactDOMClient" {
  init_jsdom()
  let client = get_react_dom_client()
  @nostd.typeof_(client.as_any()._get("createRoot")) |> assert_eq("function")
}

///|
test "hydrateRoot exists on ReactDOMClient" {
  init_jsdom()
  let client = get_react_dom_client()
  @nostd.typeof_(client.as_any()._get("hydrateRoot")) |> assert_eq("function")
}

///|
test "createRoot and render" {
  init_jsdom()
  defer @testing_library_react.cleanup()
  // Use React Testing Library's render which handles all the setup
  let result = @testing_library_react.render(
    @react.component(simple_component, { text: "Hello createRoot" }),
  )
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Hello createRoot"),
  ).toHaveTextContent("Hello createRoot")
  result.unmount()
}

///|
test "ReactDOMRoot has render method" {
  init_jsdom()
  let client = get_react_dom_client()
  let document : @dom.Document = @js.globalThis().get("document").cast()
  guard document.body() is Some(body)
  let container = document.createElement("div")
  body.as_node().appendChild(container.as_node()) |> ignore
  let root = client.createRoot(container)
  // Verify render method exists
  @nostd.typeof_(root.as_any()._get("render")) |> assert_eq("function")
  // Verify unmount method exists
  @nostd.typeof_(root.as_any()._get("unmount")) |> assert_eq("function")
  root.unmount()
  body.as_node().removeChild(container.as_node()) |> ignore
}
