///|
/// Hono RPC Client
/// https://hono.dev/docs/guides/rpc

///|
/// HonoClient type for making RPC requests
pub type HonoClient

///|
pub fn HonoClient::as_any(self : HonoClient) -> @core.Any = "%identity"

///|
/// Create a Hono RPC client
/// https://hono.dev/docs/guides/rpc
pub extern "js" fn hc(base_url : String) -> HonoClient =
  #| (baseUrl) => {
  #|   const { hc } = require('hono/client');
  #|   return hc(baseUrl);
  #| }

///|
/// Build request options object from keyword arguments
extern "js" fn build_request_options(
  query : @core.Any,
  form : @core.Any,
  json : @core.Any,
  param : @core.Any,
  header : @core.Any,
  init : @core.Any,
) -> @core.Any =
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
pub fn ClientResponse::as_any(self : ClientResponse) -> @core.Any = "%identity"

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
pub async fn ClientResponse::json(self : ClientResponse) -> @core.Any {
  let promise : @core.Promise[@core.Any] = self
    .as_any()
    ._call("json", [])
    .cast()
  promise.wait()
}

///|
/// Parse response as text
pub async fn ClientResponse::text(self : ClientResponse) -> String {
  let promise : @core.Promise[String] = self.as_any()._call("text", []).cast()
  promise.wait()
}

///|
/// Parse response as array buffer
#alias(array_buffer)
pub async fn ClientResponse::arrayBuffer(self : ClientResponse) -> @core.Any {
  let promise : @core.Promise[@core.Any] = self
    .as_any()
    ._call("arrayBuffer", [])
    .cast()
  promise.wait()
}

///|
/// Parse response as blob
pub async fn ClientResponse::blob(self : ClientResponse) -> @core.Any {
  let promise : @core.Promise[@core.Any] = self
    .as_any()
    ._call("blob", [])
    .cast()
  promise.wait()
}

///|
/// Get headers from response
pub fn ClientResponse::headers(self : ClientResponse) -> @core.Any {
  self.as_any()["headers"]
}

///|
/// ClientEndpoint represents a path endpoint that can be called with HTTP methods
pub type ClientEndpoint

///|
pub fn ClientEndpoint::as_any(self : ClientEndpoint) -> @core.Any = "%identity"

///|
/// Make a GET request to the endpoint (calls $get method)
/// https://hono.dev/docs/guides/rpc#client
extern "js" fn ffi_call_dollar_get(
  endpoint : @core.Any,
  options : @core.Any,
) -> @core.Any =
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
  query? : @core.Any,
  form? : @core.Any,
  json? : @core.Any,
  param? : @core.Any,
  header? : @core.Any,
  init? : @core.Any,
) -> ClientResponse {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  let promise : @core.Promise[ClientResponse] = if has_options {
    let opts = build_request_options(
      query.unwrap_or(@core.undefined()),
      form.unwrap_or(@core.undefined()),
      json.unwrap_or(@core.undefined()),
      param.unwrap_or(@core.undefined()),
      header.unwrap_or(@core.undefined()),
      init.unwrap_or(@core.undefined()),
    )
    ffi_call_dollar_get(self.as_any(), opts).cast()
  } else {
    ffi_call_dollar_get(self.as_any(), @core.undefined()).cast()
  }
  promise.wait()
}

///|
/// Make a POST request to the endpoint (calls $post method)
extern "js" fn ffi_call_dollar_post(
  endpoint : @core.Any,
  options : @core.Any,
) -> @core.Any =
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
  query? : @core.Any,
  form? : @core.Any,
  json? : @core.Any,
  param? : @core.Any,
  header? : @core.Any,
  init? : @core.Any,
) -> ClientResponse {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  let promise : @core.Promise[ClientResponse] = if has_options {
    let opts = build_request_options(
      query.unwrap_or(@core.undefined()),
      form.unwrap_or(@core.undefined()),
      json.unwrap_or(@core.undefined()),
      param.unwrap_or(@core.undefined()),
      header.unwrap_or(@core.undefined()),
      init.unwrap_or(@core.undefined()),
    )
    ffi_call_dollar_post(self.as_any(), opts).cast()
  } else {
    ffi_call_dollar_post(self.as_any(), @core.undefined()).cast()
  }
  promise.wait()
}

