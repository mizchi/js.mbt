///|
#external
pub type Response

///|
pub impl JsImpl for Response

///|
pub extern "js" fn Response::redirect(url : String, status? : Int) -> Response =
  #| (url, status) => Response

///|
pub extern "js" fn Response::json_(data : Js, options? : Js) -> Response =
  #| (data, options) => Response.json(data, options)

///|
pub extern "js" fn Response::error() -> Response =
  #| () => Response.error()

///|
pub extern "js" fn Response::json(self : Self) -> Promise[Js] =
  #| (v) => v.json()

///|
pub extern "js" fn Response::text(self : Self) -> Promise[String] =
  #| (v) => v.text()

///|
pub extern "js" fn Response::form_data(self : Self) -> Promise[FormData] =
  #| (v) => v.formData()

///|
pub extern "js" fn Response::bytes(
  self : Self,
) -> Promise[@arraybuffer.Uint8Array] =
  #| (v) => v.bytes()

///|
pub extern "js" fn Response::clone(self : Self) -> Response =
  #| (v) => v.clone()

///|
pub extern "js" fn Response::ok(self : Self) -> Bool =
  #| (v) => v.ok

///|
pub extern "js" fn Response::status(self : Self) -> Int =
  #| (v) => v.status

///|
#alias(statusText)
pub extern "js" fn Response::status_text(self : Self) -> String =
  #| (v) => v.statusText

///|
pub extern "js" fn Response::redirected(self : Self) -> Bool =
  #| (v) => v.redirected

///|
pub extern "js" fn Response::type_(self : Self) -> String =
  #| (v) => v.type

///|
/// Get the body as a ReadableStream
pub fn Response::body(self : Self) -> @stream.ReadableStream? {
  self.get("body") |> @js.unsafe_cast_option()
}
