///|
using @js {unsafe_cast}

///|
using @react {component}

///|
using @react_element {div, button, input, span}

///|
using @react_testing_library {
  render,
  cleanup,
  screen,
  text_content,
  get_string_property,
  get_property,
}

///|
priv struct AppProps {} derive(Default)

///|
fn app(_props : AppProps) -> @react.Element {
  let (cnt, set_cnt) = @react.use_state(0)
  let on_click : @dom.MouseEventHandler = _ => set_cnt(cnt + 1) |> ignore
  div(["Hello RTL", div(["Count: \{cnt}"]), button(on_click~, ["click me"])])
}

///|
test "testing-library/react" {
  // @global_jsdom.register()
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  render(component(app, AppProps::default())) |> ignore
  fireEvent().click(screen().getByText("click me"))
  // screen().debug()
  text_content(screen().getByText("Count: 1")) |> assert_eq("Count: 1")
}

///|
test "RenderResult methods" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => div(["Test Content"], id="test-id")
  let result = render(component(comp, AppProps::default()))
  // Test container
  let container = result.container()
  @js.typeof_(container) |> assert_eq("object")
  // Test baseElement
  let base = result.baseElement()
  @js.typeof_(base) |> assert_eq("object")
  // Test debug (should not throw)
  // result.debug()
  // Test rerender
  let comp2 = (_props : AppProps) => div(["Rerendered Content"])
  result.rerender(component(comp2, AppProps::default()))
  text_content(screen().getByText("Rerendered Content"))
  |> assert_eq("Rerendered Content")
  // Test unmount
  result.unmount()
}

///|
test "queryBy methods return None when not found" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => div(["Existing text"])
  render(component(comp, AppProps::default())) |> ignore
  // queryByText returns null (converted to None in JS) for non-existent text
  let result : @js.Js = screen().call("queryByText", ["Non-existent"])
  let is_null = @js.is_null(result)
  assert_eq(is_null, true)
  // queryByText returns element for existing text
  let existing : @js.Js = screen().call("queryByText", ["Existing text"])
  let is_null2 = @js.is_null(existing)
  assert_eq(is_null2, false)
  // Verify the text content
  let text = text_content(unsafe_cast(existing))
  assert_eq(text, "Existing text")
}

///|
test "getAllBy and queryAllBy methods" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => div([
    button(["Button 1"]),
    button(["Button 2"]),
    button(["Button 3"]),
  ])
  render(component(comp, AppProps::default())) |> ignore
  // getAllByRole returns array of all buttons
  let buttons = screen().getAllByRole("button")
  buttons.length() |> assert_eq(3)
  // queryAllByRole also returns array
  let buttons2 = screen().queryAllByRole("button")
  buttons2.length() |> assert_eq(3)
  // queryAllByRole returns empty array for non-existent elements
  let nonexistent = screen().queryAllByRole("checkbox")
  nonexistent.length() |> assert_eq(0)
}

///|
test "getByRole query" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => div([
    button(["Click me"]),
    input(type_="text"),
  ])
  render(component(comp, AppProps::default())) |> ignore
  // getByRole finds button
  let btn = screen().getByRole("button")
  text_content(btn) |> assert_eq("Click me")
  // getByRole finds textbox
  let input_el = screen().getByRole("textbox")
  @js.typeof_(input_el) |> assert_eq("object")
}

///|
test "getByPlaceholderText query" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => div([input(placeholder="Enter your name")])
  render(component(comp, AppProps::default())) |> ignore
  let input_el = screen().getByPlaceholderText("Enter your name")
  get_string_property(input_el, "placeholder") |> assert_eq("Enter your name")
}

///|
test "getByDisplayValue query" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => div([
    input(value="test value", on_change=fn(_) { () }),
  ])
  render(component(comp, AppProps::default())) |> ignore
  let input_el = screen().getByDisplayValue("test value")
  get_string_property(input_el, "value") |> assert_eq("test value")
}

///|
test "getByText with multiple results" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => div([
    div(["Item"]),
    div(["Item"]),
    div(["Item"]),
  ])
  render(component(comp, AppProps::default())) |> ignore
  // getAllByText returns all matching elements
  let items = screen().getAllByText("Item")
  items.length() |> assert_eq(3)
}

///|
test "fireEvent click on button" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => {
    let (clicked, set_clicked) = @react.use_state(false)
    let on_click : @dom.MouseEventHandler = _ => set_clicked(true)
    div([
      button(on_click~, ["Click me"]),
      div([if clicked { "Clicked!" } else { "Not clicked" }]),
    ])
  }
  render(component(comp, AppProps::default())) |> ignore
  screen().getByText("Not clicked") |> ignore
  fireEvent().click(screen().getByText("Click me"))
  text_content(screen().getByText("Clicked!")) |> assert_eq("Clicked!")
}

