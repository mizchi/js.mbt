///|
#external
pub type Element

///|
pub impl Js for Element with to_js(self) -> Val {
  self |> js
}

///|
pub fn Element::get_tag_name(self : Self) -> String {
  self.to_js().get("tagName").cast()
}

///|
pub fn Element::get_inner_html(self : Self) -> String {
  self.to_js().get("innerHTML").cast()
}

///|
pub fn Element::set_text_content(self : Self, text : String) -> Unit {
  self.to_js().set("textContent", text |> js) |> ignore
}

///|
pub fn Element::set_inner_html(self : Self, html : String) -> Unit {
  self.to_js().set("innerHTML", html |> js) |> ignore
}

///|
pub fn Element::get_text_content(self : Self) -> String {
  self.to_js().get("textContent").cast()
}

///|
pub fn Element::set_attribute(self : Self, name : String, value : String) -> Unit {
  self
  .to_js()
  .call_method("setAttribute", [name |> js, value |> js])
  |> ignore
}

///|
pub fn Element::get_attribute(self : Self, name : String) -> Val? {
  self.to_js().call_method("getAttribute", [name |> js]).cast_option()
}

///|
pub fn Element::get_value(self : Self) -> String {
  self.to_js().get("value").cast()
}

///|
pub fn Element::append_child(self : Self, child : Self) -> Self {
  self.to_js().call_method("appendChild", [child |> js]).cast()
}

///|
pub fn Element::insert_before(self : Self, child : Self) -> Self {
  self.to_js().call_method("insertBefore", [child |> js]).cast()
}

///|
pub fn Element::query_selector(self : Self, selector : String) -> Self? {
  self
  .to_js()
  .call_method("querySelector", [selector |> js])
  .cast_option()
}

///|
pub fn Element::id(self : Self) -> String? {
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
pub fn Element::focus(self : Self) -> Unit {
  self.to_js().call_method("focus", []) |> ignore
}

///|
pub fn Element::add_event_listener(
  self : Self,
  event : String,
  listener : (Event) -> Unit,
) -> Unit {
  self
  .to_js()
  .call_method("addEventListener", [event |> js, listener |> js])
  |> ignore
}

///|
pub fn Element::remove_event_listener(
  self : Self,
  event : String,
  listener : (Event) -> Unit,
) -> Unit {
  self
  .to_js()
  .call_method("removeEventListener", [
    event |> js,
    listener |> js,
  ])
  |> ignore
}
