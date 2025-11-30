///|
fn init_jsdom() -> Unit {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  @testing_library_react.setup_matchers()
  @testing_library_react.cleanup()
}

///|
fn get_react_dom() -> ReactDOM {
  @node.require("react-dom") |> @js.identity
}

///|
test "createPortal exists on ReactDOM" {
  init_jsdom()
  let react_dom = get_react_dom()
  @nostd.typeof_(react_dom.as_any()["createPortal"]) |> assert_eq("function")
}

///|
test "flushSync exists on ReactDOM" {
  init_jsdom()
  let react_dom = get_react_dom()
  @nostd.typeof_(react_dom.as_any()["flushSync"]) |> assert_eq("function")
}

///|
test "createPortal returns React element" {
  init_jsdom()
  @testing_library_react.cleanup()
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
  @nostd.typeof_(portal.as_any()) |> assert_eq("object")
  @nostd.is_null(portal.as_any()) |> assert_eq(false)
  // Cleanup
  body.removeChild(portal_target) |> ignore
}

///|
test "createPortal with key" {
  init_jsdom()
  @testing_library_react.cleanup()
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
  @nostd.typeof_(portal.as_any()) |> assert_eq("object")
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
  @testing_library_react.cleanup()
  let document : @dom.Document = @js.globalThis().get("document").cast()
  guard document.body() is Some(body)
  // Create portal target
  let portal_target = document.createElement("div")
  portal_target.set("id", "portal-root")
  body.appendChild(portal_target) |> ignore
  // Render component with portal
  @testing_library_react.render(
    @react.component(portal_test_component, { portal_target, }),
  )
  |> ignore
  // Verify main content
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Main Content"),
  ).toHaveTextContent("Main Content")
  // Verify portal content
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Portal Content"),
  ).toHaveTextContent("Portal Content")
  // Cleanup
  @testing_library_react.cleanup()
  body.removeChild(portal_target) |> ignore
}
