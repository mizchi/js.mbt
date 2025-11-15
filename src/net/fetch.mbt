///|
extern "js" fn ffi_fetch(url : String, init : Val) -> Promise[Response] =
  #| (url, init) => fetch(url, init)

///|
extern "js" fn ffi_fetch_request(request : Request) -> Promise[Response] =
  #| (request) => fetch(request)

///|
pub fn fetch(
  url : String,
  method_~ : String,
  headers? : Map[String, String] = {},
  cache? : String,
  mode? : String,
  body? : &Js, // String, ArrayBuffer, FormData, etc.
  credentials? : String,
  integrity? : String,
  keepalive? : Bool,
  priority? : String,
  redirect? : String,
  referrer? : String,
  referrerPolicy? : String,
  signal? : @async.AbortSignal,
) -> Promise[Response] {
  let init_obj = new_empty_object()
  init_obj.set("method", method_)
  let header_obj = @js.new_empty_object()
  for k, v in headers {
    header_obj.set(k, v)
  }
  if body is Some(body) {
    init_obj.set("body", body)
  }
  if cache is Some(c) {
    init_obj.set("cache", c)
  }
  if mode is Some(m) {
    init_obj.set("mode", m)
  }
  if credentials is Some(c) {
    init_obj.set("credentials", c)
  }
  if integrity is Some(i) {
    init_obj.set("integrity", i)
  }
  if keepalive is Some(k) {
    init_obj.set("keepalive", k)
  }
  if priority is Some(p) {
    init_obj.set("priority", p)
  }
  if redirect is Some(r) {
    init_obj.set("redirect", r)
  }
  if referrer is Some(r) {
    init_obj.set("referrer", r)
  }
  if referrerPolicy is Some(rp) {
    init_obj.set("referrerPolicy", rp)
  }
  if signal is Some(s) {
    init_obj.set("signal", s)
  }
  ffi_fetch(url, init_obj)
}

///|
#external
pub type FormData

///|
pub impl Js for FormData

///|
pub fn FormData::append(self : Self, name : String, value : String) -> Unit {
  self.invoke("append", [name, value]) |> unsafe_cast
}

///|
pub fn FormData::delete(self : Self, name : String) -> Unit {
  self.invoke("delete", [name]) |> unsafe_cast
}

///|
pub fn FormData::get(self : Self, name : String) -> String {
  self.invoke("get", [name]) |> unsafe_cast
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
    ).unwrap() catch {
      e => {
        log("Fetch error: " + e.to_string())
        return
      }
    }
    let value = response.json().unwrap() catch {
        e => {
          log("Error parsing JSON: " + e.to_string())
          return
        }
      }
    log(value)
  })
}
