using @http { type FormData }

///|
fn[T] common_node(
  tag_name : String,
  props : @js.Object,
  children~ : Array[&ReactNode],
  id~ : String?,
  class~ : String?,
  style~ : Map[String, String]?,
  tab_index~ : Int?,
  ref_~ : ReactRef[T]?,
  key~ : String?,
  on_click~ : MouseEventHandler[T]?,
  on_change~ : ChangeEventHandler[T]?,
  on_keydown~ : KeyboardEventHandler[T]?,
  on_keyup~ : KeyboardEventHandler[T]?,
  on_focus~ : FocusEventHandler[T]?,
  on_blur~ : FocusEventHandler[T]?,
  on_drag~ : DragEventHandler[T]?,
  on_dragstart~ : DragEventHandler[T]?,
  on_dragend~ : DragEventHandler[T]?,
  on_dragleave~ : DragEventHandler[T]?,
  on_dragenter~ : DragEventHandler[T]?,
  on_dragover~ : DragEventHandler[T]?,
  on_drop~ : DragEventHandler[T]?,
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
    props.set("style", style_obj.to_js())
  }
  if ref_ is Some(ref_) {
    props.set("ref", ref_ |> js)
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
  @react.createElementDirect(tag_name, props.to_js(), children_js)
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
  ref_? : ReactRef[HTMLDivElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLDivElement],
  on_change? : ChangeEventHandler[HTMLDivElement],
  on_keydown? : KeyboardEventHandler[HTMLDivElement],
  on_keyup? : KeyboardEventHandler[HTMLDivElement],
  on_focus? : FocusEventHandler[HTMLDivElement],
  on_blur? : FocusEventHandler[HTMLDivElement],
  on_drag? : DragEventHandler[HTMLDivElement],
  on_dragstart? : DragEventHandler[HTMLDivElement],
  on_dragend? : DragEventHandler[HTMLDivElement],
  on_dragleave? : DragEventHandler[HTMLDivElement],
  on_dragenter? : DragEventHandler[HTMLDivElement],
  on_dragover? : DragEventHandler[HTMLDivElement],
  on_drop? : DragEventHandler[HTMLDivElement],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[HTMLSpanElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLSpanElement],
  on_change? : ChangeEventHandler[HTMLSpanElement],
  on_keydown? : KeyboardEventHandler[HTMLSpanElement],
  on_keyup? : KeyboardEventHandler[HTMLSpanElement],
  on_focus? : FocusEventHandler[HTMLSpanElement],
  on_blur? : FocusEventHandler[HTMLSpanElement],
  on_drag? : DragEventHandler[HTMLSpanElement],
  on_dragstart? : DragEventHandler[HTMLSpanElement],
  on_dragend? : DragEventHandler[HTMLSpanElement],
  on_dragleave? : DragEventHandler[HTMLSpanElement],
  on_dragenter? : DragEventHandler[HTMLSpanElement],
  on_dragover? : DragEventHandler[HTMLSpanElement],
  on_drop? : DragEventHandler[HTMLSpanElement],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[HTMLParagraphElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLParagraphElement],
  on_change? : ChangeEventHandler[HTMLParagraphElement],
  on_keydown? : KeyboardEventHandler[HTMLParagraphElement],
  on_keyup? : KeyboardEventHandler[HTMLParagraphElement],
  on_focus? : FocusEventHandler[HTMLParagraphElement],
  on_blur? : FocusEventHandler[HTMLParagraphElement],
  on_drag? : DragEventHandler[HTMLParagraphElement],
  on_dragstart? : DragEventHandler[HTMLParagraphElement],
  on_dragend? : DragEventHandler[HTMLParagraphElement],
  on_dragleave? : DragEventHandler[HTMLParagraphElement],
  on_dragenter? : DragEventHandler[HTMLParagraphElement],
  on_dragover? : DragEventHandler[HTMLParagraphElement],
  on_drop? : DragEventHandler[HTMLParagraphElement],
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
  ref_? : ReactRef[HTMLTextAreaElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLTextAreaElement],
  on_change? : ChangeEventHandler[HTMLTextAreaElement],
  on_keydown? : KeyboardEventHandler[HTMLTextAreaElement],
  on_keyup? : KeyboardEventHandler[HTMLTextAreaElement],
  on_focus? : FocusEventHandler[HTMLTextAreaElement],
  on_blur? : FocusEventHandler[HTMLTextAreaElement],
  on_drag? : DragEventHandler[HTMLTextAreaElement],
  on_dragstart? : DragEventHandler[HTMLTextAreaElement],
  on_dragend? : DragEventHandler[HTMLTextAreaElement],
  on_dragleave? : DragEventHandler[HTMLTextAreaElement],
  on_dragenter? : DragEventHandler[HTMLTextAreaElement],
  on_dragover? : DragEventHandler[HTMLTextAreaElement],
  on_drop? : DragEventHandler[HTMLTextAreaElement],
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
  ref_? : ReactRef[HTMLInputElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLInputElement],
  on_change? : ChangeEventHandler[HTMLInputElement],
  on_keydown? : KeyboardEventHandler[HTMLInputElement],
  on_keyup? : KeyboardEventHandler[HTMLInputElement],
  on_focus? : FocusEventHandler[HTMLInputElement],
  on_blur? : FocusEventHandler[HTMLInputElement],
  on_drag? : DragEventHandler[HTMLInputElement],
  on_dragstart? : DragEventHandler[HTMLInputElement],
  on_dragend? : DragEventHandler[HTMLInputElement],
  on_dragleave? : DragEventHandler[HTMLInputElement],
  on_dragenter? : DragEventHandler[HTMLInputElement],
  on_dragover? : DragEventHandler[HTMLInputElement],
  on_drop? : DragEventHandler[HTMLInputElement],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[HTMLUListElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLUListElement],
  on_change? : ChangeEventHandler[HTMLUListElement],
  on_keydown? : KeyboardEventHandler[HTMLUListElement],
  on_keyup? : KeyboardEventHandler[HTMLUListElement],
  on_focus? : FocusEventHandler[HTMLUListElement],
  on_blur? : FocusEventHandler[HTMLUListElement],
  on_drag? : DragEventHandler[HTMLUListElement],
  on_dragstart? : DragEventHandler[HTMLUListElement],
  on_dragend? : DragEventHandler[HTMLUListElement],
  on_dragleave? : DragEventHandler[HTMLUListElement],
  on_dragenter? : DragEventHandler[HTMLUListElement],
  on_dragover? : DragEventHandler[HTMLUListElement],
  on_drop? : DragEventHandler[HTMLUListElement],
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
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[HTMLOListElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLOListElement],
  on_change? : ChangeEventHandler[HTMLOListElement],
  on_keydown? : KeyboardEventHandler[HTMLOListElement],
  on_keyup? : KeyboardEventHandler[HTMLOListElement],
  on_focus? : FocusEventHandler[HTMLOListElement],
  on_blur? : FocusEventHandler[HTMLOListElement],
  on_drag? : DragEventHandler[HTMLOListElement],
  on_dragstart? : DragEventHandler[HTMLOListElement],
  on_dragend? : DragEventHandler[HTMLOListElement],
  on_dragleave? : DragEventHandler[HTMLOListElement],
  on_dragenter? : DragEventHandler[HTMLOListElement],
  on_dragover? : DragEventHandler[HTMLOListElement],
  on_drop? : DragEventHandler[HTMLOListElement],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  ref_? : ReactRef[HTMLFormElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLFormElement],
  on_change? : ChangeEventHandler[HTMLFormElement],
  on_keydown? : KeyboardEventHandler[HTMLFormElement],
  on_keyup? : KeyboardEventHandler[HTMLFormElement],
  on_focus? : FocusEventHandler[HTMLFormElement],
  on_blur? : FocusEventHandler[HTMLFormElement],
  on_drag? : DragEventHandler[HTMLFormElement],
  on_dragstart? : DragEventHandler[HTMLFormElement],
  on_dragend? : DragEventHandler[HTMLFormElement],
  on_dragleave? : DragEventHandler[HTMLFormElement],
  on_dragenter? : DragEventHandler[HTMLFormElement],
  on_dragover? : DragEventHandler[HTMLFormElement],
  on_drop? : DragEventHandler[HTMLFormElement],
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
  ref_? : ReactRef[HTMLSelectElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLSelectElement],
  on_change? : ChangeEventHandler[HTMLSelectElement],
  on_keydown? : KeyboardEventHandler[HTMLSelectElement],
  on_keyup? : KeyboardEventHandler[HTMLSelectElement],
  on_focus? : FocusEventHandler[HTMLSelectElement],
  on_blur? : FocusEventHandler[HTMLSelectElement],
  on_drag? : DragEventHandler[HTMLSelectElement],
  on_dragstart? : DragEventHandler[HTMLSelectElement],
  on_dragend? : DragEventHandler[HTMLSelectElement],
  on_dragleave? : DragEventHandler[HTMLSelectElement],
  on_dragenter? : DragEventHandler[HTMLSelectElement],
  on_dragover? : DragEventHandler[HTMLSelectElement],
  on_drop? : DragEventHandler[HTMLSelectElement],
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
  ref_? : ReactRef[HTMLOptionElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLOptionElement],
  on_change? : ChangeEventHandler[HTMLOptionElement],
  on_keydown? : KeyboardEventHandler[HTMLOptionElement],
  on_keyup? : KeyboardEventHandler[HTMLOptionElement],
  on_focus? : FocusEventHandler[HTMLOptionElement],
  on_blur? : FocusEventHandler[HTMLOptionElement],
  on_drag? : DragEventHandler[HTMLOptionElement],
  on_dragstart? : DragEventHandler[HTMLOptionElement],
  on_dragend? : DragEventHandler[HTMLOptionElement],
  on_dragleave? : DragEventHandler[HTMLOptionElement],
  on_dragenter? : DragEventHandler[HTMLOptionElement],
  on_dragover? : DragEventHandler[HTMLOptionElement],
  on_drop? : DragEventHandler[HTMLOptionElement],
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
  children : Array[&ReactNode],
  htmlFor : String,
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[HTMLLabelElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLLabelElement],
  on_change? : ChangeEventHandler[HTMLLabelElement],
  on_keydown? : KeyboardEventHandler[HTMLLabelElement],
  on_keyup? : KeyboardEventHandler[HTMLLabelElement],
  on_focus? : FocusEventHandler[HTMLLabelElement],
  on_blur? : FocusEventHandler[HTMLLabelElement],
  on_drag? : DragEventHandler[HTMLLabelElement],
  on_dragstart? : DragEventHandler[HTMLLabelElement],
  on_dragend? : DragEventHandler[HTMLLabelElement],
  on_dragleave? : DragEventHandler[HTMLLabelElement],
  on_dragenter? : DragEventHandler[HTMLLabelElement],
  on_dragover? : DragEventHandler[HTMLLabelElement],
  on_drop? : DragEventHandler[HTMLLabelElement],
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
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[HTMLLIElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLLIElement],
  on_change? : ChangeEventHandler[HTMLLIElement],
  on_keydown? : KeyboardEventHandler[HTMLLIElement],
  on_keyup? : KeyboardEventHandler[HTMLLIElement],
  on_focus? : FocusEventHandler[HTMLLIElement],
  on_blur? : FocusEventHandler[HTMLLIElement],
  on_drag? : DragEventHandler[HTMLLIElement],
  on_dragstart? : DragEventHandler[HTMLLIElement],
  on_dragend? : DragEventHandler[HTMLLIElement],
  on_dragleave? : DragEventHandler[HTMLLIElement],
  on_dragenter? : DragEventHandler[HTMLLIElement],
  on_dragover? : DragEventHandler[HTMLLIElement],
  on_drop? : DragEventHandler[HTMLLIElement],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  ref_? : ReactRef[HTMLAnchorElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLAnchorElement],
  on_change? : ChangeEventHandler[HTMLAnchorElement],
  on_keydown? : KeyboardEventHandler[HTMLAnchorElement],
  on_keyup? : KeyboardEventHandler[HTMLAnchorElement],
  on_focus? : FocusEventHandler[HTMLAnchorElement],
  on_blur? : FocusEventHandler[HTMLAnchorElement],
  on_drag? : DragEventHandler[HTMLAnchorElement],
  on_dragstart? : DragEventHandler[HTMLAnchorElement],
  on_dragend? : DragEventHandler[HTMLAnchorElement],
  on_dragleave? : DragEventHandler[HTMLAnchorElement],
  on_dragenter? : DragEventHandler[HTMLAnchorElement],
  on_dragover? : DragEventHandler[HTMLAnchorElement],
  on_drop? : DragEventHandler[HTMLAnchorElement],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  ref_? : ReactRef[HTMLImageElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLImageElement],
  on_change? : ChangeEventHandler[HTMLImageElement],
  on_keydown? : KeyboardEventHandler[HTMLImageElement],
  on_keyup? : KeyboardEventHandler[HTMLImageElement],
  on_focus? : FocusEventHandler[HTMLImageElement],
  on_blur? : FocusEventHandler[HTMLImageElement],
  on_drag? : DragEventHandler[HTMLImageElement],
  on_dragstart? : DragEventHandler[HTMLImageElement],
  on_dragend? : DragEventHandler[HTMLImageElement],
  on_dragleave? : DragEventHandler[HTMLImageElement],
  on_dragenter? : DragEventHandler[HTMLImageElement],
  on_dragover? : DragEventHandler[HTMLImageElement],
  on_drop? : DragEventHandler[HTMLImageElement],
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
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[@dom.Element],
  on_change? : ChangeEventHandler[@dom.Element],
  on_keydown? : KeyboardEventHandler[@dom.Element],
  on_keyup? : KeyboardEventHandler[@dom.Element],
  on_focus? : FocusEventHandler[@dom.Element],
  on_blur? : FocusEventHandler[@dom.Element],
  on_drag? : DragEventHandler[@dom.Element],
  on_dragstart? : DragEventHandler[@dom.Element],
  on_dragend? : DragEventHandler[@dom.Element],
  on_dragleave? : DragEventHandler[@dom.Element],
  on_dragenter? : DragEventHandler[@dom.Element],
  on_dragover? : DragEventHandler[@dom.Element],
  on_drop? : DragEventHandler[@dom.Element],
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
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[HTMLHeadingElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLHeadingElement],
  on_change? : ChangeEventHandler[HTMLHeadingElement],
  on_keydown? : KeyboardEventHandler[HTMLHeadingElement],
  on_keyup? : KeyboardEventHandler[HTMLHeadingElement],
  on_focus? : FocusEventHandler[HTMLHeadingElement],
  on_blur? : FocusEventHandler[HTMLHeadingElement],
  on_drag? : DragEventHandler[HTMLHeadingElement],
  on_dragstart? : DragEventHandler[HTMLHeadingElement],
  on_dragend? : DragEventHandler[HTMLHeadingElement],
  on_dragleave? : DragEventHandler[HTMLHeadingElement],
  on_dragenter? : DragEventHandler[HTMLHeadingElement],
  on_dragover? : DragEventHandler[HTMLHeadingElement],
  on_drop? : DragEventHandler[HTMLHeadingElement],
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
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[HTMLHeadingElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLHeadingElement],
  on_change? : ChangeEventHandler[HTMLHeadingElement],
  on_keydown? : KeyboardEventHandler[HTMLHeadingElement],
  on_keyup? : KeyboardEventHandler[HTMLHeadingElement],
  on_focus? : FocusEventHandler[HTMLHeadingElement],
  on_blur? : FocusEventHandler[HTMLHeadingElement],
  on_drag? : DragEventHandler[HTMLHeadingElement],
  on_dragstart? : DragEventHandler[HTMLHeadingElement],
  on_dragend? : DragEventHandler[HTMLHeadingElement],
  on_dragleave? : DragEventHandler[HTMLHeadingElement],
  on_dragenter? : DragEventHandler[HTMLHeadingElement],
  on_dragover? : DragEventHandler[HTMLHeadingElement],
  on_drop? : DragEventHandler[HTMLHeadingElement],
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
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[HTMLHeadingElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLHeadingElement],
  on_change? : ChangeEventHandler[HTMLHeadingElement],
  on_keydown? : KeyboardEventHandler[HTMLHeadingElement],
  on_keyup? : KeyboardEventHandler[HTMLHeadingElement],
  on_focus? : FocusEventHandler[HTMLHeadingElement],
  on_blur? : FocusEventHandler[HTMLHeadingElement],
  on_drag? : DragEventHandler[HTMLHeadingElement],
  on_dragstart? : DragEventHandler[HTMLHeadingElement],
  on_dragend? : DragEventHandler[HTMLHeadingElement],
  on_dragleave? : DragEventHandler[HTMLHeadingElement],
  on_dragenter? : DragEventHandler[HTMLHeadingElement],
  on_dragover? : DragEventHandler[HTMLHeadingElement],
  on_drop? : DragEventHandler[HTMLHeadingElement],
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
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[HTMLHeadingElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLHeadingElement],
  on_change? : ChangeEventHandler[HTMLHeadingElement],
  on_keydown? : KeyboardEventHandler[HTMLHeadingElement],
  on_keyup? : KeyboardEventHandler[HTMLHeadingElement],
  on_focus? : FocusEventHandler[HTMLHeadingElement],
  on_blur? : FocusEventHandler[HTMLHeadingElement],
  on_drag? : DragEventHandler[HTMLHeadingElement],
  on_dragstart? : DragEventHandler[HTMLHeadingElement],
  on_dragend? : DragEventHandler[HTMLHeadingElement],
  on_dragleave? : DragEventHandler[HTMLHeadingElement],
  on_dragenter? : DragEventHandler[HTMLHeadingElement],
  on_dragover? : DragEventHandler[HTMLHeadingElement],
  on_drop? : DragEventHandler[HTMLHeadingElement],
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
  children : Array[&ReactNode],
  // shared
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,

  // react
  ref_? : ReactRef[HTMLHeadingElement],
  key? : String,
  // event handlers
  on_click? : MouseEventHandler[HTMLHeadingElement],
  on_change? : ChangeEventHandler[HTMLHeadingElement],
  on_keydown? : KeyboardEventHandler[HTMLHeadingElement],
  on_keyup? : KeyboardEventHandler[HTMLHeadingElement],
  on_focus? : FocusEventHandler[HTMLHeadingElement],
  on_blur? : FocusEventHandler[HTMLHeadingElement],
  on_drag? : DragEventHandler[HTMLHeadingElement],
  on_dragstart? : DragEventHandler[HTMLHeadingElement],
  on_dragend? : DragEventHandler[HTMLHeadingElement],
  on_dragleave? : DragEventHandler[HTMLHeadingElement],
  on_dragenter? : DragEventHandler[HTMLHeadingElement],
  on_dragover? : DragEventHandler[HTMLHeadingElement],
  on_drop? : DragEventHandler[HTMLHeadingElement],
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
  children : Array[&ReactNode],
  type_? : String,
  disabled? : Bool,
  props? : @js.Object,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  ref_? : ReactRef[HTMLButtonElement],
  key? : String,
  on_click? : MouseEventHandler[HTMLButtonElement],
  on_change? : ChangeEventHandler[HTMLButtonElement],
  on_keydown? : KeyboardEventHandler[HTMLButtonElement],
  on_keyup? : KeyboardEventHandler[HTMLButtonElement],
  on_focus? : FocusEventHandler[HTMLButtonElement],
  on_blur? : FocusEventHandler[HTMLButtonElement],
  on_drag? : DragEventHandler[HTMLButtonElement],
  on_dragstart? : DragEventHandler[HTMLButtonElement],
  on_dragend? : DragEventHandler[HTMLButtonElement],
  on_dragleave? : DragEventHandler[HTMLButtonElement],
  on_dragenter? : DragEventHandler[HTMLButtonElement],
  on_dragover? : DragEventHandler[HTMLButtonElement],
  on_drop? : DragEventHandler[HTMLButtonElement],
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
