///| MCP TypeScript SDK Server Bindings
/// Bindings for @modelcontextprotocol/sdk server implementation

///|
extern "js" fn require_mcp_server() -> @js.Any =
  #| () => require("@modelcontextprotocol/sdk/server/index.js")

///|
extern "js" fn require_mcp_types() -> @js.Any =
  #| () => require("@modelcontextprotocol/sdk/types.js")

///|
extern "js" fn require_stdio_transport() -> @js.Any =
  #| () => require("@modelcontextprotocol/sdk/server/stdio.js")

// ============================================================
// Server Types
// ============================================================

///|
/// Native MCP Server from @modelcontextprotocol/sdk
#external
pub type SdkServer

///|
pub impl @js.JsImpl for SdkServer

///|
/// StdioServerTransport from @modelcontextprotocol/sdk
#external
pub type StdioServerTransport

///|
pub impl @js.JsImpl for StdioServerTransport

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
  let server_class = sdk.get("Server")
  // Build capabilities object
  let capabilities = @js.Object::new()
  if tools {
    capabilities.set("tools", @js.Object::new())
  }
  if resources {
    capabilities.set("resources", @js.Object::new())
  }
  if prompts {
    capabilities.set("prompts", @js.Object::new())
  }
  // Build server info
  let server_info = @js.identity(
    @mbtconv.from_map({
      "name": name |> @nostd.any,
      "version": version |> @nostd.any,
    }),
  )
  // Create server instance
  let opts = @js.identity(
    @mbtconv.from_map({ "capabilities": @nostd.any(capabilities.as_any()) }),
  )
  ffi_construct(server_class, [server_info, opts]) |> @js.identity
}

///|
extern "js" fn ffi_construct(
  class_ : @js.Any,
  args : Array[@js.Any],
) -> @js.Any =
  #| (cls, args) => new cls(...args)

///|
/// Set request handler for tools/list
pub fn SdkServer::set_tools_list_handler(
  self : SdkServer,
  handler : () -> Array[Tool],
) -> Unit {
  let types = require_mcp_types()
  let schema = types.get("ListToolsRequestSchema")
  let wrapped = fn(_request : @js.Any) -> @js.Any {
    let tools = handler()
    let tools_arr : Array[@js.Any] = tools.map(fn(t) { t.as_any() })
    @js.identity(
      @mbtconv.from_map({ "tools": @nostd.any(@js.from_array(tools_arr)) }),
    )
  }
  ffi_set_handler(self.as_any(), schema, wrapped)
}

///|
extern "js" fn ffi_set_handler(
  server : @js.Any,
  schema : @js.Any,
  handler : (@js.Any) -> @js.Any,
) -> Unit =
  #| (server, schema, handler) => server.setRequestHandler(schema, handler)

///|
/// Set request handler for tools/call
pub fn SdkServer::set_tools_call_handler(
  self : SdkServer,
  handler : async (String, @js.Any) -> Array[Content],
) -> Unit {
  let types = require_mcp_types()
  let schema = types.get("CallToolRequestSchema")
  let wrapped = fn(request : @js.Any) -> @js.Promise[@js.Any] {
    let params = request.get("params")
    let name : String = params.get("name").cast()
    let args = params.get("arguments")
    let promise_handler = @js.promisify2(handler)
    promise_handler(name, args).then(fn(contents) {
      let content_arr : Array[@js.Any] = contents.map(fn(c) { c.as_any() })
      @js.Promise::resolve(
        @js.identity(
          @mbtconv.from_map({
            "content": @nostd.any(@js.from_array(content_arr)),
          }),
        ),
      )
    })
  }
  ffi_set_handler_async(self.as_any(), schema, wrapped)
}

///|
extern "js" fn ffi_set_handler_async(
  server : @js.Any,
  schema : @js.Any,
  handler : (@js.Any) -> @js.Promise[@js.Any],
) -> Unit =
  #| (server, schema, handler) => server.setRequestHandler(schema, handler)

///|
/// Set request handler for resources/list
pub fn SdkServer::set_resources_list_handler(
  self : SdkServer,
  handler : () -> Array[Resource],
) -> Unit {
  let types = require_mcp_types()
  let schema = types.get("ListResourcesRequestSchema")
  let wrapped = fn(_request : @js.Any) -> @js.Any {
    let resources = handler()
    let resources_arr : Array[@js.Any] = resources.map(fn(r) { r.as_any() })
    @js.identity(
      @mbtconv.from_map({
        "resources": @nostd.any(@js.from_array(resources_arr)),
      }),
    )
  }
  ffi_set_handler(self.as_any(), schema, wrapped)
}

