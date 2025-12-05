///| MCP TypeScript SDK Client Bindings
/// Bindings for @modelcontextprotocol/sdk client implementation

///|
extern "js" fn require_mcp_client() -> @core.Any =
  #| () => require("@modelcontextprotocol/sdk/client/index.js")

///|
extern "js" fn require_mcp_client_types() -> @core.Any =
  #| () => require("@modelcontextprotocol/sdk/types.js")

///|
extern "js" fn require_stdio_client_transport() -> @core.Any =
  #| () => require("@modelcontextprotocol/sdk/client/stdio.js")

// ============================================================
// Client Types
// ============================================================

///|
/// Native MCP Client from @modelcontextprotocol/sdk
#external
pub type SdkClient

///|
pub extern "js" fn SdkClient::as_any(self : SdkClient) -> @core.Any = "%identity"

///|
/// StdioClientTransport from @modelcontextprotocol/sdk
#external
pub type StdioClientTransport

// ============================================================
// Client Implementation
// ============================================================

///|
/// Create a new MCP SDK Client
pub fn SdkClient::new(name : String, version : String) -> SdkClient {
  let sdk = require_mcp_client()
  let client_class = sdk._get("Client")
  // Build client info
  let client_info = @core.identity(
    @core.from_entries([
      ("name", name |> @core.any),
      ("version", version |> @core.any),
    ]),
  )
  // Create client instance with empty capabilities
  let opts = @core.identity(
    @core.from_entries([("capabilities", @core.any(@core.new_object()))]),
  )
  ffi_construct_client(client_class, [client_info, opts]) |> @core.identity
}

///|
extern "js" fn ffi_construct_client(
  class_ : @core.Any,
  args : Array[@core.Any],
) -> @core.Any =
  #| (cls, args) => new cls(...args)

///|
extern "js" fn ffi_client_request(
  client : @core.Any,
  request : @core.Any,
  schema : @core.Any,
) -> @js.Promise[@core.Any] =
  #| (client, request, schema) => client.request(request, schema)

///|
extern "js" fn ffi_client_connect(
  client : @core.Any,
  transport : @core.Any,
) -> @js.Promise[Unit] =
  #| (client, transport) => client.connect(transport)

///|
extern "js" fn ffi_client_close(client : @core.Any) -> @js.Promise[Unit] =
  #| (client) => client.close()

///|
/// Connect client to transport
pub async fn SdkClient::connect(
  self : SdkClient,
  transport : StdioClientTransport,
) -> Unit {
  ffi_client_connect(self |> @core.any, transport |> @core.any).wait()
}

///|
/// Close client
pub async fn SdkClient::close(self : SdkClient) -> Unit {
  ffi_client_close(self |> @core.any).wait()
}

// ============================================================
// Tool Operations
// ============================================================

///|
/// List tools result
pub(all) struct ListToolsResult {
  tools : Array[ToolInfo]
  raw : @core.Any
}

///|
/// Tool info from list
pub(all) struct ToolInfo {
  name : String
  description : String?
  input_schema : @core.Any
}

///|
/// List available tools
pub async fn SdkClient::list_tools(self : SdkClient) -> ListToolsResult {
  let request = @core.identity(
    @core.from_entries([("method", "tools/list" |> @core.any)]),
  )
  let types = require_mcp_client_types()
  let schema = types._get("ListToolsResultSchema")
  let result = ffi_client_request(self |> @core.any, request, schema).wait()
  let tools : Array[ToolInfo] = result._get("tools") |> @core.identity
  { tools, raw: result }
}

///|
/// Call tool result
pub(all) struct CallToolResult {
  content : Array[ContentResult]
  is_error : Bool?
  raw : @core.Any
}

///|
/// Content result from tool call
pub(all) struct ContentResult {
  text : String?
  data : String?
  mime_type : String?
  raw : @core.Any
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
  arguments : @core.Any,
) -> CallToolResult {
  let params = @core.from_entries([
    ("name", name |> @core.any),
    ("arguments", @core.any(arguments)),
  ])
  let request = @core.identity(
    @core.from_entries([
      ("method", "tools/call" |> @core.any),
      ("params", @core.any(params)),
    ]),
  )
  let types = require_mcp_client_types()
  let schema = types._get("CallToolResultSchema")
  let result = ffi_client_request(self |> @core.any, request, schema).wait()
  let content : Array[ContentResult] = result._get("content") |> @core.identity
  let is_error : Bool? = result._get("isError") |> @core.identity_option()
  { content, is_error, raw: result }
}

// ============================================================
// Resource Operations
// ============================================================

