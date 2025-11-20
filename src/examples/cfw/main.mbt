///|
using @js {log}

///|
using @http {type Request, type Response, fetch, fetch_request, new_response}

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
    let pathname = url.pathname()

    // Route handling
    if pathname == "/" {
      Response::html_response(
        "<h1>Cloudflare Worker with MoonBit</h1><p>Available routes: /api/hello, /api/echo, /api/fetch, /api/json</p>",
        200,
      )
    } else if pathname == "/api/hello" {
      Response::json_response(
        "{\"message\":\"Hello from MoonBit Worker!\"}", 200,
      )
    } else if pathname == "/api/echo" {
      // Echo back the URL (method would need Request API improvements)
      let response_data = "{\"url\":\"" + url_str + "\"}"
      Response::json_response(response_data, 200)
    } else if pathname == "/api/fetch" {
      // Fetch external API
      let res = fetch(
        "https://jsonplaceholder.typicode.com/todos/1",
        method_="GET",
      ).unwrap() catch {
        e => {
          log("Error: " + e.to_string())
          return Response::json_response("{\"error\":\"Failed to fetch\"}", 500)
        }
      }
      res
    } else if pathname == "/api/json" {
      // Return complex JSON
      Response::json_response(
        "{\"status\":\"ok\",\"data\":{\"foo\":\"bar\",\"num\":42},\"timestamp\":1234567890}",
        200,
      )
    } else if pathname == "/api/redirect" {
      // Redirect response
      Response::redirect("/", status=302)
    } else if pathname == "/api/headers" {
      // Return custom headers
      let headers = @js.Object::new()
      headers.set("Content-Type", "application/json")
      headers.set("X-Custom-Header", "MoonBit-Worker")
      headers.set("X-Powered-By", "Cloudflare")
      let options = @js.Object::new()
      options.set("status", 200)
      options.set("headers", headers.to_js())
      new_response(
        body="{\"message\":\"Check the headers\"}",
        options=options.to_js(),
      )
    } else if pathname == "/api/status/404" {
      Response::json_response("{\"error\":\"Not Found\"}", 404)
    } else if pathname == "/api/status/500" {
      Response::json_response("{\"error\":\"Internal Server Error\"}", 500)
    } else if pathname == "/api/text" {
      Response::text_response("Plain text response from MoonBit", 200)
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
      Response::json_response(
        "{\"greeting\":\"" + message + ", " + name + "!\"}",
        200,
      )
    } else if pathname == "/api/time" {
      // Return current timestamp (using a simple counter as example)
      Response::json_response("{\"timestamp\":1234567890}", 200)
    } else if pathname == "/api/user-agent" {
      // Would need Request headers API to get user-agent
      // For now, return a placeholder
      Response::json_response("{\"userAgent\":\"unknown\"}", 200)
    } else if pathname == "/api/method" {
      // Would need Request method API
      Response::json_response("{\"method\":\"unknown\"}", 200)
    } else if pathname == "/health" {
      Response::json_response(
        "{\"status\":\"healthy\",\"service\":\"moonbit-worker\"}", 200,
      )
    } else if pathname == "/api/math/add" {
      let params = url.searchParams()
      let a_str = params.get("a")
      let b_str = params.get("b")
      match (a_str, b_str) {
        (Some(a), Some(b)) =>
          // Simple string to int conversion (would need proper parsing)
          Response::json_response("{\"result\":\"" + a + "+" + b + "\"}", 200)
        _ =>
          Response::json_response(
            "{\"error\":\"Missing parameters a or b\"}", 400,
          )
      }
    } else {
      Response::json_response("{\"error\":\"Route not found\"}", 404)
    }
  }
  @promise.promisify3(async_handler)
}
