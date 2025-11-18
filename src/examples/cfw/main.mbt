///|
using @js {type Js, js, log}

///|
using @promise {run_async}

///|
using @http {type Request, type Response, fetch, fetch_request}

///|
pub fn get_fetch_handler() -> @cloudflare.CloudflareFetchHandler {
  let async_handler = async fn(
    _req : @cloudflare.CloudflareRequest,
    _env : @cloudflare.CloudflareEnv,
    _ctx : @cloudflare.CloudflareContext,
  ) -> Response {
    let res = fetch(
      "https://jsonplaceholder.typicode.com/todos/1",
      method_="GET",
    ).unwrap() catch {
      e => {
        log("Error: " + e.to_string())
        panic()
        // Response::new("Internal Server Error", 500)
      }
    }
    res
  }
  @promise.promisify3(async_handler)
}