///|
/// List resources result
pub(all) struct ListResourcesResult {
  resources : Array[ResourceInfo]
  raw : @core.Any
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
  let request = @core.identity(
    @core.from_entries([("method", "resources/list" |> @core.any)]),
  )
  let types = require_mcp_client_types()
  let schema = types._get("ListResourcesResultSchema")
  let result = ffi_client_request(self |> @core.any, request, schema).wait()
  let resources : Array[ResourceInfo] = result._get("resources")
    |> @core.identity
  { resources, raw: result }
}

///|
/// Read resource result
pub(all) struct ReadResourceResult {
  contents : Array[ContentResult]
  raw : @core.Any
}

///|
/// Read a resource
pub async fn SdkClient::read_resource(
  self : SdkClient,
  uri : String,
) -> ReadResourceResult {
  let params = @core.from_entries([("uri", uri |> @core.any)])
  let request = @core.from_entries([
    ("method", "resources/read" |> @core.any),
    ("params", @core.any(params)),
  ])
  let types = require_mcp_client_types()
  let schema = types._get("ReadResourceResultSchema")
  let result = ffi_client_request(self |> @core.any, request, schema).wait()
  let contents : Array[ContentResult] = result._get("contents")
    |> @core.identity
  { contents, raw: result }
}

// ============================================================
// Prompt Operations
// ============================================================

///|
/// List prompts result
pub(all) struct ListPromptsResult {
  prompts : Array[PromptInfo]
  raw : @core.Any
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
  let request = @core.identity(
    @core.from_entries([("method", "prompts/list" |> @core.any)]),
  )
  let types = require_mcp_client_types()
  let schema = types._get("ListPromptsResultSchema")
  let result = ffi_client_request(self |> @core.any, request, schema).wait()
  let prompts : Array[PromptInfo] = result._get("prompts") |> @core.identity
  { prompts, raw: result }
}

///|
/// Get prompt result
pub(all) struct GetPromptResult {
  description : String?
  messages : Array[PromptMessageResult]
  raw : @core.Any
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
  arguments : @core.Any?,
) -> GetPromptResult {
  let params = @core.new_object()
  params._set("name", name |> @core.any)
  if arguments is Some(args) {
    params._set("arguments", args)
  }
  let request = @core.identity(
    @core.from_entries([
      ("method", "prompts/get" |> @core.any),
      ("params", @core.any(params)),
    ]),
  )
  let types = require_mcp_client_types()
  let schema = types._get("GetPromptResultSchema")
  let result = ffi_client_request(self |> @core.any, request, schema).wait()
  let messages : Array[PromptMessageResult] = result._get("messages")
    |> @core.identity
  {
    description: result._get("description") |> @core.identity_option(),
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
  env? : @core.Any,
  cwd? : String,
) -> StdioClientTransport {
  let stdio_mod = require_stdio_client_transport()
  let transport_class = stdio_mod._get("StdioClientTransport")
  let opts = @core.new_object()
  opts._set("command", command |> @core.any)
  opts._set("args", args |> @core.any)
  if env is Some(e) {
    opts._set("env", e)
  }
  if cwd is Some(c) {
    opts._set("cwd", c |> @core.any)
  }
  ffi_construct_client(transport_class, [@core.any(opts)]) |> @core.identity
}

///|
/// Start the transport
pub async fn StdioClientTransport::start(self : StdioClientTransport) -> Unit {
  let promise : @js.Promise[Unit] = (self |> @core.any)
    ._get("start")
    ._invoke([])
    |> @core.identity
  promise.wait()
}

///|
/// Close the transport
pub async fn StdioClientTransport::close(self : StdioClientTransport) -> Unit {
  let promise : @js.Promise[Unit] = self |> @core.any |> @core.identity
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
  handler : (@core.Any) -> Unit,
) -> Unit {
  self
  .as_any()
  ._get("setNotificationHandler")
  ._invoke([
    @core.identity(@core.from_entries([("method", method_name |> @core.any)])),
    @core.identity(handler),
  ])
  |> ignore
}

///|
/// Set logging message handler
pub fn SdkClient::on_log_message(
  self : SdkClient,
  handler : (String, String, @core.Any) -> Unit,
) -> Unit {
  let wrapped = fn(notification : @core.Any) {
    let params = notification._get("params")
    let level : String = params._get("level").cast()
    let logger : String = params._get("logger")
      |> @core.identity_option()
      |> Option::unwrap_or("")
    let data = params._get("data")
    handler(level, logger, data)
  }
  self.set_notification_handler("notifications/message", wrapped)
}
