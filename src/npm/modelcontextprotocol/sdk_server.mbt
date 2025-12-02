///| MCP TypeScript SDK Server Bindings
/// Bindings for @modelcontextprotocol/sdk server implementation

///|
extern "js" fn require_mcp_server() -> @core.Any =
  #| () => require("@modelcontextprotocol/sdk/server/index.js")

///|
extern "js" fn require_mcp_types() -> @core.Any =
  #| () => require("@modelcontextprotocol/sdk/types.js")

///|
extern "js" fn require_stdio_transport() -> @core.Any =
  #| () => require("@modelcontextprotocol/sdk/server/stdio.js")

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
  let sdk = require_mcp_server()
  let server_class = sdk._get("Server")
  // Build capabilities object
  let capabilities = @core.Object::new()
  if tools {
    capabilities._set("tools", @core.Object::new())
  }
  if resources {
    capabilities._set("resources", @core.Object::new())
  }
  if prompts {
    capabilities._set("prompts", @core.Object::new())
  }
  // Build server info
  let server_info = @core.identity(
    @mbtconv.from_map({
      "name": name |> @core.any,
      "version": version |> @core.any,
    }),
  )
  // Create server instance
  let opts = @core.identity(
    @mbtconv.from_map({ "capabilities": @core.any(capabilities) }),
  )
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
  let types = require_mcp_types()
  let schema = types._get("ListToolsRequestSchema")
  let wrapped = fn(_request : @core.Any) -> @core.Any {
    let tools = handler()
    let tools_arr : Array[@core.Any] = tools.map(fn(t) { t.as_any() })
    @core.identity(
      @mbtconv.from_map({ "tools": @core.any(@core.any(tools_arr)) }),
    )
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
  let types = require_mcp_types()
  let schema = types._get("CallToolRequestSchema")
  let wrapped = fn(request : @core.Any) -> @js.Promise[@core.Any] {
    let params = request._get("params")
    let name : String = params._get("name").cast()
    let args = params._get("arguments")
    let promise_handler = @js.promisify2(handler)
    promise_handler(name, args).then(fn(contents) {
      let content_arr : Array[@core.Any] = contents.map(fn(c) { c.as_any() })
      @js.Promise::resolve(
        @core.identity(
          @mbtconv.from_map({ "content": @core.any(@core.any(content_arr)) }),
        ),
      )
    })
  }
  ffi_set_handler_async(self |> @core.any, schema, wrapped)
}

///|
extern "js" fn ffi_set_handler_async(
  server : @core.Any,
  schema : @core.Any,
  handler : (@core.Any) -> @js.Promise[@core.Any],
) -> Unit =
  #| (server, schema, handler) => server.setRequestHandler(schema, handler)

///|
/// Set request handler for resources/list
pub fn SdkServer::set_resources_list_handler(
  self : SdkServer,
  handler : () -> Array[Resource],
) -> Unit {
  let types = require_mcp_types()
  let schema = types._get("ListResourcesRequestSchema")
  let wrapped = fn(_request : @core.Any) -> @core.Any {
    let resources = handler()
    let resources_arr : Array[@core.Any] = resources.map(fn(r) { r.as_any() })
    @core.identity(
      @mbtconv.from_map({ "resources": @core.any(@core.any(resources_arr)) }),
    )
  }
  ffi_set_handler(self |> @core.any, schema, wrapped)
}

///|
/// Set request handler for resources/read
pub fn SdkServer::set_resources_read_handler(
  self : SdkServer,
  handler : async (String) -> Array[Content],
) -> Unit {
  let types = require_mcp_types()
  let schema = types._get("ReadResourceRequestSchema")
  let wrapped = fn(request : @core.Any) -> @js.Promise[@core.Any] {
    let params = request._get("params")
    let uri : String = params._get("uri").cast()
    let promise_handler = @js.promisify1(handler)
    promise_handler(uri).then(fn(contents) {
      let content_arr : Array[@core.Any] = contents.map(fn(c) { c.as_any() })
      @js.Promise::resolve(
        @core.identity(
          @mbtconv.from_map({ "contents": @core.any(@core.any(content_arr)) }),
        ),
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
  let types = require_mcp_types()
  let schema = types._get("ListPromptsRequestSchema")
  let wrapped = fn(_request : @core.Any) -> @core.Any {
    let prompts = handler()
    let prompts_arr : Array[@core.Any] = prompts.map(fn(p) { p.as_any() })
    @core.identity(
      @mbtconv.from_map({ "prompts": @core.any(@core.any(prompts_arr)) }),
    )
  }
  ffi_set_handler(self |> @core.any, schema, wrapped)
}

///|
/// Set request handler for prompts/get
pub fn SdkServer::set_prompts_get_handler(
  self : SdkServer,
  handler : async (String, @core.Any) -> PromptResult,
) -> Unit {
  let types = require_mcp_types()
  let schema = types._get("GetPromptRequestSchema")
  let wrapped = fn(request : @core.Any) -> @js.Promise[@core.Any] {
    let params = request._get("params")
    let name : String = params._get("name").cast()
    let args = params._get("arguments")
    let promise_handler = @js.promisify2(handler)
    promise_handler(name, args).then(fn(result) {
      @js.Promise::resolve(result.as_any())
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
  @core.identity(
    @mbtconv.from_map({
      "role": self.role |> @core.any,
      "content": @core.any(self.content.as_any()),
    }),
  )
}

///|
pub fn PromptResult::as_any(self : PromptResult) -> @core.Any {
  let messages_arr : Array[@core.Any] = self.messages.map(fn(m) { m.as_any() })
  @mbtconv.from_option_map({
    "description": self.description.map(fn(d) { d |> @core.any }),
    "messages": Some(@core.identity(@core.any(messages_arr))),
  }).cast()
}

// ============================================================
// Transport
// ============================================================

///|
/// Create a new StdioServerTransport
pub fn StdioServerTransport::new() -> StdioServerTransport {
  let stdio_mod = require_stdio_transport()
  let transport_class = stdio_mod._get("StdioServerTransport")
  ffi_construct(transport_class, []) |> @core.identity
}

///|
extern "js" fn ffi_server_connect(
  server : @core.Any,
  transport : @core.Any,
) -> @js.Promise[Unit] =
  #| (server, transport) => server.connect(transport)

///|
extern "js" fn ffi_server_close(server : @core.Any) -> @js.Promise[Unit] =
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
  let notification = @core.identity(
    @mbtconv.from_map({
      "method": method_name |> @core.any,
      "params": @core.any(params),
    }),
  )
  (self |> @core.any)._get("notification")._invoke([notification]) |> ignore
}

///|
/// Send a log message notification
pub fn SdkServer::log(
  self : SdkServer,
  level : String,
  message : String,
) -> Unit {
  let params = @core.identity(
    @mbtconv.from_map({
      "level": level |> @core.any,
      "logger": "server" |> @core.any,
      "data": message |> @core.any,
    }),
  )
  self.send_notification("notifications/message", params)
}
