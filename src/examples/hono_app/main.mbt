///|
/// Hono Application Example
/// Demonstrates routing, JSON responses, and JSX rendering

///|
/// Alias for @hono.jsx
fn h(
  tag : String,
  children : Array[&@hono.HonoNode],
  props? : Map[String, @js.Any],
  style? : Map[String, String],
  class? : String,
  id? : String,
  key? : String,
) -> @hono.JSXNode {
  @hono.jsx(tag, children, props?, style?, class?, id?, key?)
}

///|
/// Layout props
struct LayoutProps {
  title : String
  children : Array[&@hono.HonoNode]
}

///|
/// Default layout component
fn default_layout(props : LayoutProps) -> @hono.JSXNode {
  h("html", [
    h("head", [
      h("title", [props.title]),
      h("meta", [], props={ "charset": @js.any("UTF-8") }),
    ]),
    h("body", [
      h("header", [
        h("nav", [
          h("strong", ["Hono + MoonBit"]),
          " | ",
          h("a", ["Home"], props={ "href": @js.any("/") }),
          " | ",
          h("a", ["About"], props={ "href": @js.any("/about") }),
        ]),
      ]),
      h("main", props.children),
    ]),
  ])
}

///|
/// Create the Hono application
pub fn create_app() -> @hono.Hono[Unit, Unit] {
  let app : @hono.Hono[Unit, Unit] = @hono.Hono::new()
  // Home page with JSX
  app
  .get("/", fn(c) {
    let content = default_layout({
      title: "Hono App",
      children: [
        h("h1", ["Welcome to Hono + MoonBit"]),
        h("p", ["A fast, lightweight web framework"]),
        h("h2", ["API Endpoints"]),
        h("ul", [
          h("li", [
            h("a", ["API Hello"], props={ "href": @js.any("/api/hello") }),
          ]),
          h("li", [
            h("a", ["Health Check"], props={ "href": @js.any("/health") }),
          ]),
        ]),
      ],
    })
    c.html_jsx(content)
  })
  // About page with JSX
  .get("/about", fn(c) {
    let content = default_layout({
      title: "About",
      children: [
        h("h1", ["About"]),
        h("p", ["This is a Hono application built with MoonBit."]),
        h("p", [
          "Hono is a fast, lightweight web framework. ",
          "MoonBit is a modern programming language.",
        ]),
      ],
    })
    c.html_jsx(content)
  })
  .get("/api/hello", fn(c) { c.text("Hello from Hono!") })
  // Health check
  .get("/health", fn(c) { c.text("OK") })
  // 404 handler
  .notFound(fn(c) {
    let content = default_layout({
      title: "404 Not Found",
      children: [
        h("h1", ["404 - Page Not Found"]),
        h("p", ["The page you are looking for does not exist."]),
        h("a", ["Go Home"], props={ "href": @js.any("/") }),
      ],
    })
    c.html_jsx(content, status=404)
  })
}

///|
/// Serve the Hono app using @hono/node-server
fn serve(app : @hono.Hono[Unit, Unit], port : Int) -> Unit {
  ffi_serve(app |> @js.identity, port)
}

///|
extern "js" fn ffi_serve(app : @js.Any, port : Int) -> Unit =
  #|(app, port) => {
  #|  const { serve } = require('@hono/node-server');
  #|  serve({ fetch: app.fetch, port });
  #|  console.log(`Server running at http://localhost:${port}`);
  #|}

///|
fn main {
  let app = create_app()
  let port = 3000
  println("Starting Hono server on port " + port.to_string() + "...")
  serve(app, port)
}
