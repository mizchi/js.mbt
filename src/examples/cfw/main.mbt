///|
using @js {run_async, log}

///|
using @http {type Request, type Response, fetch, fetch_request}

// @js.Request

///|
pub fn run() -> Unit {
  run_async(() => try {
    let req = Request::new("https://jsonplaceholder.typicode.com/todos/1")
    let res = fetch_request(req)
    let text = res.wait().json().wait()
    log(text)
  } catch {
    e => log("Error: " + e.to_string())
  })
}

///|
fn main {
  run()
}
