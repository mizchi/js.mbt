///|
pub fn svg(
  // common props
  children : Array[&@js.ToJs],
  width~ : Int,
  height~ : Int,
  view_box? : String,
  // shared
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  attrs["width"] = width |> @js.Value::cast_from
  attrs["height"] = height |> @js.Value::cast_from
  if view_box is Some(view_box) {
    attrs["viewBox"] = view_box |> @js.Value::cast_from
  }
  common_node(
    "svg",
    attrs,
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
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  attrs["cx"] = cx |> @js.Value::cast_from
  attrs["cy"] = cy |> @js.Value::cast_from
  attrs["r"] = r |> @js.Value::cast_from
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> @js.Value::cast_from
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> @js.Value::cast_from
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> @js.Value::cast_from
  }
  common_node(
    "circle",
    attrs,
    id~,
    class~,
    className~,
    style~,
    tab_index~,
    ref_~,
    key~,
    on_click~,
    on_change=None,
    on_keydown=None,
    on_keyup=None,
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
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  attrs["cx"] = cx |> @js.Value::cast_from
  attrs["cy"] = cy |> @js.Value::cast_from
  attrs["rx"] = rx |> @js.Value::cast_from
  attrs["ry"] = ry |> @js.Value::cast_from
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> @js.Value::cast_from
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> @js.Value::cast_from
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> @js.Value::cast_from
  }
  common_node(
    "circle",
    attrs,
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
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  attrs["x"] = x |> @js.Value::cast_from
  attrs["y"] = y |> @js.Value::cast_from
  attrs["width"] = width |> @js.Value::cast_from
  attrs["height"] = height |> @js.Value::cast_from
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> @js.Value::cast_from
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> @js.Value::cast_from
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> @js.Value::cast_from
  }
  common_node(
    "rect",
    attrs,
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
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  attrs["x1"] = x1 |> @js.Value::cast_from
  attrs["y1"] = y1 |> @js.Value::cast_from
  attrs["x2"] = x2 |> @js.Value::cast_from
  attrs["y2"] = y2 |> @js.Value::cast_from
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> @js.Value::cast_from
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> @js.Value::cast_from
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> @js.Value::cast_from
  }
  common_node(
    "line",
    attrs,
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
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  attrs["d"] = d |> @js.Value::cast_from
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> @js.Value::cast_from
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> @js.Value::cast_from
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> @js.Value::cast_from
  }
  common_node(
    "path",
    attrs,
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
    children=[],
  )
}

///|
pub fn use_(
  // common props
  href~ : String,

  // shared
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  attrs["href"] = href |> @js.Value::cast_from
  common_node(
    "use",
    attrs,
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
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  attrs["points"] = points |> @js.Value::cast_from
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> @js.Value::cast_from
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> @js.Value::cast_from
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> @js.Value::cast_from
  }
  common_node(
    "points",
    attrs,
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
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  attrs["points"] = points |> @js.Value::cast_from
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> @js.Value::cast_from
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> @js.Value::cast_from
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> @js.Value::cast_from
  }
  common_node(
    "polyline",
    attrs,
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
    children=[],
  )
}

///|
pub fn g(
  children : Array[&@js.ToJs],
  // common props
  stroke? : String,
  stroke_width? : Int,
  fill? : String,

  // shared
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> @js.Value::cast_from
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> @js.Value::cast_from
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> @js.Value::cast_from
  }
  common_node(
    "g",
    attrs,
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
    children~,
  )
}

///|
pub fn defs(
  children : Array[&@js.ToJs],
  // shared
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  common_node(
    "defs",
    attrs,
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
    children~,
  )
}

///|
pub fn text(
  children : Array[&@js.ToJs],
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
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  attrs["x"] = x |> @js.Value::cast_from
  attrs["y"] = y |> @js.Value::cast_from
  if dx is Some(dx) {
    attrs["dx"] = dx |> @js.Value::cast_from
  }
  if dy is Some(dy) {
    attrs["dy"] = dy |> @js.Value::cast_from
  }
  if length_adjust is Some(length_adjust) {
    attrs["lengthAdjust"] = length_adjust |> @js.Value::cast_from
  }
  if text_length is Some(text_length) {
    attrs["textLength"] = text_length |> @js.Value::cast_from
  }
  if stroke is Some(stroke) {
    attrs["stroke"] = stroke |> @js.Value::cast_from
  }
  if stroke_width is Some(stroke_width) {
    attrs["strokeWidth"] = stroke_width |> @js.Value::cast_from
  }
  if fill is Some(fill) {
    attrs["fill"] = fill |> @js.Value::cast_from
  }
  if rotate is Some(rotate) {
    attrs["rotate"] = rotate |> @js.Value::cast_from
  }
  common_node(
    "text",
    attrs,
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
    children~,
  )
}

///|
pub fn image(
  x~ : Int,
  y~ : Int,
  href~ : String,
  // shared
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> VirtualElement {
  let attrs = attributes.unwrap_or({})
  attrs["x"] = x |> @js.Value::cast_from
  attrs["y"] = y |> @js.Value::cast_from
  attrs["href"] = href |> @js.Value::cast_from
  common_node(
    "image",
    attrs,
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
    children=[],
  )
}
