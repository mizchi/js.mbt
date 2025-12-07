///| DOM Renderer tests

///| Basic rendering tests

///|
test "render empty node" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  renderer.render(empty())

  // Empty renders as empty text node
  inspect(container.as_node().textContent(), content="")
}

///|
test "render text node" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  renderer.render(text("Hello World"))
  inspect(container.as_node().textContent(), content="Hello World")
}

///|
test "render simple div" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  renderer.render(div([], [text("content")]))
  let html : String = container.as_any()._get("innerHTML").cast()
  inspect(html, content="<div>content</div>")
}

///|
test "render nested elements" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props = []
  renderer.render(
    div(empty_props, [
      h1(empty_props, [text("Title")]),
      p(empty_props, [text("Paragraph")]),
    ]),
  )
  let html : String = container.as_any()._get("innerHTML").cast()
  inspect(html, content="<div><h1>Title</h1><p>Paragraph</p></div>")
}

///|
test "render fragment" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  renderer.render(fragment([text("A"), text("B"), text("C")]))
  inspect(container.as_node().textContent(), content="ABC")
}

///| Props rendering tests

///|
test "render element with className" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  renderer.render(div([class_name("container")], [text("content")]))
  let html : String = container.as_any()._get("innerHTML").cast()
  inspect(html, content="<div class=\"container\">content</div>")
}

///|
test "render element with id" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  renderer.render(div([id("my-id")], []))
  let html : String = container.as_any()._get("innerHTML").cast()
  inspect(html, content="<div id=\"my-id\"></div>")
}

///|
test "render element with multiple attributes" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let props = [class_name("btn"), id("submit"), title("Click me")]
  renderer.render(button(props, [text("Submit")]))
  let html : String = container.as_any()._get("innerHTML").cast()
  inspect(
    html,
    content="<button class=\"btn\" id=\"submit\" title=\"Click me\">Submit</button>",
  )
}

///|
test "render element with boolean attributes" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let props = [disabled(true), checked(false)]
  renderer.render(input(props))

  // Get the input element
  let input_elem = container.querySelector("input").unwrap()

  // Check that disabled attribute is set
  assert_eq(input_elem.hasAttribute("disabled"), true)
  // checked=false should not be set
  assert_eq(input_elem.hasAttribute("checked"), false)
}

///|
test "render element with style object" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let props = [style([("color", "red"), ("fontSize", "16px")])]
  renderer.render(div(props, [text("styled")]))

  // Get the div element
  let div_elem = container.querySelector("div").unwrap()
  let style_obj : @core.Any = div_elem.as_any()._get("style")

  // Check style properties
  let color : String = style_obj._get("color").cast()
  let font_size : String = style_obj._get("fontSize").cast()
  inspect(color, content="red")
  inspect(font_size, content="16px")
}

///| Event handler tests

///|
test "render element with onClick handler" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let mut clicked = false
  let props = [on_click(fn(_event : @core.Any) { clicked = true })]
  renderer.render(button(props, [text("Click")]))

  // Get the button element
  let btn = container.querySelector("button").unwrap()

  // Create and dispatch click event
  let event = doc.createEvent("Event")
  event
  .as_any()
  ._call("initEvent", [@core.any("click"), @core.any(false), @core.any(false)])
  |> ignore
  btn.as_event_target().dispatchEvent(event.as_event()) |> ignore

  // Check that handler was called
  assert_eq(clicked, true)
}

///|
test "render element with onChange handler" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let mut changed = false
  let props = [on_change(fn(_event : @core.Any) { changed = true })]
  renderer.render(input(props))

  // Get the input element
  let input_elem = container.querySelector("input").unwrap()

  // Create and dispatch change event
  let event = doc.createEvent("Event")
  event
  .as_any()
  ._call("initEvent", [@core.any("change"), @core.any(false), @core.any(false)])
  |> ignore
  input_elem.as_event_target().dispatchEvent(event.as_event()) |> ignore

  // Check that handler was called
  assert_eq(changed, true)
}

