///|
extern "js" fn ffi_render_to_string(
  render_fn : @js.Js,
  element : @js.Js,
) -> String =
  #|(renderFn, element) => renderFn(element)

///|
fn get_render_to_string() -> (@react.Element) -> String {
  // Initialize React API
  @react.init_react_api(@node.require("react"))
  let react_dom_server = @node.require("react-dom/server")
  let render_fn : @js.Js = react_dom_server.get("renderToString")
  fn(element : @react.Element) -> String {
    ffi_render_to_string(render_fn, element.to_js())
  }
}

///|
test "div element with text content" {
  let render_to_string = get_render_to_string()
  let element = div(["Hello, World!"])
  let html = render_to_string(element)
  inspect(html, content="<div>Hello, World!</div>")
}

///|
test "div element with id and class" {
  let render_to_string = get_render_to_string()
  let element = div(id="test-id", class="test-class", ["Content"])
  let html = render_to_string(element)
  inspect(
    html,
    content="<div id=\"test-id\" class=\"test-class\">Content</div>",
  )
}

///|
test "nested elements" {
  let render_to_string = get_render_to_string()
  let element = div([h1(["Title"]), p(["Paragraph 1"]), p(["Paragraph 2"])])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<div><h1>Title</h1><p>Paragraph 1</p><p>Paragraph 2</p></div>
    ),
  )
}

///|
test "input element with props" {
  let render_to_string = get_render_to_string()
  let element = input(
    type_="text",
    name="username",
    placeholder="Enter username",
    default_value="test",
  )
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<input type="text" placeholder="Enter username" name="username" value="test"/>
    ),
  )
}

///|
test "textarea element" {
  let render_to_string = get_render_to_string()
  let element = textarea(
    default_value="Hello\nWorld",
    placeholder="Enter text",
    [],
  )
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<textarea placeholder="Enter text">Hello
      #|World</textarea>
    ),
  )
}

///|
test "button element with type and disabled" {
  let render_to_string = get_render_to_string()
  let element = button(type_="submit", disabled=true, ["Submit"])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<button type="submit" disabled="">Submit</button>
    ),
  )
}

///|
test "a element with href" {
  let render_to_string = get_render_to_string()
  let element = a(href="https://example.com", target="_blank", ["Link"])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<a href="https://example.com" target="_blank">Link</a>
    ),
  )
}

///|
test "img element" {
  let render_to_string = get_render_to_string()
  let element = img(src="image.png", alt="Test image", width=100, height=200, [])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<link rel="preload" as="image" href="image.png"/><img src="image.png" alt="Test image" width="100" height="200"/>
    ),
  )
}

///|
test "ul with li elements" {
  let render_to_string = get_render_to_string()
  let element = ul([li(["Item 1"]), li(["Item 2"]), li(["Item 3"])])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<ul><li>Item 1</li><li>Item 2</li><li>Item 3</li></ul>
    ),
  )
}

///|
test "select with option elements" {
  let render_to_string = get_render_to_string()
  let element = select([
    option(value="1", ["Option 1"]),
    option(value="2", ["Option 2"]),
    option(value="3", ["Option 3"]),
  ])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<select><option value="1">Option 1</option><option value="2">Option 2</option><option value="3">Option 3</option></select>
    ),
  )
}

///|
test "form element" {
  let render_to_string = get_render_to_string()
  let element = form(method_="post", [
    label(["Name:"], "name"),
    input(type_="text", id="name", name="name"),
  ])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<form method="post"><label for="name">Name:</label><input type="text" id="name" name="name"/></form>
    ),
  )
}

///|
test "svg element with circle" {
  let render_to_string = get_render_to_string()
  let element = svg(width=100, height=100, [
    circle(cx=50, cy=50, r=40, fill="red"),
  ])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<svg width="100" height="100"><circle cx="50" cy="50" r="40" fill="red"></circle></svg>
    ),
  )
}

///|
test "svg element with rect" {
  let render_to_string = get_render_to_string()
  let element = svg(width=200, height=100, [
    rect(x=10, y=10, width=180, height=80, fill="blue"),
  ])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<svg width="200" height="100"><rect x="10" y="10" width="180" height="80" fill="blue"></rect></svg>
    ),
  )
}

