///|
/// https://developer.mozilla.org/ja/docs/Web/API/Document
#external
pub type Document

///|
pub impl Js for Document with to_js(self) -> Val {
  self |> js
}

///|
pub extern "js" fn document() -> Document =
  #| () => document

///|
pub fn Document::as_element(self : Self) -> Element {
  self |> unsafe_cast
}

///|
#alias(activeElement)
pub extern "js" fn Document::active_element(self : Self) -> Element =
  #|(self) => self.activeElement

///|
#alias(createElement)
pub extern "js" fn Document::create_element(
  self : Self,
  tag_name : String,
) -> Element =
  #|(self, tag) => self.createElement(tag)

///|
#alias(createElementNS)
pub extern "js" fn Document::create_element_ns(
  self : Self,
  tag_name : String,
  qualified_name : String,
) -> Element =
  #|(self, tag, qualified_name) => self.createElementNS(tag, qualified_name)

///|
#external
pub type TextNode

///|
pub impl Js for TextNode with to_js(self) {
  self |> unsafe_cast
}

///|
#alias(createTextNode)
pub extern "js" fn Document::create_text_node(
  self : Self,
  data : String,
) -> TextNode =
  #|(self, data) => self.createTextNode(data)

///|
#alias(readyState)
pub extern "js" fn Document::ready_state(self : Self) -> Element =
  #|(self) => self.readyState

///|
#alias(querySelector)
pub fn Document::query_selector(self : Self, selector : String) -> Self? {
  self.to_js().call_method("querySelector", [selector |> js]).cast_option()
}

///|
pub extern "js" fn Document::cookie(self : Self) -> String =
  #|(self) => self.cookie

///|
pub extern "js" fn Document::set_cookie(self : Self, content : String) -> Unit =
  #|(self, content) => self.cookie = content

///|
pub fn Document::body(self : Self) -> Element {
  self.to_js().get("body").cast()
}
