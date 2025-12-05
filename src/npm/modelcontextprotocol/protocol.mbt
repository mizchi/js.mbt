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
pub fn Content::as_any(self : Content) -> @core.Any {
  let entries : Array[(String, @core.Any)] = [
    ("type", @core.any(self.type_.to_string())),
  ]
  if self.text is Some(t) {
    entries.push(("text", @core.any(t)))
  }
  if self.data is Some(d) {
    entries.push(("data", @core.any(d)))
  }
  if self.mime_type is Some(m) {
    entries.push(("mimeType", @core.any(m)))
  }
  if self.uri is Some(u) {
    entries.push(("uri", @core.any(u)))
  }
  @core.from_entries(entries).cast()
}

///|
/// Tool Definition
pub(all) struct Tool {
  name : String
  description : String
  input_schema : @core.Any
}

///|
pub fn Tool::as_any(self : Tool) -> @core.Any {
  @core.identity(
    @core.from_entries([
      ("name", @core.any(self.name)),
      ("description", @core.any(self.description)),
      ("inputSchema", @core.any(self.input_schema)),
    ]),
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
pub fn Resource::as_any(self : Resource) -> @core.Any {
  let entries : Array[(String, @core.Any)] = [
    ("uri", @core.any(self.uri)),
    ("name", @core.any(self.name)),
  ]
  if self.description is Some(d) {
    entries.push(("description", @core.any(d)))
  }
  if self.mime_type is Some(m) {
    entries.push(("mimeType", @core.any(m)))
  }
  @core.from_entries(entries).cast()
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
pub fn PromptArgument::as_any(self : PromptArgument) -> @core.Any {
  let entries : Array[(String, @core.Any)] = [
    ("name", @core.any(self.name)),
    ("required", @core.any(self.required)),
  ]
  if self.description is Some(d) {
    entries.push(("description", @core.any(d)))
  }
  @core.from_entries(entries).cast()
}

///|
pub fn Prompt::as_any(self : Prompt) -> @core.Any {
  let args : Array[@core.Any] = []
  for i = 0; i < self.arguments.length(); i = i + 1 {
    args.push(self.arguments[i].as_any())
  }
  let entries : Array[(String, @core.Any)] = [
    ("name", @core.any(self.name)),
    ("arguments", @core.identity(@core.any(args))),
  ]
  if self.description is Some(d) {
    entries.push(("description", @core.any(d)))
  }
  @core.from_entries(entries).cast()
}

///|
/// Server Capabilities
pub struct ServerCapabilities {
  tools : Bool
  resources : Bool
  prompts : Bool
} derive(Show)

///|
pub fn ServerCapabilities::as_any(self : ServerCapabilities) -> @core.Any {
  let capabilities = @core.new_object()
  if self.tools {
    capabilities._set("tools", @core.new_object())
  }
  if self.resources {
    capabilities._set("resources", @core.new_object())
  }
  if self.prompts {
    capabilities._set("prompts", @core.new_object())
  }
  @core.identity(
    @core.from_entries([("capabilities", @core.any(capabilities))]),
  )
}

///|
/// Server Information
pub struct ServerInfo {
  name : String
  version : String
} derive(Show)

///|
pub fn ServerInfo::as_any(self : ServerInfo) -> @core.Any {
  @core.identity(
    @core.from_entries([
      ("name", @core.any(self.name)),
      ("version", @core.any(self.version)),
    ]),
  )
}

///|
/// Client Information
pub struct ClientInfo {
  name : String
  version : String
} derive(Show)

///|
pub fn ClientInfo::from_js(js : @core.Any) -> ClientInfo? {
  let obj : @js.Object = @core.identity(js)
  let name : String? = @core.any(obj)._get("name") |> @core.identity_option()
  let version : String? = @core.any(obj)._get("version")
    |> @core.identity_option()
  match (name, version) {
    (Some(n), Some(v)) => Some({ name: n, version: v })
    _ => None
  }
}
