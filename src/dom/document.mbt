///|
/// Document represents the web page loaded in the browser
/// https://developer.mozilla.org/en-US/docs/Web/API/Document
#external
pub type Document

///|
pub impl Js for Document with to_js(self) -> Val {
  self |> js
}

///|
/// Returns the global document object
pub extern "js" fn document() -> Document =
  #| () => document

///|
/// Converts Document to Element
pub fn Document::as_element(self : Self) -> Element {
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
  self.to_js().get("readyState").cast()
}

///|
/// Returns the first element matching the selector
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector
#alias(querySelector)
pub fn Document::query_selector(self : Self, selector : String) -> Element? {
  self.to_js().call_method("querySelector", [selector |> js]).cast_option()
}

///|
/// Returns all elements matching the selector
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelectorAll
pub fn Document::query_selector_all(self : Self, selector : String) -> Val {
  self.to_js().call_method("querySelectorAll", [selector |> js])
}

///|
/// Returns an element by its ID
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementById
pub fn Document::get_element_by_id(self : Self, id : String) -> Element? {
  self.to_js().call_method("getElementById", [id |> js]).cast_option()
}

///|
/// Returns elements with the specified class name
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementsByClassName
pub fn Document::get_elements_by_class_name(
  self : Self,
  class_name : String,
) -> Val {
  self.to_js().call_method("getElementsByClassName", [class_name |> js])
}

///|
/// Returns elements with the specified tag name
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementsByTagName
pub fn Document::get_elements_by_tag_name(
  self : Self,
  tag_name : String,
) -> Val {
  self.to_js().call_method("getElementsByTagName", [tag_name |> js])
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
pub fn Document::body(self : Self) -> Element {
  self.to_js().get("body").cast()
}

///|
/// Returns the document's head element
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/head
pub fn Document::head(self : Self) -> Element {
  self.to_js().get("head").cast()
}

///|
/// Returns the document's title
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/title
pub fn Document::title(self : Self) -> String {
  self.to_js().get("title").cast()
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
  self.to_js().get("URL").cast()
}

///|
/// Returns the document's domain
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/domain
pub fn Document::domain(self : Self) -> String {
  self.to_js().get("domain").cast()
}

///|
/// Returns the document's referrer
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/referrer
pub fn Document::referrer(self : Self) -> String {
  self.to_js().get("referrer").cast()
}

///|
/// Creates a document fragment
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createDocumentFragment
pub fn Document::create_document_fragment(self : Self) -> Element {
  self.to_js().call_method("createDocumentFragment", []).cast()
}

///|
/// Creates a comment node
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/createComment
pub fn Document::create_comment(self : Self, data : String) -> Element {
  self.to_js().call_method("createComment", [data |> js]).cast()
}
