///|
pub fn svg(
  // common props
  children : Array[&ReactNode],
  width~ : Int,
  height~ : Int,
  view_box? : String,
  // shared
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
  attrs["width"] = width |> js
  attrs["height"] = height |> js
  if view_box is Some(view_box) {
    attrs["viewBox"] = view_box |> js
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
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
  attrs["cx"] = cx |> js
  attrs["cy"] = cy |> js
  attrs["r"] = r |> js
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> js
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> js
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> js
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
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
  attrs["cx"] = cx |> js
  attrs["cy"] = cy |> js
  attrs["rx"] = rx |> js
  attrs["ry"] = ry |> js
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> js
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> js
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> js
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
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
  attrs["x"] = x |> js
  attrs["y"] = y |> js
  attrs["width"] = width |> js
  attrs["height"] = height |> js
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> js
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> js
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> js
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
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
  attrs["x1"] = x1 |> js
  attrs["y1"] = y1 |> js
  attrs["x2"] = x2 |> js
  attrs["y2"] = y2 |> js
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> js
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> js
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> js
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
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
  attrs["d"] = d |> js
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> js
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> js
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> js
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
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
  attrs["href"] = href |> js
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
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
  attrs["points"] = points |> unsafe_cast
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> js
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> js
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> js
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
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
  attrs["points"] = points |> unsafe_cast
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> js
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> js
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> js
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
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> js
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> js
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> js
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
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
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
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
  attrs["x"] = x |> js
  attrs["y"] = y |> js
  if dx is Some(dx) {
    attrs["dx"] = dx |> js
  }
  if dy is Some(dy) {
    attrs["dy"] = dy |> js
  }
  if length_adjust is Some(length_adjust) {
    attrs["lengthAdjust"] = length_adjust |> js
  }
  if text_length is Some(text_length) {
    attrs["textLength"] = text_length |> js
  }
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> js
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> js
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> js
  }
  if rotate is Some(rotate) {
    attrs["rotate"] = rotate |> js
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
  attributes? : Map[String, Js],
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
  let attrs = attributes.unwrap_or({})
  attrs["x"] = x |> js
  attrs["y"] = y |> js
  attrs["href"] = href |> js
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
