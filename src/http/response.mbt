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
pub extern "js" fn Response::json_(data : Js, options? : Js) -> Response =
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

///|
/// Create a JSON response with message
pub extern "js" fn Response::json_with_message(
  message : String,
  status : Int,
) -> Response =
  #| (message, status) => Response.json({ message }, { status })

///|
/// Create a JSON response with url
pub extern "js" fn Response::json_with_url(
  url : String,
  status : Int,
) -> Response =
  #| (url, status) => Response.json({ url }, { status })

///|
/// Create a JSON response with error
pub extern "js" fn Response::json_with_error(
  error : String,
  status : Int,
) -> Response =
  #| (error, status) => Response.json({ error }, { status })

///|
/// Create a JSON response with greeting
pub extern "js" fn Response::json_with_greeting(
  greeting : String,
  status : Int,
) -> Response =
  #| (greeting, status) => Response.json({ greeting }, { status })

///|
/// Create a JSON response with timestamp
pub extern "js" fn Response::json_with_timestamp(
  timestamp : Int,
  status : Int,
) -> Response =
  #| (timestamp, status) => Response.json({ timestamp }, { status })

///|
/// Create a JSON response with user agent
pub extern "js" fn Response::json_with_user_agent(
  userAgent : String,
  status : Int,
) -> Response =
  #| (userAgent, status) => Response.json({ userAgent }, { status })

///|
/// Create a JSON response with method
pub extern "js" fn Response::json_with_method(
  method_ : String,
  status : Int,
) -> Response =
  #| (method_, status) => Response.json({ method: method_ }, { status })

///|
/// Create a JSON response with health status
pub extern "js" fn Response::json_with_health(
  status_str : String,
  service : String,
  status : Int,
) -> Response =
  #| (status_str, service, status) => Response.json({ status: status_str, service }, { status })

///|
/// Create a JSON response with result
pub extern "js" fn Response::json_with_result(
  result : String,
  status : Int,
) -> Response =
  #| (result, status) => Response.json({ result }, { status })

///|
/// Create a response with custom headers
pub extern "js" fn Response::with_custom_headers(
  body : String,
  status : Int,
  customHeader : String,
  poweredBy : String,
) -> Response =
  #| (body, status, customHeader, poweredBy) => new Response(body, { status, headers: { "Content-Type": "application/json", "X-Custom-Header": customHeader, "X-Powered-By": poweredBy } })

///|
/// Create a complex JSON response
pub extern "js" fn Response::json_complex() -> Response =
  #| () => Response.json({ status: "ok", data: { foo: "bar", num: 42 }, timestamp: 1234567890 }, { status: 200 })
