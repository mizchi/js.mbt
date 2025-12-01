///| MCP TypeScript SDK Client Bindings
/// Bindings for @modelcontextprotocol/sdk client implementation

///|
extern "js" fn require_mcp_client() -> @nostd.Any =
  #| () => require("@modelcontextprotocol/sdk/client/index.js")

///|
extern "js" fn require_mcp_client_types() -> @nostd.Any =
  #| () => require("@modelcontextprotocol/sdk/types.js")

///|
extern "js" fn require_stdio_client_transport() -> @nostd.Any =
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
  let client_class = sdk._get("Client")
  // Build client info
  let client_info = @js.identity(
    @mbtconv.from_map({
      "name": name |> @nostd.any,
      "version": version |> @nostd.any,
    }),
  )
  // Create client instance with empty capabilities
  let opts = @js.identity(
    @mbtconv.from_map({
      "capabilities": @nostd.any(@nostd.Object::new()),
    }),
  )
  ffi_construct_client(client_class, [client_info, opts]) |> @js.identity
}

///|
extern "js" fn ffi_construct_client(
  class_ : @nostd.Any,
  args : Array[@nostd.Any],
) -> @nostd.Any =
  #| (cls, args) => new cls(...args)

///|
extern "js" fn ffi_client_request(
  client : @nostd.Any,
  request : @nostd.Any,
  schema : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
  #| (client, request, schema) => client.request(request, schema)

///|
extern "js" fn ffi_client_connect(
  client : @nostd.Any,
  transport : @nostd.Any,
) -> @js.Promise[Unit] =
  #| (client, transport) => client.connect(transport)

///|
extern "js" fn ffi_client_close(client : @nostd.Any) -> @js.Promise[Unit] =
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
  raw : @nostd.Any
}

///|
/// Tool info from list
pub(all) struct ToolInfo {
  name : String
  description : String?
  input_schema : @nostd.Any
}

///|
/// List available tools
pub async fn SdkClient::list_tools(self : SdkClient) -> ListToolsResult {
  let request = @js.identity(
    @nostd.from_entries([("method", "tools/list" |> @nostd.any)]),
  )
  let types = require_mcp_client_types()
  let schema = types._get("ListToolsResultSchema")
  let result = ffi_client_request(self.as_any(), request, schema).wait()
  let tools : Array[ToolInfo] = result._get("tools") |> @js.identity
  { tools, raw: result }
}

///|
/// Call tool result
pub(all) struct CallToolResult {
  content : Array[ContentResult]
  is_error : Bool?
  raw : @nostd.Any
}

///|
/// Content result from tool call
pub(all) struct ContentResult {
  text : String?
  data : String?
  mime_type : String?
  raw : @nostd.Any
}

///|
/// Get the type of the content (accesses JS "type" property)
pub fn ContentResult::type_(self : ContentResult) -> String {
  self.raw._get("type").cast()
}

///|
/// Call a tool
pub async fn SdkClient::call_tool(
  self : SdkClient,
  name : String,
  arguments : &@js.JsImpl,
) -> CallToolResult {
  let params = @js.identity(
    @mbtconv.from_map({
      "name": name |> @nostd.any,
      "arguments": @nostd.any(arguments),
    }),
  )
  let request = @js.identity(
    @mbtconv.from_map({
      "method": "tools/call" |> @nostd.any,
      "params": @nostd.any(params),
    }),
  )
  let types = require_mcp_client_types()
  let schema = types._get("CallToolResultSchema")
  let result = ffi_client_request(self.as_any(), request, schema).wait()
  let content : Array[ContentResult] = result._get("content") |> @js.identity
  let is_error : Bool? = result._get("isError") |> @js.identity_option()
  { content, is_error, raw: result }
}

// ============================================================
// Resource Operations
// ============================================================

///|
/// List resources result
pub(all) struct ListResourcesResult {
  resources : Array[ResourceInfo]
  raw : @nostd.Any
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
  let request = @js.identity(
    @nostd.from_entries([("method", "resources/list" |> @nostd.any)]),
  )
  let types = require_mcp_client_types()
  let schema = types._get("ListResourcesResultSchema")
  let result = ffi_client_request(self.as_any(), request, schema).wait()
  let resources : Array[ResourceInfo] = result._get("resources") |> @js.identity
  { resources, raw: result }
}

