///|
/// Hono RPC Client
/// https://hono.dev/docs/guides/rpc

///|
/// HonoClient type for making RPC requests
pub type HonoClient

///|
pub impl @js.JsImpl for HonoClient

///|
/// Create a new Hono RPC client
/// https://hono.dev/docs/guides/rpc
extern "js" fn ffi_hc(base_url : String) -> @js.Any =
  #| (baseUrl) => {
  #|   const { hc } = require('hono/client');
  #|   return hc(baseUrl);
  #| }

///|
/// Create a Hono RPC client
pub fn hc(base_url : String) -> HonoClient {
  ffi_hc(base_url).cast()
}

///|
/// Build request options object from keyword arguments
extern "js" fn build_request_options(
  query : @js.Any,
  form : @js.Any,
  json : @js.Any,
  param : @js.Any,
  header : @js.Any,
  init : @js.Any,
) -> @js.Any =
  #| (query, form, json, param, header, init) => {
  #|   const obj = {};
  #|   if (query !== undefined) obj.query = query;
  #|   if (form !== undefined) obj.form = form;
  #|   if (json !== undefined) obj.json = json;
  #|   if (param !== undefined) obj.param = param;
  #|   if (header !== undefined) obj.header = header;
  #|   if (init !== undefined) obj.init = init;
  #|   return obj;
  #| }

///|
/// ClientResponse type wrapping Response
pub type ClientResponse

///|
pub impl @js.JsImpl for ClientResponse

///|
/// Check if response is ok
pub fn ClientResponse::ok(self : ClientResponse) -> Bool {
  self.get("ok").cast()
}

///|
/// Get response status
pub fn ClientResponse::status(self : ClientResponse) -> Int {
  self.get("status").cast()
}

///|
/// Parse response as JSON
pub fn ClientResponse::json(self : ClientResponse) -> @js.Promise[@js.Any] {
  self.call0("json").cast()
}

///|
/// Parse response as text
pub fn ClientResponse::text(self : ClientResponse) -> @js.Promise[String] {
  self.call0("text").cast()
}

///|
/// Parse response as array buffer
#alias(array_buffer)
pub fn ClientResponse::arrayBuffer(
  self : ClientResponse,
) -> @js.Promise[@js.ArrayBuffer] {
  self.call0("arrayBuffer").cast()
}

///|
/// Parse response as blob
pub fn ClientResponse::blob(self : ClientResponse) -> @js.Promise[@js.Any] {
  self.call0("blob").cast()
}

///|
/// Get headers from response
pub fn ClientResponse::headers(self : ClientResponse) -> @js.Any {
  self.get("headers")
}

///|
/// ClientEndpoint represents a path endpoint that can be called with HTTP methods
pub type ClientEndpoint

///|
pub impl @js.JsImpl for ClientEndpoint

///|
/// Make a GET request to the endpoint (calls $get method)
/// https://hono.dev/docs/guides/rpc#client
extern "js" fn ffi_call_dollar_get(
  endpoint : @js.Any,
  options : @js.Any,
) -> @js.Any =
  #| (endpoint, options) => {
  #|   if (options === undefined) {
  #|     return endpoint.$get();
  #|   }
  #|   return endpoint.$get(options);
  #| }

///|
/// Make a GET request to the endpoint
/// Original: endpoint.$get(options)
pub fn ClientEndpoint::get_(
  self : ClientEndpoint,
  query? : @js.Any,
  form? : @js.Any,
  json? : @js.Any,
  param? : @js.Any,
  header? : @js.Any,
  init? : @js.Any,
) -> @js.Promise[ClientResponse] {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  if has_options {
    let opts = build_request_options(
      query.unwrap_or(@js.undefined()),
      form.unwrap_or(@js.undefined()),
      json.unwrap_or(@js.undefined()),
      param.unwrap_or(@js.undefined()),
      header.unwrap_or(@js.undefined()),
      init.unwrap_or(@js.undefined()),
    )
    ffi_call_dollar_get(@js.identity(self), opts).cast()
  } else {
    ffi_call_dollar_get(@js.identity(self), @js.undefined()).cast()
  }
}

///|
/// Make a POST request to the endpoint (calls $post method)
extern "js" fn ffi_call_dollar_post(
  endpoint : @js.Any,
  options : @js.Any,
) -> @js.Any =
  #| (endpoint, options) => {
  #|   if (options === undefined) {
  #|     return endpoint.$post();
  #|   }
  #|   return endpoint.$post(options);
  #| }

///|
/// Make a POST request to the endpoint
/// Original: endpoint.$post(options)
pub fn ClientEndpoint::post_(
  self : ClientEndpoint,
  query? : @js.Any,
  form? : @js.Any,
  json? : @js.Any,
  param? : @js.Any,
  header? : @js.Any,
  init? : @js.Any,
) -> @js.Promise[ClientResponse] {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  if has_options {
    let opts = build_request_options(
      query.unwrap_or(@js.undefined()),
      form.unwrap_or(@js.undefined()),
      json.unwrap_or(@js.undefined()),
      param.unwrap_or(@js.undefined()),
      header.unwrap_or(@js.undefined()),
      init.unwrap_or(@js.undefined()),
    )
    ffi_call_dollar_post(@js.identity(self), opts).cast()
  } else {
    ffi_call_dollar_post(@js.identity(self), @js.undefined()).cast()
  }
}

