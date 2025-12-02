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
pub impl ElementImpl for Element with as_any(self) -> @core.Any {
  self.as_any()
}

///|
/// Element trait - base interface for element nodes
pub(open) trait ElementImpl {
  as_any(Self) -> @core.Any
  tagName(Self) -> String = _
  className(Self) -> String = _
  setClassName(Self, String) -> Unit = _
  id(Self) -> String = _
  setId(Self, String) -> Unit = _
  getAttribute(Self, String) -> String? = _
  setAttribute(Self, String, String) -> Unit = _
  removeAttribute(Self, String) -> Unit = _
  hasAttribute(Self, String) -> Bool = _
  getElementsByTagName(Self, String) -> Array[Element] = _
  getElementsByClassName(Self, String) -> Array[Element] = _
  querySelector(Self, String) -> Element? = _
  querySelectorAll(Self, String) -> Array[Element] = _
  append(Self, Node) -> Unit = _
}

///|
impl ElementImpl with tagName(self) {
  self.as_any()._get("tagName").cast()
}

///|
impl ElementImpl with append(self, child : Node) {
  self.as_any()._call("append", [child.as_any()]) |> ignore
}

///|
impl ElementImpl with className(self) -> String {
  self.as_any()._get("className").cast()
}

///|
impl ElementImpl with setClassName(self, class_name) -> Unit {
  self.as_any()._set("className", @core.any(class_name)) |> ignore
}

///|
impl ElementImpl with id(self) -> String {
  self.as_any()._get("id").cast()
}

///|
impl ElementImpl with setId(self, id) -> Unit {
  self.as_any()._set("id", @core.any(id)) |> ignore
}

///|
impl ElementImpl with getAttribute(self, name) -> String? {
  let v : @core.Any = self
    .as_any()
    ._call("getAttribute", [@core.any(name)])
    .cast()
  v |> @core.identity_option
}

///|
impl ElementImpl with setAttribute(self, name, value) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
impl ElementImpl with removeAttribute(self, name) -> Unit {
  self.as_any()._call("removeAttribute", [@core.any(name)]) |> ignore
}

///|
impl ElementImpl with hasAttribute(self, name) -> Bool {
  self.as_any()._call("hasAttribute", [@core.any(name)]).cast()
}

///|
/// Returns a static array of elements with the specified tag name.
/// Note: The returned array is a snapshot and should be treated as immutable.
impl ElementImpl with getElementsByTagName(self, tag_name) -> Array[Element] {
  let arr : @core.Any = self
    .as_any()
    ._call("getElementsByTagName", [@core.any(tag_name)])
    .cast()
  @js.array_from(arr).map(fn(v) { @core.identity(v) })
}

///|
/// Returns a static array of elements with the specified class name.
/// Note: The returned array is a snapshot and should be treated as immutable.
impl ElementImpl with getElementsByClassName(self, class_name) -> Array[Element] {
  let arr : @core.Any = self
    .as_any()
    ._call("getElementsByClassName", [@core.any(class_name)])
    .cast()
  @js.array_from(arr).map(fn(v) { @core.identity(v) })
}

///|
impl ElementImpl with querySelector(self, selector) -> Element? {
  let v : @core.Any = self
    .as_any()
    ._call("querySelector", [@core.any(selector)])
    .cast()
  v |> @core.identity_option
}

///|
/// Returns a static array of elements matching the specified CSS selector.
/// Note: The returned array is a snapshot and should be treated as immutable.
impl ElementImpl with querySelectorAll(self, selector) -> Array[Element] {
  let arr : @core.Any = self
    .as_any()
    ._call("querySelectorAll", [@core.any(selector)])
    .cast()
  @js.array_from(arr).map(@core.identity(_))
}
