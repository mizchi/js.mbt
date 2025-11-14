///|
/// Element represents a DOM element
/// https://developer.mozilla.org/en-US/docs/Web/API/Element
#external
pub type Element

///|
pub impl Js for Element with to_js(self) -> Val {
  self |> js
}

///|
/// Get a property value from element using bracket notation
#alias("_[_]")
pub fn Element::get(self : Element, name : String) -> Val {
  self.to_js().get(name)
}

///|
/// Set a property value on element using bracket notation
#alias("_[_]=_")
pub fn Element::set(self : Element, name : String, value : &Js) -> Unit {
  self.to_js().set(name, value.to_js()) |> ignore
}

///|
/// Sets an attribute on the element
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/setAttribute
pub fn Element::set_attribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.to_js().call_method("setAttribute", [name |> js, value |> js]) |> ignore
}

///|
/// Gets an attribute value from the element
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/getAttribute
pub fn Element::get_attribute(self : Self, name : String) -> String? {
  self.to_js().call_method("getAttribute", [name |> js]).cast_option()
}

///|
/// Removes an attribute from the element
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/removeAttribute
pub fn Element::remove_attribute(self : Self, name : String) -> Unit {
  self.to_js().call_method("removeAttribute", [name |> js]) |> ignore
}

///|
/// Checks if element has the specified attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/hasAttribute
pub fn Element::has_attribute(self : Self, name : String) -> Bool {
  self.to_js().call_method("hasAttribute", [name |> js]).cast()
}

///|
/// Appends a child element to this element
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/appendChild
pub fn Element::append_child(self : Self, child : Self) -> Self {
  self.to_js().call_method("appendChild", [child |> js]).cast()
}

///|
/// Removes a child element from this element
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/removeChild
pub fn Element::remove_child(self : Self, child : Self) -> Self {
  self.to_js().call_method("removeChild", [child |> js]).cast()
}

///|
/// Inserts a node before a reference node as a child of this element
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/insertBefore
pub fn Element::insert_before(
  self : Self,
  new_node : Self,
  reference_node : Self?,
) -> Self {
  match reference_node {
    Some(ref_node) =>
      self
      .to_js()
      .call_method("insertBefore", [new_node |> js, ref_node |> js])
      .cast()
    None =>
      self
      .to_js()
      .call_method("insertBefore", [new_node |> js, @js.null_()])
      .cast()
  }
}

///|
/// Replaces a child node with a new node
/// https://developer.mozilla.org/en-US/docs/Web/API/Node/replaceChild
pub fn Element::replace_child(
  self : Self,
  new_child : Self,
  old_child : Self,
) -> Self {
  self
  .to_js()
  .call_method("replaceChild", [new_child |> js, old_child |> js])
  .cast()
}

///|
/// Returns the first element matching the selector
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/querySelector
pub fn Element::query_selector(self : Self, selector : String) -> Self? {
  self.to_js().call_method("querySelector", [selector |> js]).cast_option()
}

///|
/// Returns all elements matching the selector
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/querySelectorAll
pub fn Element::query_selector_all(self : Self, selector : String) -> Val {
  self.to_js().call_method("querySelectorAll", [selector |> js])
}

///|
/// Returns elements with the specified class name
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/getElementsByClassName
pub fn Element::get_elements_by_class_name(
  self : Self,
  class_name : String,
) -> Val {
  self.to_js().call_method("getElementsByClassName", [class_name |> js])
}

///|
/// Returns elements with the specified tag name
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/getElementsByTagName
pub fn Element::get_elements_by_tag_name(self : Self, tag_name : String) -> Val {
  self.to_js().call_method("getElementsByTagName", [tag_name |> js])
}

///|
/// Returns the window object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window
pub extern "js" fn window() -> Element =
  #| () => window

///|
/// Sets focus on the element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/focus
pub fn Element::focus(self : Self) -> Unit {
  self.to_js().call_method("focus", []) |> ignore
}

///|
/// Removes focus from the element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/blur
pub fn Element::blur(self : Self) -> Unit {
  self.to_js().call_method("blur", []) |> ignore
}

///|
/// Simulates a click on the element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/click
pub fn Element::click(self : Self) -> Unit {
  self.to_js().call_method("click", []) |> ignore
}

///|
/// Adds an event listener to the element
/// https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener
pub fn Element::add_event_listener(
  self : Self,
  event : String,
  listener : (Event) -> Unit,
) -> Unit {
  self.to_js().call_method("addEventListener", [event |> js, listener |> js])
  |> ignore
}

