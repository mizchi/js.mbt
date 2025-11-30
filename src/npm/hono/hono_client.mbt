///|
/// Hono RPC Client
/// https://hono.dev/docs/guides/rpc

///|
/// HonoClient type for making RPC requests
pub type HonoClient

///|
pub fn HonoClient::as_any(self : HonoClient) -> @nostd.Any = "%identity"

///|
/// Create a new Hono RPC client
/// https://hono.dev/docs/guides/rpc
extern "js" fn ffi_hc(base_url : String) -> @nostd.Any =
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
  query : @nostd.Any,
  form : @nostd.Any,
  json : @nostd.Any,
  param : @nostd.Any,
  header : @nostd.Any,
  init : @nostd.Any,
) -> @nostd.Any =
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
pub fn ClientResponse::as_any(self : ClientResponse) -> @nostd.Any = "%identity"

///|
/// Check if response is ok
pub fn ClientResponse::ok(self : ClientResponse) -> Bool {
  self.as_any()["ok"].cast()
}

///|
/// Get response status
pub fn ClientResponse::status(self : ClientResponse) -> Int {
  self.as_any()["status"].cast()
}

///|
/// Parse response as JSON
pub async fn ClientResponse::json(self : ClientResponse) -> @nostd.Any {
  let promise : @nostd.Promise[@nostd.Any] = self
    .as_any()
    ._call("json", [])
    .cast()
  promise.wait()
}

///|
/// Parse response as text
pub async fn ClientResponse::text(self : ClientResponse) -> String {
  let promise : @nostd.Promise[String] = self.as_any()._call("text", []).cast()
  promise.wait()
}

///|
/// Parse response as array buffer
#alias(array_buffer)
pub async fn ClientResponse::arrayBuffer(self : ClientResponse) -> @nostd.Any {
  let promise : @nostd.Promise[@nostd.Any] = self
    .as_any()
    ._call("arrayBuffer", [])
    .cast()
  promise.wait()
}

///|
/// Parse response as blob
pub async fn ClientResponse::blob(self : ClientResponse) -> @nostd.Any {
  let promise : @nostd.Promise[@nostd.Any] = self
    .as_any()
    ._call("blob", [])
    .cast()
  promise.wait()
}

///|
/// Get headers from response
pub fn ClientResponse::headers(self : ClientResponse) -> @nostd.Any {
  self.as_any()["headers"]
}

///|
/// ClientEndpoint represents a path endpoint that can be called with HTTP methods
pub type ClientEndpoint

///|
pub fn ClientEndpoint::as_any(self : ClientEndpoint) -> @nostd.Any = "%identity"

///|
/// Make a GET request to the endpoint (calls $get method)
/// https://hono.dev/docs/guides/rpc#client
extern "js" fn ffi_call_dollar_get(
  endpoint : @nostd.Any,
  options : @nostd.Any,
) -> @nostd.Any =
  #| (endpoint, options) => {
  #|   if (options === undefined) {
  #|     return endpoint.$get();
  #|   }
  #|   return endpoint.$get(options);
  #| }

///|
/// Make a GET request to the endpoint
/// Original: endpoint.$get(options)
pub async fn ClientEndpoint::get_(
  self : ClientEndpoint,
  query? : @nostd.Any,
  form? : @nostd.Any,
  json? : @nostd.Any,
  param? : @nostd.Any,
  header? : @nostd.Any,
  init? : @nostd.Any,
) -> ClientResponse {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  let promise : @nostd.Promise[ClientResponse] = if has_options {
    let opts = build_request_options(
      query.unwrap_or(@nostd.undefined()),
      form.unwrap_or(@nostd.undefined()),
      json.unwrap_or(@nostd.undefined()),
      param.unwrap_or(@nostd.undefined()),
      header.unwrap_or(@nostd.undefined()),
      init.unwrap_or(@nostd.undefined()),
    )
    ffi_call_dollar_get(self.as_any(), opts).cast()
  } else {
    ffi_call_dollar_get(self.as_any(), @nostd.undefined()).cast()
  }
  promise.wait()
}

///|
/// Make a POST request to the endpoint (calls $post method)
extern "js" fn ffi_call_dollar_post(
  endpoint : @nostd.Any,
  options : @nostd.Any,
) -> @nostd.Any =
  #| (endpoint, options) => {
  #|   if (options === undefined) {
  #|     return endpoint.$post();
  #|   }
  #|   return endpoint.$post(options);
  #| }

///|
/// Make a POST request to the endpoint
/// Original: endpoint.$post(options)
pub async fn ClientEndpoint::post_(
  self : ClientEndpoint,
  query? : @nostd.Any,
  form? : @nostd.Any,
  json? : @nostd.Any,
  param? : @nostd.Any,
  header? : @nostd.Any,
  init? : @nostd.Any,
) -> ClientResponse {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  let promise : @nostd.Promise[ClientResponse] = if has_options {
    let opts = build_request_options(
      query.unwrap_or(@nostd.undefined()),
      form.unwrap_or(@nostd.undefined()),
      json.unwrap_or(@nostd.undefined()),
      param.unwrap_or(@nostd.undefined()),
      header.unwrap_or(@nostd.undefined()),
      init.unwrap_or(@nostd.undefined()),
    )
    ffi_call_dollar_post(self.as_any(), opts).cast()
  } else {
    ffi_call_dollar_post(self.as_any(), @nostd.undefined()).cast()
  }
  promise.wait()
}

