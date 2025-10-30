///|
#external
pub type Element
///|
pub impl ToJs for Element with to_js(self) -> @js.Value {
  self |> to_js
}

///|
pub fn get_tag_name(self : Element) -> String {
  self.to_js().get("tagName").cast()
}

///|
pub fn get_inner_html(self : Element) -> String {
  self.to_js().get("innerHTML").cast()
}

///|
pub fn set_text_content(self : Element, text : String) -> Unit {
  self.to_js().set("textContent", text |> @js.to_js) |> ignore
}

///|
pub fn set_inner_html(self : Element, html : String) -> Unit {
  self.to_js().set("innerHTML", html |> @js.to_js) |> ignore
}

///|
pub fn get_text_content(self : Element) -> String {
  self.to_js().get("textContent").cast()
}

///|
pub fn set_attribute(
  self : Element,
  name : String,
  value : String,
) -> Unit {
  self.to_js().call_property("setAttribute", [name |> @js.to_js, value |> @js.to_js]) |> ignore
}

///|
pub fn get_attribute(
  self : Element,
  name : String,
) -> Value? {
  self.to_js().call_property("getAttribute", [name |> @js.to_js]).cast_option()
}

///|
pub fn get_value(self : Element) -> String {
  self.to_js().get("value").cast()
}

///|
pub fn append_child(
  self : Element,
  child : Element,
) -> Element {
  self.to_js().call_property("appendChild", [child |> @js.to_js]).cast()
}

///|
pub fn insert_before(
  self : Element,
  child : Element,
) -> Element {
  self.to_js().call_property("insertBefore", [child |> @js.to_js]).cast()
}

///|
pub fn query_selector(self : Element, selector : String) -> Element? {
  self.to_js().call_property("querySelector", [selector |> @js.to_js]).cast_option()
}

///|
pub fn id(self : Element) -> String? {
  let v = self.to_js().get("id")
  if v.is_undefined() {
    None
  } else {
    Some(v.to_string())
  }
}

///|
pub extern "js" fn window() -> Element =
  #| () => window

///|
pub extern "js" fn document() -> Element =
  #| () => document

///|
pub extern "js" fn Element::focus_internal(self : Element) -> Unit = "(self) => self.focus()"

///|
pub fn focus(self : Element) -> Unit {
  self.to_js().call_property("focus", []) |> ignore
}

///|
pub fn add_event_listener(
  self : Element,
  event : String,
  listener : (Event) -> Unit,
) -> Unit {
  self.to_js().call_property("addEventListener", [event |> @js.to_js, listener |> @js.to_js]) |> ignore
}

///|
pub fn remove_event_listener(
  self : Element,
  event : String,
  listener : (Event) -> Unit,
) -> Unit {
  self.to_js().call_property("removeEventListener", [event |> @js.to_js, listener |> @js.to_js]) |> ignore
}