///|
/// Removes an event listener from the element
/// https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/removeEventListener
pub fn Element::remove_event_listener(
  self : Self,
  event : String,
  listener : (Event) -> Unit,
) -> Unit {
  self.to_js().call_method("removeEventListener", [event |> js, listener |> js])
  |> ignore
}

///|
/// Returns the element's ID
pub fn Element::id(self : Self) -> String {
  self.to_js().get("id").cast()
}

///|
/// Sets the element's ID
pub fn Element::set_id(self : Self, id : String) -> Unit {
  self.to_js().set("id", id |> js) |> ignore
}

///|
/// Returns the element's class name
pub fn Element::class_name(self : Self) -> String {
  self.to_js().get("className").cast()
}

///|
/// Sets the element's class name
pub fn Element::set_class_name(self : Self, class_name : String) -> Unit {
  self.to_js().set("className", class_name |> js) |> ignore
}

///|
/// Returns the element's inner HTML
pub fn Element::inner_html(self : Self) -> String {
  self.to_js().get("innerHTML").cast()
}

///|
/// Sets the element's inner HTML
pub fn Element::set_inner_html(self : Self, html : String) -> Unit {
  self.to_js().set("innerHTML", html |> js) |> ignore
}

///|
/// Returns the element's outer HTML
pub fn Element::outer_html(self : Self) -> String {
  self.to_js().get("outerHTML").cast()
}

///|
/// Returns the element's tag name
pub fn Element::tag_name(self : Self) -> String {
  self.to_js().get("tagName").cast()
}

///|
/// Returns the element's client width
pub fn Element::client_width(self : Self) -> Int {
  self.to_js().get("clientWidth").cast()
}

///|
/// Returns the element's client height
pub fn Element::client_height(self : Self) -> Int {
  self.to_js().get("clientHeight").cast()
}

///|
/// Returns the element's scroll width
pub fn Element::scroll_width(self : Self) -> Int {
  self.to_js().get("scrollWidth").cast()
}

///|
/// Returns the element's scroll height
pub fn Element::scroll_height(self : Self) -> Int {
  self.to_js().get("scrollHeight").cast()
}

///|
/// Returns the element's scroll left position
pub fn Element::scroll_left(self : Self) -> Double {
  self.to_js().get("scrollLeft").cast()
}

///|
/// Sets the element's scroll left position
pub fn Element::set_scroll_left(self : Self, value : Double) -> Unit {
  self.to_js().set("scrollLeft", value |> js) |> ignore
}

///|
/// Returns the element's scroll top position
pub fn Element::scroll_top(self : Self) -> Double {
  self.to_js().get("scrollTop").cast()
}

///|
/// Sets the element's scroll top position
pub fn Element::set_scroll_top(self : Self, value : Double) -> Unit {
  self.to_js().set("scrollTop", value |> js) |> ignore
}

///|
/// Returns the element's bounding client rect
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/getBoundingClientRect
pub fn Element::get_bounding_client_rect(self : Self) -> Val {
  self.to_js().call_method("getBoundingClientRect", [])
}

///|
/// Returns whether the element matches the selector
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/matches
pub fn Element::matches(self : Self, selector : String) -> Bool {
  self.to_js().call_method("matches", [selector |> js]).cast()
}

///|
/// Returns the closest ancestor matching the selector
/// https://developer.mozilla.org/en-US/docs/Web/API/Element/closest
pub fn Element::closest(self : Self, selector : String) -> Self? {
  self.to_js().call_method("closest", [selector |> js]).cast_option()
}

///|
/// Adds a class to the element's class list
pub fn Element::add_class(self : Self, class_name : String) -> Unit {
  self.to_js().get("classList").call_method("add", [class_name |> js]) |> ignore
}

///|
/// Removes a class from the element's class list
pub fn Element::remove_class(self : Self, class_name : String) -> Unit {
  self.to_js().get("classList").call_method("remove", [class_name |> js])
  |> ignore
}

///|
/// Toggles a class in the element's class list
pub fn Element::toggle_class(self : Self, class_name : String) -> Bool {
  self.to_js().get("classList").call_method("toggle", [class_name |> js]).cast()
}

///|
/// Checks if element contains a class
pub fn Element::contains_class(self : Self, class_name : String) -> Bool {
  self
  .to_js()
  .get("classList")
  .call_method("contains", [class_name |> js])
  .cast()
}