///| Void elements tests

///|
test "render void element br" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  renderer.render(br())
  let html : String = container.as_any()._get("innerHTML").cast()
  inspect(html, content="<br>")
}

///|
test "render void element img" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let props = [src("/image.png"), alt("Image")]
  renderer.render(img(props))
  let html : String = container.as_any()._get("innerHTML").cast()
  inspect(html, content="<img src=\"/image.png\" alt=\"Image\">")
}

///| Complex rendering tests

///|
test "render complex nested structure" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props : Props = []
  let container_props = [class_name("container")]
  let button_props = [class_name("btn")]
  renderer.render(
    div(container_props, [
      h1(empty_props, [text("Welcome")]),
      p(empty_props, [text("Hello "), text("World")]),
      button(button_props, [text("Click me")]),
    ]),
  )
  let html : String = container.as_any()._get("innerHTML").cast()
  inspect(
    html,
    content="<div class=\"container\"><h1>Welcome</h1><p>Hello World</p><button class=\"btn\">Click me</button></div>",
  )
}

///|
test "render list with fragments" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props : Props = []
  let items = fragment([
    li(empty_props, [text("Item 1")]),
    li(empty_props, [text("Item 2")]),
    li(empty_props, [text("Item 3")]),
  ])
  renderer.render(ul(empty_props, [items]))
  let html : String = container.as_any()._get("innerHTML").cast()
  inspect(
    html,
    content="<ul><li>Item 1</li><li>Item 2</li><li>Item 3</li></ul>",
  )
}

///|
test "render updates container content" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)

  // First render
  renderer.render(div([], [text("First")]))
  inspect(container.as_node().textContent(), content="First")

  // Second render (should use reconciliation)
  renderer.render(div([], [text("Second")]))
  inspect(container.as_node().textContent(), content="Second")
}

///| Reconciliation tests

///|
test "reconciliation: update text content" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)

  // Initial render
  renderer.render(text("Hello"))
  inspect(container.as_node().textContent(), content="Hello")

  // Update text
  renderer.render(text("World"))
  inspect(container.as_node().textContent(), content="World")
}

///|
test "reconciliation: update element props" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)

  // Initial render
  let props1 = [class_name("old-class"), id("my-id")]
  renderer.render(div(props1, [text("content")]))
  let elem = container.querySelector("div").unwrap()
  inspect(elem.className(), content="old-class")
  inspect(elem.id(), content="my-id")

  // Update props
  let props2 = [class_name("new-class"), id("my-id")]
  renderer.render(div(props2, [text("content")]))

  // Same element should be updated
  let elem2 = container.querySelector("div").unwrap()
  inspect(elem2.className(), content="new-class")
  inspect(elem2.id(), content="my-id")
}

///|
test "reconciliation: add child elements" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props : Props = []

  // Initial render with 1 child
  renderer.render(ul(empty_props, [li(empty_props, [text("Item 1")])]))
  let items1 = container.querySelectorAll("li")
  inspect(items1.length(), content="1")

  // Add more children
  renderer.render(
    ul(empty_props, [
      li(empty_props, [text("Item 1")]),
      li(empty_props, [text("Item 2")]),
      li(empty_props, [text("Item 3")]),
    ]),
  )
  let items2 = container.querySelectorAll("li")
  inspect(items2.length(), content="3")
}

///|
test "reconciliation: remove child elements" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props : Props = []

  // Initial render with 3 children
  renderer.render(
    ul(empty_props, [
      li(empty_props, [text("Item 1")]),
      li(empty_props, [text("Item 2")]),
      li(empty_props, [text("Item 3")]),
    ]),
  )
  let items1 = container.querySelectorAll("li")
  inspect(items1.length(), content="3")

  // Remove children
  renderer.render(ul(empty_props, [li(empty_props, [text("Item 1")])]))
  let items2 = container.querySelectorAll("li")
  inspect(items2.length(), content="1")
}

