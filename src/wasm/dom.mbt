// dom.mbt - DOM API wrappers using xany (WASM-GC only)

// ============================================
// Document
// ============================================

///|
pub fn document() -> @xany.Xany {
  @xany.global_this()["document"]
}

///|
pub fn document_body() -> @xany.Xany {
  document()["body"]
}

///|
pub fn get_element_by_id(id : String) -> @xany.Xany {
  document()._call("getElementById", [@xany.Xany::of(id)])
}

///|
pub fn query_selector(selector : String) -> @xany.Xany {
  document()._call("querySelector", [@xany.Xany::of(selector)])
}

///|
pub fn create_element(tag : String) -> @xany.Xany {
  document()._call("createElement", [@xany.Xany::of(tag)])
}

///|
pub fn create_text_node(text : String) -> @xany.Xany {
  document()._call("createTextNode", [@xany.Xany::of(text)])
}

// ============================================
// Element operations
// ============================================

///|
pub fn append_child(parent : @xany.Xany, child : @xany.Xany) -> @xany.Xany {
  parent._call("appendChild", [child])
}

///|
pub fn remove_child(parent : @xany.Xany, child : @xany.Xany) -> @xany.Xany {
  parent._call("removeChild", [child])
}

///|
pub fn set_attribute(el : @xany.Xany, name : String, value : String) -> Unit {
  el._call("setAttribute", [@xany.Xany::of(name), @xany.Xany::of(value)])
  |> ignore
}

///|
pub fn get_attribute(el : @xany.Xany, name : String) -> @xany.Xany {
  el._call("getAttribute", [@xany.Xany::of(name)])
}

///|
pub fn set_text_content(el : @xany.Xany, text : String) -> Unit {
  el["textContent"] = @xany.Xany::of(text)
}

///|
pub fn get_text_content(el : @xany.Xany) -> String {
  el["textContent"].unsafe_coerce()
}

///|
pub fn set_inner_html(el : @xany.Xany, html : String) -> Unit {
  el["innerHTML"] = @xany.Xany::of(html)
}

///|
pub fn set_id(el : @xany.Xany, id : String) -> Unit {
  el["id"] = @xany.Xany::of(id)
}

///|
pub fn set_class_name(el : @xany.Xany, class_name : String) -> Unit {
  el["className"] = @xany.Xany::of(class_name)
}

///|
pub fn set_style(el : @xany.Xany, prop : String, value : String) -> Unit {
  el["style"][prop] = @xany.Xany::of(value)
}

// ============================================
// Events
// ============================================

///|
pub fn add_event_listener(
  el : @xany.Xany,
  event_type : String,
  callback : () -> Unit,
) -> Unit {
  el._call("addEventListener", [
    @xany.Xany::of(event_type),
    @xany.Xany::of(callback),
  ])
  |> ignore
}

///|
pub fn add_event_listener_with_event(
  el : @xany.Xany,
  event_type : String,
  callback : (@xany.Xany) -> Unit,
) -> Unit {
  el._call("addEventListener", [
    @xany.Xany::of(event_type),
    @xany.Xany::of(callback),
  ])
  |> ignore
}

// ============================================
// Console
// ============================================

///|
pub fn console_log(msg : String) -> Unit {
  @xany.global_this()["console"]._call("log", [@xany.Xany::of(msg)]) |> ignore
}

///|
pub fn console_log_any(value : @xany.Xany) -> Unit {
  @xany.global_this()["console"]._call("log", [value]) |> ignore
}

///|
pub fn console_error(msg : String) -> Unit {
  @xany.global_this()["console"]._call("error", [@xany.Xany::of(msg)]) |> ignore
}

// ============================================
// Window
// ============================================

///|
pub fn window() -> @xany.Xany {
  @xany.global_this()
}

///|
pub fn alert(msg : String) -> Unit {
  window()._call("alert", [@xany.Xany::of(msg)]) |> ignore
}

///|
pub fn set_timeout(callback : () -> Unit, delay : Int) -> @xany.Xany {
  window()._call("setTimeout", [@xany.Xany::of(callback), @xany.Xany::of(delay)])
}

///|
pub fn set_interval(callback : () -> Unit, delay : Int) -> @xany.Xany {
  window()._call("setInterval", [
    @xany.Xany::of(callback),
    @xany.Xany::of(delay),
  ])
}

///|
pub fn clear_timeout(id : @xany.Xany) -> Unit {
  window()._call("clearTimeout", [id]) |> ignore
}

///|
pub fn clear_interval(id : @xany.Xany) -> Unit {
  window()._call("clearInterval", [id]) |> ignore
}
