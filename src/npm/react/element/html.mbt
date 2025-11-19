///|
fn common_node(
  tag_name : String,
  props : @js.Object,
  children~ : Array[&ReactNode],
  id~ : String?,
  class~ : String?,
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
  let merged_props : @js.Object = @js.Object::assign(@js.Object::new(), props)
    |> unsafe_cast
  if id is Some(id) {
    merged_props.set("id", id)
  }
  if class is Some(class) {
    merged_props.set("className", class)
  }
  if tab_index is Some(tab_index) {
    merged_props.set("tabIndex", tab_index)
  }
  if style is Some(style) {
    let style_obj = @js.Object::new()
    for k, v in style {
      style_obj.set(k, v)
    }
    merged_props.set("style", style_obj.to_js())
  }
  if ref_ is Some(ref_) {
    merged_props.set("ref", ref_ |> js)
  }
  if key is Some(key) {
    merged_props.set("key", key)
  }
  if on_click is Some(f) {
    merged_props.set("onClick", f |> @js.from_fn1)
  }
  if on_change is Some(f) {
    merged_props.set("onChange", f |> @js.from_fn1)
  }
  if on_keydown is Some(f) {
    merged_props.set("onKeyDown", f |> @js.from_fn1)
  }
  if on_keyup is Some(f) {
    merged_props.set("onKeyUp", f |> @js.from_fn1)
  }
  // Optimize: avoid array allocation, handle drag handlers directly
  if on_drag is Some(f) {
    merged_props.set("onDrag", f |> @js.from_fn1)
  }
  if on_dragstart is Some(f) {
    merged_props.set("onDragStart", f |> @js.from_fn1)
  }
  if on_dragend is Some(f) {
    merged_props.set("onDragEnd", f |> @js.from_fn1)
  }
  if on_dragleave is Some(f) {
    merged_props.set("onDragLeave", f |> @js.from_fn1)
  }
  if on_dragenter is Some(f) {
    merged_props.set("onDragEnter", f |> @js.from_fn1)
  }
  if on_dragover is Some(f) {
    merged_props.set("onDragOver", f |> @js.from_fn1)
  }
  if on_drop is Some(f) {
    merged_props.set("onDrop", f |> @js.from_fn1)
  }
  let children_js = children.map(_.to_react_node()) |> @js.from_array
  @react.createElementDirect(tag_name, merged_props.to_js(), children_js)
}

///|
pub fn div(
  // common props
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
    tab_index~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    tab_index~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
    None => @js.Object::new()
  }
  if rows is Some(r) {
    custom_props.set("rows", r)
  }
  if columns is Some(c) {
    custom_props.set("cols", c)
  }
  if spellcheck is Some(s) {
    custom_props.set("spellCheck", s)
  }
  if value is Some(v) {
    custom_props.set("value", v)
  }
  if default_value is Some(dv) {
    custom_props.set("defaultValue", dv)
  }
  if placeholder is Some(ph) {
    custom_props.set("placeholder", ph)
  }
  common_node(
    "textarea",
    custom_props,
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
    None => @js.Object::new()
  }
  if name is Some(n) {
    custom_props.set("name", n)
  }
  if value is Some(v) {
    custom_props.set("value", v)
  }
  if default_value is Some(dv) {
    custom_props.set("defaultValue", dv)
  }
  if type_ is Some(t) {
    custom_props.set("type", t)
  }
  if placeholder is Some(ph) {
    custom_props.set("placeholder", ph)
  }
  common_node(
    "input",
    custom_props,
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
pub extern "js" fn FormData::get(self : FormData, key : String) -> Js =
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
    None => @js.Object::new()
  }
  if disabled is Some(d) {
    custom_props.set("disabled", d)
  }
  if name is Some(n) {
    custom_props.set("name", n)
  }
  if method_ is Some(m) {
    custom_props.set("method", m)
  }
  if on_submit is Some(f) {
    let fn_value : Js = f |> @js.from_fn1
    custom_props.set("onSubmit", fn_value)
  }
  if action is Some(f) {
    let fn_value : Js = f |> @js.from_fn1
    custom_props.set("action", fn_value)
  }
  if enc_type is Some(e) {
    custom_props.set("encType", e)
  }
  common_node(
    "form",
    custom_props,
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
    None => @js.Object::new()
  }
  if multiple is Some(m) {
    custom_props.set("multiple", m)
  }
  if disabled is Some(d) {
    custom_props.set("disabled", d)
  }
  if name is Some(n) {
    custom_props.set("name", n)
  }
  common_node(
    "select",
    custom_props,
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
    None => @js.Object::new()
  }
  custom_props.set("value", value)
  if selected is Some(s) {
    custom_props.set("selected", s)
  }
  common_node(
    "option",
    custom_props,
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
    None => @js.Object::new()
  }
  custom_props.set("htmlFor", htmlFor)
  common_node(
    "label",
    custom_props,
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
    None => @js.Object::new()
  }
  custom_props.set("href", href)
  if download is Some(d) {
    custom_props.set("download", d)
  }
  if target is Some(t) {
    custom_props.set("target", t)
  }
  common_node(
    "a",
    custom_props,
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
    None => @js.Object::new()
  }
  custom_props.set("src", src)
  if width is Some(d) {
    custom_props.set("width", d)
  }
  if height is Some(d) {
    custom_props.set("height", d)
  }
  if frameborder is Some(d) {
    custom_props.set("frameborder", d)
  }
  if sandbox is Some(d) {
    custom_props.set("sandbox", d)
  }
  if allowfullscreen is Some(d) {
    custom_props.set("allowfullscreen", d)
  }
  if loading is Some(d) {
    custom_props.set("loading", d)
  }
  common_node(
    "iframe",
    custom_props,
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
    None => @js.Object::new()
  }
  custom_props.set("src", src)
  if alt is Some(d) {
    custom_props.set("alt", d)
  }
  if crossorigin is Some(d) {
    custom_props.set("crossorigin", d)
  }
  if decoding is Some(d) {
    custom_props.set("decoding", d)
  }
  if width is Some(d) {
    custom_props.set("width", d)
  }
  if height is Some(d) {
    custom_props.set("height", d)
  }
  if fetchpriority is Some(d) {
    custom_props.set("fetchpriority", d)
  }
  if loading is Some(d) {
    custom_props.set("loading", d)
  }
  if sizes is Some(d) {
    custom_props.set("sizes", d)
  }
  if srcset is Some(d) {
    custom_props.set("srcset", d)
  }
  common_node(
    "img",
    custom_props,
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
    None => @js.Object::new()
  }
  if controls is Some(c) {
    custom_props.set("controls", c |> @js.unsafe_js)
  }
  common_node(
    "video",
    custom_props,
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
    None => @js.Object::new()
  }
  custom_props.set("src", src |> @js.unsafe_js)
  if type_ is Some(t) {
    custom_props.set("type", t |> @js.unsafe_js)
  }
  common_node(
    "video",
    custom_props,
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
pub fn h4(
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
pub fn h5(
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
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
    match props {
      Some(p) => p
      None => @js.Object::new()
    },
    id~,
    class~,
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
  props? : @js.Object,
  id? : String,
  class? : String,
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
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
    None => @js.Object::new()
  }
  if type_ is Some(t) {
    custom_props.set("type", t)
  }
  if disabled is Some(d) {
    custom_props.set("disabled", d)
  }
  common_node(
    "button",
    custom_props,
    id~,
    class~,
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
