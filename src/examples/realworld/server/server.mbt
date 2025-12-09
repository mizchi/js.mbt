///|
/// Realworld Example - Server
/// Hono + better-auth + node:sqlite TODO app

///|
type Env = Unit

///|
type ExecutionContext = Unit

///|
type App = @hono.Hono[Env, ExecutionContext]

///|
type Ctx = @hono.Context[Env, ExecutionContext]

///|
using @hono {h, css, style_component}

// ============ Database ============

///|
let create_todos_sql : String =
  #|CREATE TABLE IF NOT EXISTS todos (
  #|  id INTEGER PRIMARY KEY AUTOINCREMENT,
  #|  user_id TEXT NOT NULL,
  #|  title TEXT NOT NULL,
  #|  completed INTEGER DEFAULT 0,
  #|  created_at TEXT DEFAULT CURRENT_TIMESTAMP
  #|)

///|
/// better-auth required tables
let create_user_sql : String =
  #|CREATE TABLE IF NOT EXISTS user (
  #|  id TEXT PRIMARY KEY,
  #|  name TEXT NOT NULL,
  #|  email TEXT NOT NULL UNIQUE,
  #|  emailVerified INTEGER DEFAULT 0,
  #|  image TEXT,
  #|  createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
  #|  updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
  #|)

///|
let create_session_sql : String =
  #|CREATE TABLE IF NOT EXISTS session (
  #|  id TEXT PRIMARY KEY,
  #|  userId TEXT NOT NULL,
  #|  token TEXT NOT NULL UNIQUE,
  #|  expiresAt TEXT NOT NULL,
  #|  ipAddress TEXT,
  #|  userAgent TEXT,
  #|  createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
  #|  updatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
  #|  FOREIGN KEY (userId) REFERENCES user(id) ON DELETE CASCADE
  #|)

///|
let create_account_sql : String =
  #|CREATE TABLE IF NOT EXISTS account (
  #|  id TEXT PRIMARY KEY,
  #|  userId TEXT NOT NULL,
  #|  accountId TEXT NOT NULL,
  #|  providerId TEXT NOT NULL,
  #|  accessToken TEXT,
  #|  refreshToken TEXT,
  #|  accessTokenExpiresAt TEXT,
  #|  refreshTokenExpiresAt TEXT,
  #|  scope TEXT,
  #|  idToken TEXT,
  #|  password TEXT,
  #|  createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
  #|  updatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
  #|  FOREIGN KEY (userId) REFERENCES user(id) ON DELETE CASCADE
  #|)

///|
let create_verification_sql : String =
  #|CREATE TABLE IF NOT EXISTS verification (
  #|  id TEXT PRIMARY KEY,
  #|  identifier TEXT NOT NULL,
  #|  value TEXT NOT NULL,
  #|  expiresAt TEXT NOT NULL,
  #|  createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
  #|  updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
  #|)

///|
/// Initialize the database with tables
pub fn init_db() -> @sqlite.DatabaseSync {
  // Use file-based database to ensure persistence
  let db = @sqlite.DatabaseSync::new("realworld.db")
  // better-auth tables
  db.exec(create_user_sql)
  db.exec(create_session_sql)
  db.exec(create_account_sql)
  db.exec(create_verification_sql)
  // app tables
  db.exec(create_todos_sql)
  db
}

// ============ Zod Schemas ============

///|
fn create_todo_schema() -> @zod.ZodSchema {
  @zod.object({ "title": @zod.string().min(1) })
}

// ============ CSS Styles ============

///|
let html_style : @hono.CssClass = css(
  "margin: 0; padding: 0; font-family: system-ui, sans-serif;",
)

///|
let body_style : @hono.CssClass = css(
  "margin: 0; padding: 0; background: #f5f5f5;",
)

///|
let container_style : @hono.CssClass = css(
  "max-width: 800px; margin: 0 auto; padding: 2rem;",
)

///|
let card_style : @hono.CssClass = css(
  "background: white; border-radius: 8px; padding: 1.5rem; margin-bottom: 1rem; box-shadow: 0 2px 4px rgba(0,0,0,0.1);",
)

///|
let button_style : @hono.CssClass = css(
  "padding: 0.5rem 1rem; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;",
)