///|
test "reconciliation: replace element type" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props : Props = []

  // Initial render with div
  renderer.render(div(empty_props, [text("content")]))
  let divs1 = container.querySelectorAll("div")
  let spans1 = container.querySelectorAll("span")
  inspect(divs1.length(), content="1")
  inspect(spans1.length(), content="0")

  // Replace with span
  renderer.render(span(empty_props, [text("content")]))
  let divs2 = container.querySelectorAll("div")
  let spans2 = container.querySelectorAll("span")
  inspect(divs2.length(), content="0")
  inspect(spans2.length(), content="1")
}

///|
test "reconciliation: nested structure updates" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props : Props = []

  // Initial render
  renderer.render(
    div(empty_props, [
      h1(empty_props, [text("Old Title")]),
      p(empty_props, [text("Old content")]),
    ]),
  )
  inspect(container.as_node().textContent(), content="Old TitleOld content")

  // Update nested content
  renderer.render(
    div(empty_props, [
      h1(empty_props, [text("New Title")]),
      p(empty_props, [text("New content")]),
    ]),
  )
  inspect(container.as_node().textContent(), content="New TitleNew content")
}

///| Advanced reconciliation tests

///|
test "reconciliation: update style" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)

  // Initial render with style
  let props1 = [style([("color", "red"), ("fontSize", "12px")])]
  renderer.render(div(props1, [text("styled")]))
  let elem1 = container.querySelector("div").unwrap()
  let style_obj1 : @core.Any = elem1.as_any()._get("style")
  let color1 : String = style_obj1._get("color").cast()
  let fontSize1 : String = style_obj1._get("fontSize").cast()
  inspect(color1, content="red")
  inspect(fontSize1, content="12px")

  // Update style
  let props2 = [style([("color", "blue"), ("fontSize", "16px")])]
  renderer.render(div(props2, [text("styled")]))
  let elem2 = container.querySelector("div").unwrap()
  let style_obj2 : @core.Any = elem2.as_any()._get("style")
  let color2 : String = style_obj2._get("color").cast()
  let fontSize2 : String = style_obj2._get("fontSize").cast()
  inspect(color2, content="blue")
  inspect(fontSize2, content="16px")
}

///|
test "reconciliation: add attributes" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)

  // Initial render without attributes
  let props1 : Props = []
  renderer.render(div(props1, [text("content")]))
  let elem1 = container.querySelector("div").unwrap()
  assert_eq(elem1.hasAttribute("title"), false)
  assert_eq(elem1.hasAttribute("data-test"), false)

  // Add attributes
  let props2 = [title("Hello"), data_("data-test", "value")]
  renderer.render(div(props2, [text("content")]))
  let elem2 = container.querySelector("div").unwrap()
  assert_eq(elem2.hasAttribute("title"), true)
  assert_eq(elem2.getAttribute("title").unwrap(), "Hello")
  assert_eq(elem2.hasAttribute("data-test"), true)
  assert_eq(elem2.getAttribute("data-test").unwrap(), "value")
}

///|
test "reconciliation: remove attributes" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)

  // Initial render with attributes
  let props1 = [title("Hello"), data_("data-test", "value")]
  renderer.render(div(props1, [text("content")]))
  let elem1 = container.querySelector("div").unwrap()
  assert_eq(elem1.hasAttribute("title"), true)
  assert_eq(elem1.hasAttribute("data-test"), true)

  // Remove attributes
  let props2 : Props = []
  renderer.render(div(props2, [text("content")]))
  let elem2 = container.querySelector("div").unwrap()
  assert_eq(elem2.hasAttribute("title"), false)
  assert_eq(elem2.hasAttribute("data-test"), false)
}

