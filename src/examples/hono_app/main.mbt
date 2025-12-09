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
using @hono {h, get_cookie, set_cookie, delete_cookie}

// ============ CSS Styles ============

///|
struct Styles {
  html : @hono.CssClass
  body : @hono.CssClass
  nav : @hono.CssClass
  nav_link : @hono.CssClass
  main : @hono.CssClass
  button : @hono.CssClass
  error : @hono.CssClass
}

///|
fn create_styles(hono_css : @hono.HonoCss) -> Styles {
  {
    html: hono_css.css("margin: 0; padding: 0;"),
    body: hono_css.css("margin: 0; padding: 0;"),
    nav: hono_css.css(
      "display: flex; gap: 1rem; align-items: center; padding: 1rem; background: #333; color: white;",
    ),
    nav_link: hono_css.css("color: white; text-decoration: none;"),
    main: hono_css.css("padding: 2rem; max-width: 800px; margin: 0 auto;"),
    button: hono_css.css(
      "padding: 0.5rem 1rem; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;",
    ),
    error: hono_css.css(
      "color: red; padding: 1rem; background: #fee; border-radius: 4px;",
    ),
  }
}

// ============ Layout ============

///|
/// Layout props
struct LayoutProps {
  title : String
  children : Array[&@hono.HonoNode]
  user : String?
  styles : Styles
  hono_css : @hono.HonoCss
}

///|
/// Default layout component with CSS
fn default_layout(props : LayoutProps) -> @hono.JSXNode {
  h(
    "html",
    [
      h("head", [
        h("title", [props.title]),
        h("meta", [], props={ "charset": @core.any("UTF-8") }),
        props.hono_css.style_component(),
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
                  props={ "href": @core.any("/") },
                  class=props.styles.nav_link,
                ),
                h(
                  "a",
                  ["About"],
                  props={ "href": @core.any("/about") },
                  class=props.styles.nav_link,
                ),
                h(
                  "a",
                  ["Auth"],
                  props={ "href": @core.any("/auth") },
                  class=props.styles.nav_link,
                ),
                match props.user {
                  Some(name) =>
                    h("span", ["Logged in as: ", h("strong", [name])])
                  None => h("span", ["Not logged in"])
                },
              ],
              class=props.styles.nav,
            ),
          ]),
          h("main", props.children, class=props.styles.main),
        ],
        class=props.styles.body,
      ),
    ],
    class=props.styles.html,
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
pub async fn create_app() -> App {
  // Initialize JSX runtime for ESM compatibility (required for legacy jsx/fragment API)
  @hono.init_jsx_runtime()
  let hono_css = @hono.import_hono_css()
  let styles = create_styles(hono_css)
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
      styles,
      hono_css,
      children: [
        h("h1", ["Welcome to Hono + MoonBit"]),
        h("p", ["A fast, lightweight web framework with CSS-in-JS"]),
        h("h2", ["Pages"]),
        h("ul", [
          h("li", [h("a", ["About"], props={ "href": @core.any("/about") })]),
          h("li", [h("a", ["Auth Demo"], props={ "href": @core.any("/auth") })]),
        ]),
        h("h2", ["API Endpoints"]),
        h("ul", [
          h("li", [
            h("a", ["API Hello"], props={ "href": @core.any("/api/hello") }),
          ]),
          h("li", [
            h("a", ["Health Check"], props={ "href": @core.any("/health") }),
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
      styles,
      hono_css,
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
      styles,
      hono_css,
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
                  props={ "type": @core.any("submit") },
                  class=styles.button,
                ),
              ],
              props={
                "method": @core.any("POST"),
                "action": @core.any("/auth/logout"),
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
                  "type": @core.any("text"),
                  "name": @core.any("username"),
                  "placeholder": @core.any("Username"),
                  "required": @core.any(true),
                }),
                h(
                  "button",
                  ["Login"],
                  props={ "type": @core.any("submit") },
                  class=styles.button,
                ),
              ],
              props={
                "method": @core.any("POST"),
                "action": @core.any("/auth/login"),
              },
            ),
          ]
      },
    })
    c.html_jsx(content)
  })
  // Login handler
  .post("/auth/login", async fn(c) {
    let body = ffi_parse_body(c |> @core.identity).wait()
    let username : String = body._get("username").cast()
    if username.length() > 0 {
      set_cookie(c, "user", username, path="/", httpOnly=true, maxAge=3600)
      c.redirect("/auth")
    } else {
      let content = default_layout({
        title: "Login Error",
        user: None,
        styles,
        hono_css,
        children: [
          h("div", ["Username is required"], class=styles.error),
          h("a", ["Back to login"], props={ "href": @core.any("/auth") }),
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
      styles,
      hono_css,
      children: [
        h("h1", ["404 - Page Not Found"]),
        h("p", ["The page you are looking for does not exist."]),
        h("a", ["Go Home"], props={ "href": @core.any("/") }),
      ],
    })
    c.html_jsx(content, status=404)
  })
}

///|
extern "js" fn ffi_parse_body(c : @core.Any) -> @js.Promise[@core.Any] =
  #|(c) => c.req.parseBody()

///|
/// Serve the Hono app using @hono/node-server
async fn serve(app : App, port : Int) -> Unit {
  ffi_serve(app |> @core.identity, port).wait()
}

///|
extern "js" fn ffi_serve(app : @core.Any, port : Int) -> @js.Promise[Unit] =
  #|(app, port) => import('@hono/node-server').then(({ serve }) => {
  #|  serve({ fetch: app.fetch, port });
  #|  console.log(`Server running at http://localhost:${port}`);
  #|})

///|
async fn main {
  let app = create_app()
  let port = 3000
  println("Starting Hono server on port " + port.to_string() + "...")
  serve(app, port)
}
