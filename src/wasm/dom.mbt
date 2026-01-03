// dom.mbt - DOM API wrappers using @core (WASM-GC only)

// ============================================
// Document
// ============================================

///|
pub fn document() -> @core.Any {
  @core.global_this()["document"]
}

///|
pub fn document_body() -> @core.Any {
  document()["body"]
}

///|
pub fn get_element_by_id(id : String) -> @core.Any {
  document()._call("getElementById", [@core.any(id)])
}

///|
pub fn query_selector(selector : String) -> @core.Any {
  document()._call("querySelector", [@core.any(selector)])
}

///|
pub fn create_element(tag : String) -> @core.Any {
  document()._call("createElement", [@core.any(tag)])
}

///|
pub fn create_text_node(text : String) -> @core.Any {
  document()._call("createTextNode", [@core.any(text)])
}

// ============================================
// Element operations
// ============================================

///|
pub fn append_child(parent : @core.Any, child : @core.Any) -> @core.Any {
  parent._call("appendChild", [child])
}

///|
pub fn remove_child(parent : @core.Any, child : @core.Any) -> @core.Any {
  parent._call("removeChild", [child])
}

///|
pub fn set_attribute(el : @core.Any, name : String, value : String) -> Unit {
  el._call("setAttribute", [@core.any(name), @core.any(value)]) |> ignore
}

///|
pub fn get_attribute(el : @core.Any, name : String) -> @core.Any {
  el._call("getAttribute", [@core.any(name)])
}

///|
pub fn set_text_content(el : @core.Any, text : String) -> Unit {
  el["textContent"] = @core.any(text)
}

///|
pub fn get_text_content(el : @core.Any) -> @core.Any {
  el["textContent"]
}

///|
pub fn set_inner_html(el : @core.Any, html : String) -> Unit {
  el["innerHTML"] = @core.any(html)
}

///|
pub fn set_id(el : @core.Any, id : String) -> Unit {
  el["id"] = @core.any(id)
}

///|
pub fn set_class_name(el : @core.Any, class_name : String) -> Unit {
  el["className"] = @core.any(class_name)
}

///|
pub fn set_style(el : @core.Any, prop : String, value : String) -> Unit {
  el["style"][prop] = @core.any(value)
}

///|
pub fn get_style(el : @core.Any, prop : String) -> @core.Any {
  el["style"][prop]
}

// ============================================
// classList operations
// ============================================

///|
pub fn class_list_add(el : @core.Any, class_name : String) -> Unit {
  el["classList"]._call("add", [@core.any(class_name)]) |> ignore
}

///|
pub fn class_list_remove(el : @core.Any, class_name : String) -> Unit {
  el["classList"]._call("remove", [@core.any(class_name)]) |> ignore
}

///|
pub fn class_list_toggle(el : @core.Any, class_name : String) -> @core.Any {
  el["classList"]._call("toggle", [@core.any(class_name)])
}

///|
pub fn class_list_contains(el : @core.Any, class_name : String) -> @core.Any {
  el["classList"]._call("contains", [@core.any(class_name)])
}

// ============================================
// dataset (data-* attributes)
// ============================================

///|
pub fn get_dataset(el : @core.Any, key : String) -> @core.Any {
  el["dataset"][key]
}

///|
pub fn set_dataset(el : @core.Any, key : String, value : String) -> Unit {
  el["dataset"][key] = @core.any(value)
}

// ============================================
// DOM Traversal
// ============================================

///|
pub fn parent_node(el : @core.Any) -> @core.Any {
  el["parentNode"]
}

///|
pub fn parent_element(el : @core.Any) -> @core.Any {
  el["parentElement"]
}

///|
pub fn children(el : @core.Any) -> @core.Any {
  el["children"]
}

///|
pub fn first_child(el : @core.Any) -> @core.Any {
  el["firstChild"]
}

///|
pub fn last_child(el : @core.Any) -> @core.Any {
  el["lastChild"]
}

///|
pub fn next_sibling(el : @core.Any) -> @core.Any {
  el["nextSibling"]
}

///|
pub fn previous_sibling(el : @core.Any) -> @core.Any {
  el["previousSibling"]
}

///|
pub fn first_element_child(el : @core.Any) -> @core.Any {
  el["firstElementChild"]
}

///|
pub fn last_element_child(el : @core.Any) -> @core.Any {
  el["lastElementChild"]
}

///|
pub fn child_element_count(el : @core.Any) -> @core.Any {
  el["childElementCount"]
}

// ============================================
// More DOM operations
// ============================================

///|
pub fn query_selector_all(selector : String) -> @core.Any {
  document()._call("querySelectorAll", [@core.any(selector)])
}

///|
pub fn query_selector_all_on(el : @core.Any, selector : String) -> @core.Any {
  el._call("querySelectorAll", [@core.any(selector)])
}

