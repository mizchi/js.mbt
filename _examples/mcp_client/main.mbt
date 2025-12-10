///|
/// Example MCP Client
/// Run with: moon run src/examples/mcp_client
fn main {
  @async.run_async_main(run)
}

///|
async fn run() -> Unit {
  // Create client
  let client = @mcp.SdkClient::new("example-client", "1.0.0")
  // Create transport that connects to the example server
  let transport = @mcp.StdioClientTransport::new("node", [
    "target/js/debug/build/examples/mcp_server/mcp_server.js",
  ])
  // Connect
  println("Connecting to server...")
  client.connect(transport)
  println("Connected!")
  // List tools
  println("\n=== Listing Tools ===")
  let tools_result = client.list_tools()
  for tool in tools_result.tools {
    println("Tool: " + tool.name)
    if tool.description is Some(desc) {
      println("  Description: " + desc)
    }
  }
  // Call greet tool
  println("\n=== Calling 'greet' Tool ===")
  let greet_result = client.call_tool(
    "greet",
    @core.from_entries([("name", @core.any("MoonBit"))]).cast(),
  )
  for content in greet_result.content {
    if content.text is Some(text) {
      println("Response: " + text)
    }
  }
  // Call add tool
  println("\n=== Calling 'add' Tool ===")
  let add_result = client.call_tool(
    "add",
    @mbtconv.from_map({ "a": @core.any(10.0), "b": @core.any(32.0) }).cast(),
  )
  for content in add_result.content {
    if content.text is Some(text) {
      println("Response: " + text)
    }
  }
  // List resources
  println("\n=== Listing Resources ===")
  let resources_result = client.list_resources()
  for resource in resources_result.resources {
    println("Resource: " + resource.uri)
    println("  Name: " + resource.name)
    if resource.description is Some(desc) {
      println("  Description: " + desc)
    }
  }
  // Read resource
  println("\n=== Reading Resource ===")
  let read_result = client.read_resource("file:///example.txt")
  for content in read_result.contents {
    if content.text is Some(text) {
      println("Content: " + text)
    }
  }
  // List prompts
  println("\n=== Listing Prompts ===")
  let prompts_result = client.list_prompts()
  for prompt in prompts_result.prompts {
    println("Prompt: " + prompt.name)
    if prompt.description is Some(desc) {
      println("  Description: " + desc)
    }
  }
  // Get prompt
  println("\n=== Getting Prompt ===")
  let prompt_result = client.get_prompt(
    "greeting-template",
    Some(@core.from_entries([("name", @core.any("Developer"))]).cast()),
  )
  if prompt_result.description is Some(desc) {
    println("Description: " + desc)
  }
  for msg in prompt_result.messages {
    println("Role: " + msg.role)
    if msg.content.text is Some(text) {
      println("Content: " + text)
    }
  }
  // Close
  println("\n=== Closing ===")
  client.close()
  println("Done!")
}
