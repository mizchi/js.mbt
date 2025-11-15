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
/// TextNode represents a text node in the DOM
#external
pub type TextNode

///|
pub impl Js for TextNode with to_js(self) {
  self |> unsafe_cast
}

///|
/// Creates a text node with the given data
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createTextNode
#alias(createTextNode)
pub extern "js" fn Document::create_text_node(
  self : Self,
  data : String,
) -> TextNode =
  #|(self, data) => self.createTextNode(data)

///|
/// Returns the document's ready state
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/readyState
pub fn Document::ready_state(self : Self) -> String {
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
pub fn Document::query_selector_all(self : Self, selector : String) -> Val {
  self.invoke("querySelectorAll", [selector |> js])
}

///|
/// Returns an element by its ID
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementById
pub fn Document::get_element_by_id(self : Self, id : String) -> Val? {
  self.invoke("getElementById", [id |> js]) |> to_option()
}

///|
/// Returns elements with the specified class name
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementsByClassName
pub fn Document::get_elements_by_class_name(
  self : Self,
  class_name : String,
) -> Val {
  self.invoke("getElementsByClassName", [class_name |> js])
}

///|
/// Returns elements with the specified tag name
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementsByTagName
pub fn Document::get_elements_by_tag_name(
  self : Self,
  tag_name : String,
) -> Val {
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
pub fn Document::set_body(self : Self, body : HTMLBodyElement) -> Unit {
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
pub fn Document::set_title(self : Self, title : String) -> Unit {
  self.to_js().set("title", title |> js) |> ignore
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
pub fn Document::create_document_fragment(self : Self) -> Val {
  self.invoke("createDocumentFragment", []) |> unsafe_cast
}

///|
/// Creates a comment node
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createComment
pub fn Document::create_comment(self : Self, data : String) -> Val {
  self.invoke("createComment", [data |> js]) |> unsafe_cast
}

///|
/// Returns the document element (root element)
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/documentElement
pub fn Document::document_element(self : Self) -> Element {
  unsafe_cast(self.get("documentElement"))
}

///|
/// Returns the document URI
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/documentURI
pub fn Document::document_uri(self : Self) -> String {
  unsafe_cast(self.get("documentURI"))
}

///|
/// Returns the character encoding of the document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/characterSet
pub fn Document::character_set(self : Self) -> String {
  unsafe_cast(self.get("characterSet"))
}

///|
/// Returns the content type of the document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/contentType
pub fn Document::content_type(self : Self) -> String {
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
pub fn Document::adopt_node(self : Self, node : Node) -> Node {
  self.invoke("adoptNode", [node.to_js()]) |> unsafe_cast
}

///|
/// Imports a node from another document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/importNode
pub fn Document::import_node(self : Self, node : Node, deep : Bool) -> Node {
  self.invoke("importNode", [node.to_js(), deep]) |> unsafe_cast
}

///|
/// Creates an event of the specified type
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createEvent
pub fn Document::create_event(self : Self, event_type : String) -> Event {
  self.invoke("createEvent", [event_type]) |> unsafe_cast
}