///|
/// Make a PUT request to the endpoint (calls $put method)
extern "js" fn ffi_call_dollar_put(
  endpoint : @js.Any,
  options : @js.Any,
) -> @js.Any =
  #| (endpoint, options) => {
  #|   if (options === undefined) {
  #|     return endpoint.$put();
  #|   }
  #|   return endpoint.$put(options);
  #| }

///|
/// Make a PUT request to the endpoint
/// Original: endpoint.$put(options)
pub fn ClientEndpoint::put_(
  self : ClientEndpoint,
  query? : @js.Any,
  form? : @js.Any,
  json? : @js.Any,
  param? : @js.Any,
  header? : @js.Any,
  init? : @js.Any,
) -> @js.Promise[ClientResponse] {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  if has_options {
    let opts = build_request_options(
      query.unwrap_or(@js.undefined()),
      form.unwrap_or(@js.undefined()),
      json.unwrap_or(@js.undefined()),
      param.unwrap_or(@js.undefined()),
      header.unwrap_or(@js.undefined()),
      init.unwrap_or(@js.undefined()),
    )
    ffi_call_dollar_put(@js.identity(self), opts).cast()
  } else {
    ffi_call_dollar_put(@js.identity(self), @js.undefined()).cast()
  }
}

///|
/// Make a DELETE request to the endpoint (calls $delete method)
extern "js" fn ffi_call_dollar_delete(
  endpoint : @js.Any,
  options : @js.Any,
) -> @js.Any =
  #| (endpoint, options) => {
  #|   if (options === undefined) {
  #|     return endpoint.$delete();
  #|   }
  #|   return endpoint.$delete(options);
  #| }

///|
/// Make a DELETE request to the endpoint
/// Original: endpoint.$delete(options)
pub fn ClientEndpoint::delete_(
  self : ClientEndpoint,
  query? : @js.Any,
  form? : @js.Any,
  json? : @js.Any,
  param? : @js.Any,
  header? : @js.Any,
  init? : @js.Any,
) -> @js.Promise[ClientResponse] {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  if has_options {
    let opts = build_request_options(
      query.unwrap_or(@js.undefined()),
      form.unwrap_or(@js.undefined()),
      json.unwrap_or(@js.undefined()),
      param.unwrap_or(@js.undefined()),
      header.unwrap_or(@js.undefined()),
      init.unwrap_or(@js.undefined()),
    )
    ffi_call_dollar_delete(@js.identity(self), opts).cast()
  } else {
    ffi_call_dollar_delete(@js.identity(self), @js.undefined()).cast()
  }
}

///|
/// Make a PATCH request to the endpoint (calls $patch method)
extern "js" fn ffi_call_dollar_patch(
  endpoint : @js.Any,
  options : @js.Any,
) -> @js.Any =
  #| (endpoint, options) => {
  #|   if (options === undefined) {
  #|     return endpoint.$patch();
  #|   }
  #|   return endpoint.$patch(options);
  #| }

///|
/// Make a PATCH request to the endpoint
/// Original: endpoint.$patch(options)
pub fn ClientEndpoint::patch_(
  self : ClientEndpoint,
  query? : @js.Any,
  form? : @js.Any,
  json? : @js.Any,
  param? : @js.Any,
  header? : @js.Any,
  init? : @js.Any,
) -> @js.Promise[ClientResponse] {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  if has_options {
    let opts = build_request_options(
      query.unwrap_or(@js.undefined()),
      form.unwrap_or(@js.undefined()),
      json.unwrap_or(@js.undefined()),
      param.unwrap_or(@js.undefined()),
      header.unwrap_or(@js.undefined()),
      init.unwrap_or(@js.undefined()),
    )
    ffi_call_dollar_patch(@js.identity(self), opts).cast()
  } else {
    ffi_call_dollar_patch(@js.identity(self), @js.undefined()).cast()
  }
}

///|
/// Get the URL for the endpoint (calls $url method)
extern "js" fn ffi_call_dollar_url(
  endpoint : @js.Any,
  options : @js.Any,
) -> @js.Any =
  #| (endpoint, options) => {
  #|   if (options === undefined) {
  #|     return endpoint.$url();
  #|   }
  #|   return endpoint.$url(options);
  #| }

///|
/// Get the URL for the endpoint
/// Original: endpoint.$url(options)
pub fn ClientEndpoint::url_(
  self : ClientEndpoint,
  query? : @js.Any,
  form? : @js.Any,
  json? : @js.Any,
  param? : @js.Any,
  header? : @js.Any,
  init? : @js.Any,
) -> String {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  if has_options {
    let opts = build_request_options(
      query.unwrap_or(@js.undefined()),
      form.unwrap_or(@js.undefined()),
      json.unwrap_or(@js.undefined()),
      param.unwrap_or(@js.undefined()),
      header.unwrap_or(@js.undefined()),
      init.unwrap_or(@js.undefined()),
    )
    ffi_call_dollar_url(@js.identity(self), opts).cast()
  } else {
    ffi_call_dollar_url(@js.identity(self), @js.undefined()).cast()
  }
}

///|
/// Access a path on the client
/// Original: client[path] or client.path
pub fn HonoClient::path(self : HonoClient, path : String) -> ClientEndpoint {
  self.get(path).cast()
}
