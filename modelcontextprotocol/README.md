WIP

---

# Model Context Protocol (MCP) for MoonBit

MoonBit bindings for the [Model Context Protocol](https://modelcontextprotocol.io/).

## Overview

The Model Context Protocol (MCP) is an open protocol that standardizes how applications provide context to LLMs. This package provides MoonBit bindings for both MCP clients and servers.

## Features

- **Server Implementation**: Create MCP servers with tools, resources, and prompts
- **Client Implementation**: Connect to MCP servers and invoke their capabilities
- **JSON-RPC 2.0**: Full implementation of the JSON-RPC 2.0 protocol
- **Type-Safe**: Leverages MoonBit's type system for safe protocol handling

## Installation

```bash
moon add mizchi/js
moon add mizchi/npm_typed
npm install @modelcontextprotocol/sdk
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/npm_typed/modelcontextprotocol"
  ]
}
```

## Usage

### Creating an MCP Server

```moonbit
let server = McpServer::new("my-server", "1.0.0")

// Add a tool
let schema = Object::new()
schema.set("type", "object")

let tool : Tool = {
  name: "hello",
  description: "Says hello",
  input_schema: schema
}

let handler : ToolHandler = fn(params) {
  let name = match params._get("name") {
    Some(n) => @js.identity(n)
    None => "World"
  }
  Promise::resolve([Content::text("Hello, " + name + "!")])
}

server.add_tool(tool, handler)

// Handle requests
let request : JsonRpcRequest = {
  jsonrpc: "2.0",
  id: Number(1),
  method: "tools/call",
  params: Some(params_obj)
}

server.handle_request(request).then(fn(result) {
  match result {
    Ok(response) => // Handle success
    Err(error) => // Handle error
  }
})
```

### Creating an MCP Client

```moonbit
let client = McpClient::new("http://localhost:3000/mcp")

// Initialize connection
let client_info : ClientInfo = {
  name: "my-client",
  version: "1.0.0"
}

client.initialize(client_info).then(fn(_) {
  // List available tools
  client.list_tools().then(fn(tools) {
    // Call a tool
    let args = Object::new()
    args.set("name", "Alice")
    
    client.call_tool("hello", args).then(fn(content) {
      // Process result
    })
  })
})
```

### Working with Resources

```moonbit
// Server side
let resource : Resource = {
  uri: "file:///data/example.txt",
  name: "example.txt",
  description: Some("Example data file"),
  mime_type: Some("text/plain")
}

let handler : ResourceHandler = fn(uri) {
  // Read file content
  Promise::resolve([Content::text("File content here")])
}

server.add_resource(resource, handler)

// Client side
client.list_resources().then(fn(resources) {
  client.read_resource("file:///data/example.txt").then(fn(content) {
    // Process content
  })
})
```

### Working with Prompts

```moonbit
// Server side
let prompt : Prompt = {
  name: "greeting",
  description: Some("Generate a greeting"),
  arguments: [
    { name: "name", description: Some("Name to greet"), required: true }
  ]
}

let handler : PromptHandler = fn(args) {
  Promise::resolve([Content::text("Hello, {name}!")])
}

server.add_prompt(prompt, handler)

// Client side
client.list_prompts().then(fn(prompts) {
  let args = Object::new()
  args.set("name", "Bob")
  
  client.get_prompt("greeting", args).then(fn(messages) {
    // Process messages
  })
})
```

## Protocol Support

This implementation supports MCP protocol version **2024-11-05**.

### Supported Capabilities

**Server:**
- Tools (with input schema validation)
- Resources (URI-based content access)
- Prompts (templated LLM interactions)

**Client:**
- Tool discovery and invocation
- Resource listing and reading
- Prompt listing and retrieval

### JSON-RPC Methods

- `initialize` - Initialize client-server connection
- `tools/list` - List available tools
- `tools/call` - Invoke a tool
- `resources/list` - List available resources
- `resources/read` - Read a resource
- `prompts/list` - List available prompts
- `prompts/get` - Get a prompt

## Type Reference

### Core Types

- `JsonRpcRequest` - JSON-RPC 2.0 request
- `JsonRpcResponse` - JSON-RPC 2.0 success response
- `JsonRpcErrorResponse` - JSON-RPC 2.0 error response
- `JsonRpcNotification` - JSON-RPC 2.0 notification

### MCP Types

- `Content` - Content block (text, image, or resource)
- `Tool` - Tool definition
- `Resource` - Resource definition
- `Prompt` - Prompt definition
- `ServerInfo` - Server metadata
- `ClientInfo` - Client metadata
- `ServerCapabilities` - Server capability flags

### Handler Types

- `ToolHandler = (Object) -> Promise[Array[Content]]`
- `ResourceHandler = (String) -> Promise[Array[Content]]`
- `PromptHandler = (Object) -> Promise[Array[Content]]`

## License

See the main project license.

## References

- [MCP Specification](https://modelcontextprotocol.io/specification/)
- [MCP TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [JSON-RPC 2.0 Specification](https://www.jsonrpc.org/specification)
