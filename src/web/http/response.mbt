///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response
pub(all) struct Response {
  ok : Bool
  status : Int
  statusText : String
  redirected : Bool
}

///|
pub impl @js.JsImpl for Response

///|
/// Create a new Response
/// https://developer.mozilla.org/ja/docs/Web/API/Response/Response
pub fn Response::new(
  body? : String,
  status? : Int,
  statusText? : String,
  headers? : &@js.JsImpl,
) -> Response {
  let body_js = match body {
    Some(b) => @js.identity(b)
    None => @js.undefined()
  }
  match (status, statusText, headers) {
    (Some(s), Some(st), Some(h)) =>
      new_impl_full(body_js, s, @js.identity(st), h.to_any())
    (Some(s), Some(st), None) =>
      new_impl_status_text(body_js, s, @js.identity(st))
    (Some(s), None, Some(h)) => new_impl_status_headers(body_js, s, h.to_any())
    (Some(s), None, None) => new_impl_status(body_js, s)
    (None, Some(st), Some(h)) =>
      new_impl_text_headers(body_js, @js.identity(st), h.to_any())
    (None, Some(st), None) => new_impl_text(body_js, @js.identity(st))
    (None, None, Some(h)) => new_impl_headers(body_js, h.to_any())
    (None, None, None) => new_impl_plain(body_js)
  }
}

///|
extern "js" fn new_impl_full(
  body : @js.Any,
  status : Int,
  statusText : @js.Any,
  headers : @js.Any,
) -> Response =
  #| (body, status, statusText, headers) => new Response(body, { status, statusText, headers })

///|
extern "js" fn new_impl_status_text(
  body : @js.Any,
  status : Int,
  statusText : @js.Any,
) -> Response =
  #| (body, status, statusText) => new Response(body, { status, statusText })

///|
extern "js" fn new_impl_status_headers(
  body : @js.Any,
  status : Int,
  headers : @js.Any,
) -> Response =
  #| (body, status, headers) => new Response(body, { status, headers })

///|
extern "js" fn new_impl_status(body : @js.Any, status : Int) -> Response =
  #| (body, status) => new Response(body, { status })

///|
extern "js" fn new_impl_text_headers(
  body : @js.Any,
  statusText : @js.Any,
  headers : @js.Any,
) -> Response =
  #| (body, statusText, headers) => new Response(body, { statusText, headers })

///|
extern "js" fn new_impl_text(body : @js.Any, statusText : @js.Any) -> Response =
  #| (body, statusText) => new Response(body, { statusText })

///|
extern "js" fn new_impl_headers(body : @js.Any, headers : @js.Any) -> Response =
  #| (body, headers) => new Response(body, { headers })

///|
extern "js" fn new_impl_plain(body : @js.Any) -> Response =
  #| (body) => new Response(body)

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/redirect_static
pub extern "js" fn Response::redirect(url : String, status? : Int) -> Response =
  #| (url, status) => Response

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/json_static
pub fn Response::json_(data : &@js.JsImpl, options? : &@js.JsImpl) -> Response {
  match options {
    Some(opts) => json_impl(data.to_any(), opts.to_any())
    None => json_impl(data.to_any(), @js.undefined())
  }
}

///|
extern "js" fn json_impl(data : @js.Any, options : @js.Any) -> Response =
  #| (data, options) => Response.json(data, options)

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/error_static
pub extern "js" fn Response::error() -> Response =
  #| () => Response.error()

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/json
pub extern "js" fn Response::json(self : Self) -> @js.Promise[@js.Any] =
  #| (v) => v.json()

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/text
pub extern "js" fn Response::text(self : Self) -> @js.Promise[String] =
  #| (v) => v.text()

///|
pub extern "js" fn Response::form_data(self : Self) -> @js.Promise[FormData] =
  #| (v) => v.formData()

///|
pub extern "js" fn Response::bytes(
  self : Self,
) -> @js.Promise[@typedarray.Uint8Array] =
  #| (v) => v.bytes()

///|
pub extern "js" fn Response::clone(self : Self) -> Response =
  #| (v) => v.clone()

///|
/// Get the response type
/// Note: This is a method because "type" is a reserved word in MoonBit
pub extern "js" fn Response::type_(self : Self) -> String =
  #| (v) => v.type

///|
/// Get the body as a ReadableStream
pub fn Response::body(self : Self) -> @streams.ReadableStream? {
  self.get("body") |> @js.identity_option()
}

///|
/// Create an HTML response
pub extern "js" fn Response::html(body : String, status : Int) -> Response =
  #| (body, status) => new Response(body, { status, headers: { "Content-Type": "text/html" } })

///|
/// Create a text response
pub extern "js" fn Response::text_(body : String, status : Int) -> Response =
  #| (body, status) => new Response(body, { status, headers: { "Content-Type": "text/plain" } })
