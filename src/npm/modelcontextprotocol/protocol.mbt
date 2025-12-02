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
pub fn Content::as_any(self : Content) -> @nostd.Any {
  @mbtconv.from_option_map({
    "type": Some(@nostd.any(self.type_.to_string())),
    "text": self.text.map(fn(t) { @nostd.any(t) }),
    "data": self.data.map(fn(d) { @nostd.any(d) }),
    "mimeType": self.mime_type.map(fn(m) { @nostd.any(m) }),
    "uri": self.uri.map(fn(u) { @nostd.any(u) }),
  }).cast()
}

///|
/// Tool Definition
pub(all) struct Tool {
  name : String
  description : String
  input_schema : @nostd.Any
}

///|
pub fn Tool::as_any(self : Tool) -> @nostd.Any {
  @nostd.identity(
    @mbtconv.from_map({
      "name": @nostd.any(self.name),
      "description": @nostd.any(self.description),
      "inputSchema": @nostd.any(self.input_schema),
    }),
  )
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
pub fn Resource::as_any(self : Resource) -> @nostd.Any {
  @mbtconv.from_option_map({
    "uri": Some(@nostd.any(self.uri)),
    "name": Some(@nostd.any(self.name)),
    "description": self.description.map(fn(d) { @nostd.any(d) }),
    "mimeType": self.mime_type.map(fn(m) { @nostd.any(m) }),
  }).cast()
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
pub fn PromptArgument::as_any(self : PromptArgument) -> @nostd.Any {
  @mbtconv.from_option_map({
    "name": Some(@nostd.any(self.name)),
    "description": self.description.map(fn(d) { @nostd.any(d) }),
    "required": Some(@nostd.any(self.required)),
  }).cast()
}

///|
pub fn Prompt::as_any(self : Prompt) -> @nostd.Any {
  let args : Array[@nostd.Any] = []
  for i = 0; i < self.arguments.length(); i = i + 1 {
    args.push(self.arguments[i].as_any())
  }
  @mbtconv.from_option_map({
    "name": Some(@nostd.any(self.name)),
    "description": self.description.map(fn(d) { @nostd.any(d) }),
    "arguments": Some(@nostd.identity(@nostd.any(args))),
  }).cast()
}

///|
/// Server Capabilities
pub struct ServerCapabilities {
  tools : Bool
  resources : Bool
  prompts : Bool
} derive(Show)

///|
pub fn ServerCapabilities::as_any(self : ServerCapabilities) -> @nostd.Any {
  let capabilities = @nostd.Object::new()
  if self.tools {
    capabilities._set("tools", @nostd.Object::new())
  }
  if self.resources {
    capabilities._set("resources", @nostd.Object::new())
  }
  if self.prompts {
    capabilities._set("prompts", @nostd.Object::new())
  }
  @nostd.identity(
    @nostd.from_entries([("capabilities", @nostd.any(capabilities))]),
  )
}

///|
/// Server Information
pub struct ServerInfo {
  name : String
  version : String
} derive(Show)

///|
pub fn ServerInfo::as_any(self : ServerInfo) -> @nostd.Any {
  @nostd.identity(
    @mbtconv.from_map({
      "name": @nostd.any(self.name),
      "version": @nostd.any(self.version),
    }),
  )
}

///|
/// Client Information
pub struct ClientInfo {
  name : String
  version : String
} derive(Show)

///|
pub fn ClientInfo::from_js(js : @nostd.Any) -> ClientInfo? {
  let obj : @js.Object = @nostd.identity(js)
  let name : String? = @nostd.any(obj)._get("name") |> @nostd.identity_option()
  let version : String? = @nostd.any(obj)._get("version")
    |> @nostd.identity_option()
  match (name, version) {
    (Some(n), Some(v)) => Some({ name: n, version: v })
    _ => None
  }
}