///|
let button_danger_style : @hono.CssClass = css(
  "padding: 0.5rem 1rem; background: #dc3545; color: white; border: none; border-radius: 4px; cursor: pointer;",
)

///|
let input_style : @hono.CssClass = css(
  "padding: 0.5rem; border: 1px solid #ddd; border-radius: 4px; margin-right: 0.5rem;",
)

///|
let todo_item_style : @hono.CssClass = css(
  "display: flex; align-items: center; gap: 1rem; padding: 0.5rem 0; border-bottom: 1px solid #eee;",
)

///|
let nav_style : @hono.CssClass = css(
  "background: #333; color: white; padding: 1rem;",
)

///|
let nav_link_style : @hono.CssClass = css(
  "color: white; text-decoration: none; margin-right: 1rem;",
)

// ============ Auth Setup ============

///|
pub fn create_auth(db : @sqlite.DatabaseSync) -> @better_auth.Auth {
  @better_auth.betterAuth(
    database=ffi_sqlite_adapter(db),
    providers=[@better_auth.EmailPassword::{ enabled: true }],
    secret="realworld-secret-key-change-in-production",
  )
}

///|
extern "js" fn ffi_sqlite_adapter(db : @sqlite.DatabaseSync) -> @core.Any =
  #|(db) => db

// ============ Middleware ============

///|
/// Get current user from session using database lookup
async fn get_session_user(
  db : @sqlite.DatabaseSync,
  c : Ctx,
) -> @better_auth.User? {
  // Get session token from cookie
  let cookie = @hono.get_cookie(c, "better-auth.session_token")
  match cookie {
    None => None
    Some(token) => {
      // Find session in database
      let stmt = db.prepare(
        "SELECT s.userId, u.id, u.name, u.email, u.emailVerified, u.image FROM session s JOIN user u ON s.userId = u.id WHERE s.token = ?",
      )
      let results = stmt.all(anonymous_parameters=[token |> @core.any])
      if results.length() > 0 {
        Some(results[0].cast())
      } else {
        None
      }
    }
  }
}

///|
extern "js" fn ffi_get_request_headers(c : Ctx) -> @core.Any =
  #|(c) => c.req.raw.headers

// ============ Layout ============

///|
priv struct LayoutProps {
  title : String
  children : Array[&@hono.HonoNode]
  user : @better_auth.User?
}

///|
fn default_layout(props : LayoutProps) -> @hono.JSXNode {
  h(
    "html",
    [
      h("head", [
        h("title", [props.title]),
        h("meta", [], props={ "charset": @core.any("UTF-8") }),
        style_component(),
      ]),
      h(
        "body",
        [
          h(
            "nav",
            [
              h(
                "div",
                [
                  h("strong", ["Realworld TODO"]),
                  h(
                    "a",
                    ["Home"],
                    props={ "href": @core.any("/") },
                    class=nav_link_style,
                  ),
                  match props.user {
                    Some(user) =>
                      h("span", [
                        h("span", ["Welcome, ", user.email()]),
                        h(
                          "a",
                          [" | Logout"],
                          props={ "href": @core.any("/auth/logout") },
                          class=nav_link_style,
                        ),
                      ])
                    None =>
                      h("span", [
                        h(
                          "a",
                          ["Login"],
                          props={ "href": @core.any("/auth/login") },
                          class=nav_link_style,
                        ),
                        h(
                          "a",
                          ["Register"],
                          props={ "href": @core.any("/auth/register") },
                          class=nav_link_style,
                        ),
                      ])
                  },
                ],
                class=container_style,
              ),
            ],
            class=nav_style,
          ),
          h("main", props.children, class=container_style),
        ],
        class=body_style,
      ),
    ],
    class=html_style,
  )
}

// ============ App ============

