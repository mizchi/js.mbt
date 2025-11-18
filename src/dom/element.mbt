///|
#external
pub type Element

///|
pub impl JsImpl for Element

///|
pub impl EventTargetImpl for Element

///|
pub impl NodeImpl for Element

///|
pub impl ElementImpl for Element

///|
/// Element trait - base interface for element nodes
pub(open) trait ElementImpl: JsImpl + NodeImpl {
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
  self.get("tagName") |> unsafe_cast
}

///|
impl ElementImpl with append(self, child) {
  self.invoke("append", [child.to_js()]) |> unsafe_cast
}

///|
impl ElementImpl with className(self) -> String {
  unsafe_cast(self.get("className"))
}

///|
impl ElementImpl with setClassName(self, class_name) -> Unit {
  self.set("className", class_name)
}

///|
impl ElementImpl with id(self) -> String {
  unsafe_cast(self.get("id"))
}

///|
impl ElementImpl with setId(self, id) -> Unit {
  self.set("id", id)
}

///|
impl ElementImpl with getAttribute(self, name) -> String? {
  self.invoke("getAttribute", [name]) |> unsafe_cast
}

///|
impl ElementImpl with setAttribute(self, name, value) -> Unit {
  ignore(self.invoke("setAttribute", [name, value]))
}

///|
impl ElementImpl with removeAttribute(self, name) -> Unit {
  ignore(self.invoke("removeAttribute", [name]))
}

///|
impl ElementImpl with hasAttribute(self, name) -> Bool {
  self.invoke("hasAttribute", [name]) |> unsafe_cast
}

///|
impl ElementImpl with getElementsByTagName(self, tag_name) -> Array[Element] {
  @js.array_from(self.invoke("getElementsByTagName", [tag_name])).map(fn(v) {
    unsafe_cast(v)
  })
}

///|
impl ElementImpl with getElementsByClassName(self, class_name) -> Array[Element] {
  @js.array_from(self.invoke("getElementsByClassName", [class_name])).map(fn(
    v,
  ) {
    unsafe_cast(v)
  })
}

///|
impl ElementImpl with querySelector(self, selector) -> Element? {
  self.invoke("querySelector", [selector]) |> unsafe_cast
}

///|
impl ElementImpl with querySelectorAll(self, selector) -> Array[Element] {
  @js.array_from(self.invoke("querySelectorAll", [selector])).map(
    unsafe_cast(_),
  )
}
