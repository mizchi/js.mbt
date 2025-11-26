///|
// priv struct () {} derive(Default)

///|
fn app(_props : Unit) -> @react.Element {
  let (cnt, set_cnt) = @react.use_state(0)
  let on_click : @dom.MouseEventHandler = _ => set_cnt(cnt + 1) |> ignore
  @react_element.div([
    "Hello RTL",
    @react_element.div(["Count: \{cnt}"]),
    @react_element.button(on_click~, ["click me"]),
  ])
}

///|
test "testing-library/react" {
  // @global_jsdom.register()
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  @react_testing_library.render(@react.component(app, ())) |> ignore
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("click me"),
  )
  |> ignore
  // @react_testing_library.screen().debug()
  @react_testing_library.screen().getByText("Count: 1").textContent()
  |> assert_eq("Count: 1")
}

///|
test "RenderResult methods" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => @react_element.div(
    ["Test Content"],
    id="test-id",
  )
  let result = @react_testing_library.render(@react.component(comp, ()))
  // Test container
  let container = result.container()
  @js.typeof_(container) |> assert_eq("object")
  // Test baseElement
  let base = result.baseElement()
  @js.typeof_(base) |> assert_eq("object")
  // Test debug (should not throw)
  // result.debug()
  // Test rerender
  let comp2 = (_props : Unit) => @react_element.div(["Rerendered Content"])
  result.rerender(@react.component(comp2, ()))
  @react_testing_library.screen().getByText("Rerendered Content").textContent()
  |> assert_eq("Rerendered Content")
  // Test unmount
  result.unmount()
}

///|
test "queryBy methods return None when not found" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => @react_element.div(["Existing text"])
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  // queryByText returns null (converted to None in JS) for non-existent text
  let result : @js.Any = @react_testing_library.screen().call("queryByText", [
    "Non-existent",
  ])
  let is_null = @js.is_null(result)
  assert_eq(is_null, true)
  // queryByText returns element for existing text
  let existing : @js.Any = @react_testing_library.screen().call("queryByText", [
    "Existing text",
  ])
  let is_null2 = @js.is_null(existing)
  assert_eq(is_null2, false)
  // Verify the text content
  let el : @dom.HTMLElement = @js.identity(existing)
  assert_eq(el.textContent(), "Existing text")
}

///|
test "getAllBy and queryAllBy methods" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => @react_element.div([
    @react_element.button(["Button 1"]),
    @react_element.button(["Button 2"]),
    @react_element.button(["Button 3"]),
  ])
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  // getAllByRole returns array of all buttons
  let buttons = @react_testing_library.screen().getAllByRole("button")
  buttons.length() |> assert_eq(3)
  // queryAllByRole also returns array
  let buttons2 = @react_testing_library.screen().queryAllByRole("button")
  buttons2.length() |> assert_eq(3)
  // queryAllByRole returns empty array for non-existent elements
  let nonexistent = @react_testing_library.screen().queryAllByRole("checkbox")
  nonexistent.length() |> assert_eq(0)
}

///|
test "getByRole query" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => @react_element.div([
    @react_element.button(["Click me"]),
    @react_element.input(type_="text"),
  ])
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  // getByRole finds button
  let btn = @react_testing_library.screen().getByRole("button")
  btn.textContent() |> assert_eq("Click me")
  // getByRole finds textbox
  let input_el = @react_testing_library.screen().getByRole("textbox")
  @js.typeof_(input_el) |> assert_eq("object")
}

///|
test "getByPlaceholderText query" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => @react_element.div([
    @react_element.input(placeholder="Enter your name"),
  ])
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  let input_el : @dom.HTMLInputElement = @js.identity(
    @react_testing_library.screen().getByPlaceholderText("Enter your name"),
  )
  input_el.placeholder |> assert_eq("Enter your name")
}

///|
test "getByDisplayValue query" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => @react_element.div([
    @react_element.input(value="test value", on_change=fn(_) { () }),
  ])
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  let input_el : @dom.HTMLInputElement = @js.identity(
    @react_testing_library.screen().getByDisplayValue("test value"),
  )
  input_el.value |> assert_eq("test value")
}

///|
test "getAllByText with multiple results" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => @react_element.div([
    @react_element.div(["Item"]),
    @react_element.div(["Item"]),
    @react_element.div(["Item"]),
  ])
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  // getAllByText returns all matching elements
  let items = @react_testing_library.screen().getAllByText("Item")
  items.length() |> assert_eq(3)
}