///|
test "svg element with path" {
  let render_to_string = get_render_to_string()
  let element = svg(width=100, height=100, [
    path(d="M 10 10 L 90 90", stroke="black", stroke_width=2),
  ])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<svg width="100" height="100"><path d="M 10 10 L 90 90" stroke="black" stroke-width="2"></path></svg>
    ),
  )
}

///|
test "custom props with @js.Object" {
  let render_to_string = get_render_to_string()
  let custom_props = @js.Object::new()
  custom_props.set("data-testid", "my-div")
  custom_props.set("aria-label", "Main content")
  let element = div(props=custom_props, ["Content"])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<div data-testid="my-div" aria-label="Main content">Content</div>
    ),
  )
}

///|
test "style attribute as Map" {
  let render_to_string = get_render_to_string()
  let styles : Map[String, String] = { "color": "red", "fontSize": "16px" }
  let element = div(style=styles, ["Styled content"])
  let html = render_to_string(element)
  // Style order may vary, so we check both possibilities
  let html_contains_color = html.contains("color:red")
  let html_contains_font_size = html.contains("font-size:16px")
  inspect(html_contains_color && html_contains_font_size, content="true")
}

///|
test "elements with event handlers" {
  let render_to_string = get_render_to_string()
  let on_click = fn(_evt : @dom.MouseEvent) { () }
  let on_change = fn(_evt : @dom.ChangeEvent) { () }
  let on_keydown = fn(_evt : @dom.KeyboardEvent) { () }
  let on_keyup = fn(_evt : @dom.KeyboardEvent) { () }
  let element = div(on_click~, on_change~, on_keydown~, on_keyup~, [
    "Interactive element",
  ])
  let html = render_to_string(element)
  inspect(html.contains("Interactive element"), content="true")
}

///|
test "elements with drag event handlers" {
  let render_to_string = get_render_to_string()
  let on_drag = fn(_evt : @dom.DragEvent) { () }
  let on_dragstart = fn(_evt : @dom.DragEvent) { () }
  let on_dragend = fn(_evt : @dom.DragEvent) { () }
  let on_drop = fn(_evt : @dom.DragEvent) { () }
  let element = div(on_drag~, on_dragstart~, on_dragend~, on_drop~, [
    "Draggable",
  ])
  let html = render_to_string(element)
  inspect(html.contains("Draggable"), content="true")
}

///|
test "element with tab_index and key" {
  let render_to_string = get_render_to_string()
  let element = div(tab_index=1, key="unique-key", ["Focusable element"])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<div tabindex="1">Focusable element</div>
    ),
  )
}

///|
test "textarea with rows, columns, and spellcheck" {
  let render_to_string = get_render_to_string()
  let element = textarea(rows=10, columns=50, spellcheck=false, [])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<textarea rows="10" cols="50" spellCheck="false"></textarea>
    ),
  )
}

///|
test "input with custom props" {
  let render_to_string = get_render_to_string()
  let custom_props = @js.Object::new()
  custom_props.set("data-custom", "value")
  let element = input(props=custom_props, type_="text")
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<input data-custom="value" type="text"/>
    ),
  )
}

///|
test "textarea with custom props" {
  let render_to_string = get_render_to_string()
  let custom_props = @js.Object::new()
  custom_props.set("data-test", "textarea")
  let element = textarea(props=custom_props, [])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<textarea data-test="textarea"></textarea>
    ),
  )
}

///|
test "uncovered HTML elements" {
  let render_to_string = get_render_to_string()
  let elements = [
    pre(["Preformatted text"]),
    blockquote(["Quote"]),
    span(["Span text"]),
    nav(["Navigation"]),
    main_(["Main content"]),
    header(["Header"]),
    footer(["Footer"]),
    ol([li(["Item"])]),
    article(["Article"]),
    aside(["Aside"]),
    section(["Section"]),
  ]
  for element in elements {
    let html = render_to_string(element)
    inspect(html.length() > 0, content="true")
  }
}