///|
/// Read resource result
pub(all) struct ReadResourceResult {
  contents : Array[ContentResult]
  raw : @nostd.Any
}

///|
/// Read a resource
pub async fn SdkClient::read_resource(
  self : SdkClient,
  uri : String,
) -> ReadResourceResult {
  let params = @js.identity(@nostd.from_entries([("uri", uri |> @nostd.any)]))
  let request = @js.identity(
    @mbtconv.from_map({
      "method": "resources/read" |> @nostd.any,
      "params": @nostd.any(params),
    }),
  )
  let types = require_mcp_client_types()
  let schema = types._get("ReadResourceResultSchema")
  let result = ffi_client_request(self.as_any(), request, schema).wait()
  let contents : Array[ContentResult] = result._get("contents") |> @js.identity
  { contents, raw: result }
}

// ============================================================
// Prompt Operations
// ============================================================

///|
/// List prompts result
pub(all) struct ListPromptsResult {
  prompts : Array[PromptInfo]
  raw : @nostd.Any
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
  let request = @js.identity(
    @nostd.from_entries([("method", "prompts/list" |> @nostd.any)]),
  )
  let types = require_mcp_client_types()
  let schema = types._get("ListPromptsResultSchema")
  let result = ffi_client_request(self.as_any(), request, schema).wait()
  let prompts : Array[PromptInfo] = result._get("prompts") |> @js.identity
  { prompts, raw: result }
}

///|
/// Get prompt result
pub(all) struct GetPromptResult {
  description : String?
  messages : Array[PromptMessageResult]
  raw : @nostd.Any
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
  arguments : @nostd.Any?,
) -> GetPromptResult {
  let params = @nostd.Object::new()
  params.set("name", name)
  if arguments is Some(args) {
    params.set("arguments", args)
  }
  let request = @js.identity(
    @mbtconv.from_map({
      "method": "prompts/get" |> @nostd.any,
      "params": @nostd.any(params),
    }),
  )
  let types = require_mcp_client_types()
  let schema = types._get("GetPromptResultSchema")
  let result = ffi_client_request(self.as_any(), request, schema).wait()
  let messages : Array[PromptMessageResult] = result._get("messages")
    |> @js.identity
  {
    description: result._get("description") |> @js.identity_option(),
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
  env? : @nostd.Any,
  cwd? : String,
) -> StdioClientTransport {
  let stdio_mod = require_stdio_client_transport()
  let transport_class = stdio_mod._get("StdioClientTransport")
  let opts = @nostd.Object::new()
  opts.set("command", command)
  opts.set("args", args |> @js.from_array)
  if env is Some(e) {
    opts.set("env", e)
  }
  if cwd is Some(c) {
    opts.set("cwd", c)
  }
  ffi_construct_client(transport_class, [@nostd.any(opts)]) |> @js.identity
}

///|
/// Start the transport
pub async fn StdioClientTransport::start(self : StdioClientTransport) -> Unit {
  let promise : @js.Promise[Unit] = self.as_any()._get("start").call_self([])
    |> @js.identity
  promise.wait()
}

///|
/// Close the transport
pub async fn StdioClientTransport::close(self : StdioClientTransport) -> Unit {
  let promise : @js.Promise[Unit] = self.as_any()._get("close").call_self([])
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
  handler : (@nostd.Any) -> Unit,
) -> Unit {
  self
  .as_any()
  ._get("setNotificationHandler")
  .call_self([
    @js.identity(@nostd.from_entries([("method", method_name |> @nostd.any)])),
    @js.identity(handler),
  ])
  |> ignore
}

///|
/// Set logging message handler
pub fn SdkClient::on_log_message(
  self : SdkClient,
  handler : (String, String, @nostd.Any) -> Unit,
) -> Unit {
  let wrapped = fn(notification : @nostd.Any) {
    let params = notification._get("params")
    let level : String = params._get("level").cast()
    let logger : String = params._get("logger")
      |> @js.identity_option()
      |> Option::unwrap_or("")
    let data = params._get("data")
    handler(level, logger, data)
  }
  self.set_notification_handler("notifications/message", wrapped)
}
