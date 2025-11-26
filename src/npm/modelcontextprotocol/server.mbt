///| MCP Server Implementation

///|
/// Tool Handler - takes params and returns content
pub type ToolHandler = (@js.Any) -> @js.Promise[Array[Content]]

///|
/// Resource Handler - returns content for a resource URI
pub type ResourceHandler = (String) -> @js.Promise[Array[Content]]

///|
/// Prompt Handler - takes arguments and returns messages
pub type PromptHandler = (@js.Any) -> @js.Promise[Array[Content]]

///|
/// MCP Server
pub struct McpServer {
  info : ServerInfo
  mut tools : @immut/hashmap.HashMap[String, (Tool, ToolHandler)]
  mut resources : @immut/hashmap.HashMap[String, (Resource, ResourceHandler)]
  mut prompts : @immut/hashmap.HashMap[String, (Prompt, PromptHandler)]
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
/// Register a tool
pub fn McpServer::add_tool(
  self : McpServer,
  tool : Tool,
  handler : ToolHandler,
) -> Unit {
  self.tools = self.tools.add(tool.name, (tool, handler))
}

///|
/// Register a resource
pub fn McpServer::add_resource(
  self : McpServer,
  resource : Resource,
  handler : ResourceHandler,
) -> Unit {
  self.resources = self.resources.add(resource.uri, (resource, handler))
}

///|
/// Register a prompt
pub fn McpServer::add_prompt(
  self : McpServer,
  prompt : Prompt,
  handler : PromptHandler,
) -> Unit {
  self.prompts = self.prompts.add(prompt.name, (prompt, handler))
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
  _params : @js.Object?,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  // Build capabilities dynamically
  let capabilities : ServerCapabilities = {
    tools: self.tools.length() > 0,
    resources: self.resources.length() > 0,
    prompts: self.prompts.length() > 0,
  }
  let result = @js.from_map({
    "protocolVersion": @js.any("2024-11-05"),
    "serverInfo": self.info.to_any(),
    "capabilities": capabilities.to_any(),
  })
  @js.Promise::resolve(Ok({ jsonrpc: "2.0", id, result: @js.identity(result) }))
}

///|
fn McpServer::handle_tools_list(
  self : McpServer,
  id : RequestId,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  let tools : Array[@js.Any] = []
  self.tools.each(fn(_, value) {
    let (tool, _) = value
    tools.push(tool.to_any())
  })
  let result = @js.from_map({ "tools": @js.from_array(tools) })
  @js.Promise::resolve(Ok({ jsonrpc: "2.0", id, result: @js.identity(result) }))
}

///|
fn McpServer::handle_tools_call(
  self : McpServer,
  id : RequestId,
  params : @js.Object?,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  guard params is Some(p) &&
    @js.identity_option(p.get("name")) is Some(tool_name) else {
    return @js.Promise::resolve(
      Err(self.invalid_params_error(id, "Missing tool name")),
    )
  }
  guard self.tools.get(tool_name) is Some((_, handler)) else {
    return @js.Promise::resolve(
      Err(self.method_not_found_error(id, "Tool not found: " + tool_name)),
    )
  }
  let arguments : @js.Any = @js.identity_option(p.get("arguments")).unwrap_or(
    @js.identity(@js.Object::new()),
  )
  handler(arguments).then(fn(content) {
    let result = @js.from_map({
      "content": @js.from_array(content.map(fn(c) { c.to_any() })),
    })
    @js.Promise::resolve(
      Ok({ jsonrpc: "2.0", id, result: @js.identity(result) }),
    )
  })
}

///|
fn McpServer::handle_resources_list(
  self : McpServer,
  id : RequestId,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  let resources : Array[@js.Any] = []
  self.resources.each(fn(_, value) {
    let (resource, _) = value
    resources.push(resource.to_any())
  })
  let result = @js.from_map({ "resources": @js.from_array(resources) })
  @js.Promise::resolve(Ok({ jsonrpc: "2.0", id, result: @js.identity(result) }))
}

///|
fn McpServer::handle_resources_read(
  self : McpServer,
  id : RequestId,
  params : @js.Object?,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  guard params is Some(p) &&
    @js.identity_option(p.get("uri")) is Some(resource_uri) else {
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
    let result = @js.from_map({
      "contents": @js.from_array(content.map(fn(c) { c.to_any() })),
    })
    @js.Promise::resolve(
      Ok({ jsonrpc: "2.0", id, result: @js.identity(result) }),
    )
  })
}

///|
fn McpServer::handle_prompts_list(
  self : McpServer,
  id : RequestId,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  let prompts : Array[@js.Any] = []
  self.prompts.each(fn(_, value) {
    let (prompt, _) = value
    prompts.push(prompt.to_any())
  })
  let result = @js.from_map({ "prompts": @js.from_array(prompts) })
  @js.Promise::resolve(Ok({ jsonrpc: "2.0", id, result: @js.identity(result) }))
}

///|
fn McpServer::handle_prompts_get(
  self : McpServer,
  id : RequestId,
  params : @js.Object?,
) -> @js.Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  guard params is Some(p) &&
    @js.identity_option(p.get("name")) is Some(prompt_name) else {
    return @js.Promise::resolve(
      Err(self.invalid_params_error(id, "Missing prompt name")),
    )
  }
  guard self.prompts.get(prompt_name) is Some((_, handler)) else {
    return @js.Promise::resolve(
      Err(self.method_not_found_error(id, "Prompt not found: " + prompt_name)),
    )
  }
  let arguments : @js.Any = @js.identity_option(p.get("arguments")).unwrap_or(
    @js.Object::new(),
  )
  handler(arguments).then(fn(content) {
    let result = @js.from_map({
      "messages": @js.from_array(content.map(fn(c) { c.to_any() })),
    })
    @js.Promise::resolve(
      Ok({ jsonrpc: "2.0", id, result: @js.identity(result) }),
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
