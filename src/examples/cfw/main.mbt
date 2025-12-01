///|
using @js {log, promisify3}

///|
using @http {type Response, fetch}

///|
using @url {type URL}

///|
pub fn get_fetch_handler() -> @cloudflare.CloudflareFetchHandler {
  let async_handler = async fn(
    req : @cloudflare.CloudflareRequest,
    _env : @cloudflare.CloudflareEnv,
    _ctx : @cloudflare.CloudflareContext,
  ) -> Response {
    let url_str = req.url
    let url = URL::new(url_str)
    let pathname = url.pathname

    // Route handling
    if pathname == "/" {
      Response::html(
        "<h1>Cloudflare Worker with MoonBit</h1><p>Available routes: /api/hello, /api/echo, /api/fetch, /api/json</p>",
        200,
      )
    } else if pathname == "/api/hello" {
      let data = @nostd.Object::new()
      data["message"] = "Hello from MoonBit Worker!"
      let options = @nostd.Object::new()
      options["status"] = 200
      Response::json_(data, options~)
    } else if pathname == "/api/echo" {
      let data = @nostd.Object::new()
      data["url"] = url_str
      let options = @nostd.Object::new()
      options["status"] = 200
      Response::json_(data, options~)
    } else if pathname == "/api/fetch" {
      // Fetch external API
      let res = fetch(
        "https://jsonplaceholder.typicode.com/todos/1",
        method_="GET",
      ) catch {
        e => {
          log("Error: " + e.to_string())
          let data = @nostd.Object::new()
          data["error"] = "Failed to fetch"
          let options = @nostd.Object::new()
          options["status"] = 500
          return Response::json_(data, options~)
        }
      }
      res
    } else if pathname == "/api/json" {
      let data = @nostd.Object::new()
      data["status"] = "ok"
      let inner_data = @nostd.Object::new()
      inner_data["foo"] = "bar"
      inner_data["num"] = 42
      data["data"] = inner_data
      data["timestamp"] = 1234567890
      let options = @nostd.Object::new()
      options["status"] = 200
      Response::json_(data, options~)
    } else if pathname == "/api/redirect" {
      Response::redirect("/", status=302)
    } else if pathname == "/api/headers" {
      let headers = @nostd.Object::new()
      headers["Content-Type"] = "application/json"
      headers["x-custom-header"] = "MoonBit-Worker"
      headers["x-powered-by"] = "Cloudflare"
      let data = @nostd.Object::new()
      data["message"] = "Check the headers"
      let options = @nostd.Object::new()
      options["status"] = 200
      options["headers"] = headers
      Response::json_(data, options~)
    } else if pathname == "/api/status/404" {
      let data = @nostd.Object::new()
      data["error"] = "Not Found"
      let options = @nostd.Object::new()
      options["status"] = 404
      Response::json_(data, options~)
    } else if pathname == "/api/status/500" {
      let data = @nostd.Object::new()
      data["error"] = "Internal Server Error"
      let options = @nostd.Object::new()
      options["status"] = 500
      Response::json_(data, options~)
    } else if pathname == "/api/text" {
      Response::text_("Plain text response from MoonBit", 200)
    } else if pathname == "/api/query" {
      // Parse query parameters
      let params = url.searchParams()
      let name = match params._get("name") {
        Some(n) => n
        None => "World"
      }
      let message = match params._get("message") {
        Some(m) => m
        None => "Hello"
      }
      let data = @nostd.Object::new()
      data["greeting"] = message + ", " + name + "!"
      let options = @nostd.Object::new()
      options["status"] = 200
      Response::json_(data, options~)
    } else if pathname == "/api/time" {
      let data = @nostd.Object::new()
      data["timestamp"] = 1234567890
      let options = @nostd.Object::new()
      options["status"] = 200
      Response::json_(data, options~)
    } else if pathname == "/api/user-agent" {
      let data = @nostd.Object::new()
      data["userAgent"] = "unknown"
      let options = @nostd.Object::new()
      options["status"] = 200
      Response::json_(data, options~)
    } else if pathname == "/api/method" {
      let data = @nostd.Object::new()
      data["method"] = "unknown"
      let options = @nostd.Object::new()
      options["status"] = 200
      Response::json_(data, options~)
    } else if pathname == "/health" {
      let data = @nostd.Object::new()
      data["status"] = "healthy"
      data["service"] = "moonbit-worker"
      let options = @nostd.Object::new()
      options["status"] = 200
      Response::json_(data, options~)
    } else if pathname == "/api/math/add" {
      let params = url.searchParams()
      let a_str = params._get("a")
      let b_str = params._get("b")
      match (a_str, b_str) {
        (Some(a), Some(b)) => {
          let data = @nostd.Object::new()
          data["result"] = a + "+" + b
          let options = @nostd.Object::new()
          options["status"] = 200
          Response::json_(data, options~)
        }
        _ => {
          let data = @nostd.Object::new()
          data["error"] = "Missing parameters a or b"
          let options = @nostd.Object::new()
          options["status"] = 400
          Response::json_(data, options~)
        }
      }
    } else {
      let data = @nostd.Object::new()
      data["error"] = "Route not found"
      let options = @nostd.Object::new()
      options["status"] = 404
      Response::json_(data, options~)
    }
  }
  promisify3(async_handler)
}
