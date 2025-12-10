///| MCP Server Implementation

///|
/// Tool Handler - async function that takes typed params and returns content
pub type ToolHandler[T] = async (T) -> Array[Content]

///|
/// Resource Handler - async function that returns content for a resource URI
pub type ResourceHandler = async (String) -> Array[Content]

///|
/// Prompt Handler - async function that takes arguments and returns messages
pub type PromptHandler[T] = async (T) -> Array[Content]

// Internal handler type aliases (promisified versions)

///|
type InternalToolHandler = (@core.Any) -> @js.Promise[Array[Content]]

///|
type InternalResourceHandler = (String) -> @js.Promise[Array[Content]]

///|
type InternalPromptHandler = (@core.Any) -> @js.Promise[Array[Content]]

///|
/// MCP Server
pub struct McpServer {
  info : ServerInfo
  mut tools : @immut/hashmap.HashMap[String, (Tool, InternalToolHandler)]
  mut resources : @immut/hashmap.HashMap[
    String,
    (Resource, InternalResourceHandler),
  ]
  mut prompts : @immut/hashmap.HashMap[String, (Prompt, InternalPromptHandler)]
}

///|
pub fn McpServer::new(name : String, version : String) -> McpServer {
  {
    info: { name, version },
    tools: @immut/hashmap.new(),
    resources: @immut/hashmap.new(),
    prompts: @immut/hashmap.new(),
  }
}

///|
/// Register a tool with typed handler
pub fn[T] McpServer::add_tool(
  self : McpServer,
  tool : Tool,
  handler : ToolHandler[T],
) -> Unit {
  let wrapped : async (@core.Any) -> Array[Content] = async fn(args) {
    handler(@core.identity(args))
  }
  let promisified : InternalToolHandler = @js.promisify1(wrapped)
  self.tools = self.tools.add(tool.name, (tool, promisified))
}

///|
/// Register a resource
pub fn McpServer::add_resource(
  self : McpServer,
  resource : Resource,
  handler : ResourceHandler,
) -> Unit {
  let promisified : InternalResourceHandler = @js.promisify1(handler)
  self.resources = self.resources.add(resource.uri, (resource, promisified))
}

///|
/// Register a prompt with typed handler
pub fn[T] McpServer::add_prompt(
  self : McpServer,
  prompt : Prompt,
  handler : PromptHandler[T],
) -> Unit {
  let wrapped : async (@core.Any) -> Array[Content] = async fn(args) {
    handler(@core.identity(args))
  }
  let promisified : InternalPromptHandler = @js.promisify1(wrapped)
  self.prompts = self.prompts.add(prompt.name, (prompt, promisified))
}

///|
/// Handle a JSON-RPC request
pub fn McpServer::handle_request(
  self : McpServer,
  request : JsonRpcRequest,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  let id = request.id

  // Handle different methods
  if request.method_name == "initialize" {
    self.handle_initialize(id, request.params)
  } else if request.method_name == "tools/list" {
    self.handle_tools_list(id)
  } else if request.method_name == "tools/call" {
    self.handle_tools_call(id, request.params)
  } else if request.method_name == "resources/list" {
    self.handle_resources_list(id)
  } else if request.method_name == "resources/read" {
    self.handle_resources_read(id, request.params)
  } else if request.method_name == "prompts/list" {
    self.handle_prompts_list(id)
  } else if request.method_name == "prompts/get" {
    self.handle_prompts_get(id, request.params)
  } else {
    @js.Promise::resolve(
      Err(self.method_not_found_error(id, request.method_name)),
    )
  }
}

///|
fn McpServer::handle_initialize(
  self : McpServer,
  id : RequestId,
  _params : @core.Any?,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  // Build capabilities dynamically
  let capabilities : ServerCapabilities = {
    tools: self.tools.length() > 0,
    resources: self.resources.length() > 0,
    prompts: self.prompts.length() > 0,
  }
  let result = @core.from_entries([
    ("protocolVersion", @core.any("2024-11-05")),
    ("serverInfo", @core.any(self.info.as_any())),
    ("capabilities", @core.any(capabilities.as_any())),
  ])
  @js.Promise::resolve(
    Ok({ jsonrpc: "2.0", id, result: @core.identity(result) }),
  )
}

///|
fn McpServer::handle_tools_list(
  self : McpServer,
  id : RequestId,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  let tools : Array[@core.Any] = []
  self.tools.each(fn(_, value) {
    let (tool, _) = value
    tools.push(tool.as_any())
  })
  let result = @core.from_entries([("tools", @core.any(@core.any(tools)))])
  @js.Promise::resolve(
    Ok({ jsonrpc: "2.0", id, result: @core.identity(result) }),
  )
}

