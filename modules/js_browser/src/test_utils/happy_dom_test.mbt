///|
test "HappyWindow - create and get document" {
  let window = create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  div.tagName() |> inspect(content="DIV")
}

///|
test "HappyWindow - innerText works (unlike jsdom)" {
  let window = create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  div.setInnerHTML("<span>Hello World</span>")
  // happy-dom supports innerText properly
  @dom.HTMLElement::cast_from_element(div).innerText()
  |> inspect(content="Hello World")
}

///|
test "HappyWindow - createElement and appendChild" {
  let window = create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let child = doc.createElement("span")
  child.as_node().setTextContent("Test")
  parent.as_node().appendChild(child.as_node()) |> ignore
  parent.innerHTML() |> inspect(content="<span>Test</span>")
}

///|
test "HappyWindow - querySelector" {
  let window = create_happy_window()
  defer window.close()
  let doc = window.document()
  let container = doc.createElement("div")
  container.setInnerHTML(
    "<span class=\"test\">One</span><span class=\"test\">Two</span>",
  )
  let found = container.querySelectorAll(".test")
  found.length() |> inspect(content="2")
}
