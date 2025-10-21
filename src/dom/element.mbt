///|
#external
pub type Element

///|
pub extern "js" fn get_tag_name(self : Element) -> String =
  #| (el) => el.tagName

///|
pub extern "js" fn get_inner_html(self : Element) -> String =
  #| (el) => el.innerHTML

///|
pub extern "js" fn get_text_content(self : Element) -> String =
  #| (el) => el.textContent

///|
pub extern "js" fn set_inner_html(self : Element, html : String) -> Unit =
  #| (el, html) => el.innerHTML = html

///|
pub extern "js" fn get_value(self : Element) -> String =
  #| (el) => el.value

///|
pub extern "js" fn Element::append_child(
  self : Element,
  child : Element,
) -> Element =
  #| (el, child) => el.appendChild(child)

///|
pub extern "js" fn Element::insert_before(
  self : Element,
  child : Element,
) -> Element =
  #| (el, child) => el.insertBefore(child)

///|
extern "js" fn query_selector_internal(
  self : Element,
  selector : String,
) -> Element =
  #| (el, selector) => el.querySelector(selector)

///|
pub fn Element::query_selector(self : Element, selector : String) -> Element? {
  let el = self.query_selector_internal(selector)
  if el.to_js_value().is_null() {
    return None
  } else {
    return Some(el)
  }
}

///|
pub fn Element::id(self : Element) -> String? {
  let v = self.to_js_value().get("id")
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
pub fn Element::to_js_value(self : Element) -> Value = "%identity"

///|
extern "js" fn Element::ffi_add_event_listener(
  self : Element,
  event : String,
  listener : (Event) -> Unit,
) -> Unit = "(self, eventType, listener) => self.addEventListener(eventType, listener)"

///|
extern "js" fn Element::ffi_remove_event_listener(
  self : Element,
  event : String,
  listener : (Event) -> Unit,
) -> Unit = "(self, eventType, listener) => self.removeEventListener(eventType, listener)"

///|
pub fn Element::add_event_listener(
  self : Element,
  event : String,
  listener : (Event) -> Unit,
) -> Unit {
  self.ffi_add_event_listener(event, listener |> @js.identity)
}

///|
pub fn Element::remove_event_listener(
  self : Element,
  event : String,
  listener : (Event) -> Unit,
) -> Unit {
  self.ffi_remove_event_listener(event, listener |> @js.identity)
}