///|
fn McpServer::handle_tools_call(
  self : McpServer,
  id : RequestId,
  params : @core.Any?,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  guard params is Some(p) &&
    @core.identity_option(@core.any(p)._get("name")) is Some(tool_name) else {
    return @js.Promise::resolve(
      Err(self.invalid_params_error(id, "Missing tool name")),
    )
  }
  guard self.tools.get(tool_name) is Some((_, handler)) else {
    return @js.Promise::resolve(
      Err(self.method_not_found_error(id, "Tool not found: " + tool_name)),
    )
  }
  let arguments : @core.Any = @core.identity_option(
    @core.any(p)._get("arguments"),
  ).unwrap_or(@core.new_object())
  handler(arguments).then(fn(content) {
    let result = @core.from_entries([
      ("content", @core.any(@core.any(content.map(fn(c) { @core.any(c) })))),
    ])
    @js.Promise::resolve(
      Ok({ jsonrpc: "2.0", id, result: @core.identity(result) }),
    )
  })
}

///|
fn McpServer::handle_resources_list(
  self : McpServer,
  id : RequestId,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  let resources : Array[@core.Any] = []
  self.resources.each(fn(_, value) {
    let (resource, _) = value
    resources.push(resource.as_any())
  })
  let result = @core.from_entries([
    ("resources", @core.any(@core.any(resources))),
  ])
  @js.Promise::resolve(
    Ok({ jsonrpc: "2.0", id, result: @core.identity(result) }),
  )
}

///|
fn McpServer::handle_resources_read(
  self : McpServer,
  id : RequestId,
  params : @core.Any?,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  guard params is Some(p) &&
    @core.identity_option(@core.any(p)._get("uri")) is Some(resource_uri) else {
    return @js.Promise::resolve(
      Err(self.invalid_params_error(id, "Missing resource URI")),
    )
  }
  guard self.resources.get(resource_uri) is Some((_, handler)) else {
    return @js.Promise::resolve(
      Err(
        self.method_not_found_error(id, "Resource not found: " + resource_uri),
      ),
    )
  }
  handler(resource_uri).then(fn(content) {
    let result = @core.from_entries([
      ("contents", @core.any(@core.any(content.map(fn(c) { c.as_any() })))),
    ])
    @js.Promise::resolve(
      Ok({ jsonrpc: "2.0", id, result: @core.identity(result) }),
    )
  })
}

///|
fn McpServer::handle_prompts_list(
  self : McpServer,
  id : RequestId,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  let prompts : Array[@core.Any] = []
  self.prompts.each(fn(_, value) {
    let (prompt, _) = value
    prompts.push(prompt.as_any())
  })
  let result = @core.from_entries([("prompts", @core.any(@core.any(prompts)))])
  @js.Promise::resolve(
    Ok({ jsonrpc: "2.0", id, result: @core.identity(result) }),
  )
}

///|
fn McpServer::handle_prompts_get(
  self : McpServer,
  id : RequestId,
  params : @core.Any?,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  guard params is Some(p) &&
    @core.identity_option(@core.any(p)._get("name")) is Some(prompt_name) else {
    return @js.Promise::resolve(
      Err(self.invalid_params_error(id, "Missing prompt name")),
    )
  }
  guard self.prompts.get(prompt_name) is Some((_, handler)) else {
    return @js.Promise::resolve(
      Err(self.method_not_found_error(id, "Prompt not found: " + prompt_name)),
    )
  }
  let arguments : @core.Any = @core.identity_option(
    @core.any(p)._get("arguments"),
  ).unwrap_or(@core.new_object())
  handler(arguments).then(fn(content) {
    let result = @core.from_entries([
      ("messages", @core.any(@core.any(content.map(fn(c) { c.as_any() })))),
    ])
    @js.Promise::resolve(
      Ok({ jsonrpc: "2.0", id, result: @core.identity(result) }),
    )
  })
}

///|
fn McpServer::method_not_found_error(
  _self : McpServer,
  id : RequestId,
  message : String,
) -> JsonRpcErrorResponse {
  { jsonrpc: "2.0", id, error: { code: method_not_found, message, data: None } }
}

///|
fn McpServer::invalid_params_error(
  _self : McpServer,
  id : RequestId,
  message : String,
) -> JsonRpcErrorResponse {
  { jsonrpc: "2.0", id, error: { code: invalid_params, message, data: None } }
}
