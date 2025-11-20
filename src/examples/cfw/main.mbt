///|
using @js {log}

///|
using @http {type Request, type Response, fetch, fetch_request, new_response}

///|
using @url {type URL}

///|
/// Create Response with JSON content type
extern "js" fn create_json_response(body : String, status : Int) -> Response =
  #| (body, status) => new Response(body, { status, headers: { "Content-Type": "application/json" } })

///|
/// Create Response with text content type
extern "js" fn create_text_response(body : String, status : Int) -> Response =
  #| (body, status) => new Response(body, { status, headers: { "Content-Type": "text/plain" } })

///|
/// Create Response with HTML content type
extern "js" fn create_html_response(body : String, status : Int) -> Response =
  #| (body, status) => new Response(body, { status, headers: { "Content-Type": "text/html" } })

///|
/// Create Response with redirect
extern "js" fn create_redirect_response(
  location : String,
  status : Int,
) -> Response =
  #| (location, status) => new Response("Redirecting...", { status, headers: { "Location": location } })

///|
/// Create Response with custom headers
extern "js" fn create_custom_headers_response(body : String) -> Response =
  #| (body) => new Response(body, { status: 200, headers: { "Content-Type": "application/json", "X-Custom-Header": "MoonBit-Worker", "X-Powered-By": "Cloudflare" } })

///|
/// Helper to create JSON response
fn json_response(data : String, status : Int) -> Response {
  create_json_response(data, status)
}

///|
/// Helper to create text response
fn text_response(data : String, status : Int) -> Response {
  create_text_response(data, status)
}

///|
/// Helper to create HTML response
fn html_response(data : String, status : Int) -> Response {
  create_html_response(data, status)
}

///|
pub fn get_fetch_handler() -> @cloudflare.CloudflareFetchHandler {
  let async_handler = async fn(
    req : @cloudflare.CloudflareRequest,
    _env : @cloudflare.CloudflareEnv,
    _ctx : @cloudflare.CloudflareContext,
  ) -> Response {
    let url_str = req.url()
    let url = URL::new(url_str)
    let pathname = url.pathname()

    // Route handling
    if pathname == "/" {
      html_response(
        "<h1>Cloudflare Worker with MoonBit</h1><p>Available routes: /api/hello, /api/echo, /api/fetch, /api/json</p>",
        200,
      )
    } else if pathname == "/api/hello" {
      json_response("{\"message\":\"Hello from MoonBit Worker!\"}", 200)
    } else if pathname == "/api/echo" {
      // Echo back the URL (method would need Request API improvements)
      let response_data = "{\"url\":\"" + url_str + "\"}"
      json_response(response_data, 200)
    } else if pathname == "/api/fetch" {
      // Fetch external API
      let res = fetch(
        "https://jsonplaceholder.typicode.com/todos/1",
        method_="GET",
      ).unwrap() catch {
        e => {
          log("Error: " + e.to_string())
          return json_response("{\"error\":\"Failed to fetch\"}", 500)
        }
      }
      res
    } else if pathname == "/api/json" {
      // Return complex JSON
      json_response(
        "{\"status\":\"ok\",\"data\":{\"foo\":\"bar\",\"num\":42},\"timestamp\":1234567890}",
        200,
      )
    } else if pathname == "/api/redirect" {
      // Redirect response
      create_redirect_response("/", 302)
    } else if pathname == "/api/headers" {
      // Return custom headers
      create_custom_headers_response("{\"message\":\"Check the headers\"}")
    } else if pathname == "/api/status/404" {
      json_response("{\"error\":\"Not Found\"}", 404)
    } else if pathname == "/api/status/500" {
      json_response("{\"error\":\"Internal Server Error\"}", 500)
    } else if pathname == "/api/text" {
      text_response("Plain text response from MoonBit", 200)
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
      json_response("{\"greeting\":\"" + message + ", " + name + "!\"}", 200)
    } else if pathname == "/api/time" {
      // Return current timestamp (using a simple counter as example)
      json_response("{\"timestamp\":1234567890}", 200)
    } else if pathname == "/api/user-agent" {
      // Would need Request headers API to get user-agent
      // For now, return a placeholder
      json_response("{\"userAgent\":\"unknown\"}", 200)
    } else if pathname == "/api/method" {
      // Would need Request method API
      json_response("{\"method\":\"unknown\"}", 200)
    } else if pathname == "/health" {
      json_response(
        "{\"status\":\"healthy\",\"service\":\"moonbit-worker\"}", 200,
      )
    } else if pathname == "/api/math/add" {
      let params = url.searchParams()
      let a_str = params.get("a")
      let b_str = params.get("b")
      match (a_str, b_str) {
        (Some(a), Some(b)) =>
          // Simple string to int conversion (would need proper parsing)
          json_response("{\"result\":\"" + a + "+" + b + "\"}", 200)
        _ => json_response("{\"error\":\"Missing parameters a or b\"}", 400)
      }
    } else {
      json_response("{\"error\":\"Route not found\"}", 404)
    }
  }
  @promise.promisify3(async_handler)
}
