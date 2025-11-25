///|
#external
pub type Element

///|
pub impl @js.JsImpl for Element

///|
pub impl @event.EventTargetImpl for Element

///|
pub impl NodeImpl for Element

///|
pub impl ElementImpl for Element

///|
/// Element trait - base interface for element nodes
pub(open) trait ElementImpl: @js.JsImpl + NodeImpl {
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
  self.get("tagName").cast()
}

///|
impl ElementImpl with append(self, child) {
  self.call1("append", child.to_any()).cast()
}

///|
impl ElementImpl with className(self) -> String {
  self.get("className").cast()
}

///|
impl ElementImpl with setClassName(self, class_name) -> Unit {
  self.set("className", class_name)
}

///|
impl ElementImpl with id(self) -> String {
  self.get("id").cast()
}

///|
impl ElementImpl with setId(self, id) -> Unit {
  self.set("id", id)
}

///|
impl ElementImpl with getAttribute(self, name) -> String? {
  self.call1("getAttribute", name) |> @js.identity_option
}

///|
impl ElementImpl with setAttribute(self, name, value) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}

///|
impl ElementImpl with removeAttribute(self, name) -> Unit {
  ignore(self.call1("removeAttribute", name))
}

///|
impl ElementImpl with hasAttribute(self, name) -> Bool {
  self.call1("hasAttribute", name).cast()
}

///|
/// Returns a static array of elements with the specified tag name.
/// Note: The returned array is a snapshot and should be treated as immutable.
impl ElementImpl with getElementsByTagName(self, tag_name) -> Array[Element] {
  @js.array_from(self.call1("getElementsByTagName", tag_name)).map(fn(v) {
    @js.identity(v)
  })
}

///|
/// Returns a static array of elements with the specified class name.
/// Note: The returned array is a snapshot and should be treated as immutable.
impl ElementImpl with getElementsByClassName(self, class_name) -> Array[Element] {
  @js.array_from(self.call1("getElementsByClassName", class_name)).map(fn(v) {
    @js.identity(v)
  })
}

///|
impl ElementImpl with querySelector(self, selector) -> Element? {
  self.call1("querySelector", selector) |> @js.identity_option
}

///|
/// TODO: endless loop error occurs in some cases
// impl ElementImpl with querySelector_endless_error(self, selector) -> Element? {
//   self.call("querySelector", [selector]) |> @js.any
// }

///|
/// Returns a static array of elements matching the specified CSS selector.
/// Note: The returned array is a snapshot and should be treated as immutable.
impl ElementImpl with querySelectorAll(self, selector) -> Array[Element] {
  @js.array_from(self.call1("querySelectorAll", selector)).map(@js.identity(_))
}
