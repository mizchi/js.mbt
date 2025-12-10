///| MCP TypeScript SDK Server Bindings
/// Bindings for @modelcontextprotocol/sdk server implementation

///|
#module("@modelcontextprotocol/sdk/server/index.js")
extern "js" fn ffi_mcp_server_class() -> @core.Any = "Server"

///|
#module("@modelcontextprotocol/sdk/types.js")
extern "js" fn ffi_list_tools_request_schema() -> @core.Any = "ListToolsRequestSchema"

///|
#module("@modelcontextprotocol/sdk/types.js")
extern "js" fn ffi_call_tool_request_schema() -> @core.Any = "CallToolRequestSchema"

///|
#module("@modelcontextprotocol/sdk/types.js")
extern "js" fn ffi_list_resources_request_schema() -> @core.Any = "ListResourcesRequestSchema"

///|
#module("@modelcontextprotocol/sdk/types.js")
extern "js" fn ffi_read_resource_request_schema() -> @core.Any = "ReadResourceRequestSchema"

///|
#module("@modelcontextprotocol/sdk/types.js")
extern "js" fn ffi_list_prompts_request_schema() -> @core.Any = "ListPromptsRequestSchema"

///|
#module("@modelcontextprotocol/sdk/types.js")
extern "js" fn ffi_get_prompt_request_schema() -> @core.Any = "GetPromptRequestSchema"

///|
#module("@modelcontextprotocol/sdk/server/stdio.js")
extern "js" fn ffi_stdio_server_transport_class() -> @core.Any = "StdioServerTransport"

// ============================================================
// Server Types
// ============================================================

///|
/// Native MCP Server from @modelcontextprotocol/sdk
#external
pub type SdkServer

///|
/// StdioServerTransport from @modelcontextprotocol/sdk
#external
pub type StdioServerTransport

// ============================================================
// Server Implementation
// ============================================================

///|
/// Create a new MCP SDK Server
pub fn SdkServer::new(
  name : String,
  version : String,
  tools? : Bool = true,
  resources? : Bool = true,
  prompts? : Bool = true,
) -> SdkServer {
  let server_class = ffi_mcp_server_class()
  // Build capabilities object
  let capabilities = @core.new_object()
  if tools {
    capabilities["tools"] = @core.new_object()
  }
  if resources {
    capabilities["resources"] = @core.new_object()
  }
  if prompts {
    capabilities["prompts"] = @core.new_object()
  }
  // Build server info
  let server_info = @core.from_entries([
    ("name", name |> @core.any),
    ("version", version |> @core.any),
  ])

  // Create server instance
  let opts = @core.from_entries([("capabilities", @core.any(capabilities))])
  ffi_construct(server_class, [server_info, opts]) |> @core.identity
}

///|
extern "js" fn ffi_construct(
  class_ : @core.Any,
  args : Array[@core.Any],
) -> @core.Any =
  #| (cls, args) => new cls(...args)

///|
/// Set request handler for tools/list
pub fn SdkServer::set_tools_list_handler(
  self : SdkServer,
  handler : () -> Array[Tool],
) -> Unit {
  let schema = ffi_list_tools_request_schema()
  let wrapped = fn(_request : @core.Any) -> @core.Any {
    let tools = handler()
    let tools_arr : Array[@core.Any] = tools.map(_.as_any())
    @core.from_entries([("tools", @core.any(tools_arr))])
  }
  ffi_set_handler(self |> @core.any, schema, wrapped)
}

///|
extern "js" fn ffi_set_handler(
  server : @core.Any,
  schema : @core.Any,
  handler : (@core.Any) -> @core.Any,
) -> Unit =
  #| (server, schema, handler) => server.setRequestHandler(schema, handler)

///|
/// Set request handler for tools/call
pub fn SdkServer::set_tools_call_handler(
  self : SdkServer,
  handler : async (String, @core.Any) -> Array[Content],
) -> Unit {
  let schema = ffi_call_tool_request_schema()
  let wrapped = fn(request : @core.Any) -> @js.Promise[@core.Any] {
    let params = request["params"]
    let name : String = params["name"].cast()
    let args = params["arguments"]
    let promise_handler = @js.promisify2(handler)
    promise_handler(name, args).then(fn(contents) {
      let content_arr : Array[@core.Any] = contents.map(_.as_any())
      @js.Promise::resolve(
        @core.from_entries([("content", @core.any(content_arr))]),
      )
    })
  }
  ffi_set_handler_async(self |> @core.any, schema, wrapped)
}

///|
extern "js" fn ffi_set_handler_async(
  server : @core.Any,
  schema : @core.Any,
  handler : (@core.Any) -> @core.Promise[@core.Any],
) -> Unit =
  #| (server, schema, handler) => server.setRequestHandler(schema, handler)

