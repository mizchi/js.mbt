///|
#external
pub type Element

///|
pub fn Element::as_any(self : Element) -> @nostd.Any = "%identity"

///|
pub fn Element::as_event_target(self : Element) -> @event.EventTarget = "%identity"

///|
pub fn Element::as_node(self : Element) -> Node = "%identity"

///|
pub impl @js.JsImpl for Element

///|
pub impl ElementImpl for Element with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// Element trait - base interface for element nodes
pub(open) trait ElementImpl {
  as_any(Self) -> @nostd.Any
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
  append(Self, &NodeImpl) -> Unit = _
}

///|
impl ElementImpl with tagName(self) {
  self.as_any()._get("tagName").cast()
}

///|
impl ElementImpl with append(self, child) {
  self.as_any()._call("append", [child.as_any()]) |> ignore
}

///|
impl ElementImpl with className(self) -> String {
  self.as_any()._get("className").cast()
}

///|
impl ElementImpl with setClassName(self, class_name) -> Unit {
  self.as_any()._set("className", @nostd.any(class_name)) |> ignore
}

///|
impl ElementImpl with id(self) -> String {
  self.as_any()._get("id").cast()
}

///|
impl ElementImpl with setId(self, id) -> Unit {
  self.as_any()._set("id", @nostd.any(id)) |> ignore
}

///|
impl ElementImpl with getAttribute(self, name) -> String? {
  let v : @js.Any = self.as_any()._call("getAttribute", [@nostd.any(name)]).cast()
  v |> @js.identity_option
}

///|
impl ElementImpl with setAttribute(self, name, value) -> Unit {
  self.as_any()._call("setAttribute", [@nostd.any(name), @nostd.any(value)]) |> ignore
}

///|
impl ElementImpl with removeAttribute(self, name) -> Unit {
  self.as_any()._call("removeAttribute", [@nostd.any(name)]) |> ignore
}

///|
impl ElementImpl with hasAttribute(self, name) -> Bool {
  self.as_any()._call("hasAttribute", [@nostd.any(name)]).cast()
}

///|
/// Returns a static array of elements with the specified tag name.
/// Note: The returned array is a snapshot and should be treated as immutable.
impl ElementImpl with getElementsByTagName(self, tag_name) -> Array[Element] {
  let arr : @js.Any = self.as_any()._call("getElementsByTagName", [@nostd.any(tag_name)]).cast()
  @js.array_from(arr).map(fn(v) { @js.identity(v) })
}

///|
/// Returns a static array of elements with the specified class name.
/// Note: The returned array is a snapshot and should be treated as immutable.
impl ElementImpl with getElementsByClassName(self, class_name) -> Array[Element] {
  let arr : @js.Any = self.as_any()._call("getElementsByClassName", [@nostd.any(class_name)]).cast()
  @js.array_from(arr).map(fn(v) { @js.identity(v) })
}

///|
impl ElementImpl with querySelector(self, selector) -> Element? {
  let v : @js.Any = self.as_any()._call("querySelector", [@nostd.any(selector)]).cast()
  v |> @js.identity_option
}

///|
/// Returns a static array of elements matching the specified CSS selector.
/// Note: The returned array is a snapshot and should be treated as immutable.
impl ElementImpl with querySelectorAll(self, selector) -> Array[Element] {
  let arr : @js.Any = self.as_any()._call("querySelectorAll", [@nostd.any(selector)]).cast()
  @js.array_from(arr).map(@js.identity(_))
}
