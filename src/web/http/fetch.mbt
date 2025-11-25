///|
/// https://developer.mozilla.org/ja/docs/Web/API/fetch
extern "js" fn ffi_fetch(url : String, init : @js.Any) -> @js.Promise[Response] =
  #| (url, init) => fetch(url, init)

///|
extern "js" fn ffi_fetch_request(request : Request) -> @js.Promise[Response] =
  #| (request) => fetch(request)

///|
/// https://developer.mozilla.org/ja/docs/Web/API/fetch
pub fn fetch(
  url : String,
  method_~ : String,
  headers? : Map[String, String] = {},
  cache? : String,
  mode? : String,
  body? : &@js.JsImpl, // String, ArrayBuffer, FormData, etc.
  credentials? : String,
  integrity? : String,
  keepalive? : Bool,
  priority? : String,
  redirect? : String,
  referrer? : String,
  referrerPolicy? : String,
  signal? : @js.AbortSignal,
) -> @js.Promise[Response] {
  let header_obj = @js.Object::new()
  for k, v in headers {
    header_obj.set(k, v)
  }
  let init_obj = @js.from_option_map({
    "method": Some(@js.any(method_)),
    "headers": Some(header_obj.to_any()),
    "body": body.map(fn(x) { x.to_any() }),
    "cache": cache.map(fn(x) { @js.any(x) }),
    "mode": mode.map(fn(x) { @js.any(x) }),
    "credentials": credentials.map(fn(x) { @js.any(x) }),
    "integrity": integrity.map(fn(x) { @js.any(x) }),
    "keepalive": keepalive.map(fn(x) { @js.any(x) }),
    "priority": priority.map(fn(x) { @js.any(x) }),
    "redirect": redirect.map(fn(x) { @js.any(x) }),
    "referrer": referrer.map(fn(x) { @js.any(x) }),
    "referrerPolicy": referrerPolicy.map(fn(x) { @js.any(x) }),
    "signal": signal.map(fn(x) { x.to_any() }),
  })
  ffi_fetch(url, init_obj)
}

///|
pub fn fetch_request(request : Request) -> @js.Promise[Response] {
  ffi_fetch_request(request)
}

///|
#skip("fetch test requires network")
test "fetch" {
  @js.run_async(() => {
    let response = fetch(
      "https://jsonplaceholder.typicode.com/todos/1",
      method_="GET",
      headers={ "Accept": "application/json" },
    ).wait() catch {
      e => {
        @js.log("Fetch error: " + e.to_string())
        return
      }
    }
    let value = response.json().wait() catch {
        e => {
          @js.log("Error parsing JSON: " + e.to_string())
          return
        }
      }
    @js.log(value)
  })
}
