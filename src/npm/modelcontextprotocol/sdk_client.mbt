///| MCP TypeScript SDK Client Bindings
/// Bindings for @modelcontextprotocol/sdk client implementation

///|
extern "js" fn require_mcp_client() -> @js.Any =
  #| () => require("@modelcontextprotocol/sdk/client/index.js")

///|
extern "js" fn require_mcp_client_types() -> @js.Any =
  #| () => require("@modelcontextprotocol/sdk/types.js")

///|
extern "js" fn require_stdio_client_transport() -> @js.Any =
  #| () => require("@modelcontextprotocol/sdk/client/stdio.js")

// ============================================================
// Client Types
// ============================================================

///|
/// Native MCP Client from @modelcontextprotocol/sdk
#external
pub type SdkClient

///|
pub impl @js.JsImpl for SdkClient

///|
/// StdioClientTransport from @modelcontextprotocol/sdk
#external
pub type StdioClientTransport

///|
pub impl @js.JsImpl for StdioClientTransport

// ============================================================
// Client Implementation
// ============================================================

///|
/// Create a new MCP SDK Client
pub fn SdkClient::new(name : String, version : String) -> SdkClient {
  let sdk = require_mcp_client()
  let client_class = sdk.get("Client")
  // Build client info
  let client_info = @js.from_map({
    "name": name |> @js.any,
    "version": version |> @js.any,
  })
  // Create client instance with empty capabilities
  let opts = @js.from_map({ "capabilities": @js.Object::new().as_any() })
  ffi_construct_client(client_class, [client_info, opts]) |> @js.identity
}

///|
extern "js" fn ffi_construct_client(
  class_ : @js.Any,
  args : Array[@js.Any],
) -> @js.Any =
  #| (cls, args) => new cls(...args)

///|
extern "js" fn ffi_client_request(
  client : @js.Any,
  request : @js.Any,
  schema : @js.Any,
) -> @js.Promise[@js.Any] =
  #| (client, request, schema) => client.request(request, schema)

///|
extern "js" fn ffi_client_connect(
  client : @js.Any,
  transport : @js.Any,
) -> @js.Promise[Unit] =
  #| (client, transport) => client.connect(transport)

///|
extern "js" fn ffi_client_close(client : @js.Any) -> @js.Promise[Unit] =
  #| (client) => client.close()

///|
/// Connect client to transport
pub async fn SdkClient::connect(
  self : SdkClient,
  transport : StdioClientTransport,
) -> Unit {
  ffi_client_connect(self.as_any(), transport.as_any()).wait()
}

///|
/// Close client
pub async fn SdkClient::close(self : SdkClient) -> Unit {
  ffi_client_close(self.as_any()).wait()
}

// ============================================================
// Tool Operations
// ============================================================

///|
/// List tools result
pub(all) struct ListToolsResult {
  tools : Array[ToolInfo]
  raw : @js.Any
}

///|
/// Tool info from list
pub(all) struct ToolInfo {
  name : String
  description : String?
  input_schema : @js.Any
}

///|
/// List available tools
pub async fn SdkClient::list_tools(self : SdkClient) -> ListToolsResult {
  let request = @js.from_map({ "method": "tools/list" |> @js.any })
  let types = require_mcp_client_types()
  let schema = types.get("ListToolsResultSchema")
  let result = ffi_client_request(self.as_any(), request, schema).wait()
  let tools : Array[ToolInfo] = result.get("tools") |> @js.identity
  { tools, raw: result }
}

///|
/// Call tool result
pub(all) struct CallToolResult {
  content : Array[ContentResult]
  is_error : Bool?
  raw : @js.Any
}

///|
/// Content result from tool call
pub(all) struct ContentResult {
  text : String?
  data : String?
  mime_type : String?
  raw : @js.Any
}

///|
/// Get the type of the content (accesses JS "type" property)
pub fn ContentResult::type_(self : ContentResult) -> String {
  self.raw.get("type").cast()
}

///|
/// Call a tool
pub async fn SdkClient::call_tool(
  self : SdkClient,
  name : String,
  arguments : &@js.JsImpl,
) -> CallToolResult {
  let params = @js.from_map({
    "name": name |> @js.any,
    "arguments": arguments.as_any(),
  })
  let request = @js.from_map({
    "method": "tools/call" |> @js.any,
    "params": params,
  })
  let types = require_mcp_client_types()
  let schema = types.get("CallToolResultSchema")
  let result = ffi_client_request(self.as_any(), request, schema).wait()
  let content : Array[ContentResult] = result.get("content") |> @js.identity
  let is_error : Bool? = result.get("isError") |> @js.identity_option()
  { content, is_error, raw: result }
}

// ============================================================
// Resource Operations
// ============================================================

///|
/// List resources result
pub(all) struct ListResourcesResult {
  resources : Array[ResourceInfo]
  raw : @js.Any
}

///|
/// Resource info from list
pub(all) struct ResourceInfo {
  uri : String
  name : String
  description : String?
  mime_type : String?
}

