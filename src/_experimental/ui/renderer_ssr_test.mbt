///| SSR Renderer tests

///| Basic rendering tests

///|
test "render empty node" {
  let html = render_to_string(empty())
  inspect(html, content="")
}

///|
test "render text node" {
  let html = render_to_string(text("Hello"))
  inspect(html, content="Hello")
}

///|
test "render text with HTML entities" {
  let html = render_to_string(text("<script>alert('xss')</script>"))
  inspect(html, content="&lt;script&gt;alert(&#39;xss&#39;)&lt;/script&gt;")
}

///|
test "render div with text" {
  let html = render_to_string(div([], [text("content")]))
  inspect(html, content="<div>content</div>")
}

///|
test "render nested elements" {
  let empty_props = []
  let html = render_to_string(
    div(empty_props, [
      h1(empty_props, [text("Title")]),
      p(empty_props, [text("Text")]),
    ]),
  )
  inspect(html, content="<div><h1>Title</h1><p>Text</p></div>")
}

///|
test "render fragment" {
  let html = render_to_string(fragment([text("A"), text("B"), text("C")]))
  inspect(html, content="ABC")
}

///| Props rendering tests

///|
test "render element with className" {
  let html = render_to_string(div([class_name("container")], [text("content")]))
  inspect(html, content="<div class=\"container\">content</div>")
}

///|
test "render element with id" {
  let html = render_to_string(div([id("my-id")], [text("content")]))
  inspect(html, content="<div id=\"my-id\">content</div>")
}

///|
test "render element with multiple attributes" {
  let props = [class_name("btn"), id("submit"), title("Click me")]
  let html = render_to_string(button(props, [text("Submit")]))
  inspect(
    html,
    content="<button class=\"btn\" id=\"submit\" title=\"Click me\">Submit</button>",
  )
}

///|
test "render element with boolean attributes" {
  let props = [disabled(true), checked(false)]
  let html = render_to_string(input(props))
  inspect(html, content="<input disabled>")
}

///|
test "render element with style" {
  let props = [style([("color", "red"), ("font-size", "16px")])]
  let html = render_to_string(div(props, [text("styled")]))
  inspect(
    html,
    content="<div style=\"color: red; font-size: 16px\">styled</div>",
  )
}

///|
test "render skips event handlers" {
  let props = [class_name("btn"), on_click(fn(_event : @core.Any) { () })]
  let html = render_to_string(button(props, [text("Click")]))
  inspect(html, content="<button class=\"btn\">Click</button>")
}

///| Void elements tests

///|
test "render br element" {
  let html = render_to_string(br())
  inspect(html, content="<br>")
}

///|
test "render hr element" {
  let html = render_to_string(hr())
  inspect(html, content="<hr>")
}

///|
test "render img element" {
  let props = [src("/image.png"), alt("Image")]
  let html = render_to_string(img(props))
  inspect(html, content="<img src=\"/image.png\" alt=\"Image\">")
}

///|
test "render input element" {
  let props = [type_("text"), placeholder("Enter text")]
  let html = render_to_string(input(props))
  inspect(html, content="<input type=\"text\" placeholder=\"Enter text\">")
}

///| Complex rendering tests

///|
test "render complex nested structure" {
  let container_props = [class_name("container")]
  let button_props = [class_name("btn")]
  let html = render_to_string(
    div(container_props, [
      h1([], [text("App")]),
      div([], [p([], [text("Welcome")]), button(button_props, [text("Click")])]),
    ]),
  )
  inspect(
    html,
    content="<div class=\"container\"><h1>App</h1><div><p>Welcome</p><button class=\"btn\">Click</button></div></div>",
  )
}

///|
test "render element with escaped attribute values" {
  let props = [title("<script>alert('xss')</script>")]
  let html = render_to_string(div(props, [text("safe")]))
  inspect(
    html,
    content="<div title=\"&lt;script&gt;alert(&#39;xss&#39;)&lt;/script&gt;\">safe</div>",
  )
}

///|
test "render empty fragment" {
  let html = render_to_string(fragment([]))
  inspect(html, content="")
}

///|
test "render fragment with mixed content" {
  let html = render_to_string(
    fragment([text("Before"), div([], [text("Middle")]), text("After")]),
  )
  inspect(html, content="Before<div>Middle</div>After")
}
