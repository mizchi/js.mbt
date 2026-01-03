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
pub fn get_text_content(el : @core.Any) -> String {
  el["textContent"] |> @core.Any::cast()
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

// ============================================
// Events
// ============================================

///|
pub fn add_event_listener(
  el : @core.Any,
  event_type : String,
  callback : () -> Unit,
) -> Unit {
  el._call("addEventListener", [@core.any(event_type), @core.any(callback)])
  |> ignore
}

///|
pub fn add_event_listener_with_event(
  el : @core.Any,
  event_type : String,
  callback : (@core.Any) -> Unit,
) -> Unit {
  el._call("addEventListener", [@core.any(event_type), @core.any(callback)])
  |> ignore
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