///|
/// Set request handler for resources/read
pub fn SdkServer::set_resources_read_handler(
  self : SdkServer,
  handler : async (String) -> Array[Content],
) -> Unit {
  let types = require_mcp_types()
  let schema = types.get("ReadResourceRequestSchema")
  let wrapped = fn(request : @js.Any) -> @js.Promise[@js.Any] {
    let params = request.get("params")
    let uri : String = params.get("uri").cast()
    let promise_handler = @js.promisify1(handler)
    promise_handler(uri).then(fn(contents) {
      let content_arr : Array[@js.Any] = contents.map(fn(c) { c.as_any() })
      @js.Promise::resolve(
        @js.identity(
          @mbtconv.from_map({
            "contents": @nostd.any(@js.from_array(content_arr)),
          }),
        ),
      )
    })
  }
  ffi_set_handler_async(self.as_any(), schema, wrapped)
}

///|
/// Set request handler for prompts/list
pub fn SdkServer::set_prompts_list_handler(
  self : SdkServer,
  handler : () -> Array[Prompt],
) -> Unit {
  let types = require_mcp_types()
  let schema = types.get("ListPromptsRequestSchema")
  let wrapped = fn(_request : @js.Any) -> @js.Any {
    let prompts = handler()
    let prompts_arr : Array[@js.Any] = prompts.map(fn(p) { p.as_any() })
    @js.identity(
      @mbtconv.from_map({ "prompts": @nostd.any(@js.from_array(prompts_arr)) }),
    )
  }
  ffi_set_handler(self.as_any(), schema, wrapped)
}

///|
/// Set request handler for prompts/get
pub fn SdkServer::set_prompts_get_handler(
  self : SdkServer,
  handler : async (String, @js.Any) -> PromptResult,
) -> Unit {
  let types = require_mcp_types()
  let schema = types.get("GetPromptRequestSchema")
  let wrapped = fn(request : @js.Any) -> @js.Promise[@js.Any] {
    let params = request.get("params")
    let name : String = params.get("name").cast()
    let args = params.get("arguments")
    let promise_handler = @js.promisify2(handler)
    promise_handler(name, args).then(fn(result) {
      @js.Promise::resolve(result.as_any())
    })
  }
  ffi_set_handler_async(self.as_any(), schema, wrapped)
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
pub fn PromptMessage::as_any(self : PromptMessage) -> @js.Any {
  @js.identity(
    @mbtconv.from_map({
      "role": self.role |> @nostd.any,
      "content": @nostd.any(self.content.as_any()),
    }),
  )
}

///|
pub fn PromptResult::as_any(self : PromptResult) -> @js.Any {
  let messages_arr : Array[@js.Any] = self.messages.map(fn(m) { m.as_any() })
  @js.from_option_map({
    "description": self.description.map(fn(d) { d |> @js.any }),
    "messages": Some(@js.from_array(messages_arr)),
  })
}

// ============================================================
// Transport
// ============================================================

///|
/// Create a new StdioServerTransport
pub fn StdioServerTransport::new() -> StdioServerTransport {
  let stdio_mod = require_stdio_transport()
  let transport_class = stdio_mod.get("StdioServerTransport")
  ffi_construct(transport_class, []) |> @js.identity
}

///|
extern "js" fn ffi_server_connect(
  server : @js.Any,
  transport : @js.Any,
) -> @js.Promise[Unit] =
  #| (server, transport) => server.connect(transport)

///|
extern "js" fn ffi_server_close(server : @js.Any) -> @js.Promise[Unit] =
  #| (server) => server.close()

///|
/// Connect server to transport
pub async fn SdkServer::connect(
  self : SdkServer,
  transport : StdioServerTransport,
) -> Unit {
  ffi_server_connect(self.as_any(), transport.as_any()).wait()
}

///|
/// Close server
pub async fn SdkServer::close(self : SdkServer) -> Unit {
  ffi_server_close(self.as_any()).wait()
}

///|
/// Send a notification
pub fn SdkServer::send_notification(
  self : SdkServer,
  method_name : String,
  params : &@js.JsImpl,
) -> Unit {
  let notification = @js.identity(
    @mbtconv.from_map({
      "method": method_name |> @nostd.any,
      "params": @nostd.any(params.as_any()),
    }),
  )
  self.as_any().get("notification").call_self([notification]) |> ignore
}

///|
/// Send a log message notification
pub fn SdkServer::log(
  self : SdkServer,
  level : String,
  message : String,
) -> Unit {
  let params = @js.identity(
    @mbtconv.from_map({
      "level": level |> @nostd.any,
      "logger": "server" |> @nostd.any,
      "data": message |> @nostd.any,
    }),
  )
  self.send_notification("notifications/message", params)
}
