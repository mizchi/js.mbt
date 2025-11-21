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
      Response::json_with_message("Hello from MoonBit Worker!", 200)
    } else if pathname == "/api/echo" {
      Response::json_with_url(url_str, 200)
    } else if pathname == "/api/fetch" {
      // Fetch external API
      let res = fetch(
        "https://jsonplaceholder.typicode.com/todos/1",
        method_="GET",
      ).unwrap() catch {
        e => {
          log("Error: " + e.to_string())
          return Response::json_with_error("Failed to fetch", 500)
        }
      }
      res
    } else if pathname == "/api/json" {
      Response::json_complex()
    } else if pathname == "/api/redirect" {
      Response::redirect("/", status=302)
    } else if pathname == "/api/headers" {
      Response::with_custom_headers(
        "{\"message\":\"Check the headers\"}", 200, "MoonBit-Worker", "Cloudflare",
      )
    } else if pathname == "/api/status/404" {
      Response::json_with_error("Not Found", 404)
    } else if pathname == "/api/status/500" {
      Response::json_with_error("Internal Server Error", 500)
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
      Response::json_with_greeting(message + ", " + name + "!", 200)
    } else if pathname == "/api/time" {
      Response::json_with_timestamp(1234567890, 200)
    } else if pathname == "/api/user-agent" {
      Response::json_with_user_agent("unknown", 200)
    } else if pathname == "/api/method" {
      Response::json_with_method("unknown", 200)
    } else if pathname == "/health" {
      Response::json_with_health("healthy", "moonbit-worker", 200)
    } else if pathname == "/api/math/add" {
      let params = url.searchParams()
      let a_str = params.get("a")
      let b_str = params.get("b")
      match (a_str, b_str) {
        (Some(a), Some(b)) => Response::json_with_result(a + "+" + b, 200)
        _ => Response::json_with_error("Missing parameters a or b", 400)
      }
    } else {
      Response::json_with_error("Route not found", 404)
    }
  }
  promisify3(async_handler)
}