///|
test "reconciliation: update boolean attributes" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)

  // Initial render without disabled
  let props1 : Props = []
  renderer.render(input(props1))
  let input1 = container.querySelector("input").unwrap()
  assert_eq(input1.hasAttribute("disabled"), false)

  // Update to disabled=true
  let props2 = [disabled(true)]
  renderer.render(input(props2))
  let input2 = container.querySelector("input").unwrap()
  assert_eq(input2.hasAttribute("disabled"), true)

  // Update with disabled=false (should remove attribute)
  let props3 = [disabled(false)]
  renderer.render(input(props3))
  let input3 = container.querySelector("input").unwrap()
  assert_eq(input3.hasAttribute("disabled"), false)

  // Update back to disabled=true
  let props4 = [disabled(true)]
  renderer.render(input(props4))
  let input4 = container.querySelector("input").unwrap()
  assert_eq(input4.hasAttribute("disabled"), true)
}

///|
test "reconciliation: fragment updates" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)

  // Initial render with fragment
  renderer.render(fragment([text("A"), text("B")]))
  inspect(container.as_node().textContent(), content="AB")

  // Update fragment content
  renderer.render(fragment([text("X"), text("Y"), text("Z")]))
  inspect(container.as_node().textContent(), content="XYZ")

  // Update to fewer children
  renderer.render(fragment([text("1")]))
  inspect(container.as_node().textContent(), content="1")
}

///|
test "reconciliation: deep nested partial update" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props : Props = []

  // Initial render with deep nesting
  renderer.render(
    div(empty_props, [
      div(empty_props, [
        div(empty_props, [
          span(empty_props, [text("Deep text")]),
          p(empty_props, [text("Unchanged")]),
        ]),
      ]),
    ]),
  )
  inspect(container.as_node().textContent(), content="Deep textUnchanged")

  // Update only the deeply nested span
  renderer.render(
    div(empty_props, [
      div(empty_props, [
        div(empty_props, [
          span(empty_props, [text("Updated text")]),
          p(empty_props, [text("Unchanged")]),
        ]),
      ]),
    ]),
  )
  inspect(container.as_node().textContent(), content="Updated textUnchanged")

  // Verify structure is preserved
  let spans = container.querySelectorAll("span")
  let ps = container.querySelectorAll("p")
  inspect(spans.length(), content="1")
  inspect(ps.length(), content="1")
}

///|
test "reconciliation: multiple consecutive updates" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props : Props = []

  // Update 1
  renderer.render(div(empty_props, [text("Step 1")]))
  inspect(container.as_node().textContent(), content="Step 1")

  // Update 2
  renderer.render(div(empty_props, [text("Step 2")]))
  inspect(container.as_node().textContent(), content="Step 2")

  // Update 3
  renderer.render(div(empty_props, [text("Step 3")]))
  inspect(container.as_node().textContent(), content="Step 3")

  // Update 4 - change structure
  renderer.render(
    div(empty_props, [span(empty_props, [text("Step 4 in span")])]),
  )
  inspect(container.as_node().textContent(), content="Step 4 in span")

  // Update 5 - back to simple text
  renderer.render(div(empty_props, [text("Step 5")]))
  inspect(container.as_node().textContent(), content="Step 5")
}

///|
test "reconciliation: mixed updates (props + children)" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props : Props = []

  // Initial render
  let props1 = [class_name("old")]
  renderer.render(div(props1, [span(empty_props, [text("Old child")])]))
  let div1 = container.querySelector("div").unwrap()
  inspect(div1.className(), content="old")
  inspect(container.as_node().textContent(), content="Old child")

  // Update both props and children
  let props2 = [class_name("new"), id("my-div")]
  renderer.render(
    div(props2, [
      span(empty_props, [text("New child 1")]),
      span(empty_props, [text("New child 2")]),
    ]),
  )
  let div2 = container.querySelector("div").unwrap()
  inspect(div2.className(), content="new")
  inspect(div2.id(), content="my-div")
  inspect(container.as_node().textContent(), content="New child 1New child 2")
  let spans = container.querySelectorAll("span")
  inspect(spans.length(), content="2")
}