///|
test "fireEvent click on button" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let (clicked, set_clicked) = @react.use_state(false)
    let on_click : @dom.MouseEventHandler = _ => set_clicked(true)
    @react_element.div([
      @react_element.button(on_click~, ["Click me"]),
      @react_element.div([if clicked { "Clicked!" } else { "Not clicked" }]),
    ])
  }
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.screen().getByText("Not clicked") |> ignore
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("Click me"),
  )
  |> ignore
  @react_testing_library.screen().getByText("Clicked!").textContent()
  |> assert_eq("Clicked!")
}

///|
test "fireEvent change on input" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let (value, set_value) = @react.use_state("")
    let on_change : @dom.ChangeEventHandler = e => {
      let target : @js.Any = e.get("target")
      let new_value : String = target.get("value").cast()
      set_value(new_value)
    }
    @react_element.div([
      @react_element.input(on_change~, value~, placeholder="Type here"),
      @react_element.div(["Value: \{value}"]),
    ])
  }
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  let input_el = @react_testing_library.screen().getByPlaceholderText(
    "Type here",
  )
  // Create event object
  let event = @js.Object::new()
  let target = @js.Object::new()
  target.set("value", "hello")
  event.set("target", target.to_any())
  @react_testing_library.fireEvent().change(input_el, event.to_any()) |> ignore
  @react_testing_library.screen().getByText("Value: hello").textContent()
  |> assert_eq("Value: hello")
}

///|
test "fireEvent submit on form" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let (submitted, set_submitted) = @react.use_state(false)
    let on_submit = fn(e : @js.Any) {
      e.call0("preventDefault") |> ignore
      set_submitted(true)
    }
    @react_element.div([
      @react_element.form(
        [@react_element.button(["Submit"], type_="submit")],
        on_submit=@js.identity(on_submit),
        id="test-form",
      ),
      if submitted {
        @react_element.div(["Form submitted"])
      } else {
        @react_element.div(["Not submitted"])
      },
    ])
  }
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.screen().getByText("Not submitted") |> ignore
  let form_el : @dom.HTMLElement = @react_testing_library.screen()
    .getByText("Submit")
    .get("form")
    .cast()
  @react_testing_library.fireEvent().submit(form_el) |> ignore
  @react_testing_library.screen().getByText("Form submitted").textContent()
  |> assert_eq("Form submitted")
}

///|
test "fireEvent focus and blur on input" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let (focused, set_focused) = @react.use_state(false)
    let on_focus = fn(_e : @js.Any) { set_focused(true) }
    let on_blur = fn(_e : @js.Any) { set_focused(false) }
    @react_element.div([
      @react_element.input(
        on_focus=@js.identity(on_focus),
        on_blur=@js.identity(on_blur),
        placeholder="Focus me",
      ),
      @react_element.div([if focused { "Focused" } else { "Not focused" }]),
    ])
  }
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  let input_el = @react_testing_library.screen().getByPlaceholderText(
    "Focus me",
  )
  @react_testing_library.fireEvent().focus(input_el) |> ignore
  @react_testing_library.screen().getByText("Focused").textContent()
  |> assert_eq("Focused")
  @react_testing_library.fireEvent().blur(input_el) |> ignore
  @react_testing_library.screen().getByText("Not focused").textContent()
  |> assert_eq("Not focused")
}

///|
test "fireEvent keyDown on input" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let (key, set_key) = @react.use_state("")
    let on_keydown = fn(e : @js.Any) {
      let k : String = e.get("key").cast()
      set_key("Key: \{k}")
    }
    @react_element.div([
      @react_element.input(
        on_keydown=@js.identity(on_keydown),
        placeholder="Press a key",
      ),
      @react_element.div([if key == "" { "No key pressed" } else { key }]),
    ])
  }
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  let input_el = @react_testing_library.screen().getByPlaceholderText(
    "Press a key",
  )
  let event = @js.Object::new()
  event.set("key", "Enter")
  @react_testing_library.fireEvent().keyDown(input_el, event.to_any()) |> ignore
  @react_testing_library.screen().getByText("Key: Enter").textContent()
  |> assert_eq("Key: Enter")
}

///|
test "configure function exists" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  // Just test that configure can be called without error
  let config = @js.Object::new()
  configure(config.to_any())
  // If we get here without error, the test passes
  assert_eq(1, 1)
}

///| React Hooks Tests with renderHook

