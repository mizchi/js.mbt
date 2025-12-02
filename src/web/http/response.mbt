///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response
pub(all) struct Response {
  ok : Bool
  status : Int
  statusText : String
  redirected : Bool
}

///|
pub fn Response::as_any(self : Response) -> @core.Any = "%identity"

///|
/// Create a new Response
/// https://developer.mozilla.org/ja/docs/Web/API/Response/Response
pub fn Response::new(
  body? : String,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> Response {
  let body_js = match body {
    Some(b) => @core.identity(b)
    None => @global.undefined()
  }
  match (status, statusText, headers) {
    (Some(s), Some(st), Some(h)) =>
      new_impl_full(body_js, s, @core.identity(st), h.cast())
    (Some(s), Some(st), None) =>
      new_impl_status_text(body_js, s, @core.identity(st))
    (Some(s), None, Some(h)) => new_impl_status_headers(body_js, s, h.cast())
    (Some(s), None, None) => new_impl_status(body_js, s)
    (None, Some(st), Some(h)) =>
      new_impl_text_headers(body_js, @core.identity(st), h.cast())
    (None, Some(st), None) => new_impl_text(body_js, @core.identity(st))
    (None, None, Some(h)) => new_impl_headers(body_js, h.cast())
    (None, None, None) => new_impl_plain(body_js)
  }
}

///|
extern "js" fn new_impl_full(
  body : @core.Any,
  status : Int,
  statusText : @core.Any,
  headers : @core.Any,
) -> Response =
  #| (body, status, statusText, headers) => new Response(body, { status, statusText, headers })

///|
extern "js" fn new_impl_status_text(
  body : @core.Any,
  status : Int,
  statusText : @core.Any,
) -> Response =
  #| (body, status, statusText) => new Response(body, { status, statusText })

///|
extern "js" fn new_impl_status_headers(
  body : @core.Any,
  status : Int,
  headers : @core.Any,
) -> Response =
  #| (body, status, headers) => new Response(body, { status, headers })

///|
extern "js" fn new_impl_status(body : @core.Any, status : Int) -> Response =
  #| (body, status) => new Response(body, { status })

///|
extern "js" fn new_impl_text_headers(
  body : @core.Any,
  statusText : @core.Any,
  headers : @core.Any,
) -> Response =
  #| (body, statusText, headers) => new Response(body, { statusText, headers })

///|
extern "js" fn new_impl_text(
  body : @core.Any,
  statusText : @core.Any,
) -> Response =
  #| (body, statusText) => new Response(body, { statusText })

///|
extern "js" fn new_impl_headers(
  body : @core.Any,
  headers : @core.Any,
) -> Response =
  #| (body, headers) => new Response(body, { headers })

///|
extern "js" fn new_impl_plain(body : @core.Any) -> Response =
  #| (body) => new Response(body)

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/redirect_static
pub extern "js" fn Response::redirect(url : String, status? : Int) -> Response =
  #| (url, status) => Response

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/json_static
pub fn Response::json_(data : @core.Any, options? : @core.Any) -> Response {
  match options {
    Some(opts) => json_impl(data.cast(), opts.cast())
    None => json_impl(data.cast(), @global.undefined())
  }
}

///|
extern "js" fn json_impl(data : @core.Any, options : @core.Any) -> Response =
  #| (data, options) => Response.json(data, options)

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/error_static
pub extern "js" fn Response::error() -> Response =
  #| () => Response.error()

///|
extern "js" fn ffi_response_json(response : Response) -> @js.Promise[@core.Any] =
  #| (v) => v.json()

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/json
pub async fn Response::json(self : Self) -> @core.Any {
  ffi_response_json(self).wait()
}

///|
extern "js" fn ffi_response_text(response : Response) -> @js.Promise[String] =
  #| (v) => v.text()

///|
/// https://developer.mozilla.org/ja/docs/Web/API/Response/text
pub async fn Response::text(self : Self) -> String {
  ffi_response_text(self).wait()
}

///|
extern "js" fn ffi_response_form_data(
  response : Response,
) -> @js.Promise[FormData] =
  #| (v) => v.formData()

///|
#alias(form_data)
pub async fn Response::formData(self : Self) -> FormData {
  ffi_response_form_data(self).wait()
}

///|
extern "js" fn ffi_response_bytes(
  response : Response,
) -> @js.Promise[@arraybuffer.Uint8Array] =
  #| (v) => v.bytes()

///|
pub async fn Response::bytes(self : Self) -> @arraybuffer.Uint8Array {
  ffi_response_bytes(self).wait()
}

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
  self.as_any()["body"] |> @core.identity_option()
}

///|
/// Create an HTML response
pub extern "js" fn Response::html(body : String, status : Int) -> Response =
  #| (body, status) => new Response(body, { status, headers: { "Content-Type": "text/html" } })

///|
/// Create a text response
pub extern "js" fn Response::text_(body : String, status : Int) -> Response =
  #| (body, status) => new Response(body, { status, headers: { "Content-Type": "text/plain" } })
