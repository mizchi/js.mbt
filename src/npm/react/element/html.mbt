///|
fn common_node(
  tag_name : String,
  attributes : Map[String, Val],
  children~ : Array[&ReactNode],
  id~ : String?,
  class~ : String?,
  className~ : String?,
  style~ : Map[String, String]?,
  tab_index~ : Int?,
  ref_~ : ReactRef[@dom.Element]?,
  key~ : String?,
  on_click~ : MouseEventHandler?,
  on_change~ : ChangeEventHandler?,
  on_keydown~ : KeyboardEventHandler?,
  on_keyup~ : KeyboardEventHandler?,
  on_drag~ : DragEventHandler?,
  on_dragstart~ : DragEventHandler?,
  on_dragend~ : DragEventHandler?,
  on_dragleave~ : DragEventHandler?,
  on_dragenter~ : DragEventHandler?,
  on_dragover~ : DragEventHandler?,
  on_drop~ : DragEventHandler?,
) -> @react.Element {
  let attr : Map[String, Val] = {}
  for k, v in attributes {
    attr[k] = v
  }
  if id is Some(id) {
    attr.set("id", id |> safe_js)
  }
  if class is Some(class) {
    attr.set("className", class |> safe_js)
  }
  if className is Some(className) {
    attr.set("className", className |> safe_js)
  }
  if tab_index is Some(tab_index) {
    attr.set("tabIndex", tab_index |> safe_js)
  }
  if style is Some(style) {
    let style_obj = @js.Object::new()
    for k, v in style {
      style_obj.set(k, v)
    }
    attr.set("style", style_obj.to_js())
  }
  if ref_ is Some(ref_) {
    attr.set("ref", ref_ |> safe_js)
  }
  if key is Some(key) {
    attr.set("key", key |> safe_js)
  }
  if on_click is Some(f) {
    attr.set("onClick", f |> @js.from_fn1)
  }
  if on_change is Some(f) {
    attr.set("onChange", f |> @js.from_fn1)
  }
  if on_keydown is Some(f) {
    attr.set("onKeyDown", f |> @js.from_fn1)
  }
  if on_keyup is Some(f) {
    attr.set("onKeyUp", f |> @js.from_fn1)
  }
  let drag_handlers : Array[(String, DragEventHandler?)] = [
    ("onDrag", on_drag),
    ("onDragStart", on_dragstart),
    ("onDragEnd", on_dragend),
    ("onDragLeave", on_dragleave),
    ("onDragEnter", on_dragenter),
    ("onDragOver", on_dragover),
    ("onDrop", on_drop),
  ]
  for h in drag_handlers {
    if h.1 is Some(f) {
      attr.set(h.0, f |> @js.from_fn1)
    }
  }
  h(tag_name, attributes=attr, children.map(_.to_react_node()))
}

///|
pub fn div(
  // common props
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "div",
    attributes.unwrap_or({}),
    id~,
    class~,
    tab_index~,
    className~,
    style~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    children~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
  )
}

