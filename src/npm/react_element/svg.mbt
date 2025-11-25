///|
pub fn svg(
  // common props
  children : Array[&@react.ReactNode],
  width~ : Double,
  height~ : Double,
  view_box? : String,
  // shared
  props? : @js.Any,
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
  // Optimize: avoid Object.assign when props is provided but reuse if empty
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
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
pub fn circle(
  // common props
  cx~ : Double,
  cy~ : Double,
  r~ : Double,
  stroke? : String,
  stroke_width? : Double,
  fill? : String,

  // shared
  props? : @js.Any,
  id? : String,
  class? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : @react.ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : @react.MouseEventHandler[@dom.Element],
  on_drag? : @react.DragEventHandler[@dom.Element],
  on_dragstart? : @react.DragEventHandler[@dom.Element],
  on_dragend? : @react.DragEventHandler[@dom.Element],
  on_dragleave? : @react.DragEventHandler[@dom.Element],
  on_dragenter? : @react.DragEventHandler[@dom.Element],
  on_dragover? : @react.DragEventHandler[@dom.Element],
  on_drop? : @react.DragEventHandler[@dom.Element],
) -> @react.Element {
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
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
    on_focus=None,
    on_blur=None,
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
  cx~ : Double,
  cy~ : Double,
  rx~ : Double,
  ry~ : Double,
  stroke? : String,
  stroke_width? : Double,
  fill? : String,

  // shared
  props? : @js.Any,
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
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
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
pub fn rect(
  // common props
  x~ : Double,
  y~ : Double,
  width~ : Double,
  height~ : Double,
  stroke? : String,
  stroke_width? : Double,
  fill? : String,

  // shared
  props? : @js.Any,
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
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
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
pub fn line(
  // common props
  x1~ : Double,
  y1~ : Double,
  x2~ : Double,
  y2~ : Double,
  stroke? : String,
  stroke_width? : Double,
  fill? : String,

  // shared
  props? : @js.Any,
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
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
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
pub fn path(
  // common props
  d~ : String,
  stroke? : String,
  stroke_width? : Double,
  fill? : String,

  // shared
  props? : @js.Any,
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
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
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
pub fn use_(
  // common props
  href~ : String,

  // shared
  props? : @js.Any,
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
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
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
pub fn polygon(
  // common props
  points~ : Array[(Double, Double)],
  stroke? : String,
  stroke_width? : Double,
  fill? : String,

  // shared
  props? : @js.Any,
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
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("points", points |> @js.identity)
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
pub fn polyline(
  // common props
  points~ : Array[(Double, Double)],
  stroke? : String,
  stroke_width? : Double,
  fill? : String,

  // shared
  props? : @js.Any,
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
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
      } else {
        p
      }
    None => @js.Object::new()
  }
  attrs.set("points", points |> @js.identity)
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
pub fn g(
  children : Array[&@react.ReactNode],
  // common props
  stroke? : String,
  stroke_width? : Double,
  fill? : String,

  // shared
  props? : @js.Any,
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
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
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
pub fn defs(
  children : Array[&@react.ReactNode],
  // shared
  props? : @js.Any,
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
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
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
pub fn text(
  children : Array[&@react.ReactNode],
  // common props
  x~ : Double,
  y~ : Double,
  dx? : String,
  dy? : String,
  length_adjust? : String,
  text_length? : String,
  rotate? : String,
  stroke? : String,
  stroke_width? : Double,
  fill? : String,

  // shared
  props? : @js.Any,
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
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
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
pub fn image(
  x~ : Double,
  y~ : Double,
  href~ : String,
  // shared
  props? : @js.Any,
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
  let attrs = match props {
    Some(p) =>
      if @js.Object::keys(p).length() > 0 {
        @js.Object::assign(@js.Object::new(), p)
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
