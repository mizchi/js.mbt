///|
pub fn svg(
  // common props
  children : Array[&@react.ReactNode],
  width~ : Double,
  height~ : Double,
  view_box? : String,
  // shared
  props? : @core.Any,
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
        @js.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
  }
  attrs._set("width", width |> @core.any)
  attrs._set("height", height |> @core.any)
  if view_box is Some(view_box) {
    attrs._set("viewBox", view_box |> @core.any)
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
  props? : @core.Any,
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
        @js.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
  }
  attrs._set("cx", cx |> @core.any)
  attrs._set("cy", cy |> @core.any)
  attrs._set("r", r |> @core.any)
  if stroke is Some(stroke) {
    attrs._set("stroke", stroke |> @core.any)
  }
  if stroke_width is Some(stroke_width) {
    attrs._set("strokeWidth", stroke_width |> @core.any)
  }
  if fill is Some(fill) {
    attrs._set("fill", fill |> @core.any)
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
  props? : @core.Any,
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
        @js.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
  }
  attrs._set("cx", cx |> @core.any)
  attrs._set("cy", cy |> @core.any)
  attrs._set("rx", rx |> @core.any)
  attrs._set("ry", ry |> @core.any)
  if stroke is Some(stroke) {
    attrs._set("stroke", stroke |> @core.any)
  }
  if stroke_width is Some(stroke_width) {
    attrs._set("strokeWidth", stroke_width |> @core.any)
  }
  if fill is Some(fill) {
    attrs._set("fill", fill |> @core.any)
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
  props? : @core.Any,
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
        @js.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
  }
  attrs._set("x", x |> @core.any)
  attrs._set("y", y |> @core.any)
  attrs._set("width", width |> @core.any)
  attrs._set("height", height |> @core.any)
  if stroke is Some(stroke) {
    attrs._set("stroke", stroke |> @core.any)
  }
  if stroke_width is Some(stroke_width) {
    attrs._set("strokeWidth", stroke_width |> @core.any)
  }
  if fill is Some(fill) {
    attrs._set("fill", fill |> @core.any)
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
  props? : @core.Any,
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
        @js.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
  }
  attrs._set("x1", x1 |> @core.any)
  attrs._set("y1", y1 |> @core.any)
  attrs._set("x2", x2 |> @core.any)
  attrs._set("y2", y2 |> @core.any)
  if stroke is Some(stroke) {
    attrs._set("stroke", stroke |> @core.any)
  }
  if stroke_width is Some(stroke_width) {
    attrs._set("strokeWidth", stroke_width |> @core.any)
  }
  if fill is Some(fill) {
    attrs._set("fill", fill |> @core.any)
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
  props? : @core.Any,
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
        @js.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
  }
  attrs._set("d", d |> @core.any)
  if stroke is Some(stroke) {
    attrs._set("stroke", stroke |> @core.any)
  }
  if stroke_width is Some(stroke_width) {
    attrs._set("strokeWidth", stroke_width |> @core.any)
  }
  if fill is Some(fill) {
    attrs._set("fill", fill |> @core.any)
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
  props? : @core.Any,
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
        @js.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
  }
  attrs._set("href", href |> @core.any)
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
  props? : @core.Any,
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
      if @core.Object::keys(p).length() > 0 {
        @core.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
  }
  attrs._set("points", points |> @core.identity)
  if stroke is Some(stroke) {
    attrs._set("stroke", stroke |> @core.any)
  }
  if stroke_width is Some(stroke_width) {
    attrs._set("strokeWidth", stroke_width |> @core.any)
  }
  if fill is Some(fill) {
    attrs._set("fill", fill |> @core.any)
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
  props? : @core.Any,
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
      if @core.Object::keys(p).length() > 0 {
        @core.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
  }
  attrs._set("points", points |> @core.identity)
  if stroke is Some(stroke) {
    attrs._set("stroke", stroke |> @core.any)
  }
  if stroke_width is Some(stroke_width) {
    attrs._set("strokeWidth", stroke_width |> @core.any)
  }
  if fill is Some(fill) {
    attrs._set("fill", fill |> @core.any)
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
  props? : @core.Any,
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
        @js.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
  }
  if stroke is Some(stroke) {
    attrs._set("stroke", stroke |> @core.any)
  }
  if stroke_width is Some(stroke_width) {
    attrs._set("strokeWidth", stroke_width |> @core.any)
  }
  if fill is Some(fill) {
    attrs._set("fill", fill |> @core.any)
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
  props? : @core.Any,
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
        @js.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
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
  props? : @core.Any,
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
        @js.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
  }
  attrs._set("x", x |> @core.any)
  attrs._set("y", y |> @core.any)
  if dx is Some(dx) {
    attrs._set("dx", dx |> @core.any)
  }
  if dy is Some(dy) {
    attrs._set("dy", dy |> @core.any)
  }
  if length_adjust is Some(length_adjust) {
    attrs._set("lengthAdjust", length_adjust |> @core.any)
  }
  if text_length is Some(text_length) {
    attrs._set("textLength", text_length |> @core.any)
  }
  if stroke is Some(stroke) {
    attrs._set("stroke", stroke |> @core.any)
  }
  if stroke_width is Some(stroke_width) {
    attrs._set("strokeWidth", stroke_width |> @core.any)
  }
  if fill is Some(fill) {
    attrs._set("fill", fill |> @core.any)
  }
  if rotate is Some(rotate) {
    attrs._set("rotate", rotate |> @core.any)
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
  props? : @core.Any,
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
        @js.Object::assign(@core.Object::new(), p)
      } else {
        p
      }
    None => @core.Object::new()
  }
  attrs._set("x", x |> @core.any)
  attrs._set("y", y |> @core.any)
  attrs._set("href", href |> @core.any)
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