///|
/// HTMLElement-specific properties
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement

///|
/// Returns whether the element is contentEditable
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/contentEditable
pub fn Element::content_editable(self : Self) -> String {
  self.to_js().get("contentEditable").cast()
}

///|
/// Sets whether the element is contentEditable
pub fn Element::set_content_editable(self : Self, value : String) -> Unit {
  self.to_js().set("contentEditable", value |> js) |> ignore
}

///|
/// Returns whether the element is editable
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/isContentEditable
pub fn Element::is_content_editable(self : Self) -> Bool {
  self.to_js().get("isContentEditable").cast()
}

///|
/// Returns the element's title
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/title
pub fn Element::title(self : Self) -> String {
  self.to_js().get("title").cast()
}

///|
/// Sets the element's title
pub fn Element::set_title(self : Self, title : String) -> Unit {
  self.to_js().set("title", title |> js) |> ignore
}

///|
/// Returns the element's lang attribute
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/lang
pub fn Element::lang(self : Self) -> String {
  self.to_js().get("lang").cast()
}

///|
/// Sets the element's lang attribute
pub fn Element::set_lang(self : Self, lang : String) -> Unit {
  self.to_js().set("lang", lang |> js) |> ignore
}

///|
/// Returns the element's dir attribute (text direction)
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/dir
pub fn Element::dir(self : Self) -> String {
  self.to_js().get("dir").cast()
}

///|
/// Sets the element's dir attribute
pub fn Element::set_dir(self : Self, dir : String) -> Unit {
  self.to_js().set("dir", dir |> js) |> ignore
}

///|
/// Returns whether the element is hidden
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/hidden
pub fn Element::hidden(self : Self) -> Bool {
  self.to_js().get("hidden").cast()
}

///|
/// Sets whether the element is hidden
pub fn Element::set_hidden(self : Self, hidden : Bool) -> Unit {
  self.to_js().set("hidden", hidden |> js) |> ignore
}

///|
/// Returns the element's tabIndex
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/tabIndex
pub fn Element::tab_index(self : Self) -> Int {
  self.to_js().get("tabIndex").cast()
}

///|
/// Sets the element's tabIndex
pub fn Element::set_tab_index(self : Self, index : Int) -> Unit {
  self.to_js().set("tabIndex", index |> js) |> ignore
}

///|
/// Returns the element's access key
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/accessKey
pub fn Element::access_key(self : Self) -> String {
  self.to_js().get("accessKey").cast()
}

///|
/// Sets the element's access key
pub fn Element::set_access_key(self : Self, key : String) -> Unit {
  self.to_js().set("accessKey", key |> js) |> ignore
}

///|
/// Returns whether the element is draggable
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/draggable
pub fn Element::draggable(self : Self) -> Bool {
  self.to_js().get("draggable").cast()
}

///|
/// Sets whether the element is draggable
pub fn Element::set_draggable(self : Self, draggable : Bool) -> Unit {
  self.to_js().set("draggable", draggable |> js) |> ignore
}

///|
/// Returns whether the element is spellcheck enabled
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/spellcheck
pub fn Element::spellcheck(self : Self) -> Bool {
  self.to_js().get("spellcheck").cast()
}

///|
/// Sets whether the element is spellcheck enabled
pub fn Element::set_spellcheck(self : Self, spellcheck : Bool) -> Unit {
  self.to_js().set("spellcheck", spellcheck |> js) |> ignore
}

///|
/// Returns the element's offset parent
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/offsetParent
pub fn Element::offset_parent(self : Self) -> Element? {
  self.to_js().get("offsetParent").cast_option()
}

///|
/// Returns the element's offset top
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/offsetTop
pub fn Element::offset_top(self : Self) -> Int {
  self.to_js().get("offsetTop").cast()
}

///|
/// Returns the element's offset left
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/offsetLeft
pub fn Element::offset_left(self : Self) -> Int {
  self.to_js().get("offsetLeft").cast()
}

///|
/// Returns the element's offset width
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/offsetWidth
pub fn Element::offset_width(self : Self) -> Int {
  self.to_js().get("offsetWidth").cast()
}

///|
/// Returns the element's offset height
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/offsetHeight
pub fn Element::offset_height(self : Self) -> Int {
  self.to_js().get("offsetHeight").cast()
}
