///| JSON-RPC 2.0 Message Types

///|
/// JSON-RPC Request ID - can be string or number
pub enum RequestId {
  String(String)
  Number(Int)
} derive(Show, Eq)

///|
pub fn RequestId::as_any(self : RequestId) -> @core.Any {
  match self {
    String(s) => @core.identity(s)
    Number(n) => @core.identity(n)
  }
}

///|
pub fn RequestId::from_js(js : @core.Any) -> RequestId? {
  let ty = @core.typeof_(js)
  if ty == "string" {
    let s : String = @core.identity(js)
    Some(String(s))
  } else if ty == "number" {
    let n : Int = @core.identity(js)
    Some(Number(n))
  } else {
    None
  }
}

///|
/// JSON-RPC Request
pub struct JsonRpcRequest {
  jsonrpc : String // Always "2.0"
  id : RequestId
  method_name : String
  params : @core.Any?
}

///|
pub fn JsonRpcRequest::as_any(self : JsonRpcRequest) -> @core.Any {
  let entries : Array[(String, @core.Any)] = [
    ("jsonrpc", @core.any(self.jsonrpc)),
    ("id", @core.identity(self.id.as_any())),
    ("method", @core.any(self.method_name)),
  ]
  if self.params is Some(p) {
    entries.push(("params", @core.identity(p)))
  }
  @core.from_entries(entries).cast()
}

///|
pub fn JsonRpcRequest::from_js(js : @core.Any) -> JsonRpcRequest? {
  let obj : @js.Object = @core.identity(js)
  let jsonrpc : String? = @core.any(obj)._get("jsonrpc")
    |> @core.identity_option()
  let id_js = @core.any(obj)._get("id")
  let method_name : String? = @core.any(obj)._get("method")
    |> @core.identity_option()
  match (jsonrpc, method_name) {
    (Some(jrpc), Some(m)) =>
      match RequestId::from_js(id_js) {
        Some(id) =>
          Some({
            jsonrpc: jrpc,
            id,
            method_name: m,
            params: @core.any(obj)._get("params") |> @core.identity_option(),
          })
        None => None
      }
    _ => None
  }
}

///|
/// JSON-RPC Success Response
pub struct JsonRpcResponse {
  jsonrpc : String // Always "2.0"
  id : RequestId
  result : @core.Any
}

///|
pub fn JsonRpcResponse::as_any(self : JsonRpcResponse) -> @core.Any {
  @core.identity(
    @core.from_entries([
      ("jsonrpc", @core.any(self.jsonrpc)),
      ("id", @core.any(self.id.as_any())),
      ("result", @core.any(self.result)),
    ]),
  )
}

///|
/// JSON-RPC Error Response
pub struct JsonRpcError {
  code : Int
  message : String
  data : @core.Any?
}

///|
pub fn JsonRpcError::as_any(self : JsonRpcError) -> @core.Any {
  let entries : Array[(String, @core.Any)] = [
    ("code", @core.any(self.code)),
    ("message", @core.any(self.message)),
  ]
  if self.data is Some(d) {
    entries.push(("data", @core.identity(d)))
  }
  @core.from_entries(entries).cast()
}

///|
pub struct JsonRpcErrorResponse {
  jsonrpc : String // Always "2.0"
  id : RequestId
  error : JsonRpcError
}

///|
pub fn JsonRpcErrorResponse::as_any(self : JsonRpcErrorResponse) -> @core.Any {
  @core.identity(
    @core.from_entries([
      ("jsonrpc", @core.any(self.jsonrpc)),
      ("id", @core.any(self.id.as_any())),
      ("error", @core.any(self.error.as_any())),
    ]),
  )
}

///|
/// JSON-RPC Notification (no response expected)
pub(all) struct JsonRpcNotification {
  jsonrpc : String // Always "2.0"
  method_name : String
  params : @core.Any?
}

///|
pub fn JsonRpcNotification::as_any(self : JsonRpcNotification) -> @core.Any {
  let entries : Array[(String, @core.Any)] = [
    ("jsonrpc", @core.any(self.jsonrpc)),
    ("method", @core.any(self.method_name)),
  ]
  if self.params is Some(p) {
    entries.push(("params", @core.identity(p)))
  }
  @core.from_entries(entries).cast()
}

///|
/// Standard JSON-RPC Error Codes
pub let parse_error : Int = -32700

///|
pub let invalid_request : Int = -32600

///|
pub let method_not_found : Int = -32601

///|
pub let invalid_params : Int = -32602

///|
pub let internal_error : Int = -32603