///|
/// Make a PUT request to the endpoint (calls $put method)
extern "js" fn ffi_call_dollar_put(
  endpoint : @nostd.Any,
  options : @nostd.Any,
) -> @nostd.Any =
  #| (endpoint, options) => {
  #|   if (options === undefined) {
  #|     return endpoint.$put();
  #|   }
  #|   return endpoint.$put(options);
  #| }

///|
/// Make a PUT request to the endpoint
/// Original: endpoint.$put(options)
pub async fn ClientEndpoint::put_(
  self : ClientEndpoint,
  query? : @nostd.Any,
  form? : @nostd.Any,
  json? : @nostd.Any,
  param? : @nostd.Any,
  header? : @nostd.Any,
  init? : @nostd.Any,
) -> ClientResponse {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  let promise : @nostd.Promise[ClientResponse] = if has_options {
    let opts = build_request_options(
      query.unwrap_or(@nostd.undefined()),
      form.unwrap_or(@nostd.undefined()),
      json.unwrap_or(@nostd.undefined()),
      param.unwrap_or(@nostd.undefined()),
      header.unwrap_or(@nostd.undefined()),
      init.unwrap_or(@nostd.undefined()),
    )
    ffi_call_dollar_put(self.as_any(), opts).cast()
  } else {
    ffi_call_dollar_put(self.as_any(), @nostd.undefined()).cast()
  }
  promise.wait()
}

///|
/// Make a DELETE request to the endpoint (calls $delete method)
extern "js" fn ffi_call_dollar_delete(
  endpoint : @nostd.Any,
  options : @nostd.Any,
) -> @nostd.Any =
  #| (endpoint, options) => {
  #|   if (options === undefined) {
  #|     return endpoint.$delete();
  #|   }
  #|   return endpoint.$delete(options);
  #| }

///|
/// Make a DELETE request to the endpoint
/// Original: endpoint.$delete(options)
pub async fn ClientEndpoint::delete_(
  self : ClientEndpoint,
  query? : @nostd.Any,
  form? : @nostd.Any,
  json? : @nostd.Any,
  param? : @nostd.Any,
  header? : @nostd.Any,
  init? : @nostd.Any,
) -> ClientResponse {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  let promise : @nostd.Promise[ClientResponse] = if has_options {
    let opts = build_request_options(
      query.unwrap_or(@nostd.undefined()),
      form.unwrap_or(@nostd.undefined()),
      json.unwrap_or(@nostd.undefined()),
      param.unwrap_or(@nostd.undefined()),
      header.unwrap_or(@nostd.undefined()),
      init.unwrap_or(@nostd.undefined()),
    )
    ffi_call_dollar_delete(self.as_any(), opts).cast()
  } else {
    ffi_call_dollar_delete(self.as_any(), @nostd.undefined()).cast()
  }
  promise.wait()
}

///|
/// Make a PATCH request to the endpoint (calls $patch method)
extern "js" fn ffi_call_dollar_patch(
  endpoint : @nostd.Any,
  options : @nostd.Any,
) -> @nostd.Any =
  #| (endpoint, options) => {
  #|   if (options === undefined) {
  #|     return endpoint.$patch();
  #|   }
  #|   return endpoint.$patch(options);
  #| }

///|
/// Make a PATCH request to the endpoint
/// Original: endpoint.$patch(options)
pub async fn ClientEndpoint::patch_(
  self : ClientEndpoint,
  query? : @nostd.Any,
  form? : @nostd.Any,
  json? : @nostd.Any,
  param? : @nostd.Any,
  header? : @nostd.Any,
  init? : @nostd.Any,
) -> ClientResponse {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  let promise : @nostd.Promise[ClientResponse] = if has_options {
    let opts = build_request_options(
      query.unwrap_or(@nostd.undefined()),
      form.unwrap_or(@nostd.undefined()),
      json.unwrap_or(@nostd.undefined()),
      param.unwrap_or(@nostd.undefined()),
      header.unwrap_or(@nostd.undefined()),
      init.unwrap_or(@nostd.undefined()),
    )
    ffi_call_dollar_patch(self.as_any(), opts).cast()
  } else {
    ffi_call_dollar_patch(self.as_any(), @nostd.undefined()).cast()
  }
  promise.wait()
}

///|
/// Get the URL for the endpoint (calls $url method)
extern "js" fn ffi_call_dollar_url(
  endpoint : @nostd.Any,
  options : @nostd.Any,
) -> @nostd.Any =
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
  query? : @nostd.Any,
  form? : @nostd.Any,
  json? : @nostd.Any,
  param? : @nostd.Any,
  header? : @nostd.Any,
  init? : @nostd.Any,
) -> String {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  if has_options {
    let opts = build_request_options(
      query.unwrap_or(@nostd.undefined()),
      form.unwrap_or(@nostd.undefined()),
      json.unwrap_or(@nostd.undefined()),
      param.unwrap_or(@nostd.undefined()),
      header.unwrap_or(@nostd.undefined()),
      init.unwrap_or(@nostd.undefined()),
    )
    ffi_call_dollar_url(self.as_any(), opts).cast()
  } else {
    ffi_call_dollar_url(self.as_any(), @nostd.undefined()).cast()
  }
}

///|
/// Access a path on the client
/// Original: client[path] or client.path
pub fn HonoClient::path(self : HonoClient, path : String) -> ClientEndpoint {
  self.as_any()[path].cast()
}
