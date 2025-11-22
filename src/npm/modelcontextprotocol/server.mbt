///| MCP Server Implementation

///|
/// Tool Handler - takes params and returns content
pub type ToolHandler = (Object) -> Promise[Array[Content]]

///|
/// Resource Handler - returns content for a resource URI
pub type ResourceHandler = (String) -> Promise[Array[Content]]

///|
/// Prompt Handler - takes arguments and returns messages
pub type PromptHandler = (Object) -> Promise[Array[Content]]

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
) -> Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
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
    Promise::resolve(Err(self.method_not_found_error(id, request.method_name)))
  }
}

///|
fn McpServer::handle_initialize(
  self : McpServer,
  id : RequestId,
  _params : Object?,
) -> Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  let result = Object::new()
  result.set("protocolVersion", "2024-11-05")
  result.set("serverInfo", self.info.to_js())

  // Build capabilities dynamically
  let capabilities : ServerCapabilities = {
    tools: self.tools.length() > 0,
    resources: self.resources.length() > 0,
    prompts: self.prompts.length() > 0,
  }
  result.set("capabilities", capabilities.to_js())
  Promise::resolve(Ok({ jsonrpc: "2.0", id, result: @js.unsafe_cast(result) }))
}

///|
fn McpServer::handle_tools_list(
  self : McpServer,
  id : RequestId,
) -> Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  let tools_array = JsArray::new()
  self.tools.each(fn(_, value) {
    let (tool, _) = value
    tools_array.push(tool.to_js())
  })
  let result = Object::new()
  result.set("tools", tools_array)
  Promise::resolve(Ok({ jsonrpc: "2.0", id, result: @js.unsafe_cast(result) }))
}

///|
fn McpServer::handle_tools_call(
  self : McpServer,
  id : RequestId,
  params : Object?,
) -> Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  match params {
    None =>
      Promise::resolve(Err(self.invalid_params_error(id, "Missing params")))
    Some(p) => {
      let name : String? = p.get("name") |> @js.unsafe_cast_option()
      match name {
        None =>
          Promise::resolve(
            Err(self.invalid_params_error(id, "Missing tool name")),
          )
        Some(tool_name) =>
          match self.tools.get(tool_name) {
            None =>
              Promise::resolve(
                Err(
                  self.method_not_found_error(
                    id,
                    "Tool not found: " + tool_name,
                  ),
                ),
              )
            Some((_, handler)) => {
              let arguments : Object = match
                (p.get("arguments") |> @js.unsafe_cast_option()) {
                Some(args) => args
                None => Object::new()
              }
              handler(arguments).then(fn(content) {
                let content_array = JsArray::new()
                for i = 0; i < content.length(); i = i + 1 {
                  content_array.push(content[i].to_js())
                }
                let result = Object::new()
                result.set("content", content_array)
                Promise::resolve(
                  Ok({ jsonrpc: "2.0", id, result: @js.unsafe_cast(result) }),
                )
              })
            }
          }
      }
    }
  }
}

///|
fn McpServer::handle_resources_list(
  self : McpServer,
  id : RequestId,
) -> Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  let resources_array = JsArray::new()
  self.resources.each(fn(_, value) {
    let (resource, _) = value
    resources_array.push(resource.to_js())
  })
  let result = Object::new()
  result.set("resources", resources_array)
  Promise::resolve(Ok({ jsonrpc: "2.0", id, result: @js.unsafe_cast(result) }))
}

///|
fn McpServer::handle_resources_read(
  self : McpServer,
  id : RequestId,
  params : Object?,
) -> Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  match params {
    None =>
      Promise::resolve(Err(self.invalid_params_error(id, "Missing params")))
    Some(p) => {
      let uri : String? = p.get("uri") |> @js.unsafe_cast_option()
      match uri {
        None =>
          Promise::resolve(
            Err(self.invalid_params_error(id, "Missing resource URI")),
          )
        Some(resource_uri) =>
          match self.resources.get(resource_uri) {
            None =>
              Promise::resolve(
                Err(
                  self.method_not_found_error(
                    id,
                    "Resource not found: " + resource_uri,
                  ),
                ),
              )
            Some((_, handler)) =>
              handler(resource_uri).then(fn(content) {
                let content_array = JsArray::new()
                for i = 0; i < content.length(); i = i + 1 {
                  content_array.push(content[i].to_js())
                }
                let result = Object::new()
                result.set("contents", content_array)
                Promise::resolve(
                  Ok({ jsonrpc: "2.0", id, result: @js.unsafe_cast(result) }),
                )
              })
          }
      }
    }
  }
}

///|
fn McpServer::handle_prompts_list(
  self : McpServer,
  id : RequestId,
) -> Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  let prompts_array = JsArray::new()
  self.prompts.each(fn(_, value) {
    let (prompt, _) = value
    prompts_array.push(prompt.to_js())
  })
  let result = Object::new()
  result.set("prompts", prompts_array)
  Promise::resolve(Ok({ jsonrpc: "2.0", id, result: @js.unsafe_cast(result) }))
}

///|
fn McpServer::handle_prompts_get(
  self : McpServer,
  id : RequestId,
  params : Object?,
) -> Promise[Result[JsonRpcResponse, JsonRpcErrorResponse]] {
  match params {
    None =>
      Promise::resolve(Err(self.invalid_params_error(id, "Missing params")))
    Some(p) => {
      let name : String? = p.get("name") |> @js.unsafe_cast_option()
      match name {
        None =>
          Promise::resolve(
            Err(self.invalid_params_error(id, "Missing prompt name")),
          )
        Some(prompt_name) =>
          match self.prompts.get(prompt_name) {
            None =>
              Promise::resolve(
                Err(
                  self.method_not_found_error(
                    id,
                    "Prompt not found: " + prompt_name,
                  ),
                ),
              )
            Some((_, handler)) => {
              let arguments : Object = match
                (p.get("arguments") |> @js.unsafe_cast_option()) {
                Some(args) => args
                None => Object::new()
              }
              handler(arguments).then(fn(content) {
                let content_array = JsArray::new()
                for i = 0; i < content.length(); i = i + 1 {
                  content_array.push(content[i].to_js())
                }
                let result = Object::new()
                result.set("messages", content_array)
                Promise::resolve(
                  Ok({ jsonrpc: "2.0", id, result: @js.unsafe_cast(result) }),
                )
              })
            }
          }
      }
    }
  }
}

///|
fn McpServer::method_not_found_error(
  self : McpServer,
  id : RequestId,
  message : String,
) -> JsonRpcErrorResponse {
  { jsonrpc: "2.0", id, error: { code: method_not_found, message, data: None } }
}

///|
fn McpServer::invalid_params_error(
  self : McpServer,
  id : RequestId,
  message : String,
) -> JsonRpcErrorResponse {
  { jsonrpc: "2.0", id, error: { code: invalid_params, message, data: None } }
}