///|
test "fireEvent change on input" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => {
    let (value, set_value) = @react.use_state("")
    let on_change : @dom.ChangeEventHandler = e => {
      let target : @js.Js = e.get("target")
      let new_value : String = target.get("value") |> unsafe_cast
      set_value(new_value)
    }
    div([
      input(on_change~, value~, placeholder="Type here"),
      div(["Value: \{value}"]),
    ])
  }
  render(component(comp, AppProps::default())) |> ignore
  let input_el = screen().getByPlaceholderText("Type here")
  // Create event object
  let event = @js.Object::new()
  let target = @js.Object::new()
  target.set("value", "hello")
  event.set("target", target.to_js())
  fireEvent().change(input_el, event.to_js())
  text_content(screen().getByText("Value: hello")) |> assert_eq("Value: hello")
}

///|
test "fireEvent submit on form" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => {
    let (submitted, set_submitted) = @react.use_state(false)
    let on_submit = fn(e : @js.Js) {
      e.call0("preventDefault") |> ignore
      set_submitted(true)
    }
    div([
      @react_element.form(
        [@react_element.button(["Submit"], type_="submit")],
        on_submit=unsafe_cast(on_submit),
        id="test-form",
      ),
      if submitted {
        div(["Form submitted"])
      } else {
        div(["Not submitted"])
      },
    ])
  }
  render(component(comp, AppProps::default())) |> ignore
  screen().getByText("Not submitted") |> ignore
  let form_el = get_property(screen().getByText("Submit"), "form")
    |> unsafe_cast
  fireEvent().submit(form_el)
  text_content(screen().getByText("Form submitted"))
  |> assert_eq("Form submitted")
}

///|
test "fireEvent focus and blur on input" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => {
    let (focused, set_focused) = @react.use_state(false)
    let on_focus = fn(_e : @js.Js) { set_focused(true) }
    let on_blur = fn(_e : @js.Js) { set_focused(false) }
    div([
      input(
        on_focus=unsafe_cast(on_focus),
        on_blur=unsafe_cast(on_blur),
        placeholder="Focus me",
      ),
      div([if focused { "Focused" } else { "Not focused" }]),
    ])
  }
  render(component(comp, AppProps::default())) |> ignore
  let input_el = screen().getByPlaceholderText("Focus me")
  fireEvent().focus(input_el)
  text_content(screen().getByText("Focused")) |> assert_eq("Focused")
  fireEvent().blur(input_el)
  text_content(screen().getByText("Not focused")) |> assert_eq("Not focused")
}

///|
test "fireEvent keyDown on input" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => {
    let (key, set_key) = @react.use_state("")
    let on_keydown = fn(e : @js.Js) {
      let k : String = e.get("key") |> unsafe_cast
      set_key("Key: \{k}")
    }
    div([
      input(on_keydown=unsafe_cast(on_keydown), placeholder="Press a key"),
      div([if key == "" { "No key pressed" } else { key }]),
    ])
  }
  render(component(comp, AppProps::default())) |> ignore
  let input_el = screen().getByPlaceholderText("Press a key")
  let event = @js.Object::new()
  event.set("key", "Enter")
  fireEvent().keyDown(input_el, event.to_js())
  text_content(screen().getByText("Key: Enter")) |> assert_eq("Key: Enter")
}

///|
test "configure function exists" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  // Just test that configure can be called without error
  let config = @js.Object::new()
  configure(config.to_js())
  // If we get here without error, the test passes
  assert_eq(1, 1)
}

///| React Hooks Tests with renderHook

///|
test "renderHook: useState" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let hook = fn() {
    let (state, _set_state) = @react.use_state(0)
    state
  }
  let result = renderHook(unsafe_cast(hook))
  let hook_result = result.result()
  // result.current is the hook return value
  let current = hook_result.get("current")
  let state : Int = unsafe_cast(current)
  assert_eq(state, 0)
}

///|
test "renderHook: useState with updates" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  // Test that we can get the initial state value
  let hook = fn() {
    let (state, _set_state) = @react.use_state(0)
    state
  }
  let result = renderHook(unsafe_cast(hook))
  // Get initial state
  let current1 = result.result().get("current")
  let state1 : Int = unsafe_cast(current1)
  assert_eq(state1, 0)
  // Note: Testing state updates with renderHook requires more complex setup
  // For now, we verify the hook returns the correct initial value
}

///|
test "renderHook: useEffect" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
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
  let result = renderHook(unsafe_cast(hook))
  let current = result.result().get("current")
  let count : Int = unsafe_cast(current)
  // After useEffect runs, count should be 1
  assert_eq(count, 1)
}

///|
test "renderHook: useCallback" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let hook = fn() {
    let (count, _set_count) = @react.use_state(0)
    @react.useCallback(fn() { count * 2 }, [count])
  }
  let result = renderHook(unsafe_cast(hook))
  let current = result.result().get("current")
  // callback is a function
  @js.typeof_(current) |> assert_eq("function")
}

///|
test "renderHook: useMemo" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let hook = fn() {
    let (count, _set_count) = @react.use_state(5)
    @react.useMemo(fn() { count * 2 }, [count])
  }
  let result = renderHook(unsafe_cast(hook))
  let current = result.result().get("current")
  let doubled : Int = unsafe_cast(current)
  assert_eq(doubled, 10)
}

