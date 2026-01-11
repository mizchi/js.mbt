///|
#external
pub type Element

///|
pub fn Element::as_any(self : Element) -> @core.Any = "%identity"

///|
pub fn Element::as_event_target(self : Element) -> @event.EventTarget = "%identity"

///|
pub fn Element::as_node(self : Element) -> Node = "%identity"

///|
pub extern "js" fn Element::tagName(self : Element) -> String =
  #| (self) => self.tagName

///|
pub fn Element::append(self : Element, child : Node) -> Unit {
  self.as_any()._call("append", [child.as_any()]) |> ignore
}

///|
pub extern "js" fn Element::className(self : Element) -> String =
  #| (self) => self.className

///|
pub fn Element::setClassName(self : Element, class_name : String) -> Unit {
  self.as_any()._set("className", @core.any(class_name)) |> ignore
}

///|
pub extern "js" fn Element::id(self : Element) -> String =
  #| (self) => self.id

///|
pub fn Element::setId(self : Element, id : String) -> Unit {
  self.as_any()._set("id", @core.any(id)) |> ignore
}

///|
pub fn Element::getAttribute(self : Element, name : String) -> String? {
  let v : @core.Any = self
    .as_any()
    ._call("getAttribute", [@core.any(name)])
    .cast()
  v |> @core.identity_option
}

///|
pub fn Element::setAttribute(
  self : Element,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
pub fn Element::removeAttribute(self : Element, name : String) -> Unit {
  self.as_any()._call("removeAttribute", [@core.any(name)]) |> ignore
}

///|
pub fn Element::hasAttribute(self : Element, name : String) -> Bool {
  self.as_any()._call("hasAttribute", [@core.any(name)]).cast()
}

///|
/// Returns a static array of elements with the specified tag name.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Element::getElementsByTagName(
  self : Element,
  tag_name : String,
) -> Array[Element] {
  let arr : @core.Any = self
    .as_any()
    ._call("getElementsByTagName", [@core.any(tag_name)])
    .cast()
  @core.array_from(arr).map(fn(v) { @core.identity(v) })
}

///|
/// Returns a static array of elements with the specified class name.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Element::getElementsByClassName(
  self : Element,
  class_name : String,
) -> Array[Element] {
  let arr : @core.Any = self
    .as_any()
    ._call("getElementsByClassName", [@core.any(class_name)])
    .cast()
  @core.array_from(arr).map(fn(v) { @core.identity(v) })
}

///|
pub fn Element::querySelector(self : Element, selector : String) -> Element? {
  let v : @core.Any = self
    .as_any()
    ._call("querySelector", [@core.any(selector)])
    .cast()
  v |> @core.identity_option
}

///|
/// Returns a static array of elements matching the specified CSS selector.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Element::querySelectorAll(
  self : Element,
  selector : String,
) -> Array[Element] {
  let arr : @core.Any = self
    .as_any()
    ._call("querySelectorAll", [@core.any(selector)])
    .cast()
  @core.array_from(arr).map(@core.identity(_))
}

///|
/// Inserts nodes just before this element.
pub extern "js" fn Element::before(self : Element, nodes : Array[Node]) -> Unit =
  #| (self, nodes) => self.before(...nodes)

///|
/// Inserts nodes just after this element.
pub extern "js" fn Element::after(self : Element, nodes : Array[Node]) -> Unit =
  #| (self, nodes) => self.after(...nodes)

///|
/// Inserts nodes before the first child of this element.
pub extern "js" fn Element::prepend(
  self : Element,
  nodes : Array[Node],
) -> Unit =
  #| (self, nodes) => self.prepend(...nodes)

///|
/// Replaces this element with the given nodes.
pub extern "js" fn Element::replaceWith(
  self : Element,
  nodes : Array[Node],
) -> Unit =
  #| (self, nodes) => self.replaceWith(...nodes)

///|
/// Removes this element from the DOM.
pub fn Element::remove(self : Element) -> Unit {
  self.as_any()._call("remove", []) |> ignore
}

///|
/// Replaces all children of this element with the given nodes.
pub extern "js" fn Element::replaceChildren(
  self : Element,
  nodes : Array[Node],
) -> Unit =
  #| (self, nodes) => self.replaceChildren(...nodes)

///|
/// Inserts an element at the specified position relative to this element.
/// position: "beforebegin", "afterbegin", "beforeend", "afterend"
pub fn Element::insertAdjacentElement(
  self : Element,
  position : String,
  element : Element,
) -> Element? {
  let v : @core.Any = self
    .as_any()
    ._call("insertAdjacentElement", [@core.any(position), element.as_any()])
    .cast()
  @core.identity_option(v)
}

///|
/// Parses the specified text as HTML and inserts the resulting nodes at the specified position.
/// position: "beforebegin", "afterbegin", "beforeend", "afterend"
pub fn Element::insertAdjacentHTML(
  self : Element,
  position : String,
  html : String,
) -> Unit {
  self
  .as_any()
  ._call("insertAdjacentHTML", [@core.any(position), @core.any(html)])
  |> ignore
}

///|
/// Inserts a text node at the specified position relative to this element.
/// position: "beforebegin", "afterbegin", "beforeend", "afterend"
pub fn Element::insertAdjacentText(
  self : Element,
  position : String,
  text : String,
) -> Unit {
  self
  .as_any()
  ._call("insertAdjacentText", [@core.any(position), @core.any(text)])
  |> ignore
}

