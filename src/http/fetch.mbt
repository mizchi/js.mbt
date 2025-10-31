///|
extern "js" fn ffi_fetch(url : String, init : Val) -> Promise[Response] =
  #| (url, init) => fetch(url, init)

///|
extern "js" fn ffi_fetch_request(request : Request) -> Promise[Response] =
  #| (request) => fetch(request)

///|
pub async fn fetch(
  url : String,
  method_~ : String,
  headers? : Map[String, String],
  body? : String,
) -> Promise[Response] {
  let init_obj = new_object()
  init_obj.set("method", method_)
  if headers is Some(headers) {
    for k, v in headers {
      init_obj.set(k, v)
    }
  }
  if body is Some(body) {
    init_obj["body"] = body
  }
  ffi_fetch(url, init_obj)
}

///|
pub async fn fetch_request(request : Request) -> Promise[Response] {
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
    ) catch {
      e => {
        log("Fetch error: " + e.to_string())
        return
      }
    }
    let value = response.unwrap().json().unwrap() catch {
      e => {
        log("Error parsing JSON: " + e.to_string())
        return
      }
    }
    log(value)
  })
}