///|
pub fn pre(
  // common props
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "pre",
    attributes.unwrap_or({}),
    id~,
    tab_index~,
    class~,
    className~,
    style~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn blockquote(
  // common props
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "blockquote",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn span(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "span",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    ref_~,
    tab_index~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn nav(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "nav",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    ref_~,
    tab_index~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn p(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "p",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn textarea(
  children : Array[&ReactNode],
  rows? : Int,
  columns? : Int,
  spellcheck? : Bool,
  value? : String,
  default_value? : String,
  placeholder? : String,
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let new_attributes : Map[String, Val] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  if rows is Some(r) {
    new_attributes.set("rows", r |> js)
  }
  if columns is Some(c) {
    new_attributes.set("cols", c |> js)
  }
  if spellcheck is Some(s) {
    new_attributes.set("spellCheck", s |> js)
  }
  if value is Some(v) {
    new_attributes.set("value", v |> js)
  }
  if default_value is Some(dv) {
    new_attributes.set("defaultValue", dv |> js)
  }
  if placeholder is Some(p) {
    new_attributes.set("placeholder", p |> js)
  }
  common_node(
    "textarea",
    new_attributes,
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn input(
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  name? : String,
  type_? : String,
  value? : String,
  default_value? : String,
  placeholder? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let new_attributes : Map[String, Val] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  if name is Some(n) {
    new_attributes.set("name", n |> js)
  }
  if value is Some(v) {
    new_attributes.set("value", v |> js)
  }
  if default_value is Some(dv) {
    new_attributes.set("defaultValue", dv |> js)
  }
  if type_ is Some(t) {
    new_attributes.set("type", t |> js)
  }
  if placeholder is Some(p) {
    new_attributes.set("placeholder", p |> js)
  }
  common_node(
    "input",
    new_attributes,
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children=[],
  )
}

///|
pub fn main_(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "main",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn header(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "header",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn footer(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "footer",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn ul(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "ul",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn ol(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "ol",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn article(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "article",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn aside(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "aside",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn section(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "section",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
#external
pub type FormData

///|
pub extern "js" fn FormData::get(self : FormData, key : String) -> Val =
  #| (formData, key) => formData.get(key)

///|
pub fn form(
  children : Array[&ReactNode],

  // xxx
  method_? : String,
  disabled? : Bool,
  name? : String,
  enc_type? : String,
  action? : (FormData) -> Unit,
  on_submit? : (@dom.FormEvent) -> Unit,
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let new_attributes : Map[String, Val] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  if disabled is Some(d) {
    new_attributes.set("disabled", d |> js)
  }
  if name is Some(n) {
    new_attributes.set("name", n |> js)
  }
  if method_ is Some(m) {
    new_attributes.set("method", m |> js)
  }
  if on_submit is Some(f) {
    let fn_value : Val = f |> js
    new_attributes.set("onSubmit", fn_value)
  }
  if action is Some(f) {
    let fn_value : Val = f |> js
    new_attributes.set("action", fn_value)
  }
  if enc_type is Some(e) {
    new_attributes.set("encType", e |> js)
  }
  common_node(
    "form",
    new_attributes,
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn select(
  children : Array[&ReactNode],
  // xxx
  multiple? : Bool,
  disabled? : Bool,
  name? : String,
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let new_attributes : Map[String, Val] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  if multiple is Some(m) {
    new_attributes.set("multiple", m |> js)
  }
  if disabled is Some(d) {
    new_attributes.set("disabled", d |> js)
  }
  if name is Some(n) {
    new_attributes.set("name", n |> js)
  }
  common_node(
    "select",
    new_attributes,
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn option(
  children : Array[&ReactNode],
  value~ : String,
  selected? : Bool,
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let new_attributes : Map[String, Val] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  new_attributes.set("value", value |> js)
  if selected is Some(s) {
    new_attributes.set("selected", s |> js)
  }
  common_node(
    "option",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn label(
  children : Array[&ReactNode],
  htmlFor : String,
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let new_attributes : Map[String, Val] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  new_attributes.set("htmlFor", htmlFor |> js)
  common_node(
    "label",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn li(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "li",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn code(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "code",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn details(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "details",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn summary(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "summary",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn a(
  children : Array[&ReactNode],

  // a specific
  href~ : String,
  download? : String,
  target? : String,

  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let new_attributes : Map[String, Val] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  new_attributes.set("href", href |> js)
  if download is Some(d) {
    new_attributes.set("download", d |> js)
  }
  if target is Some(t) {
    new_attributes.set("target", t |> js)
  }
  common_node(
    "a",
    new_attributes,
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn iframe(
  children : Array[&ReactNode],

  // a specific
  src~ : String,
  width? : Int,
  height? : Int,
  frameborder? : String,
  sandbox? : String,
  tab_index? : Int,
  allowfullscreen? : Bool,
  loading? : String,
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let new_attributes : Map[String, Val] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  new_attributes.set("src", src |> js)
  if width is Some(d) {
    new_attributes.set("width", d |> js)
  }
  if height is Some(d) {
    new_attributes.set("height", d |> js)
  }
  if frameborder is Some(d) {
    new_attributes.set("frameborder", d |> js)
  }
  if sandbox is Some(d) {
    new_attributes.set("sandbox", d |> js)
  }
  if allowfullscreen is Some(d) {
    new_attributes.set("allowfullscreen", d |> js)
  }
  if loading is Some(d) {
    new_attributes.set("loading", d |> js)
  }
  common_node(
    "iframe",
    new_attributes,
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn img(
  children : Array[&ReactNode],

  // a specific
  src~ : String,
  srcset? : String,
  alt? : String,
  crossorigin? : String,
  decoding? : String,
  width? : Int,
  height? : Int,
  fetchpriority? : String,
  loading? : String,
  sizes? : String,

  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let new_attributes : Map[String, Val] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  new_attributes.set("src", src |> js)
  if alt is Some(d) {
    new_attributes.set("alt", d |> js)
  }
  if crossorigin is Some(d) {
    new_attributes.set("crossorigin", d |> js)
  }
  if decoding is Some(d) {
    new_attributes.set("decoding", d |> js)
  }
  if width is Some(d) {
    new_attributes.set("width", d |> js)
  }
  if height is Some(d) {
    new_attributes.set("height", d |> js)
  }
  if fetchpriority is Some(d) {
    new_attributes.set("fetchpriority", d |> js)
  }
  if loading is Some(d) {
    new_attributes.set("loading", d |> js)
  }
  if sizes is Some(d) {
    new_attributes.set("sizes", d |> js)
  }
  if srcset is Some(d) {
    new_attributes.set("srcset", d |> js)
  }
  common_node(
    "img",
    new_attributes,
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn video(
  children : Array[&ReactNode],

  // a specific
  controls? : Bool,

  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let new_attributes : Map[String, Val] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  if controls is Some(c) {
    new_attributes.set("controls", c |> js)
  }
  common_node(
    "video",
    new_attributes,
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn source(
  // a specific
  src~ : String,
  type_? : String,

  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let new_attributes : Map[String, Val] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  new_attributes.set("src", src |> js)
  if type_ is Some(t) {
    new_attributes.set("type", t |> js)
  }
  common_node(
    "video",
    new_attributes,
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children=[],
  )
}

///|
pub fn hr(
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "hr",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children=[],
  )
}

///|
pub fn h1(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "h1",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn h2(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "h2",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn h3(
  children : Array[&ReactNode],
  // shared
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  common_node(
    "h3",
    attributes.unwrap_or({}),
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}

///|
pub fn button(
  children : Array[&ReactNode],
  type_? : String,
  disabled? : Bool,
  attributes? : Map[String, Val],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  ref_? : ReactRef[@dom.Element],
  key? : String,
  on_click? : MouseEventHandler,
  on_change? : ChangeEventHandler,
  on_keydown? : KeyboardEventHandler,
  on_keyup? : KeyboardEventHandler,
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let new_attributes : Map[String, Val] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  if type_ is Some(t) {
    new_attributes.set("type", t |> js)
  }
  if disabled is Some(d) {
    new_attributes.set("disabled", d |> js)
  }
  common_node(
    "button",
    new_attributes,
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change~,
    on_keydown~,
    on_keyup~,
    on_drag~,
    on_dragend~,
    on_dragenter~,
    on_dragleave~,
    on_dragover~,
    on_dragstart~,
    on_drop~,
    children~,
  )
}
