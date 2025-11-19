///|
pub fn svg(
  // common props
  children : Array[&ReactNode],
  width~ : Int,
  height~ : Int,
  view_box? : String,
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
  // Optimize: avoid Object.assign when props is provided but reuse if empty
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("width", width)
  attrs.set("height", height)
  if view_box is Some(view_box) {
    attrs.set("viewBox", view_box)
  }
  common_node(
    "svg",
    attrs,
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
pub fn circle(
  // common props
  cx~ : Int,
  cy~ : Int,
  r~ : Int,
  stroke? : String,
  stroke_width? : Int,
  fill? : String,

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
  on_drag? : DragEventHandler,
  on_dragstart? : DragEventHandler,
  on_dragend? : DragEventHandler,
  on_dragleave? : DragEventHandler,
  on_dragenter? : DragEventHandler,
  on_dragover? : DragEventHandler,
  on_drop? : DragEventHandler,
) -> @react.Element {
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("cx", cx)
  attrs.set("cy", cy)
  attrs.set("r", r)
  if stroke is Some(stroke) {
    attrs.set("stroke", stroke)
  }
  if stroke_width is Some(stroke_width) {
    attrs.set("strokeWidth", stroke_width)
  }
  if fill is Some(fill) {
    attrs.set("fill", fill)
  }
  common_node(
    "circle",
    attrs,
    id~,
    class~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change=None,
    on_keydown=None,
    on_keyup=None,
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
pub fn ellipse(
  // common props
  cx~ : Int,
  cy~ : Int,
  rx~ : Int,
  ry~ : Int,
  stroke? : String,
  stroke_width? : Int,
  fill? : String,

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
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("cx", cx)
  attrs.set("cy", cy)
  attrs.set("rx", rx)
  attrs.set("ry", ry)
  if stroke is Some(stroke) {
    attrs.set("stroke", stroke)
  }
  if stroke_width is Some(stroke_width) {
    attrs.set("strokeWidth", stroke_width)
  }
  if fill is Some(fill) {
    attrs.set("fill", fill)
  }
  common_node(
    "circle",
    attrs,
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
pub fn rect(
  // common props
  x~ : Int,
  y~ : Int,
  width~ : Int,
  height~ : Int,
  stroke? : String,
  stroke_width? : Int,
  fill? : String,

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
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("x", x)
  attrs.set("y", y)
  attrs.set("width", width)
  attrs.set("height", height)
  if stroke is Some(stroke) {
    attrs.set("stroke", stroke)
  }
  if stroke_width is Some(stroke_width) {
    attrs.set("strokeWidth", stroke_width)
  }
  if fill is Some(fill) {
    attrs.set("fill", fill)
  }
  common_node(
    "rect",
    attrs,
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
pub fn line(
  // common props
  x1~ : Int,
  y1~ : Int,
  x2~ : Int,
  y2~ : Int,
  stroke? : String,
  stroke_width? : Int,
  fill? : String,

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
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("x1", x1)
  attrs.set("y1", y1)
  attrs.set("x2", x2)
  attrs.set("y2", y2)
  if stroke is Some(stroke) {
    attrs.set("stroke", stroke)
  }
  if stroke_width is Some(stroke_width) {
    attrs.set("strokeWidth", stroke_width)
  }
  if fill is Some(fill) {
    attrs.set("fill", fill)
  }
  common_node(
    "line",
    attrs,
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
pub fn path(
  // common props
  d~ : String,
  stroke? : String,
  stroke_width? : Int,
  fill? : String,

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
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("d", d)
  if stroke is Some(stroke) {
    attrs.set("stroke", stroke)
  }
  if stroke_width is Some(stroke_width) {
    attrs.set("strokeWidth", stroke_width)
  }
  if fill is Some(fill) {
    attrs.set("fill", fill)
  }
  common_node(
    "path",
    attrs,
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
pub fn use_(
  // common props
  href~ : String,

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
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("href", href)
  common_node(
    "use",
    attrs,
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
pub fn polygon(
  // common props
  points~ : Array[(Int, Int)],
  stroke? : String,
  stroke_width? : Int,
  fill? : String,

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
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("points", points |> unsafe_cast)
  if stroke is Some(stroke) {
    attrs.set("stroke", stroke)
  }
  if stroke_width is Some(stroke_width) {
    attrs.set("strokeWidth", stroke_width)
  }
  if fill is Some(fill) {
    attrs.set("fill", fill)
  }
  common_node(
    "points",
    attrs,
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
pub fn polyline(
  // common props
  points~ : Array[(Int, Int)],
  stroke? : String,
  stroke_width? : Int,
  fill? : String,

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
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("points", points |> unsafe_cast)
  if stroke is Some(stroke) {
    attrs.set("stroke", stroke)
  }
  if stroke_width is Some(stroke_width) {
    attrs.set("strokeWidth", stroke_width)
  }
  if fill is Some(fill) {
    attrs.set("fill", fill)
  }
  common_node(
    "polyline",
    attrs,
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
pub fn g(
  children : Array[&ReactNode],
  // common props
  stroke? : String,
  stroke_width? : Int,
  fill? : String,

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
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  if stroke is Some(stroke) {
    attrs.set("stroke", stroke)
  }
  if stroke_width is Some(stroke_width) {
    attrs.set("strokeWidth", stroke_width)
  }
  if fill is Some(fill) {
    attrs.set("fill", fill)
  }
  common_node(
    "g",
    attrs,
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
pub fn defs(
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
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  common_node(
    "defs",
    attrs,
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
pub fn text(
  children : Array[&ReactNode],
  // common props
  x~ : Int,
  y~ : Int,
  dx? : String,
  dy? : String,
  length_adjust? : String,
  text_length? : String,
  rotate? : String,
  stroke? : String,
  stroke_width? : Int,
  fill? : String,

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
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("x", x)
  attrs.set("y", y)
  if dx is Some(dx) {
    attrs.set("dx", dx)
  }
  if dy is Some(dy) {
    attrs.set("dy", dy)
  }
  if length_adjust is Some(length_adjust) {
    attrs.set("lengthAdjust", length_adjust)
  }
  if text_length is Some(text_length) {
    attrs.set("textLength", text_length)
  }
  if stroke is Some(stroke) {
    attrs.set("stroke", stroke)
  }
  if stroke_width is Some(stroke_width) {
    attrs.set("strokeWidth", stroke_width)
  }
  if fill is Some(fill) {
    attrs.set("fill", fill)
  }
  if rotate is Some(rotate) {
    attrs.set("rotate", rotate)
  }
  common_node(
    "text",
    attrs,
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
pub fn image(
  x~ : Int,
  y~ : Int,
  href~ : String,
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
  let attrs : @js.Object = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p) |> unsafe_cast
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("x", x)
  attrs.set("y", y)
  attrs.set("href", href)
  common_node(
    "image",
    attrs,
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
