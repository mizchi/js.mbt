///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response
#external
pub type Response

///|
pub impl JsImpl for Response

///|
/// Create a new Response
/// https://developer.mozilla.org/ja/docs/Web/API/Response/Response
pub extern "js" fn new_response(body? : String, options? : Js) -> Response =
  #| (body, options) => new Response(body, options)

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/redirect_static
pub extern "js" fn Response::redirect(url : String, status? : Int) -> Response =
  #| (url, status) => Response

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/json_static
pub fn Response::json_(data : &JsImpl, options? : &JsImpl) -> Response {
  match options {
    Some(opts) => json_impl(data.to_js(), opts.to_js())
    None => json_impl(data.to_js(), @js.undefined())
  }
}

///|
extern "js" fn json_impl(data : Js, options : Js) -> Response =
  #| (data, options) => Response.json(data, options)

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/error_static
pub extern "js" fn Response::error() -> Response =
  #| () => Response.error()

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/json
pub extern "js" fn Response::json(self : Self) -> Promise[Js] =
  #| (v) => v.json()

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/text
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

///|
/// Create an HTML response
pub extern "js" fn Response::html(body : String, status : Int) -> Response =
  #| (body, status) => new Response(body, { status, headers: { "Content-Type": "text/html" } })

///|
/// Create a text response
pub extern "js" fn Response::text_(body : String, status : Int) -> Response =
  #| (body, status) => new Response(body, { status, headers: { "Content-Type": "text/plain" } })