///|
/// Returns the closest ancestor element that matches the specified selector.
pub fn Element::closest(self : Element, selector : String) -> Element? {
  let v : @core.Any = self
    .as_any()
    ._call("closest", [@core.any(selector)])
    .cast()
  @core.identity_option(v)
}

///|
/// Returns whether the element matches the specified CSS selector.
pub fn Element::matches(self : Element, selector : String) -> Bool {
  self.as_any()._call("matches", [@core.any(selector)]).cast()
}

///|
/// Toggles the specified boolean attribute on the element.
/// Returns true if the attribute is present after the call.
pub fn Element::toggleAttribute(
  self : Element,
  name : String,
  force? : Bool,
) -> Bool {
  match force {
    Some(f) =>
      self
      .as_any()
      ._call("toggleAttribute", [@core.any(name), @core.any(f)])
      .cast()
    None => self.as_any()._call("toggleAttribute", [@core.any(name)]).cast()
  }
}

///|
/// Returns an array of all attribute names of the element.
pub fn Element::getAttributeNames(self : Element) -> Array[String] {
  let arr : @core.Any = self.as_any()._call("getAttributeNames", []).cast()
  @core.array_from(arr).map(@core.identity(_))
}

///|
/// Returns whether the element has any attributes.
pub fn Element::hasAttributes(self : Element) -> Bool {
  self.as_any()._call("hasAttributes", []).cast()
}

///|
/// Returns the inner HTML of the element.
pub fn Element::innerHTML(self : Element) -> String {
  self.as_any()._get("innerHTML").cast()
}

///|
/// Sets the inner HTML of the element.
pub fn Element::setInnerHTML(self : Element, html : String) -> Unit {
  self.as_any()._set("innerHTML", @core.any(html)) |> ignore
}

///|
/// Returns the outer HTML of the element.
pub fn Element::outerHTML(self : Element) -> String {
  self.as_any()._get("outerHTML").cast()
}

///|
/// Sets the outer HTML of the element (replaces the element itself).
pub fn Element::setOuterHTML(self : Element, html : String) -> Unit {
  self.as_any()._set("outerHTML", @core.any(html)) |> ignore
}

///|
/// Returns a live HTMLCollection of child elements.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Element::children(self : Element) -> Array[Element] {
  let arr : @core.Any = self.as_any()._get("children").cast()
  @core.array_from(arr).map(@core.identity(_))
}

///|
/// Returns the number of child elements.
pub fn Element::childElementCount(self : Element) -> Int {
  self.as_any()._get("childElementCount").cast()
}

///|
/// Returns the first child element.
pub fn Element::firstElementChild(self : Element) -> Element? {
  let v : @core.Any = self.as_any()._get("firstElementChild").cast()
  @core.identity_option(v)
}

///|
/// Returns the last child element.
pub fn Element::lastElementChild(self : Element) -> Element? {
  let v : @core.Any = self.as_any()._get("lastElementChild").cast()
  @core.identity_option(v)
}

///|
/// Returns the parent element.
pub fn Element::parentElement(self : Element) -> Element? {
  let v : @core.Any = self.as_any()._get("parentElement").cast()
  @core.identity_option(v)
}

///|
/// Returns the next sibling element.
pub fn Element::nextElementSibling(self : Element) -> Element? {
  let v : @core.Any = self.as_any()._get("nextElementSibling").cast()
  @core.identity_option(v)
}

///|
/// Returns the previous sibling element.
pub fn Element::previousElementSibling(self : Element) -> Element? {
  let v : @core.Any = self.as_any()._get("previousElementSibling").cast()
  @core.identity_option(v)
}

///|
/// Scrolls the element into view.
pub fn Element::scrollIntoView(self : Element) -> Unit {
  self.as_any()._call("scrollIntoView", []) |> ignore
}

///|
/// Returns the width of the element including padding but not border.
pub fn Element::clientWidth(self : Element) -> Int {
  self.as_any()._get("clientWidth").cast()
}

///|
/// Returns the height of the element including padding but not border.
pub fn Element::clientHeight(self : Element) -> Int {
  self.as_any()._get("clientHeight").cast()
}

///|
/// Returns the width of the element including padding and border.
pub fn Element::scrollWidth(self : Element) -> Int {
  self.as_any()._get("scrollWidth").cast()
}

///|
/// Returns the height of the element including padding and border.
pub fn Element::scrollHeight(self : Element) -> Int {
  self.as_any()._get("scrollHeight").cast()
}

///|
/// Returns the number of pixels scrolled horizontally.
pub fn Element::scrollLeft(self : Element) -> Int {
  self.as_any()._get("scrollLeft").cast()
}

///|
/// Sets the number of pixels scrolled horizontally.
pub fn Element::setScrollLeft(self : Element, value : Int) -> Unit {
  self.as_any()._set("scrollLeft", @core.any(value)) |> ignore
}

///|
/// Returns the number of pixels scrolled vertically.
pub fn Element::scrollTop(self : Element) -> Int {
  self.as_any()._get("scrollTop").cast()
}

///|
/// Sets the number of pixels scrolled vertically.
pub fn Element::setScrollTop(self : Element, value : Int) -> Unit {
  self.as_any()._set("scrollTop", @core.any(value)) |> ignore
}
