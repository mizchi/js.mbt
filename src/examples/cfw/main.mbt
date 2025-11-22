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
    let url_str = req.url()
    let url = URL::new(url_str)
    let pathname = url.pathname

    // Route handling
    if pathname == "/" {
      Response::html(
        "<h1>Cloudflare Worker with MoonBit</h1><p>Available routes: /api/hello, /api/echo, /api/fetch, /api/json</p>",
        200,
      )
    } else if pathname == "/api/hello" {
      let data = @js.Object::new()
      data.set("message", "Hello from MoonBit Worker!")
      let options = @js.Object::new()
      options.set("status", 200)
      Response::json_(data, options~)
    } else if pathname == "/api/echo" {
      let data = @js.Object::new()
      data.set("url", url_str)
      let options = @js.Object::new()
      options.set("status", 200)
      Response::json_(data, options~)
    } else if pathname == "/api/fetch" {
      // Fetch external API
      let res = fetch(
        "https://jsonplaceholder.typicode.com/todos/1",
        method_="GET",
      ).wait() catch {
        e => {
          log("Error: " + e.to_string())
          let data = @js.Object::new()
          data.set("error", "Failed to fetch")
          let options = @js.Object::new()
          options.set("status", 500)
          return Response::json_(data, options~)
        }
      }
      res
    } else if pathname == "/api/json" {
      let data = @js.Object::new()
      data.set("status", "ok")
      let inner_data = @js.Object::new()
      inner_data.set("foo", "bar")
      inner_data.set("num", 42)
      data.set("data", inner_data)
      data.set("timestamp", 1234567890)
      let options = @js.Object::new()
      options.set("status", 200)
      Response::json_(data, options~)
    } else if pathname == "/api/redirect" {
      Response::redirect("/", status=302)
    } else if pathname == "/api/headers" {
      let headers = @js.Object::new()
      headers.set("Content-Type", "application/json")
      headers.set("x-custom-header", "MoonBit-Worker")
      headers.set("x-powered-by", "Cloudflare")
      let data = @js.Object::new()
      data.set("message", "Check the headers")
      let options = @js.Object::new()
      options.set("status", 200)
      options.set("headers", headers)
      Response::json_(data, options~)
    } else if pathname == "/api/status/404" {
      let data = @js.Object::new()
      data.set("error", "Not Found")
      let options = @js.Object::new()
      options.set("status", 404)
      Response::json_(data, options~)
    } else if pathname == "/api/status/500" {
      let data = @js.Object::new()
      data.set("error", "Internal Server Error")
      let options = @js.Object::new()
      options.set("status", 500)
      Response::json_(data, options~)
    } else if pathname == "/api/text" {
      Response::text_("Plain text response from MoonBit", 200)
    } else if pathname == "/api/query" {
      // Parse query parameters
      let params = url.searchParams()
      let name = match params.get("name") {
        Some(n) => n
        None => "World"
      }
      let message = match params.get("message") {
        Some(m) => m
        None => "Hello"
      }
      let data = @js.Object::new()
      data.set("greeting", message + ", " + name + "!")
      let options = @js.Object::new()
      options.set("status", 200)
      Response::json_(data, options~)
    } else if pathname == "/api/time" {
      let data = @js.Object::new()
      data.set("timestamp", 1234567890)
      let options = @js.Object::new()
      options.set("status", 200)
      Response::json_(data, options~)
    } else if pathname == "/api/user-agent" {
      let data = @js.Object::new()
      data.set("userAgent", "unknown")
      let options = @js.Object::new()
      options.set("status", 200)
      Response::json_(data, options~)
    } else if pathname == "/api/method" {
      let data = @js.Object::new()
      data.set("method", "unknown")
      let options = @js.Object::new()
      options.set("status", 200)
      Response::json_(data, options~)
    } else if pathname == "/health" {
      let data = @js.Object::new()
      data.set("status", "healthy")
      data.set("service", "moonbit-worker")
      let options = @js.Object::new()
      options.set("status", 200)
      Response::json_(data, options~)
    } else if pathname == "/api/math/add" {
      let params = url.searchParams()
      let a_str = params.get("a")
      let b_str = params.get("b")
      match (a_str, b_str) {
        (Some(a), Some(b)) => {
          let data = @js.Object::new()
          data.set("result", a + "+" + b)
          let options = @js.Object::new()
          options.set("status", 200)
          Response::json_(data, options~)
        }
        _ => {
          let data = @js.Object::new()
          data.set("error", "Missing parameters a or b")
          let options = @js.Object::new()
          options.set("status", 400)
          Response::json_(data, options~)
        }
      }
    } else {
      let data = @js.Object::new()
      data.set("error", "Route not found")
      let options = @js.Object::new()
      options.set("status", 404)
      Response::json_(data, options~)
    }
  }
  promisify3(async_handler)
}