///|
test "reconciliation: empty node handling" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props : Props = []

  // Initial render with empty
  renderer.render(div(empty_props, [empty()]))
  inspect(container.as_node().textContent(), content="")

  // Update to text
  renderer.render(div(empty_props, [text("Now visible")]))
  inspect(container.as_node().textContent(), content="Now visible")

  // Update back to empty
  renderer.render(div(empty_props, [empty()]))
  inspect(container.as_node().textContent(), content="")

  // Update to multiple children including empty
  renderer.render(div(empty_props, [text("Before"), empty(), text("After")]))
  inspect(container.as_node().textContent(), content="BeforeAfter")
}

///|
test "reconciliation: reorder children (non-keyed)" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props : Props = []

  // Initial order: A, B, C
  renderer.render(
    ul(empty_props, [
      li(empty_props, [text("A")]),
      li(empty_props, [text("B")]),
      li(empty_props, [text("C")]),
    ]),
  )
  let lis1 = container.querySelectorAll("li")
  inspect(lis1.length(), content="3")
  inspect(container.as_node().textContent(), content="ABC")

  // Reorder: C, A, B (without keys, this updates content in place)
  renderer.render(
    ul(empty_props, [
      li(empty_props, [text("C")]),
      li(empty_props, [text("A")]),
      li(empty_props, [text("B")]),
    ]),
  )
  let lis2 = container.querySelectorAll("li")
  inspect(lis2.length(), content="3")
  inspect(container.as_node().textContent(), content="CAB")
}

///|
test "reconciliation: complex real-world scenario" {
  @global_jsdom.register()
  let doc = @dom.document()
  let container = doc.createElement("div")
  let renderer = DomRenderer::new(container)
  let empty_props : Props = []

  // Initial render: Login form
  let form_props1 = [class_name("login-form")]
  renderer.render(
    div(form_props1, [
      h1(empty_props, [text("Login")]),
      input([type_("text"), placeholder("Username")]),
      input([type_("password"), placeholder("Password")]),
      button(empty_props, [text("Login")]),
    ]),
  )
  inspect(
    container.querySelector("h1").unwrap().as_node().textContent(),
    content="Login",
  )
  inspect(container.querySelectorAll("input").length(), content="2")
  inspect(container.querySelectorAll("button").length(), content="1")

  // Update: Show error message and disable button
  let form_props2 = [class_name("login-form error")]
  let button_props = [disabled(true)]
  renderer.render(
    div(form_props2, [
      h1(empty_props, [text("Login")]),
      p([class_name("error")], [text("Invalid credentials")]),
      input([type_("text"), placeholder("Username")]),
      input([type_("password"), placeholder("Password")]),
      button(button_props, [text("Login")]),
    ]),
  )
  let form_div = container.querySelector("div").unwrap()
  inspect(form_div.className(), content="login-form error")
  inspect(container.querySelectorAll("p").length(), content="1")
  inspect(
    container.querySelector("p").unwrap().as_node().textContent(),
    content="Invalid credentials",
  )
  assert_eq(
    container.querySelector("button").unwrap().hasAttribute("disabled"),
    true,
  )

  // Update: Clear error and enable button
  let form_props3 = [class_name("login-form")]
  renderer.render(
    div(form_props3, [
      h1(empty_props, [text("Login")]),
      input([type_("text"), placeholder("Username")]),
      input([type_("password"), placeholder("Password")]),
      button(empty_props, [text("Login")]),
    ]),
  )
  let form_div2 = container.querySelector("div").unwrap()
  inspect(form_div2.className(), content="login-form")
  inspect(container.querySelectorAll("p").length(), content="0")
  assert_eq(
    container.querySelector("button").unwrap().hasAttribute("disabled"),
    false,
  )
}
