// This test file uses abbreviated namespace imports for better DSL readability.
// In testing-library tests, concise syntax like `expect(screen().getByText("x")).toHaveClass("btn")`
// is preferred over fully qualified paths for better test readability.

///|
/// Setup React Testing Library environment.
/// Returns a dispose function that should be called via defer.
/// Usage: let dispose = setup(); defer dispose()
fn setup() -> () -> Unit {
  @global_jsdom.register()
  @testing_library_react.setup_matchers()
  cleanup()
  () => cleanup()
}

///|
test "toHaveTextContent with string" {
  let dispose = setup()
  defer dispose()
  let comp = _ => @react_element.div(["Hello World"])
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByText("Hello World")).toHaveTextContent("Hello World")
}

///|
test "toHaveTextContent with regex" {
  let dispose = setup()
  defer dispose()
  let comp = _ => @react_element.div(["Hello Regex"])
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByText("Hello Regex")).toHaveTextContent(
    @regexp.RegExp::new("Hello"),
  )
}

///|
test "getByText with regex" {
  let dispose = setup()
  defer dispose()
  let comp = _ => @react_element.div(["Hello Pattern Match"])
  render(@react.component(comp, ())) |> ignore
  // Using RegExp with getByText via TextMatch trait
  expect(screen().getByText(@regexp.RegExp::new("Pattern"))).toBeInTheDocument()
}

///|
test "toHaveClass" {
  let dispose = setup()
  defer dispose()
  let comp = _ => @react_element.div(class="greeting active", ["Test Class"])
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByText("Test Class"))
  ..toHaveClass("greeting")
  ..toHaveClass("active")
}

///|
test "toHaveAttribute" {
  let dispose = setup()
  defer dispose()
  let comp = _ => @react_element.input(type_="text", placeholder="Enter name")
  render(@react.component(comp, ())) |> ignore
  expect(screen().get_by_placeholder_text("Enter name"))
  ..toHaveAttribute("type")
  ..toHaveAttributeValue("type", "text")
  ..toHaveAttributeValue("placeholder", "Enter name")
}

///|
test "toBeInTheDocument" {
  let dispose = setup()
  defer dispose()
  let comp = _ => @react_element.span(["Test InDoc"])
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByText("Test InDoc")).toBeInTheDocument()
}

///|
test "toBeDisabled and toBeEnabled" {
  let dispose = setup()
  defer dispose()
  let comp = _ => @react_element.div([
    @react_element.button(disabled=true, ["Disabled Btn"]),
    @react_element.button(["Enabled Btn"]),
  ])
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByText("Disabled Btn")).toBeDisabled()
  expect(screen().getByText("Enabled Btn")).toBeEnabled()
}

///|
test "toHaveValue for input" {
  let dispose = setup()
  defer dispose()
  let comp = _ => @react_element.input(
    type_="text",
    default_value="hello",
    placeholder="value test",
  )
  render(@react.component(comp, ())) |> ignore
  expect(screen().getByPlaceholderText("value test")).toHaveValue("hello")
}

///|
test "chained matchers" {
  let dispose = setup()
  defer dispose()
  let comp = _ => @react_element.button(class="btn primary", type_="submit", [
    "Submit",
  ])
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  // Chained matchers on same element
  expect(screen().getByText("Submit"))
  ..toBeInTheDocument()
  ..toHaveTextContent("Submit")
  ..toHaveClass("btn")
  ..toHaveClass("primary")
  ..toHaveAttributeValue("type", "submit")
  ..toBeEnabled()
}
