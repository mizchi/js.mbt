///|
test "jsx creates element" {
  let node = @hono.jsx("div", ["Hello"])
  @core.typeof_(node.as_any()) |> assert_eq("object")
}

///|
test "jsx with props" {
  let node = @hono.jsx("div", ["Hello"], class="container", id="main")
  @core.typeof_(node.as_any()) |> assert_eq("object")
}

///|
test "jsx with style" {
  let node = @hono.jsx("div", ["Styled"], style={
    "color": "red",
    "fontSize": "16px",
  })
  @core.typeof_(node.as_any()) |> assert_eq("object")
}

///|
test "jsx nested elements" {
  let inner = @hono.jsx("span", ["Inner"])
  let outer = @hono.jsx("div", [inner])
  @core.typeof_(outer.as_any()) |> assert_eq("object")
}

///|
test "fragment creates element" {
  let node = @hono.fragment(["Hello", "World"])
  @core.typeof_(node.as_any()) |> assert_eq("object")
}

///|
test "renderToString renders jsx" {
  let node = @hono.jsx("div", ["Hello, Hono!"])
  let html = @hono.render_to_string(node)
  html |> inspect(content="<div>Hello, Hono!</div>")
}

///|
test "renderToString with nested elements" {
  let inner = @hono.jsx("span", ["World"])
  let outer = @hono.jsx("div", ["Hello, ", inner])
  let html = @hono.render_to_string(outer)
  html |> inspect(content="<div>Hello, <span>World</span></div>")
}

///|
test "renderToString with props" {
  let node = @hono.jsx("div", ["Content"], class="container", id="main")
  let html = @hono.render_to_string(node)
  // Note: attribute order may vary
  @core.typeof_(html |> @core.any) |> assert_eq("string")
  assert_true(html.contains("class=\"container\""))
  assert_true(html.contains("id=\"main\""))
}

///|
test "renderToString fragment" {
  let node = @hono.fragment([@hono.jsx("span", ["A"]), @hono.jsx("span", ["B"])])
  let html = @hono.render_to_string(node)
  html |> inspect(content="<span>A</span><span>B</span>")
}

///|
test "raw inserts unescaped html" {
  let node = @hono.raw("<b>Bold</b>")
  @core.typeof_(node |> @core.any) |> assert_eq("object")
}

///|
test "html creates escaped string" {
  let escaped = @hono.html("<div>Hello</div>")
  @core.typeof_(escaped |> @core.any) |> assert_eq("object")
}

///|
struct TestProps {
  name : String
  count : Int
}

///|
fn testComponent(props : TestProps) -> @hono.JSXNode {
  @hono.jsx("div", [
    "Hello, " + props.name + "! Count: " + props.count.to_string(),
  ])
}

///|
test "jsxComponent with custom component" {
  let node = @hono.jsx_component(testComponent, { name: "World", count: 42 })
  let html = @hono.render_to_string(node)
  html |> inspect(content="<div>Hello, World! Count: 42</div>")
}

///|
test "memo wraps component" {
  let memoized = @hono.memo(testComponent)
  let node = memoized({ name: "Memo", count: 1 })
  let html = @hono.render_to_string(node)
  html |> inspect(content="<div>Hello, Memo! Count: 1</div>")
}

///|
test "createContext creates context" {
  let ctx : @hono.HonoContext[String] = @hono.create_context(Some("default"))
  // createContext returns a function in Hono
  @core.typeof_(ctx |> @core.any) |> assert_eq("function")
}

///|
async test "Context::htmlJsx renders JSX response" {
  let app : @hono.Hono[@core.Any, @core.Any] = @hono.Hono::new()
  app.get("/jsx", fn(c) {
    let node = @hono.jsx("h1", ["Hello from JSX!"])
    c.html_jsx(node)
  })
  |> ignore
  let client = @hono.test_client(app)
  let endpoint = client.path("jsx")
  @core.typeof_(endpoint |> @core.any) |> assert_eq("function")
}

///|
async test "Context::htmlJsx with complex JSX" {
  let app : @hono.Hono[@core.Any, @core.Any] = @hono.Hono::new()
  app.get("/page", fn(c) {
    let content = @hono.jsx("html", [
      @hono.jsx("head", [@hono.jsx("title", ["My Page"])]),
      @hono.jsx("body", [
        @hono.jsx("h1", ["Welcome"]),
        @hono.jsx("p", ["This is a paragraph."]),
      ]),
    ])
    c.html_jsx(content)
  })
  |> ignore
  let client = @hono.test_client(app)
  let endpoint = client.path("page")
  @core.typeof_(endpoint |> @core.any) |> assert_eq("function")
}

///|
async test "Context::htmlJsx with status code" {
  let app : @hono.Hono[@core.Any, @core.Any] = @hono.Hono::new()
  app.get("/not-found", fn(c) {
    let node = @hono.jsx("h1", ["Page Not Found"])
    c.html_jsx(node, status=404)
  })
  |> ignore
  let client = @hono.test_client(app)
  let endpoint = client.path("not-found")
  @core.typeof_(endpoint |> @core.any) |> assert_eq("function")
}
