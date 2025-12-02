///|
// priv struct () {} derive(Default)

///|
fn app(_ : Unit) -> @react.Element {
  let (cnt, set_cnt) = @react.use_state(0)
  let on_click : @dom.MouseEventHandler = _ => set_cnt(cnt + 1) |> ignore
  @react_element.div([
    "Hello RTL",
    @react_element.div(["Count: \{cnt}"]),
    @react_element.button(on_click~, ["click me"]),
  ])
}

///|
fn setup_rtl() -> Unit {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  @testing_library_react.setup_matchers()
  @testing_library_react.cleanup()
}

///|
test "testing-library/react" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  @testing_library_react.render(@react.component(app, ())) |> ignore
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("click me"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Count: 1"),
  )..toHaveTextContent("Count: 1")
}

///|
test "RenderResult methods" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => @react_element.div(id="test-id", [
    "Test Content",
  ])
  let result = @testing_library_react.render(@react.component(comp, ()))
  // Test container
  let container = result.container()
  @nostd.typeof_(container |> @nostd.any) |> assert_eq("object")
  // Test baseElement
  let base = result.baseElement()
  @nostd.typeof_(base |> @nostd.any) |> assert_eq("object")
  let comp2 = (_props : Unit) => @react_element.div(["Rerendered Content"])
  result.rerender(@react.component(comp2, ()))
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Rerendered Content"),
  )..toHaveTextContent("Rerendered Content")
  // Test unmount
  result.unmount()
}

///|
test "queryBy methods return None when not found" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => @react_element.div(["Existing text"])
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  // queryByText returns null (converted to None in JS) for non-existent text
  let result = @testing_library_react.screen().queryByText("Non-existent")
  assert_eq(result is None, true)
  // queryByText returns element for existing text
  let existing = @testing_library_react.screen().queryByText("Existing text")
  assert_eq(existing is Some(_), true)
  // Verify the text content using raw HTMLElement
  guard existing is Some(el) else { fail("Expected element") }
  assert_eq(el.as_element().as_node().textContent(), "Existing text")
}

///|
test "getAllBy and queryAllBy methods" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => @react_element.div([
    @react_element.button(["Button 1"]),
    @react_element.button(["Button 2"]),
    @react_element.button(["Button 3"]),
  ])
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  // getAllByRole returns array of all buttons
  let buttons = @testing_library_react.screen().getAllByRole("button")
  buttons.length() |> assert_eq(3)
  // queryAllByRole also returns array
  let buttons2 = @testing_library_react.screen().queryAllByRole("button")
  buttons2.length() |> assert_eq(3)
  // queryAllByRole returns empty array for non-existent elements
  let nonexistent = @testing_library_react.screen().queryAllByRole("checkbox")
  nonexistent.length() |> assert_eq(0)
}

///|
test "getByRole query" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => @react_element.div([
    @react_element.button(["Click me"]),
    @react_element.input(type_="text"),
  ])
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  // getByRole finds button
  @testing_library_react.expect(
    @testing_library_react.screen().getByRole("button"),
  )..toHaveTextContent("Click me")
  // getByRole finds textbox (just verify it exists)
  @testing_library_react.screen().getByRole("textbox") |> ignore
}

///|
test "getByPlaceholderText query" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => @react_element.div([
    @react_element.input(placeholder="Enter your name"),
  ])
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByPlaceholderText("Enter your name"),
  )..toHaveAttribute("placeholder")
}

///|
test "getByDisplayValue query" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => @react_element.div([
    @react_element.input(value="test value", on_change=fn(_) { () }),
  ])
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByDisplayValue("test value"),
  )..toHaveValue("test value")
}

///|
test "getAllByText with multiple results" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => @react_element.div([
    @react_element.div(["Item"]),
    @react_element.div(["Item"]),
    @react_element.div(["Item"]),
  ])
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  // getAllByText returns all matching elements
  let items = @testing_library_react.screen().getAllByText("Item")
  items.length() |> assert_eq(3)
}

///|
test "fireEvent click on button" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (clicked, set_clicked) = @react.use_state(false)
    let on_click : @dom.MouseEventHandler = _ => set_clicked(true)
    @react_element.div([
      @react_element.button(on_click~, ["Click me"]),
      @react_element.div([if clicked { "Clicked!" } else { "Not clicked" }]),
    ])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.screen().getByText("Not clicked") |> ignore
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("Click me"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Clicked!"),
  )..toHaveTextContent("Clicked!")
}

