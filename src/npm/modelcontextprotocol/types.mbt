///| JSON-RPC 2.0 Message Types

///|
/// JSON-RPC Request ID - can be string or number
pub enum RequestId {
  String(String)
  Number(Int)
} derive(Show, Eq)

///|
pub fn RequestId::as_any(self : RequestId) -> @nostd.Any {
  match self {
    String(s) => @js.identity(s)
    Number(n) => @js.identity(n)
  }
}

///|
pub fn RequestId::from_js(js : @nostd.Any) -> RequestId? {
  let ty = @js.typeof_(js)
  if ty == "string" {
    let s : String = @js.identity(js)
    Some(String(s))
  } else if ty == "number" {
    let n : Int = @js.identity(js)
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
  params : @nostd.Any?
}

///|
pub fn JsonRpcRequest::as_any(self : JsonRpcRequest) -> @nostd.Any {
  @mbtconv.from_option_map({
    "jsonrpc": Some(@nostd.any(self.jsonrpc)),
    "id": Some(@nostd.identity(self.id.as_any())),
    "method": Some(@nostd.any(self.method_name)),
    "params": self.params.map(fn(x) { @nostd.identity(x) }),
  }).cast()
}

///|
pub fn JsonRpcRequest::from_js(js : @nostd.Any) -> JsonRpcRequest? {
  let obj : @js.Object = @js.identity(js)
  let jsonrpc : String? = obj._get("jsonrpc") |> @js.identity_option()
  let id_js = obj._get("id")
  let method_name : String? = obj._get("method") |> @js.identity_option()
  match (jsonrpc, method_name) {
    (Some(jrpc), Some(m)) =>
      match RequestId::from_js(id_js) {
        Some(id) =>
          Some({
            jsonrpc: jrpc,
            id,
            method_name: m,
            params: obj._get("params") |> @js.identity_option(),
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
  result : @nostd.Any
}

///|
pub fn JsonRpcResponse::as_any(self : JsonRpcResponse) -> @nostd.Any {
  @js.identity(
    @mbtconv.from_map({
      "jsonrpc": @nostd.any(self.jsonrpc),
      "id": @nostd.any(self.id.as_any()),
      "result": @nostd.any(self.result),
    }),
  )
}

///|
/// JSON-RPC Error Response
pub struct JsonRpcError {
  code : Int
  message : String
  data : @nostd.Any?
}

///|
pub fn JsonRpcError::as_any(self : JsonRpcError) -> @nostd.Any {
  @mbtconv.from_option_map({
    "code": Some(@nostd.any(self.code)),
    "message": Some(@nostd.any(self.message)),
    "data": self.data.map(fn(x) { @nostd.identity(x) }),
  }).cast()
}

///|
pub struct JsonRpcErrorResponse {
  jsonrpc : String // Always "2.0"
  id : RequestId
  error : JsonRpcError
}

///|
pub fn JsonRpcErrorResponse::as_any(self : JsonRpcErrorResponse) -> @nostd.Any {
  @js.identity(
    @mbtconv.from_map({
      "jsonrpc": @nostd.any(self.jsonrpc),
      "id": @nostd.any(self.id.as_any()),
      "error": @nostd.any(self.error.as_any()),
    }),
  )
}

///|
/// JSON-RPC Notification (no response expected)
pub(all) struct JsonRpcNotification {
  jsonrpc : String // Always "2.0"
  method_name : String
  params : @nostd.Any?
}

///|
pub fn JsonRpcNotification::as_any(self : JsonRpcNotification) -> @nostd.Any {
  @mbtconv.from_option_map({
    "jsonrpc": Some(@nostd.any(self.jsonrpc)),
    "method": Some(@nostd.any(self.method_name)),
    "params": self.params.map(fn(x) { @nostd.identity(x) }),
  }).cast()
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
