///|
#external
pub type Element

///|
pub impl Js for Element

///|
pub impl EventTargetImpl for Element

///|
/// Element trait - base interface for element nodes
pub(open) trait ElementImpl: Js + NodeImpl {
  tag_name(Self) -> String = _
  class_name(Self) -> String = _
  set_class_name(Self, String) -> Unit = _
  id(Self) -> String = _
  set_id(Self, String) -> Unit = _
  get_attribute(Self, String) -> String? = _
  set_attribute(Self, String, String) -> Unit = _
  remove_attribute(Self, String) -> Unit = _
  has_attribute(Self, String) -> Bool = _
  get_elements_by_tag_name(Self, String) -> Array[Element] = _
  get_elements_by_class_name(Self, String) -> Array[Element] = _
  query_selector(Self, String) -> Element? = _
  query_selector_all(Self, String) -> Array[Element] = _
}

///|
impl ElementImpl with tag_name(self) -> String {
  unsafe_cast(self.get("tagName"))
}

///|
impl ElementImpl with class_name(self) -> String {
  unsafe_cast(self.get("className"))
}

///|
impl ElementImpl with set_class_name(self, class_name) -> Unit {
  self.set("className", class_name)
}

///|
impl ElementImpl with id(self) -> String {
  unsafe_cast(self.get("id"))
}

///|
impl ElementImpl with set_id(self, id) -> Unit {
  self.set("id", id)
}

///|
impl ElementImpl with get_attribute(self, name) -> String? {
  self.invoke("getAttribute", [name]) |> unsafe_cast
}

///|
impl ElementImpl with set_attribute(self, name, value) -> Unit {
  ignore(self.invoke("setAttribute", [name, value]))
}

///|
impl ElementImpl with remove_attribute(self, name) -> Unit {
  ignore(self.invoke("removeAttribute", [name]))
}

///|
impl ElementImpl with has_attribute(self, name) -> Bool {
  self.invoke("hasAttribute", [name]) |> unsafe_cast
}

///|
impl ElementImpl with get_elements_by_tag_name(self, tag_name) -> Array[Element] {
  @js.array_from(self.invoke("getElementsByTagName", [tag_name])).map(fn(v) {
    unsafe_cast(v)
  })
}

///|
impl ElementImpl with get_elements_by_class_name(self, class_name) -> Array[
  Element,
] {
  @js.array_from(self.invoke("getElementsByClassName", [class_name])).map(fn(
    v,
  ) {
    unsafe_cast(v)
  })
}

///|
impl ElementImpl with query_selector(self, selector) -> Element? {
  self.invoke("querySelector", [selector]) |> unsafe_cast
}

///|
impl ElementImpl with query_selector_all(self, selector) -> Array[Element] {
  @js.array_from(self.invoke("querySelectorAll", [selector])).map(
    unsafe_cast(_),
  )
}
