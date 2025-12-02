///|
/// Example MCP Server
/// Run with: moon run src/examples/mcp_server
fn main {
  @async.run_async_main(run)
}

///|
async fn run() -> Unit {
  // Create server
  let server = @mcp.SdkServer::new("example-server", "1.0.0")
  // Register tools
  server.set_tools_list_handler(fn() {
    [
      {
        name: "greet",
        description: "Greet someone by name",
        input_schema: @mbtconv.from_map({
          "type": @core.any("object"),
          "properties": @mbtconv.from_map({
            "name": @mbtconv.from_map({
              "type": @core.any("string"),
              "description": @core.any("Name to greet"),
            }).cast(),
          }).cast(),
          "required": @core.any(["name"]),
        }).cast(),
      },
      {
        name: "add",
        description: "Add two numbers",
        input_schema: @mbtconv.from_map({
          "type": @core.any("object"),
          "properties": @mbtconv.from_map({
            "a": @mbtconv.from_map({
              "type": @core.any("number"),
              "description": @core.any("First number"),
            }).cast(),
            "b": @mbtconv.from_map({
              "type": @core.any("number"),
              "description": @core.any("Second number"),
            }).cast(),
          }).cast(),
          "required": @core.any(["a", "b"]),
        }).cast(),
      },
    ]
  })
  // Register tool call handler
  server.set_tools_call_handler(async fn(name, args) {
    if name == "greet" {
      let person_name : String = args._get("name").cast()
      [@mcp.Content::text("Hello, " + person_name + "!")]
    } else if name == "add" {
      let a : Double = args._get("a").cast()
      let b : Double = args._get("b").cast()
      let result = a + b
      [@mcp.Content::text("Result: " + result.to_string())]
    } else {
      [@mcp.Content::text("Unknown tool: " + name)]
    }
  })
  // Register resources
  server.set_resources_list_handler(fn() {
    [
      {
        uri: "file:///example.txt",
        name: "example.txt",
        description: Some("An example text file"),
        mime_type: Some("text/plain"),
      },
    ]
  })
  // Register resource read handler
  server.set_resources_read_handler(async fn(uri) {
    if uri == "file:///example.txt" {
      [@mcp.Content::text("This is example content.")]
    } else {
      [@mcp.Content::text("Resource not found: " + uri)]
    }
  })
  // Register prompts
  server.set_prompts_list_handler(fn() {
    [
      {
        name: "greeting-template",
        description: Some("Generate a greeting"),
        arguments: [
          { name: "name", description: Some("Name to greet"), required: true },
        ],
      },
    ]
  })
  // Register prompt get handler
  server.set_prompts_get_handler(async fn(name, args) {
    if name == "greeting-template" {
      let person_name : String = args._get("name")
        |> @core.identity_option()
        |> Option::unwrap_or("World")
      {
        description: Some("A friendly greeting"),
        messages: [
          {
            role: "user",
            content: @mcp.Content::text("Please greet " + person_name),
          },
        ],
      }
    } else {
      { description: None, messages: [] }
    }
  })
  // Connect to stdio transport
  let transport = @mcp.StdioServerTransport::new()
  server.connect(transport)
  // Keep server running
  loop_forever()
}

///|
extern "js" fn loop_forever() -> Unit =
  #| () => { setInterval(() => {}, 1000 * 60 * 60); }
