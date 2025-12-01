///| MCP Client Implementation

///|
/// MCP Client
pub struct McpClient {
  server_info : ServerInfo?
  mut request_id : Int
  endpoint : String
}

///|
pub fn McpClient::new(endpoint : String) -> McpClient {
  { server_info: None, request_id: 0, endpoint }
}

///|
fn McpClient::next_id(self : McpClient) -> RequestId {
  self.request_id = self.request_id + 1
  Number(self.request_id)
}

///|
/// Create a JSON-RPC request object with params
pub fn McpClient::create_request_with_params(
  self : McpClient,
  method_name : String,
  params : @nostd.Any,
) -> JsonRpcRequest {
  let id = self.next_id()
  // TODO: need Some?
  { jsonrpc: "2.0", id, method_name, params: Some(params) }
}

///|
/// Create a JSON-RPC request object without params
pub fn McpClient::create_request(
  self : McpClient,
  method_name : String,
) -> JsonRpcRequest {
  let id = self.next_id()
  { jsonrpc: "2.0", id, method_name, params: None }
}

///|
/// Get server info (available after initialize)
pub fn McpClient::get_server_info(self : McpClient) -> ServerInfo? {
  self.server_info
}