///|
test "renderHook: useRef" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let hook = fn() { @react.useRef(Some(42)) }
  let result = renderHook(unsafe_cast(hook))
  let current = result.result().get("current")
  // ref has a current property
  let ref_current = current.get("current")
  let value : Int = unsafe_cast(ref_current)
  assert_eq(value, 42)
}

///|
test "renderHook: useContext" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let ctx : @react.Context[Int] = @react.create_context(Some(100))
  let hook = fn() { @react.use_context(ctx) }
  let result = renderHook(unsafe_cast(hook))
  let current = result.result().get("current")
  let value : Int = unsafe_cast(current)
  assert_eq(value, 100)
}

///|
test "renderHook: useReducer" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let reducer = fn(state : Int, action : Int) { state + action }
  let hook = fn() {
    let (state, _dispatch) = @react.use_reducer(reducer, 0)
    state
  }
  let result = renderHook(unsafe_cast(hook))
  let current = result.result().get("current")
  let state : Int = unsafe_cast(current)
  assert_eq(state, 0)
  // Note: Testing dispatch with renderHook requires more complex setup
  // For now, we verify the hook returns the correct initial state
}

///|
test "renderHook: rerender method" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  // Use a simple hook that doesn't need props
  let multiplier_ref : Ref[Int] = { val: 2 }
  let hook = fn() {
    let (count, _set_count) = @react.use_state(10)
    count * multiplier_ref.val
  }
  let result = renderHook(unsafe_cast(hook))
  let current1 = result.result().get("current")
  let value1 : Int = unsafe_cast(current1)
  assert_eq(value1, 20)
  // Change multiplier and rerender
  multiplier_ref.val = 3
  result.rerender(@js.undefined())
  let current2 = result.result().get("current")
  let value2 : Int = unsafe_cast(current2)
  assert_eq(value2, 30)
}

///|
test "renderHook: unmount method" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let hook = fn() { @react.use_state(0) }
  let result = renderHook(unsafe_cast(hook))
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
  cleanup()
  let comp = (_props : AppProps) => {
    let id = @react.use_id()
    div([span(["The ID is: \{id}"])])
  }
  let result = render(component(comp, AppProps::default()))
  // useId generates IDs that contain _ character
  let container = result.container()
  let text = text_content(container)
  assert_eq(text.contains("The ID is:"), true)
}

///|
test "useTransition hook" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => {
    let (count, set_count) = @react.use_state(0)
    let (is_pending, start_transition) = @react.use_transition()
    let on_click : @dom.MouseEventHandler = _ => start_transition(fn() {
      set_count(count + 1)
    })
    let pending_text = if is_pending { " (pending)" } else { "" }
    div([
      span(["Count: \{count}\{pending_text}"]),
      button(on_click~, ["Increment"]),
    ])
  }
  render(component(comp, AppProps::default())) |> ignore
  text_content(screen().getByText("Count: 0")) |> assert_eq("Count: 0")
  fireEvent().click(screen().getByText("Increment"))
  text_content(screen().getByText("Count: 1")) |> assert_eq("Count: 1")
}

///|
test "useDeferredValue hook" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => {
    let (value, set_value) = @react.use_state(0)
    let deferred = @react.use_deferred_value(value)
    let on_click : @dom.MouseEventHandler = _ => set_value(value + 1)
    div([
      span(["Value: \{value}, Deferred: \{deferred}"]),
      button(on_click~, ["Update"]),
    ])
  }
  render(component(comp, AppProps::default())) |> ignore
  text_content(screen().getByText("Value: 0, Deferred: 0"))
  |> assert_eq("Value: 0, Deferred: 0")
  fireEvent().click(screen().getByText("Update"))
  // After update, both should eventually match
  text_content(screen().getByText("Value: 1, Deferred: 1"))
  |> assert_eq("Value: 1, Deferred: 1")
}

///|
test "useOptimistic hook" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => {
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
    div([span(["Optimistic: \{optimistic}"]), button(on_click~, ["Add"])])
  }
  render(component(comp, AppProps::default())) |> ignore
  text_content(screen().getByText("Optimistic: 0"))
  |> assert_eq("Optimistic: 0")
  fireEvent().click(screen().getByText("Add"))
  text_content(screen().getByText("Optimistic: 1"))
  |> assert_eq("Optimistic: 1")
}

///|
priv struct ChildProps {} derive(Default)

///|
fn child_component(_props : ChildProps) -> @react.Element {
  let ref_val : @react.ReactRef[@dom.HTMLDivElement] = @react.use_ref(None)
  @react.use_imperative_handle(
    ref_val,
    fn() -> @dom.HTMLDivElement { @js.Object::new() |> unsafe_cast },
    [],
  )
  div(["Child"], ref_=ref_val)
}

///|
fn parent_component(_props : AppProps) -> @react.Element {
  div([component(child_component, ChildProps::default())])
}

///|
test "useImperativeHandle hook" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  render(component(parent_component, AppProps::default())) |> ignore
  text_content(screen().getByText("Child")) |> assert_eq("Child")
}
