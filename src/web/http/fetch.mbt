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
  let header_obj = @core.new_object()
  for k, v in headers {
    header_obj._set(k, @core.any(v))
  }
  let entries : Array[(String, @core.Any)] = []
  entries.push(("method", @core.any(method_)))
  entries.push(("headers", header_obj))
  if body is Some(v) {
    entries.push(("body", v))
  }
  if cache is Some(v) {
    entries.push(("cache", @core.any(v)))
  }
  if mode is Some(v) {
    entries.push(("mode", @core.any(v)))
  }
  if credentials is Some(v) {
    entries.push(("credentials", @core.any(v)))
  }
  if integrity is Some(v) {
    entries.push(("integrity", @core.any(v)))
  }
  if keepalive is Some(v) {
    entries.push(("keepalive", @core.any(v)))
  }
  if priority is Some(v) {
    entries.push(("priority", @core.any(v)))
  }
  if redirect is Some(v) {
    entries.push(("redirect", @core.any(v)))
  }
  if referrer is Some(v) {
    entries.push(("referrer", @core.any(v)))
  }
  if referrerPolicy is Some(v) {
    entries.push(("referrerPolicy", @core.any(v)))
  }
  if signal is Some(v) {
    entries.push(("signal", @core.identity(v)))
  }
  let init_obj = @core.from_entries(entries).cast()
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
      println("Fetch error: " + e.to_string())
      return
    }
  }
  let value = response.json() catch {
    e => {
      println("Error parsing JSON: " + e.to_string())
      return
    }
  }
  @js.log(value)
}
