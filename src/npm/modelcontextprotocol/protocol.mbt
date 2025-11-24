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
pub fn Content::to_js(self : Content) -> @js.Object {
  let obj = @js.Object::new()
  obj.set("type", self.type_.to_string())
  match self.text {
    Some(t) => obj.set("text", t)
    None => ()
  }
  match self.data {
    Some(d) => obj.set("data", d)
    None => ()
  }
  match self.mime_type {
    Some(m) => obj.set("mimeType", m)
    None => ()
  }
  match self.uri {
    Some(u) => obj.set("uri", u)
    None => ()
  }
  obj
}

///|
/// Tool Definition
pub(all) struct Tool {
  name : String
  description : String
  input_schema : @js.Object
}

///|
pub fn Tool::to_js(self : Tool) -> @js.Object {
  let obj = @js.Object::new()
  obj.set("name", self.name)
  obj.set("description", self.description)
  obj.set("inputSchema", self.input_schema)
  obj
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
pub fn Resource::to_js(self : Resource) -> @js.Object {
  let obj = @js.Object::new()
  obj.set("uri", self.uri)
  obj.set("name", self.name)
  match self.description {
    Some(d) => obj.set("description", d)
    None => ()
  }
  match self.mime_type {
    Some(m) => obj.set("mimeType", m)
    None => ()
  }
  obj
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
pub fn PromptArgument::to_js(self : PromptArgument) -> @js.Object {
  let obj = @js.Object::new()
  obj.set("name", self.name)
  match self.description {
    Some(d) => obj.set("description", d)
    None => ()
  }
  obj.set("required", self.required)
  obj
}

///|
pub fn Prompt::to_js(self : Prompt) -> @js.Object {
  let obj = @js.Object::new()
  obj.set("name", self.name)
  match self.description {
    Some(d) => obj.set("description", d)
    None => ()
  }
  let args_array = @js.JsArray::new()
  for i = 0; i < self.arguments.length(); i = i + 1 {
    args_array.push(self.arguments[i].to_js())
  }
  obj.set("arguments", args_array)
  obj
}

///|
/// Server Capabilities
pub struct ServerCapabilities {
  tools : Bool
  resources : Bool
  prompts : Bool
} derive(Show)

///|
pub fn ServerCapabilities::to_js(self : ServerCapabilities) -> @js.Object {
  let obj = @js.Object::new()
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
  obj.set("capabilities", capabilities)
  obj
}

///|
/// Server Information
pub struct ServerInfo {
  name : String
  version : String
} derive(Show)

///|
pub fn ServerInfo::to_js(self : ServerInfo) -> @js.Object {
  let obj = @js.Object::new()
  obj.set("name", self.name)
  obj.set("version", self.version)
  obj
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