///|
/// List available resources
pub async fn SdkClient::list_resources(self : SdkClient) -> ListResourcesResult {
  let request = @js.from_map({ "method": "resources/list" |> @js.any })
  let types = require_mcp_client_types()
  let schema = types.get("ListResourcesResultSchema")
  let result = ffi_client_request(self.as_any(), request, schema).wait()
  let resources : Array[ResourceInfo] = result.get("resources") |> @js.identity
  { resources, raw: result }
}

///|
/// Read resource result
pub(all) struct ReadResourceResult {
  contents : Array[ContentResult]
  raw : @js.Any
}

///|
/// Read a resource
pub async fn SdkClient::read_resource(
  self : SdkClient,
  uri : String,
) -> ReadResourceResult {
  let params = @js.from_map({ "uri": uri |> @js.any })
  let request = @js.from_map({
    "method": "resources/read" |> @js.any,
    "params": params,
  })
  let types = require_mcp_client_types()
  let schema = types.get("ReadResourceResultSchema")
  let result = ffi_client_request(self.as_any(), request, schema).wait()
  let contents : Array[ContentResult] = result.get("contents") |> @js.identity
  { contents, raw: result }
}

// ============================================================
// Prompt Operations
// ============================================================

///|
/// List prompts result
pub(all) struct ListPromptsResult {
  prompts : Array[PromptInfo]
  raw : @js.Any
}

///|
/// Prompt info from list
pub(all) struct PromptInfo {
  name : String
  description : String?
  arguments : Array[PromptArgumentInfo]?
}

///|
/// Prompt argument info
pub(all) struct PromptArgumentInfo {
  name : String
  description : String?
  required : Bool?
}

///|
/// List available prompts
pub async fn SdkClient::list_prompts(self : SdkClient) -> ListPromptsResult {
  let request = @js.from_map({ "method": "prompts/list" |> @js.any })
  let types = require_mcp_client_types()
  let schema = types.get("ListPromptsResultSchema")
  let result = ffi_client_request(self.as_any(), request, schema).wait()
  let prompts : Array[PromptInfo] = result.get("prompts") |> @js.identity
  { prompts, raw: result }
}

///|
/// Get prompt result
pub(all) struct GetPromptResult {
  description : String?
  messages : Array[PromptMessageResult]
  raw : @js.Any
}

///|
/// Prompt message result
pub(all) struct PromptMessageResult {
  role : String
  content : ContentResult
}

///|
/// Get a prompt
pub async fn SdkClient::get_prompt(
  self : SdkClient,
  name : String,
  arguments : @js.Any?,
) -> GetPromptResult {
  let params = @js.Object::new()
  params.set("name", name)
  if arguments is Some(args) {
    params.set("arguments", args)
  }
  let request = @js.from_map({
    "method": "prompts/get" |> @js.any,
    "params": params.as_any(),
  })
  let types = require_mcp_client_types()
  let schema = types.get("GetPromptResultSchema")
  let result = ffi_client_request(self.as_any(), request, schema).wait()
  let messages : Array[PromptMessageResult] = result.get("messages")
    |> @js.identity
  {
    description: result.get("description") |> @js.identity_option(),
    messages,
    raw: result,
  }
}

// ============================================================
// Transport
// ============================================================

///|
/// Create a new StdioClientTransport
pub fn StdioClientTransport::new(
  command : String,
  args : Array[String],
  env? : @js.Any,
  cwd? : String,
) -> StdioClientTransport {
  let stdio_mod = require_stdio_client_transport()
  let transport_class = stdio_mod.get("StdioClientTransport")
  let opts = @js.Object::new()
  opts.set("command", command)
  opts.set("args", args |> @js.from_array)
  if env is Some(e) {
    opts.set("env", e)
  }
  if cwd is Some(c) {
    opts.set("cwd", c)
  }
  ffi_construct_client(transport_class, [opts.as_any()]) |> @js.identity
}

///|
/// Start the transport
pub async fn StdioClientTransport::start(self : StdioClientTransport) -> Unit {
  let promise : @js.Promise[Unit] = self.as_any().get("start").call_self([])
    |> @js.identity
  promise.wait()
}

///|
/// Close the transport
pub async fn StdioClientTransport::close(self : StdioClientTransport) -> Unit {
  let promise : @js.Promise[Unit] = self.as_any().get("close").call_self([])
    |> @js.identity
  promise.wait()
}

// ============================================================
// Notification Handlers
// ============================================================

///|
/// Set notification handler
pub fn SdkClient::set_notification_handler(
  self : SdkClient,
  method_name : String,
  handler : (@js.Any) -> Unit,
) -> Unit {
  self
  .as_any()
  .get("setNotificationHandler")
  .call_self([
    @js.from_map({ "method": method_name |> @js.any }),
    @js.identity(handler),
  ])
  |> ignore
}

///|
/// Set logging message handler
pub fn SdkClient::on_log_message(
  self : SdkClient,
  handler : (String, String, @js.Any) -> Unit,
) -> Unit {
  let wrapped = fn(notification : @js.Any) {
    let params = notification.get("params")
    let level : String = params.get("level").cast()
    let logger : String = params.get("logger")
      |> @js.identity_option()
      |> Option::unwrap_or("")
    let data = params.get("data")
    handler(level, logger, data)
  }
  self.set_notification_handler("notifications/message", wrapped)
}