///|
/// Set request handler for resources/list
pub fn SdkServer::set_resources_list_handler(
  self : SdkServer,
  handler : () -> Array[Resource],
) -> Unit {
  let schema = ffi_list_resources_request_schema()
  let wrapped = fn(_request : @core.Any) -> @core.Any {
    let resources = handler()
    let resources_arr : Array[@core.Any] = resources.map(_.as_any())
    @core.from_entries([("resources", @core.any(resources_arr))])
  }
  ffi_set_handler(self |> @core.any, schema, wrapped)
}

///|
/// Set request handler for resources/read
pub fn SdkServer::set_resources_read_handler(
  self : SdkServer,
  handler : async (String) -> Array[Content],
) -> Unit {
  let schema = ffi_read_resource_request_schema()
  let wrapped = fn(request : @core.Any) -> @core.Promise[@core.Any] {
    let params = request["params"]
    let uri : String = params["uri"].cast()
    let promise_handler = @js.promisify1(handler)
    promise_handler(uri).then(fn(contents) {
      let content_arr : Array[@core.Any] = contents.map(_.as_any())
      @js.Promise::resolve(
        @core.from_entries([("contents", @core.any(content_arr))]),
      )
    })
  }
  ffi_set_handler_async(self |> @core.any, schema, wrapped)
}

///|
/// Set request handler for prompts/list
pub fn SdkServer::set_prompts_list_handler(
  self : SdkServer,
  handler : () -> Array[Prompt],
) -> Unit {
  let schema = ffi_list_prompts_request_schema()
  let wrapped = fn(_request : @core.Any) -> @core.Any {
    let prompts = handler()
    let prompts_arr : Array[@core.Any] = prompts.map(_.as_any())
    @core.from_entries([("prompts", @core.any(prompts_arr))])
  }
  ffi_set_handler(self |> @core.any, schema, wrapped)
}

///|
/// Set request handler for prompts/get
pub fn SdkServer::set_prompts_get_handler(
  self : SdkServer,
  handler : async (String, @core.Any) -> PromptResult,
) -> Unit {
  let schema = ffi_get_prompt_request_schema()
  let wrapped = fn(request : @core.Any) -> @js.Promise[@core.Any] {
    let params = request._get("params")
    let name : String = params["name"].cast()
    let args = params["arguments"]
    let promise_handler = @core.promisify2(handler)
    promise_handler(name, args).then(fn(result) {
      @core.Promise::resolve(result.as_any())
    })
  }
  ffi_set_handler_async(self |> @core.any, schema, wrapped)
}

///|
/// Prompt result
pub(all) struct PromptResult {
  description : String?
  messages : Array[PromptMessage]
}

///|
/// Prompt message
pub(all) struct PromptMessage {
  role : String // "user" or "assistant"
  content : Content
}

///|
pub fn PromptMessage::as_any(self : PromptMessage) -> @core.Any {
  @core.from_entries([
    ("role", self.role |> @core.any),
    ("content", @core.any(self.content.as_any())),
  ])
}

///|
pub fn PromptResult::as_any(self : PromptResult) -> @core.Any {
  let messages_arr : Array[@core.Any] = self.messages.map(_.as_any())
  let entries : Array[(String, @core.Any)] = [
    ("messages", @core.any(messages_arr)),
  ]
  if self.description is Some(d) {
    entries.push(("description", d |> @core.any))
  }
  @core.from_entries(entries).cast()
}

// ============================================================
// Transport
// ============================================================

///|
/// Create a new StdioServerTransport
pub fn StdioServerTransport::new() -> StdioServerTransport {
  let transport_class = ffi_stdio_server_transport_class()
  ffi_construct(transport_class, []) |> @core.identity
}

///|
extern "js" fn ffi_server_connect(
  server : @core.Any,
  transport : @core.Any,
) -> @core.Promise[Unit] =
  #| (server, transport) => server.connect(transport)

///|
extern "js" fn ffi_server_close(server : @core.Any) -> @core.Promise[Unit] =
  #| (server) => server.close()

///|
/// Connect server to transport
pub async fn SdkServer::connect(
  self : SdkServer,
  transport : StdioServerTransport,
) -> Unit {
  ffi_server_connect(self |> @core.any, transport |> @core.any).wait()
}

///|
/// Close server
pub async fn SdkServer::close(self : SdkServer) -> Unit {
  ffi_server_close(self |> @core.any).wait()
}

///|
/// Send a notification
pub fn SdkServer::send_notification(
  self : SdkServer,
  method_name : String,
  params : @core.Any,
) -> Unit {
  let notification = @core.from_entries([
    ("method", method_name |> @core.any),
    ("params", @core.any(params)),
  ])
  (self |> @core.any)._get("notification")._invoke([notification]) |> ignore
}

///|
/// Send a log message notification
pub fn SdkServer::log(
  self : SdkServer,
  level : String,
  message : String,
) -> Unit {
  let params = @core.from_entries([
    ("level", level |> @core.any),
    ("logger", "server" |> @core.any),
    ("data", message |> @core.any),
  ])
  self.send_notification("notifications/message", params)
}
