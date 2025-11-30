///| JSON-RPC 2.0 Message Types

///|
/// JSON-RPC Request ID - can be string or number
pub enum RequestId {
  String(String)
  Number(Int)
} derive(Show, Eq)

///|
pub fn RequestId::as_any(self : RequestId) -> @js.Any {
  match self {
    String(s) => @js.identity(s)
    Number(n) => @js.identity(n)
  }
}

///|
pub fn RequestId::from_js(js : @js.Any) -> RequestId? {
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
  params : @js.Any?
}

///|
pub fn JsonRpcRequest::as_any(self : JsonRpcRequest) -> @js.Any {
  @js.from_option_map({
    "jsonrpc": Some(@js.any(self.jsonrpc)),
    "id": Some(self.id.as_any()),
    "method": Some(@js.any(self.method_name)),
    "params": self.params,
  })
}

///|
pub fn JsonRpcRequest::from_js(js : @js.Any) -> JsonRpcRequest? {
  let obj : @js.Object = @js.identity(js)
  let jsonrpc : String? = obj.get("jsonrpc") |> @js.identity_option()
  let id_js = obj.get("id")
  let method_name : String? = obj.get("method") |> @js.identity_option()
  match (jsonrpc, method_name) {
    (Some(jrpc), Some(m)) =>
      match RequestId::from_js(id_js) {
        Some(id) =>
          Some({
            jsonrpc: jrpc,
            id,
            method_name: m,
            params: obj.get("params") |> @js.identity_option(),
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
  result : @js.Any
}

///|
pub fn JsonRpcResponse::as_any(self : JsonRpcResponse) -> @js.Any {
  @js.from_map({
    "jsonrpc": @js.any(self.jsonrpc),
    "id": self.id.as_any(),
    "result": self.result,
  })
}

///|
/// JSON-RPC Error Response
pub struct JsonRpcError {
  code : Int
  message : String
  data : @js.Any?
}

///|
pub fn JsonRpcError::as_any(self : JsonRpcError) -> @js.Any {
  @js.from_option_map({
    "code": Some(@js.any(self.code)),
    "message": Some(@js.any(self.message)),
    "data": self.data,
  })
}

///|
pub struct JsonRpcErrorResponse {
  jsonrpc : String // Always "2.0"
  id : RequestId
  error : JsonRpcError
}

///|
pub fn JsonRpcErrorResponse::as_any(self : JsonRpcErrorResponse) -> @js.Any {
  @js.from_map({
    "jsonrpc": @js.any(self.jsonrpc),
    "id": self.id.as_any(),
    "error": self.error.as_any(),
  })
}

///|
/// JSON-RPC Notification (no response expected)
pub(all) struct JsonRpcNotification {
  jsonrpc : String // Always "2.0"
  method_name : String
  params : @js.Any?
}

///|
pub fn JsonRpcNotification::as_any(self : JsonRpcNotification) -> @js.Any {
  @js.from_option_map({
    "jsonrpc": Some(@js.any(self.jsonrpc)),
    "method": Some(@js.any(self.method_name)),
    "params": self.params,
  })
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
