///|
/// Document represents the web page loaded in the browser
/// https://developer.mozilla.org/en-US/docs/Web/API/Document
#external
pub type Document

///|
pub impl @js.JsImpl for Document

///|
pub impl @event.EventTargetImpl for Document

///|
pub impl NodeImpl for Document

///|
pub impl ElementImpl for Document

///|
/// Returns the global document object
pub extern "js" fn document() -> Document =
  #| () => document

///|
/// Returns the currently focused element
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/activeElement
#alias(active_element)
pub extern "js" fn Document::activeElement(self : Self) -> Element =
  #|(self) => self.activeElement

///|
/// Creates a new element with the given tag name
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createElement
#alias(create_element)
pub extern "js" fn Document::createElement(
  self : Self,
  tag_name : String,
) -> Element =
  #|(self, tag) => self.createElement(tag)

///|
/// Creates a new element with namespace
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createElementNS
#alias(create_element_ns)
pub extern "js" fn Document::createElementNs(
  self : Self,
  namespace_uri : String,
  qualified_name : String,
) -> Element =
  #|(self, namespaceURI, qualifiedName) => self.createElementNS(namespaceURI, qualifiedName)

///|
/// Creates a text node with the given data
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createTextNode
#alias(create_text_node)
pub extern "js" fn Document::createTextNode(self : Self, data : String) -> Text =
  #|(self, data) => self.createTextNode(data)

///|
/// Returns the document's ready state
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/readyState
#alias(ready_state)
pub fn Document::readyState(self : Self) -> String {
  self.get("readyState").cast()
}

///|
/// Returns an element by its ID
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementById
#alias(get_element_by_id)
pub fn Document::getElementById(self : Self, id : String) -> Element? {
  self.call("getElementById", [id |> @js.js]) |> @js.identity_option()
}

///|
/// Returns elements with the specified class name
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementsByClassName
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(get_elements_by_class_name)
pub fn Document::getElementsByClassName(
  self : Self,
  class_name : String,
) -> Array[Element] {
  @js.array_from(self.call("getElementsByClassName", [class_name])).map(fn(v) {
    v |> @js.identity
  })
}

///|
/// Returns elements with the specified tag name
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementsByTagName
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(get_elements_by_tag_name)
pub fn Document::getElementsByTagName(
  self : Self,
  tagName : String,
) -> Array[Element] {
  @js.array_from(self.call("getElementsByTagName", [tagName])).map(_.cast())
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
  self.get("body") |> @js.identity_option()
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
  self.get("head") |> @js.identity_option()
}

///|
/// Returns the document's title
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/title
pub fn Document::title(self : Self) -> String {
  self.get("title").cast()
}

///|
/// Sets the document's title
#alias(set_title)
pub fn Document::setTitle(self : Self, title : String) -> Unit {
  self.set("title", title) |> ignore
}

///|
/// Returns the document's URL
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/URL
pub fn Document::url(self : Self) -> String {
  self.get("URL").cast()
}

///|
/// Returns the document's domain
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/domain
pub fn Document::domain(self : Self) -> String {
  self.get("domain").cast()
}

///|
/// Returns the document's referrer
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/referrer
pub fn Document::referrer(self : Self) -> String {
  self.get("referrer").cast()
}

///|
/// Creates a document fragment
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createDocumentFragment
#alias(create_document_fragment)
pub fn Document::createDocumentFragment(self : Self) -> DocumentFragment {
  self.call0("createDocumentFragment") |> @js.identity
}

///|
/// Creates a comment node
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createComment
#alias(create_comment)
pub fn Document::createComment(self : Self, data : String) -> Node {
  self.call("createComment", [data]).cast()
}

///|
/// Returns the document element (root element)
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/documentElement
#alias(document_element)
pub fn Document::documentElement(self : Self) -> Element {
  self.get("documentElement").cast()
}

///|
/// Returns the document URI
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/documentURI
#alias(document_uri)
pub fn Document::documentURI(self : Self) -> String {
  self.get("documentURI").cast()
}

///|
/// Returns the character encoding of the document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/characterSet
#alias(character_set)
pub fn Document::characterSet(self : Self) -> String {
  self.get("characterSet").cast()
}

///|
/// Returns the content type of the document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/contentType
#alias(content_type)
pub fn Document::contentType(self : Self) -> String {
  self.get("contentType").cast()
}

///|
/// Returns the document type
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/doctype
pub fn Document::doctype(self : Self) -> @js.Any? {
  self.get("doctype") |> @js.identity_option()
}

///|
/// Adopts a node from an external document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/adoptNode
#alias(adopt_node)
pub fn Document::adoptNode(self : Self, node : Node) -> Node {
  self.call("adoptNode", [node.to_any()]).cast()
}

///|
/// Imports a node from another document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/importNode
#alias(import_node)
pub fn Document::importNode(self : Self, node : Node, deep : Bool) -> Node {
  self.call2("importNode", node.to_any(), deep) |> @js.identity
}

///|
/// Creates an event of the specified type
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createEvent
#alias(create_event)
pub fn Document::createEvent(self : Self, event_type : String) -> Event {
  self.call("createEvent", [event_type]).cast()
}

///|
/// Returns the element from point within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/elementFromPoint
pub fn Document::elementFromPoint(
  self : Self,
  x : Double,
  y : Double,
) -> Element? {
  self.call2("elementFromPoint", x, y) |> @js.identity_option()
}

///|
/// Returns elements from point within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/elementsFromPoint
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Document::elementsFromPoint(
  self : Self,
  x : Double,
  y : Double,
) -> Array[Element] {
  @js.array_from(self.call2("elementsFromPoint", x, y)).map(fn(v) {
    @js.identity(v)
  })
}