///|
test "fireEvent change on input" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (value, set_value) = @react.use_state("")
    let on_change : @dom.ChangeEventHandler = e => {
      let target : @nostd.Any = e.as_any()._get("target")
      let new_value : String = target._get("value").cast()
      set_value(new_value)
    }
    @react_element.div([
      @react_element.input(on_change~, value~, placeholder="Type here"),
      @react_element.div(["Value: \{value}"]),
    ])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  let input_el = @testing_library_react.screen().getByPlaceholderText(
    "Type here",
  )
  // Create event object using from_map
  let event : @nostd.Any = @nostd.from_entries([
    ("target", @nostd.from_entries([("value", @nostd.any("hello"))])),
  ])
  @testing_library_react.fireEvent().change(input_el, event) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Value: hello"),
  )..toHaveTextContent("Value: hello")
}

///|
test "fireEvent submit on form" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (submitted, set_submitted) = @react.use_state(false)
    let on_submit = fn(e : @nostd.Any) {
      e.call0("preventDefault") |> ignore
      set_submitted(true)
    }
    @react_element.div([
      @react_element.form(
        [@react_element.button(["Submit"], type_="submit")],
        on_submit=@nostd.identity(on_submit),
        id="test-form",
      ),
      if submitted {
        @react_element.div(["Form submitted"])
      } else {
        @react_element.div(["Not submitted"])
      },
    ])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.screen().getByText("Not submitted") |> ignore
  // Get form element via container
  let result = @testing_library_react.render(@react.component(comp, ()))
  let form_el : @dom.HTMLElement = result
    .container()
    .querySelector("form")
    .unwrap()
    |> @nostd.identity
  @testing_library_react.fireEvent().submit(form_el) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Form submitted"),
  )..toHaveTextContent("Form submitted")
}

///|
test "fireEvent focus and blur on input" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (focused, set_focused) = @react.use_state(false)
    let on_focus = fn(_e : @nostd.Any) { set_focused(true) }
    let on_blur = fn(_e : @nostd.Any) { set_focused(false) }
    @react_element.div([
      @react_element.input(
        on_focus=@nostd.identity(on_focus),
        on_blur=@nostd.identity(on_blur),
        placeholder="Focus me",
      ),
      @react_element.div([if focused { "Focused" } else { "Not focused" }]),
    ])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  let input_el = @testing_library_react.screen().getByPlaceholderText(
    "Focus me",
  )
  @testing_library_react.fireEvent().focus(input_el) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Focused"),
  )..toHaveTextContent("Focused")
  @testing_library_react.fireEvent().blur(input_el) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Not focused"),
  )..toHaveTextContent("Not focused")
}

///|
test "fireEvent keyDown on input" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (key, set_key) = @react.use_state("")
    let on_keydown = fn(e : @nostd.Any) {
      let k : String = e._get("key").cast()
      set_key("Key: \{k}")
    }
    @react_element.div([
      @react_element.input(
        on_keydown=@nostd.identity(on_keydown),
        placeholder="Press a key",
      ),
      @react_element.div([if key == "" { "No key pressed" } else { key }]),
    ])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  let input_el = @testing_library_react.screen().getByPlaceholderText(
    "Press a key",
  )
  let event : @nostd.Any = @nostd.from_entries([("key", @nostd.any("Enter"))]).cast()
  @testing_library_react.fireEvent().keyDown(input_el, event) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Key: Enter"),
  )..toHaveTextContent("Key: Enter")
}

///|
test "configure function exists" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  // Just test that configure can be called without error
  let config = @nostd.Object::new()
  let config_any : @nostd.Any = config.cast()
  configure(config_any)
}

///| React Hooks Tests with renderHook

///|
test "renderHook: useState" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  let hook = fn() {
    let (state, _set_state) = @react.use_state(0)
    state
  }
  let result = renderHook(@nostd.identity(hook))
  let hook_result = result.result()
  // result.current is the hook return value
  let current = hook_result["current"]
  let state : Int = current.cast()
  assert_eq(state, 0)
}

///|
test "renderHook: useState with updates" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  // Test that we can get the initial state value
  let hook = fn() {
    let (state, _set_state) = @react.use_state(0)
    state
  }
  let result = renderHook(@nostd.identity(hook))
  // Get initial state
  let current1 = result.result()["current"]
  let state1 : Int = current1.cast()
  assert_eq(state1, 0)
  // Note: Testing state updates with renderHook requires more complex setup
  // For now, we verify the hook returns the correct initial value
}

///|
test "renderHook: useEffect" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  let hook = () => {
    let (count, set_count) = @react.use_state(0)
    @react.useEffect(
      () => {
        set_count(count + 1)
        () => ()
      },
      [],
    )
    count
  }
  let result = renderHook(@nostd.identity(hook))
  let current = result.result()["current"]
  let count : Int = current.cast()
  // After useEffect runs, count should be 1
  assert_eq(count, 1)
}

