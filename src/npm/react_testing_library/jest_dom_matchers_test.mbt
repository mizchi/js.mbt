// This test file uses abbreviated namespace imports for better DSL readability.
// In testing-library tests, concise syntax like `expect(screen().getByText("x")).toHaveClass("btn")`
// is preferred over fully qualified paths for better test readability.

///|
fn setup_once() -> Unit {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  setup_matchers()
  cleanup()
}

///|
test "toHaveTextContent with string" {
  setup_once()
  defer cleanup()
  let comp = (_props : Unit) => @react_element.div(["Hello World"])
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByText("Hello World")).toHaveTextContent("Hello World")
}

///|
test "toHaveTextContent with regex" {
  setup_once()
  defer cleanup()
  let comp = (_props : Unit) => @react_element.div(["Hello Regex"])
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByText("Hello Regex")).toHaveTextContentMatch(
    @regexp.RegExp::new("Hello"),
  )
}

///|
test "toHaveClass" {
  setup_once()
  defer cleanup()
  let comp = (_props : Unit) => @react_element.div(class="greeting active", [
    "Test Class",
  ])
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByText("Test Class"))
  ..toHaveClass("greeting")
  ..toHaveClass("active")
}

///|
test "toHaveAttribute" {
  setup_once()
  defer cleanup()
  let comp = (_props : Unit) => @react_element.input(
    type_="text",
    placeholder="Enter name",
  )
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByPlaceholderText("Enter name"))
  ..toHaveAttribute("type")
  ..toHaveAttributeValue("type", "text")
  ..toHaveAttributeValue("placeholder", "Enter name")
}

///|
test "toBeInTheDocument" {
  setup_once()
  defer cleanup()
  let comp = (_props : Unit) => @react_element.span(["Test InDoc"])
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByText("Test InDoc")).toBeInTheDocument()
}

///|
test "toBeDisabled and toBeEnabled" {
  setup_once()
  defer cleanup()
  let comp = (_props : Unit) => @react_element.div([
    @react_element.button(disabled=true, ["Disabled Btn"]),
    @react_element.button(["Enabled Btn"]),
  ])
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByText("Disabled Btn")).toBeDisabled()
  expect(screen().getByText("Enabled Btn")).toBeEnabled()
}

///|
test "toHaveValue for input" {
  setup_once()
  defer cleanup()
  let comp = (_props : Unit) => @react_element.input(
    type_="text",
    default_value="hello",
    placeholder="value test",
  )
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByPlaceholderText("value test")).toHaveValue("hello")
}

///|
test "chained matchers" {
  setup_once()
  defer cleanup()
  let comp = _ => @react_element.button(class="btn primary", type_="submit", [
    "Submit",
  ])
  render(@react.component(comp, ())) |> ignore
  // Chained matchers on same element
  expect(screen().getByText("Submit"))
  ..toBeInTheDocument()
  ..toHaveTextContent("Submit")
  ..toHaveClass("btn")
  ..toHaveClass("primary")
  ..toHaveAttributeValue("type", "submit")
  ..toBeEnabled()
}