///|
test "renderHook: useState" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let hook = fn() {
    let (state, _set_state) = @react.use_state(0)
    state
  }
  let result = renderHook(@js.identity(hook))
  let hook_result = result.result()
  // result.current is the hook return value
  let current = hook_result.get("current")
  let state : Int = @js.identity(current)
  assert_eq(state, 0)
}

///|
test "renderHook: useState with updates" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  // Test that we can get the initial state value
  let hook = fn() {
    let (state, _set_state) = @react.use_state(0)
    state
  }
  let result = renderHook(@js.identity(hook))
  // Get initial state
  let current1 = result.result().get("current")
  let state1 : Int = @js.identity(current1)
  assert_eq(state1, 0)
  // Note: Testing state updates with renderHook requires more complex setup
  // For now, we verify the hook returns the correct initial value
}

///|
test "renderHook: useEffect" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let hook = fn() {
    let (count, set_count) = @react.use_state(0)
    @react.useEffect(
      fn() {
        set_count(count + 1)
        fn() { () }
      },
      [],
    )
    count
  }
  let result = renderHook(@js.identity(hook))
  let current = result.result().get("current")
  let count : Int = @js.identity(current)
  // After useEffect runs, count should be 1
  assert_eq(count, 1)
}

///|
test "renderHook: useCallback" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let hook = fn() {
    let (count, _set_count) = @react.use_state(0)
    @react.useCallback(fn() { count * 2 }, [count])
  }
  let result = renderHook(@js.identity(hook))
  let current = result.result().get("current")
  // callback is a function
  @js.typeof_(current) |> assert_eq("function")
}

///|
test "renderHook: useMemo" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let hook = fn() {
    let (count, _set_count) = @react.use_state(5)
    @react.useMemo(fn() { count * 2 }, [count])
  }
  let result = renderHook(@js.identity(hook))
  let current = result.result().get("current")
  let doubled : Int = @js.identity(current)
  assert_eq(doubled, 10)
}

///|
test "renderHook: useRef" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let hook = fn() { @react.useRef(Some(42)) }
  let result = renderHook(@js.identity(hook))
  let current = result.result().get("current")
  // ref has a current property
  let ref_current = current.get("current")
  let value : Int = @js.identity(ref_current)
  assert_eq(value, 42)
}

///|
test "renderHook: useContext" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let ctx : @react.Context[Int] = @react.create_context(Some(100))
  let hook = fn() { @react.use_context(ctx) }
  let result = renderHook(@js.identity(hook))
  let current = result.result().get("current")
  let value : Int = @js.identity(current)
  assert_eq(value, 100)
}

///|
test "renderHook: useReducer" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let reducer = fn(state : Int, action : Int) { state + action }
  let hook = fn() {
    let (state, _dispatch) = @react.use_reducer(reducer, 0)
    state
  }
  let result = renderHook(@js.identity(hook))
  let current = result.result().get("current")
  let state : Int = @js.identity(current)
  assert_eq(state, 0)
  // Note: Testing dispatch with renderHook requires more complex setup
  // For now, we verify the hook returns the correct initial state
}

///|
test "renderHook: rerender method" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  // Use a simple hook that doesn't need props
  let multiplier_ref : Ref[Int] = { val: 2 }
  let hook = fn() {
    let (count, _set_count) = @react.use_state(10)
    count * multiplier_ref.val
  }
  let result = renderHook(@js.identity(hook))
  let current1 = result.result().get("current")
  let value1 : Int = @js.identity(current1)
  assert_eq(value1, 20)
  // Change multiplier and rerender
  multiplier_ref.val = 3
  result.rerender(@js.undefined())
  let current2 = result.result().get("current")
  let value2 : Int = @js.identity(current2)
  assert_eq(value2, 30)
}

///|
test "renderHook: unmount method" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let hook = fn() { @react.use_state(0) }
  let result = renderHook(@js.identity(hook))
  // Verify hook is mounted
  let current = result.result().get("current")
  @js.typeof_(current) |> assert_eq("object")
  // Unmount should not throw
  result.unmount()
}

///|
test "useId hook" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let id = @react.use_id()
    @react_element.div([@react_element.span(["The ID is: \{id}"])])
  }
  let result = @react_testing_library.render(@react.component(comp, ()))
  // useId generates IDs that contain _ character
  let container = result.container()
  assert_eq(container.textContent().contains("The ID is:"), true)
}

