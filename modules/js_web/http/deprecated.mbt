// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `Response(..)` constructor.
#deprecated("use `Response(..)` instead")
pub fn Response::new(
  body? : String,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> Response {
  Response(body?, status?, statusText?, headers?)
}

///|
/// Deprecated alias for the `RequestInit(..)` constructor.
#deprecated("use `RequestInit(..)` instead")
pub fn RequestInit::new(
  http_method? : String = "GET",
  headers? : Headers,
  body? : @core.Any,
  mode? : String,
  credentials? : String,
  cache? : String,
  redirect? : String,
  referrer? : String,
  referrerPolicy? : String,
  integrity? : String,
  keepalive? : Bool,
  signal? : @js_async.AbortSignal,
  priority? : String,
) -> RequestInit {
  RequestInit(
    http_method~,
    headers?,
    body?,
    mode?,
    credentials?,
    cache?,
    redirect?,
    referrer?,
    referrerPolicy?,
    integrity?,
    keepalive?,
    signal?,
    priority?,
  )
}

///|
/// Deprecated alias for the `Request(..)` constructor.
#deprecated("use `Request(..)` instead")
pub fn Request::new(url : String) -> Request {
  Request(url)
}

///|
/// Deprecated alias for `Request(url, init~)`.
#deprecated("use `Request(url, init~)` instead")
pub fn Request::new_with_init(url : String, init : RequestInit) -> Request {
  Request(url, init~)
}

///|
/// Deprecated alias for `Response::from_body_init(..)`.
#deprecated("use `Response::from_body_init(..)` instead")
pub fn Response::new_with_body(
  body? : @core.Any,
  status? : Int,
  statusText? : String,
  headers? : @core.Any,
) -> Response {
  Response::from_body_init(body?, status?, statusText?, headers?)
}