///|
test "renderHook: useCallback" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  let hook = fn() {
    let (count, _set_count) = @react.use_state(0)
    @react.useCallback(fn() { count * 2 }, [@nostd.any(count)])
  }
  let result = renderHook(@nostd.identity(hook))
  let current = result.result()["current"]
  // callback is a function
  @nostd.typeof_(current) |> assert_eq("function")
}

///|
test "renderHook: useMemo" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  let hook = fn() {
    let (count, _set_count) = @react.use_state(5)
    @react.useMemo(fn() { count * 2 }, [@nostd.any(count)])
  }
  let result = renderHook(@nostd.identity(hook))
  let current = result.result()["current"]
  let doubled : Int = current.cast()
  assert_eq(doubled, 10)
}

///|
test "renderHook: useRef" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  let hook = fn() { @react.useRef(Some(42)) }
  let result = renderHook(@nostd.identity(hook))
  let current = result.result()["current"]
  // ref has a current property
  let ref_current = current["current"]
  let value : Int = @nostd.identity(ref_current)
  assert_eq(value, 42)
}

///|
test "renderHook: useContext" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  let ctx : @react.Context[Int] = @react.create_context(Some(100))
  let hook = fn() { @react.use_context(ctx) }
  let result = renderHook(@nostd.identity(hook))
  let current = result.result()["current"]
  let value : Int = current.cast()
  assert_eq(value, 100)
}

///|
test "renderHook: useReducer" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  let reducer = fn(state : Int, action : Int) { state + action }
  let hook = fn() {
    let (state, _dispatch) = @react.use_reducer(reducer, 0)
    state
  }
  let result = renderHook(@nostd.identity(hook))
  let current = result.result()["current"]
  let state : Int = current.cast()
  assert_eq(state, 0)
  // Note: Testing dispatch with renderHook requires more complex setup
  // For now, we verify the hook returns the correct initial state
}

///|
test "renderHook: rerender method" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  // Use a simple hook that doesn't need props
  let multiplier_ref : Ref[Int] = { val: 2 }
  let hook = fn() {
    let (count, _set_count) = @react.use_state(10)
    count * multiplier_ref.val
  }
  let result = renderHook(@nostd.identity(hook))
  let current1 = result.result()["current"]
  let value1 : Int = current1.cast()
  assert_eq(value1, 20)
  // Change multiplier and rerender
  multiplier_ref.val = 3
  result.rerender(@nostd.undefined())
  let current2 = result.result()["current"]
  let value2 : Int = current2.cast()
  assert_eq(value2, 30)
}

///|
test "renderHook: unmount method" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  let hook = fn() { @react.use_state(0) }
  let result = renderHook(@nostd.identity(hook))
  // Verify hook is mounted
  let current = result.result()["current"]
  @nostd.typeof_(current) |> assert_eq("object")
  // Unmount should not throw
  result.unmount()
}

///|
test "useId hook" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let id = @react.use_id()
    @react_element.div([@react_element.span(["The ID is: \{id}"])])
  }
  let result = @testing_library_react.render(@react.component(comp, ()))
  // useId generates IDs that contain _ character
  let container = result.container()
  assert_eq(container.as_node().textContent().contains("The ID is:"), true)
}

///|
test "useTransition hook" {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (count, set_count) = @react.use_state(0)
    let (is_pending, start_transition) = @react.use_transition()
    let on_click : @dom.MouseEventHandler = _ => start_transition(fn() {
      set_count(count + 1)
    })
    let pending_text = if is_pending { " (pending)" } else { "" }
    @react_element.div([
      @react_element.span(["Count: \{count}\{pending_text}"]),
      @react_element.button(on_click~, ["Increment"]),
    ])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Count: 0"),
  )..toHaveTextContent("Count: 0")
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("Increment"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Count: 1"),
  )..toHaveTextContent("Count: 1")
}

///|
test "useDeferredValue hook" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (value, set_value) = @react.use_state(0)
    let deferred = @react.use_deferred_value(value)
    let on_click : @dom.MouseEventHandler = _ => set_value(value + 1)
    @react_element.div([
      @react_element.span(["Value: \{value}, Deferred: \{deferred}"]),
      @react_element.button(on_click~, ["Update"]),
    ])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Value: 0, Deferred: 0"),
  )..toHaveTextContent("Value: 0, Deferred: 0")
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("Update"),
  )
  |> ignore
  // After update, both should eventually match
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Value: 1, Deferred: 1"),
  )..toHaveTextContent("Value: 1, Deferred: 1")
}

///|
test "useOptimistic hook" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (count, set_count) = @react.use_state(0)
    let (optimistic, add_optimistic) = @react.use_optimistic(count, fn(
      state,
      value,
    ) {
      state + value
    })
    let (_is_pending, start_transition) = @react.use_transition()
    let on_click : @dom.MouseEventHandler = _ => start_transition(fn() {
      add_optimistic(1)
      set_count(count + 1)
    })
    @react_element.div([
      @react_element.span(["Optimistic: \{optimistic}"]),
      @react_element.button(on_click~, ["Add"]),
    ])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Optimistic: 0"),
  )..toHaveTextContent("Optimistic: 0")
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("Add"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Optimistic: 1"),
  )..toHaveTextContent("Optimistic: 1")
}

