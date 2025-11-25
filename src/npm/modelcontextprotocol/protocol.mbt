///| MCP Protocol Types

///|
/// Content Type - text or resource
pub enum ContentType {
  Text
  Image
  Resource
} derive(Show, Eq)

///|
pub fn ContentType::to_string(self : ContentType) -> String {
  match self {
    Text => "text"
    Image => "image"
    Resource => "resource"
  }
}

///|
/// Content Block
pub struct Content {
  type_ : ContentType
  text : String?
  data : String?
  mime_type : String?
  uri : String?
} derive(Show)

///|
pub fn Content::text(text : String) -> Content {
  { type_: Text, text: Some(text), data: None, mime_type: None, uri: None }
}

///|
pub fn Content::image(data : String, mime_type : String) -> Content {
  {
    type_: Image,
    text: None,
    data: Some(data),
    mime_type: Some(mime_type),
    uri: None,
  }
}

///|
pub fn Content::resource(uri : String) -> Content {
  { type_: Resource, text: None, data: None, mime_type: None, uri: Some(uri) }
}

///|
pub fn Content::to_any(self : Content) -> @js.Any {
  @js.from_option_map({
    "type": Some(@js.any(self.type_.to_string())),
    "text": self.text.map(fn(t) { @js.any(t) }),
    "data": self.data.map(fn(d) { @js.any(d) }),
    "mimeType": self.mime_type.map(fn(m) { @js.any(m) }),
    "uri": self.uri.map(fn(u) { @js.any(u) }),
  })
}

///|
/// Tool Definition
pub(all) struct Tool {
  name : String
  description : String
  input_schema : @js.Any
}

///|
pub fn Tool::to_any(self : Tool) -> @js.Any {
  @js.from_map({
    "name": @js.any(self.name),
    "description": @js.any(self.description),
    "inputSchema": self.input_schema,
  })
}

///|
/// Resource Definition
pub(all) struct Resource {
  uri : String
  name : String
  description : String?
  mime_type : String?
} derive(Show)

///|
pub fn Resource::to_any(self : Resource) -> @js.Any {
  @js.from_option_map({
    "uri": Some(@js.any(self.uri)),
    "name": Some(@js.any(self.name)),
    "description": self.description.map(fn(d) { @js.any(d) }),
    "mimeType": self.mime_type.map(fn(m) { @js.any(m) }),
  })
}

///|
/// Prompt Definition
pub(all) struct Prompt {
  name : String
  description : String?
  arguments : Array[PromptArgument]
} derive(Show)

///|
pub(all) struct PromptArgument {
  name : String
  description : String?
  required : Bool
} derive(Show)

///|
pub fn PromptArgument::to_any(self : PromptArgument) -> @js.Any {
  @js.from_option_map({
    "name": Some(@js.any(self.name)),
    "description": self.description.map(fn(d) { @js.any(d) }),
    "required": Some(@js.any(self.required)),
  })
}

///|
pub fn Prompt::to_any(self : Prompt) -> @js.Any {
  let args : Array[@js.Any] = []
  for i = 0; i < self.arguments.length(); i = i + 1 {
    args.push(self.arguments[i].to_any())
  }
  @js.from_option_map({
    "name": Some(@js.any(self.name)),
    "description": self.description.map(fn(d) { @js.any(d) }),
    "arguments": Some(@js.from_array(args)),
  })
}

///|
/// Server Capabilities
pub struct ServerCapabilities {
  tools : Bool
  resources : Bool
  prompts : Bool
} derive(Show)

///|
pub fn ServerCapabilities::to_any(self : ServerCapabilities) -> @js.Any {
  let capabilities = @js.Object::new()
  if self.tools {
    capabilities.set("tools", @js.Object::new())
  }
  if self.resources {
    capabilities.set("resources", @js.Object::new())
  }
  if self.prompts {
    capabilities.set("prompts", @js.Object::new())
  }
  @js.from_map({ "capabilities": capabilities })
}

///|
/// Server Information
pub struct ServerInfo {
  name : String
  version : String
} derive(Show)

///|
pub fn ServerInfo::to_any(self : ServerInfo) -> @js.Any {
  @js.from_map({ "name": @js.any(self.name), "version": @js.any(self.version) })
}

///|
/// Client Information
pub struct ClientInfo {
  name : String
  version : String
} derive(Show)

///|
pub fn ClientInfo::from_js(js : @js.Any) -> ClientInfo? {
  let obj : @js.Object = @js.identity(js)
  let name : String? = obj.get("name") |> @js.identity_option()
  let version : String? = obj.get("version") |> @js.identity_option()
  match (name, version) {
    (Some(n), Some(v)) => Some({ name: n, version: v })
    _ => None
  }
}
