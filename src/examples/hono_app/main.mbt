///|
/// Hono Application Example
/// Demonstrates routing, JSON responses, JSX rendering, CSS styling, and cookie auth

///|
/// c.env for cloudflare bindings
/// e.g: c.env.MY_KV
type Env = Unit

///|
/// c.executionCtx for cloudflare bindings
/// e.g: c.executionCtx.waitUntil()
type ExecutionContext = Unit

///|
type App = @hono.Hono[Env, ExecutionContext]

///|
type Ctx = @hono.Context[Env, ExecutionContext]

///|
using @hono {h, css, style_component, get_cookie, set_cookie, delete_cookie}

// ============ CSS Styles ============

///|
let html_style : @hono.CssClass = css("margin: 0; padding: 0;")

///|
let body_style : @hono.CssClass = css("margin: 0; padding: 0;")

///|
let nav_style : @hono.CssClass = css(
  "display: flex; gap: 1rem; align-items: center; padding: 1rem; background: #333; color: white;",
)

///|
let nav_link_style : @hono.CssClass = css(
  "color: white; text-decoration: none;",
)

///|
let main_style : @hono.CssClass = css(
  "padding: 2rem; max-width: 800px; margin: 0 auto;",
)

///|
let button_style : @hono.CssClass = css(
  "padding: 0.5rem 1rem; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;",
)

///|
let error_style : @hono.CssClass = css(
  "color: red; padding: 1rem; background: #fee; border-radius: 4px;",
)

// ============ Layout ============

///|
/// Layout props
struct LayoutProps {
  title : String
  children : Array[&@hono.HonoNode]
  user : String?
}

///|
/// Default layout component with CSS
fn default_layout(props : LayoutProps) -> @hono.JSXNode {
  h(
    "html",
    [
      h("head", [
        h("title", [props.title]),
        h("meta", [], props={ "charset": @nostd.any("UTF-8") }),
        style_component(),
      ]),
      h(
        "body",
        [
          h("header", [
            h(
              "nav",
              [
                h("strong", ["Hono + MoonBit"]),
                h(
                  "a",
                  ["Home"],
                  props={ "href": @nostd.any("/") },
                  class=nav_link_style,
                ),
                h(
                  "a",
                  ["About"],
                  props={ "href": @nostd.any("/about") },
                  class=nav_link_style,
                ),
                h(
                  "a",
                  ["Auth"],
                  props={ "href": @nostd.any("/auth") },
                  class=nav_link_style,
                ),
                match props.user {
                  Some(name) =>
                    h("span", ["Logged in as: ", h("strong", [name])])
                  None => h("span", ["Not logged in"])
                },
              ],
              class=nav_style,
            ),
          ]),
          h("main", props.children, class=main_style),
        ],
        class=body_style,
      ),
    ],
    class=html_style,
  )
}

// ============ Auth Helpers ============

///|
fn get_current_user(c : Ctx) -> String? {
  get_cookie(c, "user")
}

// ============ App ============

