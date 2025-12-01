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
      data["message"] = "Hello from MoonBit Worker!" |> @nostd.any
      let options = @nostd.Object::new()
      options["status"] = 200 |> @nostd.any
      Response::json_(data, options~)
    } else if pathname == "/api/echo" {
      let data = @nostd.Object::new()
      data["url"] = url_str |> @nostd.any
      let options = @nostd.Object::new()
      options["status"] = 200 |> @nostd.any
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
          data["error"] = "Failed to fetch" |> @nostd.any
          let options = @nostd.Object::new()
          options["status"] = 500 |> @nostd.any
          return Response::json_(data, options~)
        }
      }
      res
    } else if pathname == "/api/json" {
      let data = @nostd.Object::new()
      data["status"] = "ok" |> @nostd.any
      let inner_data = @nostd.Object::new()
      inner_data["foo"] = "bar" |> @nostd.any
      inner_data["num"] = 42 |> @nostd.any
      data["data"] = inner_data
      data["timestamp"] = 1234567890 |> @nostd.any
      let options = @nostd.Object::new()
      options["status"] = 200 |> @nostd.any
      Response::json_(data, options~)
    } else if pathname == "/api/redirect" {
      Response::redirect("/", status=302)
    } else if pathname == "/api/headers" {
      let headers = @nostd.Object::new()
      headers["Content-Type"] = "application/json" |> @nostd.any
      headers["x-custom-header"] = "MoonBit-Worker" |> @nostd.any
      headers["x-powered-by"] = "Cloudflare" |> @nostd.any
      let data = @nostd.Object::new()
      data["message"] = "Check the headers" |> @nostd.any
      let options = @nostd.Object::new()
      options["status"] = 200 |> @nostd.any
      options["headers"] = headers
      Response::json_(data, options~)
    } else if pathname == "/api/status/404" {
      let data = @nostd.Object::new()
      data["error"] = "Not Found" |> @nostd.any
      let options = @nostd.Object::new()
      options["status"] = 404 |> @nostd.any
      Response::json_(data, options~)
    } else if pathname == "/api/status/500" {
      let data = @nostd.Object::new()
      data["error"] = "Internal Server Error" |> @nostd.any
      let options = @nostd.Object::new()
      options["status"] = 500 |> @nostd.any
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
      let data = @nostd.Object::new()
      data["greeting"] = (message + ", " + name + "!") |> @nostd.any
      let options = @nostd.Object::new()
      options["status"] = 200 |> @nostd.any
      Response::json_(data, options~)
    } else if pathname == "/api/time" {
      let data = @nostd.Object::new()
      data["timestamp"] = 1234567890 |> @nostd.any
      let options = @nostd.Object::new()
      options["status"] = 200 |> @nostd.any
      Response::json_(data, options~)
    } else if pathname == "/api/user-agent" {
      let data = @nostd.Object::new()
      data["userAgent"] = "unknown" |> @nostd.any
      let options = @nostd.Object::new()
      options["status"] = 200 |> @nostd.any
      Response::json_(data, options~)
    } else if pathname == "/api/method" {
      let data = @nostd.Object::new()
      data["method"] = "unknown" |> @nostd.any
      let options = @nostd.Object::new()
      options["status"] = 200 |> @nostd.any
      Response::json_(data, options~)
    } else if pathname == "/health" {
      let data = @nostd.Object::new()
      data["status"] = "healthy" |> @nostd.any
      data["service"] = "moonbit-worker" |> @nostd.any
      let options = @nostd.Object::new()
      options["status"] = 200 |> @nostd.any
      Response::json_(data, options~)
    } else if pathname == "/api/math/add" {
      let params = url.searchParams()
      let a_str = params.get("a")
      let b_str = params.get("b")
      match (a_str, b_str) {
        (Some(a), Some(b)) => {
          let data = @nostd.Object::new()
          data["result"] = (a + "+" + b) |> @nostd.any
          let options = @nostd.Object::new()
          options["status"] = 200 |> @nostd.any
          Response::json_(data, options~)
        }
        _ => {
          let data = @nostd.Object::new()
          data["error"] = "Missing parameters a or b" |> @nostd.any
          let options = @nostd.Object::new()
          options["status"] = 400 |> @nostd.any
          Response::json_(data, options~)
        }
      }
    } else {
      let data = @nostd.Object::new()
      data["error"] = "Route not found" |> @nostd.any
      let options = @nostd.Object::new()
      options["status"] = 404 |> @nostd.any
      Response::json_(data, options~)
    }
  }
  promisify3(async_handler)
}
