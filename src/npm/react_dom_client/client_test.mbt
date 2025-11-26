///|
fn init_jsdom() -> Unit {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  @react_testing_library.setup_matchers()
  @react_testing_library.cleanup()
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
  @js.typeof_(client.get("createRoot")) |> assert_eq("function")
}

///|
test "hydrateRoot exists on ReactDOMClient" {
  init_jsdom()
  let client = get_react_dom_client()
  @js.typeof_(client.get("hydrateRoot")) |> assert_eq("function")
}

///|
test "createRoot and render" {
  init_jsdom()
  defer @react_testing_library.cleanup()
  // Use React Testing Library's render which handles all the setup
  let result = @react_testing_library.render(
    @react.component(simple_component, { text: "Hello createRoot" }),
  )
  @react_testing_library.expect(
    @react_testing_library.screen().getByText("Hello createRoot"),
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
  body.appendChild(container) |> ignore
  let root = client.createRoot(container)
  // Verify render method exists
  @js.typeof_(root.get("render")) |> assert_eq("function")
  // Verify unmount method exists
  @js.typeof_(root.get("unmount")) |> assert_eq("function")
  root.unmount()
  body.removeChild(container) |> ignore
}
