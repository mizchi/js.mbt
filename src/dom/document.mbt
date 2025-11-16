///|
/// Document represents the web page loaded in the browser
/// https://developer.mozilla.org/en-US/docs/Web/API/Document
#external
pub type Document

///|
pub impl Js for Document

///|
pub impl EventTargetImpl for Document

///|
pub impl NodeImpl for Document

///|
/// Returns the global document object
pub extern "js" fn document() -> Document =
  #| () => document

///|
/// Converts Document to Element
pub fn Document::as_element(self : Self) -> Val {
  self |> unsafe_cast
}

///|
/// Returns the currently focused element
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/activeElement
#alias(activeElement)
pub extern "js" fn Document::active_element(self : Self) -> Element =
  #|(self) => self.activeElement

///|
/// Creates a new element with the given tag name
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createElement
#alias(createElement)
pub extern "js" fn Document::create_element(
  self : Self,
  tag_name : String,
) -> Element =
  #|(self, tag) => self.createElement(tag)

///|
/// Creates a new element with namespace
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createElementNS
#alias(createElementNS)
pub extern "js" fn Document::create_element_ns(
  self : Self,
  namespace_uri : String,
  qualified_name : String,
) -> Element =
  #|(self, namespaceURI, qualifiedName) => self.createElementNS(namespaceURI, qualifiedName)

///|
/// Creates a text node with the given data
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createTextNode
#alias(createTextNode)
pub extern "js" fn Document::create_text_node(
  self : Self,
  data : String,
) -> Text =
  #|(self, data) => self.createTextNode(data)

///|
/// Returns the document's ready state
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/readyState
#alias(ready_state)
pub fn Document::readyState(self : Self) -> String {
  unsafe_cast(self.get("readyState"))
}

///|
/// Returns the first element matching the selector
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector
#alias(querySelector)
pub fn Document::query_selector(self : Self, selector : String) -> Val? {
  self.invoke("querySelector", [selector |> js]) |> to_option()
}

///|
/// Returns all elements matching the selector
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelectorAll
#alias(query_selector_all)
pub fn Document::querySelectorAll(self : Self, selector : String) -> Val {
  self.invoke("querySelectorAll", [selector |> js])
}

///|
/// Returns an element by its ID
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementById
#alias(get_element_by_id)
pub fn Document::getElementById(self : Self, id : String) -> Val? {
  self.invoke("getElementById", [id |> js]) |> to_option()
}

///|
/// Returns elements with the specified class name
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementsByClassName
#alias(get_elements_by_class_name)
pub fn Document::getElementsByClassName(
  self : Self,
  class_name : String,
) -> Val {
  self.invoke("getElementsByClassName", [class_name |> js])
}

///|
/// Returns elements with the specified tag name
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementsByTagName
#alias(get_elements_by_tag_name)
pub fn Document::getElementsByTagName(self : Self, tag_name : String) -> Val {
  self.invoke("getElementsByTagName", [tag_name |> js])
}

///|
/// Returns the document's cookie string
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/cookie
pub extern "js" fn Document::cookie(self : Self) -> String =
  #|(self) => self.cookie

///|
/// Sets the document's cookie
pub extern "js" fn Document::set_cookie(self : Self, content : String) -> Unit =
  #|(self, content) => self.cookie = content

///|
/// Returns the document's body element
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/body
pub fn Document::body(self : Self) -> HTMLBodyElement? {
  self.get("body") |> to_option()
}

///|
/// Sets the document's body element
#alias(set_body)
pub fn Document::setBody(self : Self, body : HTMLBodyElement) -> Unit {
  self.set("body", body) |> ignore
}

///|
/// Returns the document's head element
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/head
pub fn Document::head(self : Self) -> HTMLHeadElement? {
  self.get("head") |> to_option()
}

///|
/// Returns the document's title
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/title
pub fn Document::title(self : Self) -> String {
  unsafe_cast(self.get("title"))
}

///|
/// Sets the document's title
#alias(set_title)
pub fn Document::setTitle(self : Self, title : String) -> Unit {
  self.set("title", title |> js) |> ignore
}

///|
/// Returns the document's URL
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/URL
pub fn Document::url(self : Self) -> String {
  unsafe_cast(self.get("URL"))
}

///|
/// Returns the document's domain
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/domain
pub fn Document::domain(self : Self) -> String {
  unsafe_cast(self.get("domain"))
}

///|
/// Returns the document's referrer
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/referrer
pub fn Document::referrer(self : Self) -> String {
  unsafe_cast(self.get("referrer"))
}

///|
/// Creates a document fragment
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createDocumentFragment
#alias(create_document_fragment)
pub fn Document::createDocumentFragment(self : Self) -> Val {
  self.invoke("createDocumentFragment", []) |> unsafe_cast
}

///|
/// Creates a comment node
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createComment
#alias(create_comment)
pub fn Document::createComment(self : Self, data : String) -> Val {
  self.invoke("createComment", [data |> js]) |> unsafe_cast
}

///|
/// Returns the document element (root element)
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/documentElement
#alias(document_element)
pub fn Document::documentElement(self : Self) -> Element {
  unsafe_cast(self.get("documentElement"))
}

///|
/// Returns the document URI
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/documentURI
#alias(document_uri)
pub fn Document::documentURI(self : Self) -> String {
  unsafe_cast(self.get("documentURI"))
}

///|
/// Returns the character encoding of the document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/characterSet
#alias(character_set)
pub fn Document::characterSet(self : Self) -> String {
  unsafe_cast(self.get("characterSet"))
}

///|
/// Returns the content type of the document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/contentType
#alias(content_type)
pub fn Document::contentType(self : Self) -> String {
  unsafe_cast(self.get("contentType"))
}

///|
/// Returns the document type
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/doctype
pub fn Document::doctype(self : Self) -> Val? {
  self.get("doctype") |> to_option()
}

///|
/// Adopts a node from an external document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/adoptNode
#alias(adopt_node)
pub fn Document::adoptNode(self : Self, node : Node) -> Node {
  self.invoke("adoptNode", [node.to_js()]) |> unsafe_cast
}

///|
/// Imports a node from another document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/importNode
#alias(import_node)
pub fn Document::importNode(self : Self, node : Node, deep : Bool) -> Node {
  self.invoke("importNode", [node.to_js(), deep]) |> unsafe_cast
}

///|
/// Creates an event of the specified type
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createEvent
#alias(create_event)
pub fn Document::createEvent(self : Self, event_type : String) -> Event {
  self.invoke("createEvent", [event_type]) |> unsafe_cast
}
