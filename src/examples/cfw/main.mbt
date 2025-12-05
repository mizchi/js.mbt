///|
using @js {promisify3}

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
      let data = @core.new_object()
      data["message"] = "Hello from MoonBit Worker!" |> @core.any
      let options = @core.new_object()
      options["status"] = 200 |> @core.any
      Response::json_(data, options~)
    } else if pathname == "/api/echo" {
      let data = @core.new_object()
      data["url"] = url_str |> @core.any
      let options = @core.new_object()
      options["status"] = 200 |> @core.any
      Response::json_(data, options~)
    } else if pathname == "/api/fetch" {
      // Fetch external API
      let res = fetch(
        "https://jsonplaceholder.typicode.com/todos/1",
        method_="GET",
      ) catch {
        e => {
          println("Error: " + e.to_string())
          let data = @core.new_object()
          data["error"] = "Failed to fetch" |> @core.any
          let options = @core.new_object()
          options["status"] = 500 |> @core.any
          return Response::json_(data, options~)
        }
      }
      res
    } else if pathname == "/api/json" {
      let data = @core.new_object()
      data["status"] = "ok" |> @core.any
      let inner_data = @core.new_object()
      inner_data["foo"] = "bar" |> @core.any
      inner_data["num"] = 42 |> @core.any
      data["data"] = inner_data
      data["timestamp"] = 1234567890 |> @core.any
      let options = @core.new_object()
      options["status"] = 200 |> @core.any
      Response::json_(data, options~)
    } else if pathname == "/api/redirect" {
      Response::redirect("/", status=302)
    } else if pathname == "/api/headers" {
      let headers = @core.new_object()
      headers["Content-Type"] = "application/json" |> @core.any
      headers["x-custom-header"] = "MoonBit-Worker" |> @core.any
      headers["x-powered-by"] = "Cloudflare" |> @core.any
      let data = @core.new_object()
      data["message"] = "Check the headers" |> @core.any
      let options = @core.new_object()
      options["status"] = 200 |> @core.any
      options["headers"] = headers
      Response::json_(data, options~)
    } else if pathname == "/api/status/404" {
      let data = @core.new_object()
      data["error"] = "Not Found" |> @core.any
      let options = @core.new_object()
      options["status"] = 404 |> @core.any
      Response::json_(data, options~)
    } else if pathname == "/api/status/500" {
      let data = @core.new_object()
      data["error"] = "Internal Server Error" |> @core.any
      let options = @core.new_object()
      options["status"] = 500 |> @core.any
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
      let data = @core.new_object()
      data["greeting"] = (message + ", " + name + "!") |> @core.any
      let options = @core.new_object()
      options["status"] = 200 |> @core.any
      Response::json_(data, options~)
    } else if pathname == "/api/time" {
      let data = @core.new_object()
      data["timestamp"] = 1234567890 |> @core.any
      let options = @core.new_object()
      options["status"] = 200 |> @core.any
      Response::json_(data, options~)
    } else if pathname == "/api/user-agent" {
      let data = @core.new_object()
      data["userAgent"] = "unknown" |> @core.any
      let options = @core.new_object()
      options["status"] = 200 |> @core.any
      Response::json_(data, options~)
    } else if pathname == "/api/method" {
      let data = @core.new_object()
      data["method"] = "unknown" |> @core.any
      let options = @core.new_object()
      options["status"] = 200 |> @core.any
      Response::json_(data, options~)
    } else if pathname == "/health" {
      let data = @core.new_object()
      data["status"] = "healthy" |> @core.any
      data["service"] = "moonbit-worker" |> @core.any
      let options = @core.new_object()
      options["status"] = 200 |> @core.any
      Response::json_(data, options~)
    } else if pathname == "/api/math/add" {
      let params = url.searchParams()
      let a_str = params.get("a")
      let b_str = params.get("b")
      match (a_str, b_str) {
        (Some(a), Some(b)) => {
          let data = @core.new_object()
          data["result"] = (a + "+" + b) |> @core.any
          let options = @core.new_object()
          options["status"] = 200 |> @core.any
          Response::json_(data, options~)
        }
        _ => {
          let data = @core.new_object()
          data["error"] = "Missing parameters a or b" |> @core.any
          let options = @core.new_object()
          options["status"] = 400 |> @core.any
          Response::json_(data, options~)
        }
      }
    } else {
      let data = @core.new_object()
      data["error"] = "Route not found" |> @core.any
      let options = @core.new_object()
      options["status"] = 404 |> @core.any
      Response::json_(data, options~)
    }
  }
  promisify3(async_handler)
}
