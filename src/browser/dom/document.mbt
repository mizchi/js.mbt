///|
/// Document represents the web page loaded in the browser
/// https://developer.mozilla.org/en-US/docs/Web/API/Document
#external
pub type Document

///|
pub fn Document::as_any(self : Document) -> @core.Any = "%identity"

///|
pub fn Document::as_event_target(self : Document) -> @event.EventTarget = "%identity"

///|
pub fn Document::as_node(self : Document) -> Node = "%identity"

///|

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
  self.as_any()._get("readyState").cast()
}

///|
/// Returns an element by its ID
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementById
#alias(get_element_by_id)
pub fn Document::getElementById(self : Self, id : String) -> Element? {
  let v : @core.Any = self
    .as_any()
    ._call("getElementById", [@core.any(id)])
    .cast()
  v |> @core.identity_option()
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
  let arr : @core.Any = self
    .as_any()
    ._call("getElementsByClassName", [@core.any(class_name)])
    .cast()
  @core.array_from(arr).map(fn(v) { v |> @core.identity })
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
  let arr : @core.Any = self
    .as_any()
    ._call("getElementsByTagName", [@core.any(tagName)])
    .cast()
  @core.array_from(arr).map(_.cast())
}

///|
/// Returns the first element matching the specified CSS selector
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector
#alias(query_selector)
pub fn Document::querySelector(self : Self, selector : String) -> Element? {
  let v : @core.Any = self
    .as_any()
    ._call("querySelector", [@core.any(selector)])
    .cast()
  v |> @core.identity_option()
}

///|
/// Returns all elements matching the specified CSS selector
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelectorAll
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(query_selector_all)
pub fn Document::querySelectorAll(
  self : Self,
  selector : String,
) -> Array[Element] {
  let arr : @core.Any = self
    .as_any()
    ._call("querySelectorAll", [@core.any(selector)])
    .cast()
  @core.array_from(arr).map(fn(v) { @core.identity(v) })
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
  let v : @core.Any = self.as_any()._get("body").cast()
  v |> @core.identity_option()
}

///|
/// Sets the document's body element
#alias(set_body)
pub fn Document::setBody(self : Self, body : HTMLBodyElement) -> Unit {
  self.as_any()._set("body", body.as_any()) |> ignore
}

///|
/// Returns the document's head element
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/head
pub fn Document::head(self : Self) -> HTMLHeadElement? {
  let v : @core.Any = self.as_any()._get("head").cast()
  v |> @core.identity_option()
}

///|
/// Returns the document's title
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/title
pub fn Document::title(self : Self) -> String {
  self.as_any()._get("title").cast()
}

///|
/// Sets the document's title
#alias(set_title)
pub fn Document::setTitle(self : Self, title : String) -> Unit {
  self.as_any()._set("title", @core.any(title)) |> ignore
}

///|
/// Returns the document's URL
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/URL
pub fn Document::url(self : Self) -> String {
  self.as_any()._get("URL").cast()
}

///|
/// Returns the document's domain
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/domain
pub fn Document::domain(self : Self) -> String {
  self.as_any()._get("domain").cast()
}

///|
/// Returns the document's referrer
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/referrer
pub fn Document::referrer(self : Self) -> String {
  self.as_any()._get("referrer").cast()
}

///|
/// Creates a document fragment
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createDocumentFragment
#alias(create_document_fragment)
pub fn Document::createDocumentFragment(self : Self) -> DocumentFragment {
  self.as_any()._call("createDocumentFragment", []).cast()
}

///|
/// Creates a comment node
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createComment
#alias(create_comment)
pub fn Document::createComment(self : Self, data : String) -> Node {
  self.as_any()._call("createComment", [@core.any(data)]).cast()
}

///|
/// Returns the document element (root element)
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/documentElement
#alias(document_element)
pub fn Document::documentElement(self : Self) -> Element {
  self.as_any()._get("documentElement").cast()
}

///|
/// Returns the document URI
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/documentURI
#alias(document_uri)
pub fn Document::documentURI(self : Self) -> String {
  self.as_any()._get("documentURI").cast()
}

///|
/// Returns the character encoding of the document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/characterSet
#alias(character_set)
pub fn Document::characterSet(self : Self) -> String {
  self.as_any()._get("characterSet").cast()
}

///|
/// Returns the content type of the document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/contentType
#alias(content_type)
pub fn Document::contentType(self : Self) -> String {
  self.as_any()._get("contentType").cast()
}

///|
/// Returns the document type
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/doctype
pub fn Document::doctype(self : Self) -> @core.Any? {
  let v : @core.Any = self.as_any()._get("doctype").cast()
  v |> @core.identity_option()
}

///|
/// Adopts a node from an external document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/adoptNode
#alias(adopt_node)
pub fn Document::adoptNode(self : Self, node : Node) -> Node {
  let self_js : @core.Any = self.as_any().cast()
  self_js._call("adoptNode", [node.as_any().cast()]).cast()
}

///|
/// Imports a node from another document
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/importNode
#alias(import_node)
pub fn Document::importNode(self : Self, node : Node, deep : Bool) -> Node {
  let self_js : @core.Any = self.as_any().cast()
  let node_js : @core.Any = node.as_any().cast()
  self_js._call("importNode", [node_js, @core.any(deep)]).cast()
}

///|
/// Creates an event of the specified type
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createEvent
#alias(create_event)
pub fn Document::createEvent(self : Self, event_type : String) -> Event {
  self.as_any()._call("createEvent", [@core.any(event_type)]).cast()
}

///|
/// Returns the element from point within the shadow root
/// https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/elementFromPoint
pub fn Document::elementFromPoint(
  self : Self,
  x : Double,
  y : Double,
) -> Element? {
  let v : @core.Any = self
    .as_any()
    ._call("elementFromPoint", [@core.any(x), @core.any(y)])
    .cast()
  v |> @core.identity_option()
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
  let arr : @core.Any = self
    .as_any()
    ._call("elementsFromPoint", [@core.any(x), @core.any(y)])
    .cast()
  @core.array_from(arr).map(fn(v) { @core.identity(v) })
}
