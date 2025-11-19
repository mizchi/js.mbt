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