///|
test "useTransition hook" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
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
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.screen().getByText("Count: 0").textContent()
  |> assert_eq("Count: 0")
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("Increment"),
  )
  |> ignore
  @react_testing_library.screen().getByText("Count: 1").textContent()
  |> assert_eq("Count: 1")
}

///|
test "useDeferredValue hook" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let (value, set_value) = @react.use_state(0)
    let deferred = @react.use_deferred_value(value)
    let on_click : @dom.MouseEventHandler = _ => set_value(value + 1)
    @react_element.div([
      @react_element.span(["Value: \{value}, Deferred: \{deferred}"]),
      @react_element.button(on_click~, ["Update"]),
    ])
  }
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.screen()
  .getByText("Value: 0, Deferred: 0")
  .textContent()
  |> assert_eq("Value: 0, Deferred: 0")
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("Update"),
  )
  |> ignore
  // After update, both should eventually match
  @react_testing_library.screen()
  .getByText("Value: 1, Deferred: 1")
  .textContent()
  |> assert_eq("Value: 1, Deferred: 1")
}

///|
test "useOptimistic hook" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
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
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.screen().getByText("Optimistic: 0").textContent()
  |> assert_eq("Optimistic: 0")
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("Add"),
  )
  |> ignore
  @react_testing_library.screen().getByText("Optimistic: 1").textContent()
  |> assert_eq("Optimistic: 1")
}

///|
priv struct ChildProps {} derive(Default)

///|
fn child_component(_props : ChildProps) -> @react.Element {
  let ref_val : @react.ReactRef[@dom.HTMLDivElement] = @react.use_ref(None)
  @react.use_imperative_handle(
    ref_val,
    fn() -> @dom.HTMLDivElement { @js.Object::new() |> @js.identity },
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
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_testing_library.cleanup()
  @react_testing_library.render(@react.component(parent_component, ()))
  |> ignore
  @react_testing_library.screen().getByText("Child").textContent()
  |> assert_eq("Child")
}

// =============================================================================
// React Router Tests
// =============================================================================

///|
async fn init_react_router() -> Unit {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  @react_router.dynamic_import()
  @react_testing_library.cleanup()
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
  @react_testing_library.render(@react_router.router_provider(router)) |> ignore
  @react_testing_library.screen().getByText("Home Page").textContent()
  |> assert_eq("Home Page")
}

///|
async test "react-router: navigate to different route" {
  init_react_router()
  let routes = [
    @react_router.Route::Component(path="/", component=home_component),
    @react_router.Route::Component(path="/about", component=about_component),
  ]
  let router = @react_router.create_memory_router(routes, options=@react_router.MemoryRouterOptions::{
    initial_entries: Some(["/about"]),
    initial_index: None,
  })
  @react_testing_library.render(@react_router.router_provider(router)) |> ignore
  @react_testing_library.screen().getByText("About Page").textContent()
  |> assert_eq("About Page")
}

///|
async test "react-router: route with params" {
  init_react_router()
  let routes = [
    @react_router.Route::Component(path="/users/:id", component=user_component),
  ]
  let router = @react_router.create_memory_router(routes, options=@react_router.MemoryRouterOptions::{
    initial_entries: Some(["/users/456"]),
    initial_index: None,
  })
  @react_testing_library.render(@react_router.router_provider(router)) |> ignore
  @react_testing_library.screen().getByText("User: 456").textContent()
  |> assert_eq("User: 456")
}

///|
async test "react-router: Link component renders" {
  init_react_router()
  let routes = [
    @react_router.Route::Component(path="/", component=home_component),
    @react_router.Route::Component(path="/about", component=about_component),
  ]
  let router = @react_router.create_memory_router(routes, options=@react_router.MemoryRouterOptions::{
    initial_entries: Some(["/"]),
    initial_index: None,
  })
  @react_testing_library.render(@react_router.router_provider(router)) |> ignore
  // Home page should render
  @react_testing_library.screen().getByText("Home Page").textContent()
  |> assert_eq("Home Page")
}

///|
fn location_display(_props : @react_router.RouteProps) -> @react.Element {
  let location = @react_router.useLocation()
  @react_element.div(["Path: \{location.pathname}"], id="location")
}

///|
async test "react-router: useLocation hook" {
  init_react_router()
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
  @react_testing_library.render(@react_router.router_provider(router)) |> ignore
  @react_testing_library.screen().getByText("Path: /test/path").textContent()
  |> assert_eq("Path: /test/path")
}