///|
pub fn clone_node(el : @core.Any, deep : Bool) -> @core.Any {
  el._call("cloneNode", [@core.ToAny::to_any(deep)])
}

///|
pub fn insert_before(
  parent : @core.Any,
  new_node : @core.Any,
  ref_node : @core.Any,
) -> @core.Any {
  parent._call("insertBefore", [new_node, ref_node])
}

///|
pub fn replace_child(
  parent : @core.Any,
  new_child : @core.Any,
  old_child : @core.Any,
) -> @core.Any {
  parent._call("replaceChild", [new_child, old_child])
}

///|
pub fn remove(el : @core.Any) -> Unit {
  el._call("remove", []) |> ignore
}

///|
pub fn has_attribute(el : @core.Any, name : String) -> @core.Any {
  el._call("hasAttribute", [@core.any(name)])
}

///|
pub fn remove_attribute(el : @core.Any, name : String) -> Unit {
  el._call("removeAttribute", [@core.any(name)]) |> ignore
}

///|
pub fn get_bounding_client_rect(el : @core.Any) -> @core.Any {
  el._call("getBoundingClientRect", [])
}

// ============================================
// Form Elements
// ============================================

///|
pub fn get_value(el : @core.Any) -> @core.Any {
  el["value"]
}

///|
pub fn set_value(el : @core.Any, value : String) -> Unit {
  el["value"] = @core.any(value)
}

///|
pub fn get_checked(el : @core.Any) -> @core.Any {
  el["checked"]
}

///|
pub fn set_checked(el : @core.Any, checked : Bool) -> Unit {
  el["checked"] = @core.ToAny::to_any(checked)
}

///|
pub fn get_disabled(el : @core.Any) -> @core.Any {
  el["disabled"]
}

///|
pub fn set_disabled(el : @core.Any, disabled : Bool) -> Unit {
  el["disabled"] = @core.ToAny::to_any(disabled)
}

///|
pub fn get_selected_index(el : @core.Any) -> @core.Any {
  el["selectedIndex"]
}

///|
pub fn set_selected_index(el : @core.Any, index : Int) -> Unit {
  el["selectedIndex"] = @core.ToAny::to_any(index)
}

///|
pub fn focus(el : @core.Any) -> Unit {
  el._call("focus", []) |> ignore
}

///|
pub fn blur(el : @core.Any) -> Unit {
  el._call("blur", []) |> ignore
}

// ============================================
// Events
// ============================================
// LIMITATION: These functions are defined but CANNOT be used in WASM-GC.
// MoonBit closures have incompatible types with externref.
// Error: "array.new_fixed expected externref, found (ref X)"
// Workaround: Set up event handlers from JavaScript side.

///|
/// WARNING: Does not work in WASM-GC - use JavaScript for event handling
pub fn add_event_listener(
  _el : @core.Any,
  _event_type : String,
  _callback : () -> Unit,
) -> Unit {
  abort("add_event_listener: Not supported in WASM-GC. Use JavaScript.")
}

///|
/// WARNING: Does not work in WASM-GC - use JavaScript for event handling
pub fn add_event_listener_with_event(
  _el : @core.Any,
  _event_type : String,
  _callback : (@core.Any) -> Unit,
) -> Unit {
  abort(
    "add_event_listener_with_event: Not supported in WASM-GC. Use JavaScript.",
  )
}

// ============================================
// Console
// ============================================

///|
pub fn console_log(msg : String) -> Unit {
  @core.global_this()["console"]._call("log", [@core.any(msg)]) |> ignore
}

///|
pub fn console_log_any(value : @core.Any) -> Unit {
  @core.global_this()["console"]._call("log", [value]) |> ignore
}

///|
pub fn console_error(msg : String) -> Unit {
  @core.global_this()["console"]._call("error", [@core.any(msg)]) |> ignore
}

// ============================================
// Window
// ============================================

///|
pub fn window() -> @core.Any {
  @core.global_this()
}

///|
pub fn alert(msg : String) -> Unit {
  window()._call("alert", [@core.any(msg)]) |> ignore
}

///|
pub fn set_timeout(callback : () -> Unit, delay : Int) -> @core.Any {
  window()._call("setTimeout", [@core.any(callback), @core.any(delay)])
}

///|
pub fn set_interval(callback : () -> Unit, delay : Int) -> @core.Any {
  window()._call("setInterval", [@core.any(callback), @core.any(delay)])
}

///|
pub fn clear_timeout(id : @core.Any) -> Unit {
  window()._call("clearTimeout", [id]) |> ignore
}

///|
pub fn clear_interval(id : @core.Any) -> Unit {
  window()._call("clearInterval", [id]) |> ignore
}