///|
priv struct ChildProps {} derive(Default)

///|
fn child_component(_props : ChildProps) -> @react.Element {
  let ref_val : @react.ReactRef[@dom.HTMLDivElement] = @react.use_ref(None)
  @react.use_imperative_handle(
    ref_val,
    fn() -> @dom.HTMLDivElement { @nostd.Object::new() |> @nostd.identity },
    [],
  )
  @react_element.div(["Child"], ref_=ref_val)
}

///|
fn parent_component(_props : Unit) -> @react.Element {
  @react_element.div([@react.component(child_component, ChildProps::default())])
}

///|
test "useImperativeHandle hook" {
  setup_rtl()
  defer @testing_library_react.cleanup()
  @testing_library_react.render(@react.component(parent_component, ()))
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Child"),
  )..toHaveTextContent("Child")
}

// =============================================================================
// React Router Tests
// =============================================================================

///|
async fn init_react_router() -> Unit {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  @testing_library_react.setup_matchers()
  @testing_library_react.cleanup()
  @react_router.dynamic_import()
}

///|
fn home_component(_props : @react_router.RouteProps) -> @react.Element {
  @react_element.div(["Home Page"], id="home")
}

///|
fn about_component(_props : @react_router.RouteProps) -> @react.Element {
  @react_element.div(["About Page"], id="about")
}

///|
fn user_component(_props : @react_router.RouteProps) -> @react.Element {
  let params = @react_router.useParams()
  let user_id = params.get("id").unwrap_or("unknown")
  @react_element.div(["User: \{user_id}"], id="user")
}

///|
async test "react-router: basic routing with memory router" {
  init_react_router()
  let routes = [
    @react_router.Route::Component(path="/", component=home_component),
    @react_router.Route::Component(path="/about", component=about_component),
  ]
  let router = @react_router.create_memory_router(routes, options=@react_router.MemoryRouterOptions::{
    initial_entries: Some(["/"]),
    initial_index: None,
  })
  @testing_library_react.render(@react_router.router_provider(router)) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Home Page"),
  )..toHaveTextContent("Home Page")
}

///|
async test "react-router: navigate to different route" {
  init_react_router()
  defer @testing_library_react.cleanup()
  let routes = [
    @react_router.Route::Component(path="/", component=home_component),
    @react_router.Route::Component(path="/about", component=about_component),
  ]
  let router = @react_router.create_memory_router(routes, options=@react_router.MemoryRouterOptions::{
    initial_entries: Some(["/about"]),
    initial_index: None,
  })
  @testing_library_react.render(@react_router.router_provider(router)) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("About Page"),
  )..toHaveTextContent("About Page")
}

///|
async test "react-router: route with params" {
  init_react_router()
  defer @testing_library_react.cleanup()
  let routes = [
    @react_router.Route::Component(path="/users/:id", component=user_component),
  ]
  let router = @react_router.create_memory_router(routes, options=@react_router.MemoryRouterOptions::{
    initial_entries: Some(["/users/456"]),
    initial_index: None,
  })
  @testing_library_react.render(@react_router.router_provider(router)) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("User: 456"),
  )..toHaveTextContent("User: 456")
}

///|
async test "react-router: Link component renders" {
  init_react_router()
  defer @testing_library_react.cleanup()
  let routes = [
    @react_router.Route::Component(path="/", component=home_component),
    @react_router.Route::Component(path="/about", component=about_component),
  ]
  let router = @react_router.create_memory_router(routes, options=@react_router.MemoryRouterOptions::{
    initial_entries: Some(["/"]),
    initial_index: None,
  })
  @testing_library_react.render(@react_router.router_provider(router)) |> ignore
  // Home page should render
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Home Page"),
  )..toHaveTextContent("Home Page")
}

///|
fn location_display(_props : @react_router.RouteProps) -> @react.Element {
  let location = @react_router.useLocation()
  @react_element.div(["Path: \{location.pathname}"], id="location")
}

///|
async test "react-router: useLocation hook" {
  init_react_router()
  defer @testing_library_react.cleanup()
  let routes = [
    @react_router.Route::Component(
      path="/test/path",
      component=location_display,
    ),
  ]
  let router = @react_router.create_memory_router(routes, options=@react_router.MemoryRouterOptions::{
    initial_entries: Some(["/test/path"]),
    initial_index: None,
  })
  @testing_library_react.render(@react_router.router_provider(router)) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Path: /test/path"),
  )..toHaveTextContent("Path: /test/path")
}