///|
/// Make a PUT request to the endpoint (calls $put method)
extern "js" fn ffi_call_dollar_put(
  endpoint : @core.Any,
  options : @core.Any,
) -> @core.Any =
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
  query? : @core.Any,
  form? : @core.Any,
  json? : @core.Any,
  param? : @core.Any,
  header? : @core.Any,
  init? : @core.Any,
) -> ClientResponse {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  let promise : @core.Promise[ClientResponse] = if has_options {
    let opts = build_request_options(
      query.unwrap_or(@core.undefined()),
      form.unwrap_or(@core.undefined()),
      json.unwrap_or(@core.undefined()),
      param.unwrap_or(@core.undefined()),
      header.unwrap_or(@core.undefined()),
      init.unwrap_or(@core.undefined()),
    )
    ffi_call_dollar_put(self.as_any(), opts).cast()
  } else {
    ffi_call_dollar_put(self.as_any(), @core.undefined()).cast()
  }
  promise.wait()
}

///|
/// Make a DELETE request to the endpoint (calls $delete method)
extern "js" fn ffi_call_dollar_delete(
  endpoint : @core.Any,
  options : @core.Any,
) -> @core.Any =
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
  query? : @core.Any,
  form? : @core.Any,
  json? : @core.Any,
  param? : @core.Any,
  header? : @core.Any,
  init? : @core.Any,
) -> ClientResponse {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  let promise : @core.Promise[ClientResponse] = if has_options {
    let opts = build_request_options(
      query.unwrap_or(@core.undefined()),
      form.unwrap_or(@core.undefined()),
      json.unwrap_or(@core.undefined()),
      param.unwrap_or(@core.undefined()),
      header.unwrap_or(@core.undefined()),
      init.unwrap_or(@core.undefined()),
    )
    ffi_call_dollar_delete(self.as_any(), opts).cast()
  } else {
    ffi_call_dollar_delete(self.as_any(), @core.undefined()).cast()
  }
  promise.wait()
}

///|
/// Make a PATCH request to the endpoint (calls $patch method)
extern "js" fn ffi_call_dollar_patch(
  endpoint : @core.Any,
  options : @core.Any,
) -> @core.Any =
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
  query? : @core.Any,
  form? : @core.Any,
  json? : @core.Any,
  param? : @core.Any,
  header? : @core.Any,
  init? : @core.Any,
) -> ClientResponse {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  let promise : @core.Promise[ClientResponse] = if has_options {
    let opts = build_request_options(
      query.unwrap_or(@core.undefined()),
      form.unwrap_or(@core.undefined()),
      json.unwrap_or(@core.undefined()),
      param.unwrap_or(@core.undefined()),
      header.unwrap_or(@core.undefined()),
      init.unwrap_or(@core.undefined()),
    )
    ffi_call_dollar_patch(self.as_any(), opts).cast()
  } else {
    ffi_call_dollar_patch(self.as_any(), @core.undefined()).cast()
  }
  promise.wait()
}

///|
/// Get the URL for the endpoint (calls $url method)
extern "js" fn ffi_call_dollar_url(
  endpoint : @core.Any,
  options : @core.Any,
) -> @core.Any =
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
  query? : @core.Any,
  form? : @core.Any,
  json? : @core.Any,
  param? : @core.Any,
  header? : @core.Any,
  init? : @core.Any,
) -> String {
  let has_options = query is Some(_) ||
    form is Some(_) ||
    json is Some(_) ||
    param is Some(_) ||
    header is Some(_) ||
    init is Some(_)
  if has_options {
    let opts = build_request_options(
      query.unwrap_or(@core.undefined()),
      form.unwrap_or(@core.undefined()),
      json.unwrap_or(@core.undefined()),
      param.unwrap_or(@core.undefined()),
      header.unwrap_or(@core.undefined()),
      init.unwrap_or(@core.undefined()),
    )
    ffi_call_dollar_url(self.as_any(), opts).cast()
  } else {
    ffi_call_dollar_url(self.as_any(), @core.undefined()).cast()
  }
}

///|
/// Access a path on the client
/// Original: client[path] or client.path
pub fn HonoClient::path(self : HonoClient, path : String) -> ClientEndpoint {
  self.as_any()[path].cast()
}
