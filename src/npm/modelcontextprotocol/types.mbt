///| JSON-RPC 2.0 Message Types

///|
/// JSON-RPC Request ID - can be string or number
pub enum RequestId {
  String(String)
  Number(Int)
} derive(Show, Eq)

///|
pub fn RequestId::to_js(self : RequestId) -> @js.Js {
  match self {
    String(s) => @js.unsafe_cast(s)
    Number(n) => @js.unsafe_cast(n)
  }
}

///|
pub fn RequestId::from_js(js : @js.Js) -> RequestId? {
  let ty = @js.typeof_(js)
  if ty == "string" {
    let s : String = @js.unsafe_cast(js)
    Some(String(s))
  } else if ty == "number" {
    let n : Int = @js.unsafe_cast(js)
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
  params : @js.Object?
}

///|
pub fn JsonRpcRequest::to_js(self : JsonRpcRequest) -> @js.Object {
  let obj = @js.Object::new()
  obj.set("jsonrpc", self.jsonrpc)
  obj.set("id", self.id.to_js())
  obj.set("method", self.method_name)
  match self.params {
    Some(p) => obj.set("params", p)
    None => ()
  }
  obj
}

///|
pub fn JsonRpcRequest::from_js(js : @js.Js) -> JsonRpcRequest? {
  let obj : @js.Object = @js.unsafe_cast(js)
  let jsonrpc : String? = obj.get("jsonrpc") |> @js.unsafe_cast_option()
  let id_js = obj.get("id")
  let method_name : String? = obj.get("method") |> @js.unsafe_cast_option()
  match (jsonrpc, method_name) {
    (Some(jrpc), Some(m)) =>
      match RequestId::from_js(id_js) {
        Some(id) =>
          Some({
            jsonrpc: jrpc,
            id,
            method_name: m,
            params: obj.get("params") |> @js.unsafe_cast_option(),
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
  result : @js.Js
}

///|
pub fn JsonRpcResponse::to_js(self : JsonRpcResponse) -> @js.Object {
  let obj = @js.Object::new()
  obj.set("jsonrpc", self.jsonrpc)
  obj.set("id", self.id.to_js())
  obj.set("result", self.result)
  obj
}

///|
/// JSON-RPC Error Response
pub struct JsonRpcError {
  code : Int
  message : String
  data : @js.Js?
}

///|
pub fn JsonRpcError::to_js(self : JsonRpcError) -> @js.Object {
  let obj = @js.Object::new()
  obj.set("code", self.code)
  obj.set("message", self.message)
  match self.data {
    Some(d) => obj.set("data", d)
    None => ()
  }
  obj
}

///|
pub struct JsonRpcErrorResponse {
  jsonrpc : String // Always "2.0"
  id : RequestId
  error : JsonRpcError
}

///|
pub fn JsonRpcErrorResponse::to_js(self : JsonRpcErrorResponse) -> @js.Object {
  let obj = @js.Object::new()
  obj.set("jsonrpc", self.jsonrpc)
  obj.set("id", self.id.to_js())
  obj.set("error", self.error.to_js())
  obj
}

///|
/// JSON-RPC Notification (no response expected)
pub(all) struct JsonRpcNotification {
  jsonrpc : String // Always "2.0"
  method_name : String
  params : @js.Object?
}

///|
pub fn JsonRpcNotification::to_js(self : JsonRpcNotification) -> @js.Object {
  let obj = @js.Object::new()
  obj.set("jsonrpc", self.jsonrpc)
  obj.set("method", self.method_name)
  match self.params {
    Some(p) => obj.set("params", p)
    None => ()
  }
  obj
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
