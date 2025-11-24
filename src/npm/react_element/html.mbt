///|

///|
fn[T] common_node(
  tag_name : String,
  props : @js.Object,
  children~ : Array[&@react.ReactNode],
  id~ : String?,
  class~ : String?,
  style~ : Map[String, String]?,
  tab_index~ : Int?,
  ref_~ : @react.ReactRef[T]?,
  key~ : String?,
  on_click~ : @react.MouseEventHandler[T]?,
  on_change~ : @react.ChangeEventHandler[T]?,
  on_keydown~ : @react.KeyboardEventHandler[T]?,
  on_keyup~ : @react.KeyboardEventHandler[T]?,
  on_focus~ : @react.FocusEventHandler[T]?,
  on_blur~ : @react.FocusEventHandler[T]?,
  on_drag~ : @react.DragEventHandler[T]?,
  on_dragstart~ : @react.DragEventHandler[T]?,
  on_dragend~ : @react.DragEventHandler[T]?,
  on_dragleave~ : @react.DragEventHandler[T]?,
  on_dragenter~ : @react.DragEventHandler[T]?,
  on_dragover~ : @react.DragEventHandler[T]?,
  on_drop~ : @react.DragEventHandler[T]?,
) -> @react.Element {
  if id is Some(id) {
    props.set("id", id)
  }
  if class is Some(class) {
    props.set("className", class)
  }
  if tab_index is Some(tab_index) {
    props.set("tabIndex", tab_index)
  }
  if style is Some(style) {
    let style_obj = @js.Object::new()
    for k, v in style {
      style_obj.set(k, v)
    }
    props.set("style", style_obj.to_any())
  }
  if ref_ is Some(ref_) {
    props.set("ref", ref_ |> @js.any)
  }
  if key is Some(key) {
    props.set("key", key)
  }
  if on_click is Some(f) {
    props.set("onClick", f |> @js.from_fn1)
  }
  if on_change is Some(f) {
    props.set("onChange", f |> @js.from_fn1)
  }
  if on_keydown is Some(f) {
    props.set("onKeyDown", f |> @js.from_fn1)
  }
  if on_keyup is Some(f) {
    props.set("onKeyUp", f |> @js.from_fn1)
  }
  if on_focus is Some(f) {
    props.set("onFocus", f |> @js.from_fn1)
  }
  if on_blur is Some(f) {
    props.set("onBlur", f |> @js.from_fn1)
  }
  // Optimize: avoid array allocation, handle drag handlers directly
  if on_drag is Some(f) {
    props.set("onDrag", f |> @js.from_fn1)
  }
  if on_dragstart is Some(f) {
    props.set("onDragStart", f |> @js.from_fn1)
  }
  if on_dragend is Some(f) {
    props.set("onDragEnd", f |> @js.from_fn1)
  }
  if on_dragleave is Some(f) {
    props.set("onDragLeave", f |> @js.from_fn1)
  }
  if on_dragenter is Some(f) {
    props.set("onDragEnter", f |> @js.from_fn1)
  }
  if on_dragover is Some(f) {
    props.set("onDragOver", f |> @js.from_fn1)
  }
  if on_drop is Some(f) {
    props.set("onDrop", f |> @js.from_fn1)
  }
  let children_js = children.map(_.to_react_node()) |> @js.from_array
  @react.createElementDirect(tag_name, props.to_any(), children_js)
}

