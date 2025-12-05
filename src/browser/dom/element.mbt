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

///|
pub fn Element::tagName(self : Element) -> String {
  self.as_any()._get("tagName").cast()
}

///|
pub fn Element::append(self : Element, child : Node) -> Unit {
  self.as_any()._call("append", [child.as_any()]) |> ignore
}

///|
pub fn Element::className(self : Element) -> String {
  self.as_any()._get("className").cast()
}

///|
pub fn Element::setClassName(self : Element, class_name : String) -> Unit {
  self.as_any()._set("className", @core.any(class_name)) |> ignore
}

///|
pub fn Element::id(self : Element) -> String {
  self.as_any()._get("id").cast()
}

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
