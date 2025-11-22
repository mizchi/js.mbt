///|
/// https://developer.mozilla.org/ja/docs/Web/API/fetch
extern "js" fn ffi_fetch(url : String, init : Js) -> Promise[Response] =
  #| (url, init) => fetch(url, init)

///|
extern "js" fn ffi_fetch_request(request : Request) -> Promise[Response] =
  #| (request) => fetch(request)

///|
/// https://developer.mozilla.org/ja/docs/Web/API/fetch
pub fn fetch(
  url : String,
  method_~ : String,
  headers? : Map[String, String] = {},
  cache? : String,
  mode? : String,
  body? : &JsImpl, // String, ArrayBuffer, FormData, etc.
  credentials? : String,
  integrity? : String,
  keepalive? : Bool,
  priority? : String,
  redirect? : String,
  referrer? : String,
  referrerPolicy? : String,
  signal? : AbortSignal,
) -> Promise[Response] {
  let header_obj = @js.Object::new()
  for k, v in headers {
    header_obj.set(k, v)
  }
  let init_obj = @js.from_entries_option([
    ("method", Some(method_)),
    ("headers", Some(header_obj)),
    ("body", body.map(x => x)),
    ("cache", cache.map(x => x)),
    ("mode", mode.map(x => x)),
    ("credentials", credentials.map(x => x)),
    ("integrity", integrity.map(x => x)),
    ("keepalive", keepalive.map(x => x)),
    ("priority", priority.map(x => x)),
    ("redirect", redirect.map(x => x)),
    ("referrer", referrer.map(x => x)),
    ("referrerPolicy", referrerPolicy.map(x => x)),
    ("signal", signal.map(x => x)),
  ])
  ffi_fetch(url, init_obj)
}

///|
pub fn fetch_request(request : Request) -> Promise[Response] {
  ffi_fetch_request(request)
}

///|
#skip("fetch test requires network")
test "fetch" {
  run_async(() => {
    let response = fetch(
      "https://jsonplaceholder.typicode.com/todos/1",
      method_="GET",
      headers={ "Accept": "application/json" },
    ).wait() catch {
      e => {
        log("Fetch error: " + e.to_string())
        return
      }
    }
    let value = response.json().wait() catch {
        e => {
          log("Error parsing JSON: " + e.to_string())
          return
        }
      }
    log(value)
  })
}
