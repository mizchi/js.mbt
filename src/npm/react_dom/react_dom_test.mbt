///|
fn init_jsdom() -> Unit {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
}

///|
fn get_react_dom() -> ReactDOM {
  @node.require("react-dom") |> @js.identity
}

///|
test "createPortal exists on ReactDOM" {
  init_jsdom()
  let react_dom = get_react_dom()
  @js.typeof_(react_dom.get("createPortal")) |> assert_eq("function")
}

///|
test "flushSync exists on ReactDOM" {
  init_jsdom()
  let react_dom = get_react_dom()
  @js.typeof_(react_dom.get("flushSync")) |> assert_eq("function")
}

///|
test "createPortal returns React element" {
  init_jsdom()
  @react_testing_library.cleanup()
  let react_dom = get_react_dom()
  let document : @dom.Document = @js.globalThis().get("document").cast()
  guard document.body() is Some(body)
  // Create portal target
  let portal_target = document.createElement("div")
  portal_target.set("id", "portal-root")
  body.appendChild(portal_target) |> ignore
  // Create portal
  let portal_content = @react_element.div(id="modal", ["Modal Content"])
  let portal = react_dom.createPortal(portal_content, portal_target)
  // Verify portal is a valid React element
  @js.typeof_(portal) |> assert_eq("object")
  @js.is_null(portal) |> assert_eq(false)
  // Cleanup
  body.removeChild(portal_target) |> ignore
}

///|
test "createPortal with key" {
  init_jsdom()
  @react_testing_library.cleanup()
  let react_dom = get_react_dom()
  let document : @dom.Document = @js.globalThis().get("document").cast()
  guard document.body() is Some(body)
  // Create portal target
  let portal_target = document.createElement("div")
  body.appendChild(portal_target) |> ignore
  // Create portal with key
  let portal_content = @react_element.div(["Portal with key"])
  let portal = react_dom.createPortal(
    portal_content,
    portal_target,
    key="my-portal-key",
  )
  // Verify portal is created
  @js.typeof_(portal) |> assert_eq("object")
  // Cleanup
  body.removeChild(portal_target) |> ignore
}

///|
test "flushSync returns callback result" {
  init_jsdom()
  let react_dom = get_react_dom()
  // Test that flushSync returns the callback's return value
  let result = react_dom.flushSync(fn() { 42 })
  assert_eq(result, 42)
  let str_result = react_dom.flushSync(fn() { "hello" })
  assert_eq(str_result, "hello")
}

///|
test "flushSync executes callback" {
  init_jsdom()
  let react_dom = get_react_dom()
  let counter : Ref[Int] = { val: 0 }
  react_dom.flushSync(fn() { counter.val = counter.val + 1 })
  assert_eq(counter.val, 1)
}

///|
priv struct PortalTestProps {
  portal_target : @dom.Element
}

///|
fn portal_test_component(props : PortalTestProps) -> @react.Element {
  let react_dom = get_react_dom()
  @react.fragment([
    @react_element.div(id="main", ["Main Content"]),
    react_dom.createPortal(
      @react_element.div(id="portal", ["Portal Content"]),
      props.portal_target,
    ),
  ])
}

///|
test "createPortal renders to target" {
  init_jsdom()
  @react_testing_library.cleanup()
  let document : @dom.Document = @js.globalThis().get("document").cast()
  guard document.body() is Some(body)
  // Create portal target
  let portal_target = document.createElement("div")
  portal_target.set("id", "portal-root")
  body.appendChild(portal_target) |> ignore
  // Render component with portal
  @react_testing_library.render(
    @react.component(portal_test_component, { portal_target, }),
  )
  |> ignore
  // Verify main content
  @react_testing_library.screen()
  .getByText("Main Content")
  .get("textContent")
  .cast()
  |> assert_eq("Main Content")
  // Verify portal content
  @react_testing_library.screen()
  .getByText("Portal Content")
  .get("textContent")
  .cast()
  |> assert_eq("Portal Content")
  // Cleanup
  @react_testing_library.cleanup()
  body.removeChild(portal_target) |> ignore
}
