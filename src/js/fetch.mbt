///|
#external
pub type Request

///|
#external
pub type Response

///|
pub extern "js" fn Response::json(self : Response) -> Promise[Value] =
  #| (v) => v.json()

///|
pub extern "js" fn Response::text(self : Response) -> Promise[String] =
  #| (v) => v.text()

///|
extern "js" fn ffi_fetch(input : String, init : Value) -> Promise[Response] =
  #| (input, init) => fetch(input, init)

///|
pub async fn fetch(
  url : String,
  method_~ : String,
  headers? : Map[String, String],
) -> Promise[Response] {
  let init_obj = new_object()
  init_obj.set("method", method_)
  if headers is Some(headers) {
    for k, v in headers {
      init_obj.set(k, v)
    }
  }
  ffi_fetch(url, init_obj)
}

///|
#skip
test "fetch" {
  run_async(async fn() noraise {
    let response = fetch(
      "https://jsonplaceholder.typicode.com/todos/1",
      method_="GET",
      headers={ "Accept": "application/json" },
    ) catch {
      e => {
        console_error("Fetch error: " + e.to_string())
        return
      }
    }
    let value = response.wait().json().wait() catch {
      e => {
        console_error("Error parsing JSON: " + e.to_string())
        return
      }
    }
    log(value)
  })
}