///|
/// Create the Hono application
pub fn create_app() -> App {
  let app : App = @hono.Hono::new()
  // Apply CORS middleware to API routes only
  app.cors("/api/*", origin="*") |> ignore
  // Home page with JSX
  app
  .get("/", fn(c) {
    let user = get_current_user(c)
    let content = default_layout({
      title: "Hono App",
      user,
      children: [
        h("h1", ["Welcome to Hono + MoonBit"]),
        h("p", ["A fast, lightweight web framework with CSS-in-JS"]),
        h("h2", ["Pages"]),
        h("ul", [
          h("li", [h("a", ["About"], props={ "href": @nostd.any("/about") })]),
          h("li", [h("a", ["Auth Demo"], props={ "href": @nostd.any("/auth") })]),
        ]),
        h("h2", ["API Endpoints"]),
        h("ul", [
          h("li", [
            h("a", ["API Hello"], props={ "href": @nostd.any("/api/hello") }),
          ]),
          h("li", [
            h("a", ["Health Check"], props={ "href": @nostd.any("/health") }),
          ]),
        ]),
      ],
    })
    c.html_jsx(content)
  })
  // About page
  .get("/about", fn(c) {
    let user = get_current_user(c)
    let content = default_layout({
      title: "About",
      user,
      children: [
        h("h1", ["About"]),
        h("p", ["This is a Hono application built with MoonBit."]),
        h("p", [
          "Hono is a fast, lightweight web framework. ", "MoonBit is a modern programming language.",
        ]),
      ],
    })
    c.html_jsx(content)
  })
  // Auth page - show login form or logout button
  .get("/auth", fn(c) {
    let user = get_current_user(c)
    let content = default_layout({
      title: "Auth",
      user,
      children: match user {
        Some(name) =>
          [
            h("h1", ["Welcome, ", name, "!"]),
            h("p", ["You are currently logged in."]),
            h(
              "form",
              [
                h(
                  "button",
                  ["Logout"],
                  props={ "type": @nostd.any("submit") },
                  class=button_style,
                ),
              ],
              props={
                "method": @nostd.any("POST"),
                "action": @nostd.any("/auth/logout"),
              },
            ),
          ]
        None =>
          [
            h("h1", ["Login"]),
            h("p", ["Enter your username to login:"]),
            h(
              "form",
              [
                h("input", [], props={
                  "type": @nostd.any("text"),
                  "name": @nostd.any("username"),
                  "placeholder": @nostd.any("Username"),
                  "required": @nostd.any(true),
                }),
                h(
                  "button",
                  ["Login"],
                  props={ "type": @nostd.any("submit") },
                  class=button_style,
                ),
              ],
              props={
                "method": @nostd.any("POST"),
                "action": @nostd.any("/auth/login"),
              },
            ),
          ]
      },
    })
    c.html_jsx(content)
  })
  // Login handler
  .post("/auth/login", async fn(c) {
    let body = ffi_parse_body(c |> @nostd.identity).wait()
    let username : String = body._get("username").cast()
    if username.length() > 0 {
      set_cookie(c, "user", username, path="/", httpOnly=true, maxAge=3600)
      c.redirect("/auth")
    } else {
      let content = default_layout({
        title: "Login Error",
        user: None,
        children: [
          h("div", ["Username is required"], class=error_style),
          h("a", ["Back to login"], props={ "href": @nostd.any("/auth") }),
        ],
      })
      c.html_jsx(content, status=400)
    }
  })
  // Logout handler
  .post("/auth/logout", fn(c) {
    delete_cookie(c, "user", path="/") |> ignore
    c.redirect("/auth")
  })
  // API endpoints
  .get("/api/hello", fn(c) { c.text("Hello from Hono!") })
  .get("/api/me", fn(c) {
    match get_current_user(c) {
      Some(name) => c.text("user: " + name)
      None => c.text("not logged in")
    }
  })
  // Health check
  .get("/health", fn(c) { c.text("OK") })
  // 404 handler
  .notFound(fn(c) {
    let user = get_current_user(c)
    let content = default_layout({
      title: "404 Not Found",
      user,
      children: [
        h("h1", ["404 - Page Not Found"]),
        h("p", ["The page you are looking for does not exist."]),
        h("a", ["Go Home"], props={ "href": @nostd.any("/") }),
      ],
    })
    c.html_jsx(content, status=404)
  })
}

///|
extern "js" fn ffi_parse_body(c : @nostd.Any) -> @js.Promise[@nostd.Any] =
  #|(c) => c.req.parseBody()

///|
/// Serve the Hono app using @hono/node-server
fn serve(app : App, port : Int) -> Unit {
  ffi_serve(app |> @nostd.identity, port)
}

///|
extern "js" fn ffi_serve(app : @nostd.Any, port : Int) -> Unit =
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
