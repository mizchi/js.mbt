///|
fn setup() -> () -> Unit {
  @global_jsdom.register()
  @vue.init_vue_api(@node.require("vue"))
  @vue.init_vue_ssr(@node.require("@vue/server-renderer"))
  fn() { @testing_library_vue.cleanup() }
}

///|
async test "SSR: renderToString basic div" {
  let _ = setup()
  let vnode = @vue.h("div", ["Hello World"])
  let html = @vue.renderToString(vnode)
  inspect(html, content="<div>Hello World</div>")
}

///|
async test "SSR: renderToString nested elements" {
  let _ = setup()
  let vnode = @vue.h("div", [
    @vue.h("span", ["Nested"]),
    @vue.h("p", ["Content"]),
  ])
  let html = @vue.renderToString(vnode)
  inspect(html, content="<div><span>Nested</span><p>Content</p></div>")
}

///|
async test "SSR: renderToString with props" {
  let _ = setup()
  let vnode = @vue.h("div", ["Test"], props={ "class": @core.any("my-class") })
  let html = @vue.renderToString(vnode)
  inspect(html, content="<div class=\"my-class\">Test</div>")
}

///|
async test "SSR: renderToString with style" {
  let _ = setup()
  let vnode = @vue.h("span", ["Styled"], style={
    "color": "red",
    "fontSize": "14px",
  })
  let html = @vue.renderToString(vnode)
  inspect(
    html,
    content="<span style=\"color:red;font-size:14px;\">Styled</span>",
  )
}

///|
async test "SSR: renderToString button element" {
  let _ = setup()
  let vnode = @vue.h("button", ["Click me"])
  let html = @vue.renderToString(vnode)
  inspect(html, content="<button>Click me</button>")
}

///|
async test "SSR: renderToString input element" {
  let _ = setup()
  let vnode = @vue.h("input", [], props={
    "type": @core.any("text"),
    "placeholder": @core.any("Enter name"),
  })
  let html = @vue.renderToString(vnode)
  inspect(html, content="<input type=\"text\" placeholder=\"Enter name\">")
}

///|
async test "SSR: renderToString with data-testid" {
  let _ = setup()
  let vnode = @vue.h("div", ["Test Element"], props={
    "data-testid": @core.any("my-element"),
  })
  let html = @vue.renderToString(vnode)
  inspect(html, content="<div data-testid=\"my-element\">Test Element</div>")
}

///|
async test "SSR: renderToString fragment" {
  let _ = setup()
  let vnode = @vue.fragment([@vue.h("span", ["A"]), @vue.h("span", ["B"])])
  let html = @vue.renderToString(vnode)
  inspect(html, content="<!--[--><span>A</span><span>B</span><!--]-->")
}

///|
async test "SSR: renderToString list items" {
  let _ = setup()
  let items = ["One", "Two", "Three"]
  let list_items : Array[&@vue.VueNode] = items.map(fn(item) {
    @vue.h("li", [item])
  })
  let vnode = @vue.h("ul", list_items)
  let html = @vue.renderToString(vnode)
  inspect(html, content="<ul><li>One</li><li>Two</li><li>Three</li></ul>")
}

///|
async test "SSR: renderToString with key" {
  let _ = setup()
  let vnode = @vue.h("div", ["Keyed"], key="unique-key")
  let html = @vue.renderToString(vnode)
  inspect(html, content="<div>Keyed</div>")
}

///|
async test "SSR: renderToString anchor tag" {
  let _ = setup()
  let vnode = @vue.h("a", ["Link"], props={
    "href": @core.any("https://example.com"),
  })
  let html = @vue.renderToString(vnode)
  inspect(html, content="<a href=\"https://example.com\">Link</a>")
}

///|
async test "SSR: renderToString image element" {
  let _ = setup()
  let vnode = @vue.h("img", [], props={
    "src": @core.any("image.png"),
    "alt": @core.any("An image"),
  })
  let html = @vue.renderToString(vnode)
  inspect(html, content="<img src=\"image.png\" alt=\"An image\">")
}

///|
async test "SSR: renderToString form structure" {
  let _ = setup()
  let vnode = @vue.h("form", [
    @vue.h("label", ["Name"], props={ "for": @core.any("name-input") }),
    @vue.h("input", [], props={
      "id": @core.any("name-input"),
      "type": @core.any("text"),
    }),
    @vue.h("button", ["Submit"], props={ "type": @core.any("submit") }),
  ])
  let html = @vue.renderToString(vnode)
  inspect(
    html,
    content="<form><label for=\"name-input\">Name</label><input id=\"name-input\" type=\"text\"><button type=\"submit\">Submit</button></form>",
  )
}

///|
async test "SSR: renderToString table structure" {
  let _ = setup()
  let vnode = @vue.h("table", [
    @vue.h("thead", [
      @vue.h("tr", [@vue.h("th", ["Header 1"]), @vue.h("th", ["Header 2"])]),
    ]),
    @vue.h("tbody", [
      @vue.h("tr", [@vue.h("td", ["Cell 1"]), @vue.h("td", ["Cell 2"])]),
    ]),
  ])
  let html = @vue.renderToString(vnode)
  inspect(
    html,
    content="<table><thead><tr><th>Header 1</th><th>Header 2</th></tr></thead><tbody><tr><td>Cell 1</td><td>Cell 2</td></tr></tbody></table>",
  )
}

///|
async test "SSR: renderToString with disabled attribute" {
  let _ = setup()
  let vnode = @vue.h("button", ["Disabled Button"], props={
    "disabled": @core.any(true),
  })
  let html = @vue.renderToString(vnode)
  inspect(html, content="<button disabled>Disabled Button</button>")
}

///|
async test "SSR: renderToString checkbox" {
  let _ = setup()
  let vnode = @vue.h("input", [], props={
    "type": @core.any("checkbox"),
    "checked": @core.any(true),
  })
  let html = @vue.renderToString(vnode)
  inspect(html, content="<input type=\"checkbox\" checked>")
}

///|
async test "SSR: renderToString select with options" {
  let _ = setup()
  let vnode = @vue.h("select", [
    @vue.h("option", ["Option A"], props={ "value": @core.any("a") }),
    @vue.h("option", ["Option B"], props={ "value": @core.any("b") }),
  ])
  let html = @vue.renderToString(vnode)
  inspect(
    html,
    content="<select><option value=\"a\">Option A</option><option value=\"b\">Option B</option></select>",
  )
}

///|
async test "SSR: renderToString empty div" {
  let _ = setup()
  let vnode = @vue.h("div", [])
  let html = @vue.renderToString(vnode)
  inspect(html, content="<div></div>")
}

///|
async test "SSR: renderToString mixed text and elements" {
  let _ = setup()
  let vnode = @vue.h("p", [
    "Text before ",
    @vue.h("strong", ["bold"]),
    " text after",
  ])
  let html = @vue.renderToString(vnode)
  inspect(html, content="<p>Text before <strong>bold</strong> text after</p>")
}

///|
async test "SSR: renderToString with numeric content" {
  let _ = setup()
  let vnode = @vue.h("span", [42])
  let html = @vue.renderToString(vnode)
  inspect(html, content="<span>42</span>")
}