///|
pub async fn create_app(
  db : @sqlite.DatabaseSync,
  auth : @better_auth.Auth,
) -> App {
  let app : App = @hono.Hono::new()

  // Mount better-auth routes
  let _ = @hono.mount_auth(app, auth)

  // Home page - TODO list
  app
  .get("/", async fn(c) {
    let user = get_session_user(db, c)
    match user {
      Some(u) => {
        let todos = get_todos(db, u.id())
        let content = default_layout({
          title: "My TODOs",
          user: Some(u),
          children: [
            h(
              "div",
              [
                h("h1", ["My TODOs"]),
                // Add TODO form
                h(
                  "form",
                  [
                    h(
                      "input",
                      [],
                      props={
                        "type": @core.any("text"),
                        "name": @core.any("title"),
                        "placeholder": @core.any("Add a new TODO..."),
                        "required": @core.any(true),
                      },
                      class=input_style,
                    ),
                    h(
                      "button",
                      ["Add"],
                      props={ "type": @core.any("submit") },
                      class=button_style,
                    ),
                  ],
                  props={
                    "method": @core.any("POST"),
                    "action": @core.any("/todos"),
                  },
                ),
              ],
              class=card_style,
            ),
            h(
              "div",
              todos.map(fn(todo) {
                let id : Int = todo._get("id").cast()
                let title : String = todo._get("title").cast()
                let completed : Int = todo._get("completed").cast()
                h(
                  "div",
                  [
                    h("input", [], props={
                      "type": @core.any("checkbox"),
                      "checked": @core.any(completed == 1),
                      "onchange": @core.any("this.form.submit()"),
                      "form": @core.any("toggle-" + id.to_string()),
                    }),
                    h("span", [title], props={
                      "style": @core.any(
                        if completed == 1 {
                          "text-decoration: line-through; color: #888;"
                        } else {
                          ""
                        },
                      ),
                    }),
                    h(
                      "form",
                      [
                        h("input", [], props={
                          "type": @core.any("hidden"),
                          "name": @core.any("completed"),
                          "value": @core.any(
                            if completed == 1 {
                              "false"
                            } else {
                              "true"
                            },
                          ),
                        }),
                      ],
                      props={
                        "id": @core.any("toggle-" + id.to_string()),
                        "method": @core.any("POST"),
                        "action": @core.any(
                          "/todos/" + id.to_string() + "/toggle",
                        ),
                        "style": @core.any("display: none;"),
                      },
                    ),
                    h(
                      "form",
                      [
                        h(
                          "button",
                          ["Delete"],
                          props={ "type": @core.any("submit") },
                          class=button_danger_style,
                        ),
                      ],
                      props={
                        "method": @core.any("POST"),
                        "action": @core.any(
                          "/todos/" + id.to_string() + "/delete",
                        ),
                        "style": @core.any("margin-left: auto;"),
                      },
                    ),
                  ],
                  class=todo_item_style,
                )
              }),
              class=card_style,
            ),
          ],
        })
        c.html_jsx(content)
      }
      None => c.redirect("/auth/login")
    }
  })

  // Create TODO
  .post("/todos", async fn(c) {
    let user = get_session_user(db, c)
    match user {
      Some(u) => {
        let body : @core.Any = ffi_parse_body(c).wait() |> @core.identity()
        let schema = create_todo_schema()
        match schema.safeParse(body) {
          Ok(data) => {
            let title : String = data["title"].cast()
            create_todo(db, u.id(), title)
          }
          Err(_) => ()
        }
        c.redirect("/")
      }
      None => c.redirect("/auth/login")
    }
  })

  // Toggle TODO
  .post("/todos/:id/toggle", async fn(c) {
    let user = get_session_user(db, c)
    match user {
      Some(u) => {
        match c.req.param("id") {
          Some(id) => {
            let body = ffi_parse_body(c).wait()
            let completed : String = body._get("completed").cast()
            toggle_todo(db, u.id(), @strconv.parse_int(id), completed == "true")
          }
          None => ()
        }
        c.redirect("/")
      }
      None => c.redirect("/auth/login")
    }
  })

  // Delete TODO
  .post("/todos/:id/delete", async fn(c) {
    let user = get_session_user(db, c)
    match user {
      Some(u) => {
        match c.req.param("id") {
          Some(id) => delete_todo(db, u.id(), @strconv.parse_int(id))
          None => ()
        }
        c.redirect("/")
      }
      None => c.redirect("/auth/login")
    }
  })

  // Auth pages
  .get("/auth/login", async fn(c) {
    let user = get_session_user(db, c)
    if user is Some(_) {
      return c.redirect("/")
    }
    let content = default_layout({
      title: "Login",
      user: None,
      children: [
        h(
          "div",
          [
            h("h1", ["Login"]),
            h(
              "form",
              [
                h("div", [
                  h("label", ["Email"]),
                  h(
                    "input",
                    [],
                    props={
                      "type": @core.any("email"),
                      "name": @core.any("email"),
                      "required": @core.any(true),
                    },
                    class=input_style,
                  ),
                ]),
                h("div", [
                  h("label", ["Password"]),
                  h(
                    "input",
                    [],
                    props={
                      "type": @core.any("password"),
                      "name": @core.any("password"),
                      "required": @core.any(true),
                    },
                    class=input_style,
                  ),
                ]),
                h(
                  "button",
                  ["Login"],
                  props={ "type": @core.any("submit") },
                  class=button_style,
                ),
              ],
              props={
                "method": @core.any("POST"),
                "action": @core.any("/auth/login"),
              },
            ),
            h("p", [
              "Don't have an account? ",
              h("a", ["Register"], props={ "href": @core.any("/auth/register") }),
            ]),
          ],
          class=card_style,
        ),
      ],
    })
    c.html_jsx(content)
  })
  .post("/auth/login", async fn(c) {
    let body = ffi_parse_body(c).wait()
    let email : String = body._get("email").cast()
    let password : String = body._get("password").cast()
    let response = auth.api().signInEmail(email~, password~)
    if not(response.hasError()) {
      let token = response.token()
      @hono.set_cookie(
        c,
        "better-auth.session_token",
        token,
        path="/",
        httpOnly=true,
        maxAge=86400 * 7,
      )
      c.redirect("/")
    } else {
      let error_msg = response.errorMessage().unwrap_or("Unknown error")
      let content = default_layout({
        title: "Login Error",
        user: None,
        children: [
          h(
            "div",
            [
              h("h1", ["Login Failed"]),
              h("p", [error_msg]),
              h("a", ["Try again"], props={ "href": @core.any("/auth/login") }),
            ],
            class=card_style,
          ),
        ],
      })
      c.html_jsx(content, status=401)
    }
  })
  .get("/auth/register", async fn(c) {
    let user = get_session_user(db, c)
    if user is Some(_) {
      return c.redirect("/")
    }
    let content = default_layout({
      title: "Register",
      user: None,
      children: [
        h(
          "div",
          [
            h("h1", ["Register"]),
            h(
              "form",
              [
                h("div", [
                  h("label", ["Name"]),
                  h(
                    "input",
                    [],
                    props={
                      "type": @core.any("text"),
                      "name": @core.any("name"),
                      "required": @core.any(true),
                    },
                    class=input_style,
                  ),
                ]),
                h("div", [
                  h("label", ["Email"]),
                  h(
                    "input",
                    [],
                    props={
                      "type": @core.any("email"),
                      "name": @core.any("email"),
                      "required": @core.any(true),
                    },
                    class=input_style,
                  ),
                ]),
                h("div", [
                  h("label", ["Password"]),
                  h(
                    "input",
                    [],
                    props={
                      "type": @core.any("password"),
                      "name": @core.any("password"),
                      "required": @core.any(true),
                      "minlength": @core.any(8),
                    },
                    class=input_style,
                  ),
                ]),
                h(
                  "button",
                  ["Register"],
                  props={ "type": @core.any("submit") },
                  class=button_style,
                ),
              ],
              props={
                "method": @core.any("POST"),
                "action": @core.any("/auth/register"),
              },
            ),
            h("p", [
              "Already have an account? ",
              h("a", ["Login"], props={ "href": @core.any("/auth/login") }),
            ]),
          ],
          class=card_style,
        ),
      ],
    })
    c.html_jsx(content)
  })
  .post("/auth/register", async fn(c) {
    let body = ffi_parse_body(c).wait()
    let name : String = body._get("name").cast()
    let email : String = body._get("email").cast()
    let password : String = body._get("password").cast()
    let response = auth.api().signUpEmail(name~, email~, password~)
    if not(response.hasError()) {
      c.redirect("/auth/login")
    } else {
      let error_msg = response.errorMessage().unwrap_or("Unknown error")
      let content = default_layout({
        title: "Register Error",
        user: None,
        children: [
          h(
            "div",
            [
              h("h1", ["Registration Failed"]),
              h("p", [error_msg]),
              h("a", ["Try again"], props={
                "href": @core.any("/auth/register"),
              }),
            ],
            class=card_style,
          ),
        ],
      })
      c.html_jsx(content, status=400)
    }
  })
  .get("/auth/logout", async fn(c) {
    let headers = ffi_get_request_headers(c)
    auth.api().signOut(headers)
    c.redirect("/auth/login")
  })

  // API endpoints for client
  .get("/api/todos", async fn(c) {
    let user = get_session_user(db, c)
    match user {
      Some(u) => {
        let todos = get_todos(db, u.id())
        c.json(todos |> @core.any)
      }
      None => {
        let obj = @core.new_object()
        obj["error"] = "Unauthorized" |> @core.any
        c.json(obj, status=401)
      }
    }
  })
  .post("/api/todos", async fn(c) {
    let user = get_session_user(db, c)
    match user {
      Some(u) => {
        let body : @core.Any = c.req.json() |> @core.identity()
        let schema = create_todo_schema()
        match schema.safeParse(body) {
          Ok(data) => {
            let title : String = data["title"].cast()
            create_todo(db, u.id(), title)
            let obj = @core.new_object()
            obj["success"] = true |> @core.any
            c.json(obj)
          }
          Err(_) => {
            let obj = @core.new_object()
            obj["error"] = "Invalid data" |> @core.any
            c.json(obj, status=400)
          }
        }
      }
      None => {
        let obj = @core.new_object()
        obj["error"] = "Unauthorized" |> @core.any
        c.json(obj, status=401)
      }
    }
  })
  .delete("/api/todos/:id", async fn(c) {
    let user = get_session_user(db, c)
    match user {
      Some(u) =>
        match c.req.param("id") {
          Some(id) => {
            delete_todo(db, u.id(), @strconv.parse_int(id))
            let obj = @core.new_object()
            obj["success"] = true |> @core.any
            c.json(obj)
          }
          None => {
            let obj = @core.new_object()
            obj["error"] = "Invalid id" |> @core.any
            c.json(obj, status=400)
          }
        }
      None => {
        let obj = @core.new_object()
        obj["error"] = "Unauthorized" |> @core.any
        c.json(obj, status=401)
      }
    }
  })
  |> ignore
  app
}