///|
pub fn div(
  // common props
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : @react.ReactRef[@dom.HTMLDivElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLDivElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLDivElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLDivElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLDivElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLDivElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLDivElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLDivElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLDivElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLDivElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLDivElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLDivElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLDivElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLDivElement],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : @react.ReactRef[@dom.HTMLSpanElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLSpanElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLSpanElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLSpanElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLSpanElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLSpanElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLSpanElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLSpanElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLSpanElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLSpanElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLSpanElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLSpanElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLSpanElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLSpanElement],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : @react.ReactRef[@dom.HTMLParagraphElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLParagraphElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLParagraphElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLParagraphElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLParagraphElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLParagraphElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLParagraphElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLParagraphElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLParagraphElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLParagraphElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLParagraphElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLParagraphElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLParagraphElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLParagraphElement],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
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
  ref_? : @react.ReactRef[@dom.HTMLTextAreaElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLTextAreaElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLTextAreaElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLTextAreaElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLTextAreaElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLTextAreaElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLTextAreaElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLTextAreaElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLTextAreaElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLTextAreaElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLTextAreaElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLTextAreaElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLTextAreaElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLTextAreaElement],
) -> @react.Element {
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p).cast()
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
    on_focus~,
    on_blur~,
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
  ref_? : @react.ReactRef[@dom.HTMLInputElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLInputElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLInputElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLInputElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLInputElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLInputElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLInputElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLInputElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLInputElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLInputElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLInputElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLInputElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLInputElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLInputElement],
) -> @react.Element {
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p).cast()
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.HTMLUListElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLUListElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLUListElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLUListElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLUListElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLUListElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLUListElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLUListElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLUListElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLUListElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLUListElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLUListElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLUListElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLUListElement],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.HTMLOListElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLOListElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLOListElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLOListElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLOListElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLOListElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLOListElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLOListElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLOListElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLOListElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLOListElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLOListElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLOListElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLOListElement],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
pub fn form(
  children : Array[&@react.ReactNode],

  // xxx
  method_? : String,
  disabled? : Bool,
  name? : String,
  enc_type? : String,
  action? : (@http.FormData) -> Unit,
  on_submit? : (@dom.FormEvent) -> Unit,
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.HTMLFormElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLFormElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLFormElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLFormElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLFormElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLFormElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLFormElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLFormElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLFormElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLFormElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLFormElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLFormElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLFormElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLFormElement],
) -> @react.Element {
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p).cast()
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
    let fn_value : @js.Any = f |> @js.from_fn1
    custom_props.set("onSubmit", fn_value)
  }
  if action is Some(f) {
    let fn_value : @js.Any = f |> @js.from_fn1
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
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
  ref_? : @react.ReactRef[@dom.HTMLSelectElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLSelectElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLSelectElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLSelectElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLSelectElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLSelectElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLSelectElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLSelectElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLSelectElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLSelectElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLSelectElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLSelectElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLSelectElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLSelectElement],
) -> @react.Element {
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p).cast()
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  value~ : String,
  selected? : Bool,
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.HTMLOptionElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLOptionElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLOptionElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLOptionElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLOptionElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLOptionElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLOptionElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLOptionElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLOptionElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLOptionElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLOptionElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLOptionElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLOptionElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLOptionElement],
) -> @react.Element {
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p).cast()
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  htmlFor : String,
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.HTMLLabelElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLLabelElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLLabelElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLLabelElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLLabelElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLLabelElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLLabelElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLLabelElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLLabelElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLLabelElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLLabelElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLLabelElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLLabelElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLLabelElement],
) -> @react.Element {
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p).cast()
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.HTMLLIElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLLIElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLLIElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLLIElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLLIElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLLIElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLLIElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLLIElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLLIElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLLIElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLLIElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLLIElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLLIElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLLIElement],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],

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
  ref_? : @react.ReactRef[@dom.HTMLAnchorElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLAnchorElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLAnchorElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLAnchorElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLAnchorElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLAnchorElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLAnchorElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLAnchorElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLAnchorElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLAnchorElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLAnchorElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLAnchorElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLAnchorElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLAnchorElement],
) -> @react.Element {
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p).cast()
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],

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
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
) -> @react.Element {
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p).cast()
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],

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
  ref_? : @react.ReactRef[@dom.HTMLImageElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLImageElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLImageElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLImageElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLImageElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLImageElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLImageElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLImageElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLImageElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLImageElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLImageElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLImageElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLImageElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLImageElement],
) -> @react.Element {
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p).cast()
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],

  // a specific
  controls? : Bool,

  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
) -> @react.Element {
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p).cast()
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
    on_focus~,
    on_blur~,
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
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
) -> @react.Element {
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p).cast()
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
    on_focus~,
    on_blur~,
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
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_change? : @react.ChangeEventHandler[@dom.Element],
  on_keydown? : @react.KeyboardEventHandler[@dom.Element],
  on_keyup? : @react.KeyboardEventHandler[@dom.Element],
  on_focus? : @react.FocusEventHandler[@dom.Element],
  on_blur? : @react.FocusEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.HTMLHeadingElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLHeadingElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLHeadingElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLHeadingElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLHeadingElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLHeadingElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLHeadingElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLHeadingElement],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.HTMLHeadingElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLHeadingElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLHeadingElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLHeadingElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLHeadingElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLHeadingElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLHeadingElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLHeadingElement],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.HTMLHeadingElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLHeadingElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLHeadingElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLHeadingElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLHeadingElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLHeadingElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLHeadingElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLHeadingElement],
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.HTMLHeadingElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLHeadingElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLHeadingElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLHeadingElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLHeadingElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLHeadingElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLHeadingElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLHeadingElement],
) -> @react.Element {
  common_node(
    "h4",
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : @react.ReactRef[@dom.HTMLHeadingElement],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.HTMLHeadingElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLHeadingElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLHeadingElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLHeadingElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLHeadingElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLHeadingElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLHeadingElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLHeadingElement],
) -> @react.Element {
  common_node(
    "h5",
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
    on_focus~,
    on_blur~,
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
  children : Array[&@react.ReactNode],
  type_? : String,
  disabled? : Bool,
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  ref_? : @react.ReactRef[@dom.HTMLButtonElement],
  key? : String,
  on_click? : @react.MouseEventHandler[@dom.HTMLButtonElement],
  on_change? : @react.ChangeEventHandler[@dom.HTMLButtonElement],
  on_keydown? : @react.KeyboardEventHandler[@dom.HTMLButtonElement],
  on_keyup? : @react.KeyboardEventHandler[@dom.HTMLButtonElement],
  on_focus? : @react.FocusEventHandler[@dom.HTMLButtonElement],
  on_blur? : @react.FocusEventHandler[@dom.HTMLButtonElement],
  on_drag? : @react.DragEventHandler[@dom.HTMLButtonElement],
  on_dragstart? : @react.DragEventHandler[@dom.HTMLButtonElement],
  on_dragend? : @react.DragEventHandler[@dom.HTMLButtonElement],
  on_dragleave? : @react.DragEventHandler[@dom.HTMLButtonElement],
  on_dragenter? : @react.DragEventHandler[@dom.HTMLButtonElement],
  on_dragover? : @react.DragEventHandler[@dom.HTMLButtonElement],
  on_drop? : @react.DragEventHandler[@dom.HTMLButtonElement],
) -> @react.Element {
  let custom_props : @js.Object = match props {
    Some(p) => @js.Object::assign(@js.Object::new(), p).cast()
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
    on_focus~,
    on_blur~,
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