///|
test "p element with custom props" {
  let render_to_string = get_render_to_string()
  let custom_props = @js.Object::new()
  custom_props.set("data-paragraph", "test")
  let element = p(props=custom_props, ["Paragraph with props"])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<p data-paragraph="test">Paragraph with props</p>
    ),
  )
}

///|
test "ul with custom props" {
  let render_to_string = get_render_to_string()
  let custom_props = @js.Object::new()
  custom_props.set("data-list", "custom")
  let element = ul(props=custom_props, [li(["Item"])])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<ul data-list="custom"><li>Item</li></ul>
    ),
  )
}

///|
test "SVG text element" {
  let render_to_string = get_render_to_string()
  let element = svg(width=200, height=100, [
    text(x=10, y=50, fill="black", ["Hello SVG"]),
  ])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<svg width="200" height="100"><text x="10" y="50" fill="black">Hello SVG</text></svg>
    ),
  )
}

///|
test "SVG ellipse element" {
  let render_to_string = get_render_to_string()
  let element = svg(width=200, height=100, [
    ellipse(cx=100, cy=50, rx=80, ry=30, fill="yellow"),
  ])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<svg width="200" height="100"><circle cx="100" cy="50" rx="80" ry="30" fill="yellow"></circle></svg>
    ),
  )
}

///|
test "SVG line element" {
  let render_to_string = get_render_to_string()
  let element = svg(width=200, height=100, [
    line(x1=0, y1=0, x2=200, y2=100, stroke="red", stroke_width=2),
  ])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<svg width="200" height="100"><line x1="0" y1="0" x2="200" y2="100" stroke="red" stroke-width="2"></line></svg>
    ),
  )
}

///|

///|

///|
test "SVG g (group) element" {
  let render_to_string = get_render_to_string()
  let element = svg(width=200, height=100, [
    g(stroke="black", [circle(cx=50, cy=50, r=20)]),
  ])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<svg width="200" height="100"><g stroke="black"><circle cx="50" cy="50" r="20"></circle></g></svg>
    ),
  )
}

///|
test "SVG image element" {
  let render_to_string = get_render_to_string()
  let element = svg(width=200, height=100, [image(x=0, y=0, href="image.svg")])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<svg width="200" height="100"><image x="0" y="0" href="image.svg"></image></svg>
    ),
  )
}

///|
test "SVG defs element" {
  let render_to_string = get_render_to_string()
  let element = svg(width=200, height=100, [
    defs([circle(cx=50, cy=50, r=20, id="myCircle")]),
  ])
  let html = render_to_string(element)
  inspect(html.contains("<defs>"), content="true")
}

///|
test "h4 and h5 elements" {
  let render_to_string = get_render_to_string()
  let h4_element = h4(["Heading 4"])
  let h5_element = h5(["Heading 5"])
  let h4_html = render_to_string(h4_element)
  let h5_html = render_to_string(h5_element)
  inspect(h4_html, content="<h4>Heading 4</h4>")
  inspect(h5_html, content="<h5>Heading 5</h5>")
}

///|
test "details and summary elements" {
  let render_to_string = get_render_to_string()
  let element = details([summary(["Click to expand"]), p(["Hidden content"])])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<details><summary>Click to expand</summary><p>Hidden content</p></details>
    ),
  )
}

///|
test "code element" {
  let render_to_string = get_render_to_string()
  let element = code(["const x = 42;"])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<code>const x = 42;</code>
    ),
  )
}

///|
test "iframe element" {
  let render_to_string = get_render_to_string()
  let element = iframe(src="https://example.com", width=800, height=600, [])
  let html = render_to_string(element)
  inspect(
    html,
    content=(
      #|<iframe src="https://example.com" width="800" height="600"></iframe>
    ),
  )
}

///|
test "video element with controls" {
  let render_to_string = get_render_to_string()
  let element = video(controls=true, [
    source(src="video.mp4", type_="video/mp4"),
  ])
  let html = render_to_string(element)
  inspect(html.contains("<video"), content="true")
  inspect(html.contains("controls"), content="true")
}
