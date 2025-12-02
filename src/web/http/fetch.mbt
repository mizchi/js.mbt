///|
/// https://developer.mozilla.org/ja/docs/Web/API/fetch
extern "js" fn ffi_fetch(
  url : String,
  init : @core.Any,
) -> @js.Promise[Response] =
  #| (url, init) => fetch(url, init)

///|
extern "js" fn ffi_fetch_request(request : Request) -> @js.Promise[Response] =
  #| (request) => fetch(request)

///|
/// https://developer.mozilla.org/ja/docs/Web/API/fetch
pub async fn fetch(
  url : String,
  method_~ : String,
  headers? : Map[String, String] = {},
  cache? : String,
  mode? : String,
  body? : @core.Any, // String, ArrayBuffer, FormData, etc.
  credentials? : String,
  integrity? : String,
  keepalive? : Bool,
  priority? : String,
  redirect? : String,
  referrer? : String,
  referrerPolicy? : String,
  signal? : @js.AbortSignal,
) -> Response {
  let header_obj = @core.Object::new()
  for k, v in headers {
    header_obj._set(k, @core.any(v))
  }
  let init_obj = @mbtconv.from_option_map({
    "method": Some(@core.any(method_)),
    "headers": Some(header_obj),
    "body": body.map(fn(x) { x }),
    "cache": cache.map(fn(x) { @core.any(x) }),
    "mode": mode.map(fn(x) { @core.any(x) }),
    "credentials": credentials.map(fn(x) { @core.any(x) }),
    "integrity": integrity.map(fn(x) { @core.any(x) }),
    "keepalive": keepalive.map(fn(x) { @core.any(x) }),
    "priority": priority.map(fn(x) { @core.any(x) }),
    "redirect": redirect.map(fn(x) { @core.any(x) }),
    "referrer": referrer.map(fn(x) { @core.any(x) }),
    "referrerPolicy": referrerPolicy.map(fn(x) { @core.any(x) }),
    "signal": signal.map(fn(x) { @core.identity(x) }),
  }).cast()
  ffi_fetch(url, init_obj).wait()
}

///|
pub async fn fetch_request(request : Request) -> Response {
  ffi_fetch_request(request).wait()
}

///|
#skip("fetch test requires network")
async test "fetch" {
  let response = fetch(
    "https://jsonplaceholder.typicode.com/todos/1",
    method_="GET",
    headers={ "Accept": "application/json" },
  ) catch {
    e => {
      @js.log("Fetch error: " + e.to_string())
      return
    }
  }
  let value = response.json() catch {
    e => {
      @js.log("Error parsing JSON: " + e.to_string())
      return
    }
  }
  @js.log(value)
}
