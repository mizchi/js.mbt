///|
using @js {log}

///|
using @http {type Request, type Response, fetch, fetch_request, new_response}

///|
/// Helper to create JSON response
fn json_response(data : String, status : Int) -> Response {
  let headers = @js.Object::new()
  headers.set("Content-Type", "application/json")
  let options = @js.Object::new()
  options.set("status", status)
  options.set("headers", headers)
  new_response(body=data, options=options.to_js())
}

///|
/// Helper to create text response
fn text_response(data : String, status : Int) -> Response {
  let headers = @js.Object::new()
  headers.set("Content-Type", "text/plain")
  let options = @js.Object::new()
  options.set("status", status)
  options.set("headers", headers)
  new_response(body=data, options=options.to_js())
}

///|
/// Helper to create HTML response
fn html_response(data : String, status : Int) -> Response {
  let headers = @js.Object::new()
  headers.set("Content-Type", "text/html")
  let options = @js.Object::new()
  options.set("status", status)
  options.set("headers", headers)
  new_response(body=data, options=options.to_js())
}

///|
pub fn get_fetch_handler() -> @cloudflare.CloudflareFetchHandler {
  let async_handler = async fn(
    req : @cloudflare.CloudflareRequest,
    _env : @cloudflare.CloudflareEnv,
    _ctx : @cloudflare.CloudflareContext,
  ) -> Response {
    let url = req.url()
    let url_obj = @js.new_(@js.js("URL"), [@js.js(url)])
    let pathname = url_obj.get("pathname") |> @js.unsafe_cast

    // Route handling
    if pathname == "/" {
      html_response("<h1>Cloudflare Worker with MoonBit</h1><p>Available routes: /api/hello, /api/echo, /api/fetch, /api/json</p>", 200)
    } else if pathname == "/api/hello" {
      json_response("{\"message\":\"Hello from MoonBit Worker!\"}", 200)
    } else if pathname == "/api/echo" {
      // Echo back the URL (method would need Request API improvements)
      let response_data = "{\"url\":\"" + url + "\"}"
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
      json_response("{\"status\":\"ok\",\"data\":{\"foo\":\"bar\",\"num\":42},\"timestamp\":1234567890}", 200)
    } else if pathname == "/api/redirect" {
      // Redirect response
      let headers = @js.Object::new()
      headers.set("Location", "/")
      let options = @js.Object::new()
      options.set("status", 302)
      options.set("headers", headers)
      new_response(body="Redirecting...", options=options.to_js())
    } else if pathname == "/api/headers" {
      // Return custom headers
      let headers = @js.Object::new()
      headers.set("X-Custom-Header", "MoonBit-Worker")
      headers.set("X-Powered-By", "Cloudflare")
      headers.set("Content-Type", "application/json")
      let options = @js.Object::new()
      options.set("status", 200)
      options.set("headers", headers)
      new_response(body="{\"message\":\"Check the headers\"}", options=options.to_js())
    } else if pathname == "/api/status/404" {
      json_response("{\"error\":\"Not Found\"}", 404)
    } else if pathname == "/api/status/500" {
      json_response("{\"error\":\"Internal Server Error\"}", 500)
    } else if pathname == "/api/text" {
      text_response("Plain text response from MoonBit", 200)
    } else {
      json_response("{\"error\":\"Route not found\"}", 404)
    }
  }
  @promise.promisify3(async_handler)
}