// ============ DB Operations ============

///|
fn get_todos(db : @sqlite.DatabaseSync, user_id : String) -> Array[@core.Any] {
  let stmt = db.prepare(
    "SELECT * FROM todos WHERE user_id = ? ORDER BY created_at DESC",
  )
  stmt.all(anonymous_parameters=[user_id |> @core.any]).map(fn(x) { x.cast() })
}

///|
fn create_todo(
  db : @sqlite.DatabaseSync,
  user_id : String,
  title : String,
) -> Unit {
  let stmt = db.prepare("INSERT INTO todos (user_id, title) VALUES (?, ?)")
  stmt.run(anonymous_parameters=[user_id |> @core.any, title |> @core.any])
  |> ignore
}

///|
fn toggle_todo(
  db : @sqlite.DatabaseSync,
  user_id : String,
  id : Int,
  completed : Bool,
) -> Unit {
  let stmt = db.prepare(
    "UPDATE todos SET completed = ? WHERE id = ? AND user_id = ?",
  )
  stmt.run(anonymous_parameters=[
    if completed {
      1 |> @core.any
    } else {
      0 |> @core.any
    },
    id |> @core.any,
    user_id |> @core.any,
  ])
  |> ignore
}

///|
fn delete_todo(db : @sqlite.DatabaseSync, user_id : String, id : Int) -> Unit {
  let stmt = db.prepare("DELETE FROM todos WHERE id = ? AND user_id = ?")
  stmt.run(anonymous_parameters=[id |> @core.any, user_id |> @core.any])
  |> ignore
}

// ============ FFI ============

///|
extern "js" fn ffi_parse_body(c : Ctx) -> @js.Promise[@core.Any] =
  #|(c) => c.req.parseBody()

///|
pub fn serve(app : App, port : Int) -> Unit {
  ffi_serve(app |> @core.identity, port)
}

///|
extern "js" fn ffi_serve(app : @core.Any, port : Int) -> Unit =
  #|(app, port) => {
  #|  const { serve } = require('@hono/node-server');
  #|  serve({ fetch: app.fetch, port });
  #|  console.log(`Server running at http://localhost:${port}`);
  #|}
