///|
using @js {unsafe_cast}

///|
using @react {component}

///|
using @element {div, button, input, label, span}

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
  screen().getByText("Count: 1").get("textContent")
  |> unsafe_cast
  |> assert_eq("Count: 1")
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
  result.debug()
  // Test rerender
  let comp2 = (_props : AppProps) => div(["Rerendered Content"])
  result.rerender(component(comp2, AppProps::default()))
  screen().getByText("Rerendered Content").get("textContent")
  |> unsafe_cast
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
  let text : String = existing.get("textContent") |> unsafe_cast
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
  btn.get("textContent") |> unsafe_cast |> assert_eq("Click me")
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
  input_el.get("placeholder") |> unsafe_cast |> assert_eq("Enter your name")
}

///|
test "getByDisplayValue query" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
  cleanup()
  let comp = (_props : AppProps) => div([input(value="test value")])
  render(component(comp, AppProps::default())) |> ignore
  let input_el = screen().getByDisplayValue("test value")
  input_el.get("value") |> unsafe_cast |> assert_eq("test value")
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
  screen().getByText("Clicked!").get("textContent")
  |> unsafe_cast
  |> assert_eq("Clicked!")
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
  screen().getByText("Value: hello").get("textContent")
  |> unsafe_cast
  |> assert_eq("Value: hello")
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
      @element.form(
        [@element.button(["Submit"], type_="submit")],
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
  let form_el = screen().getByText("Submit").get("form") |> unsafe_cast
  fireEvent().submit(form_el)
  screen().getByText("Form submitted").get("textContent")
  |> unsafe_cast
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
  screen().getByText("Focused").get("textContent")
  |> unsafe_cast
  |> assert_eq("Focused")
  fireEvent().blur(input_el)
  screen().getByText("Not focused").get("textContent")
  |> unsafe_cast
  |> assert_eq("Not focused")
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
  screen().getByText("Key: Enter").get("textContent")
  |> unsafe_cast
  |> assert_eq("Key: Enter")
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
