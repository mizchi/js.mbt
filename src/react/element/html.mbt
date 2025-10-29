///|
using @react {type ReactRef, h}

///|
fn common_node(
  tag_name : String,
  attributes : Map[String, @js.Value],
  children~ : Array[&@js.ToJs],
  id~ : String?,
  class~ : String?,
  className~ : String?,
  style~ : Map[String, String]?,
  tab_index~ : Int?,
  ref_~ : ReactRef[@dom.Element]?,
  key~ : String?,
  on_click~ : ((@dom.MouseEvent) -> Unit)?,
  on_change~ : ((@dom.ChangeEvent) -> Unit)?,
  on_keydown~ : ((@dom.KeyboardEvent) -> Unit)?,
  on_keyup~ : ((@dom.KeyboardEvent) -> Unit)?,
) -> @react.Element {
  let attr : Map[String, @js.Value] = {}
  for k, v in attributes {
    attr[k] = v
  }
  if id is Some(id) {
    attr["id"] = id |> @js.to_js
  }
  if class is Some(class) {
    attr["className"] = class |> @js.to_js
  }
  if className is Some(className) {
    attr["className"] = className |> @js.to_js
  }
  if style is Some(style) {
    let style_obj : @js.Value = @js.new_object()
    for k, v in style {
      style_obj[k] = @js.to_js(v)
    }
    attr["style"] = style_obj
  }
  if ref_ is Some(ref_) {
    attr["ref"] = ref_ |> @js.to_js
  }
  if key is Some(key) {
    attr["key"] = key |> @js.to_js
  }
  if on_click is Some(on_click) {
    let f : @js.Value = on_click |> @js.identity
    attr["onClick"] = f
  }
  if on_change is Some(on_change) {
    let f : @js.Value = on_change |> @js.identity
    attr["onChange"] = f
  }
  if on_keydown is Some(on_keydown) {
    let f : @js.Value = on_keydown |> @js.identity
    attr["onKeyDown"] = f
  }
  if on_keyup is Some(on_keyup) {
    let f : @js.Value = on_keyup |> @js.identity
    attr["onKeyUp"] = f
  }
  if tab_index is Some(tab_index) {
    attr["tabIndex"] = tab_index |> @js.to_js
  }
  h(tag_name, attributes=attr, children)
}

///|
pub fn div(
  // common props
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
  )
}

///|
pub fn pre(
  // common props
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
    children~,
  )
}

///|
pub fn blockquote(
  // common props
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
    children~,
  )
}

///|
pub fn span(
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
    children~,
  )
}

///|
pub fn nav(
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
    children~,
  )
}

///|
pub fn p(
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
    children~,
  )
}

///|
pub fn textarea(
  children : Array[&@js.ToJs],
  rows? : Int,
  columns? : Int,
  spellcheck? : Bool,
  value? : String,
  default_value? : String,
  placeholder? : String,
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
) -> @react.Element {
  let new_attributes : Map[String, @js.Value] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  if rows is Some(r) {
    new_attributes["rows"] = r |> @js.to_js
  }
  if columns is Some(c) {
    new_attributes["cols"] = c |> @js.to_js
  }
  if spellcheck is Some(s) {
    new_attributes["spellCheck"] = s |> @js.to_js
  }
  if value is Some(v) {
    new_attributes["value"] = v |> @js.to_js
  }
  if default_value is Some(dv) {
    new_attributes["defaultValue"] = dv |> @js.to_js
  }
  if placeholder is Some(p) {
    new_attributes["placeholder"] = p |> @js.to_js
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
    children~,
  )
}

///|
pub fn input(
  // shared
  attributes? : Map[String, @js.Value],
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
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> @react.Element {
  let new_attributes : Map[String, @js.Value] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  if name is Some(n) {
    new_attributes["name"] = n |> @js.to_js
  }
  if value is Some(v) {
    new_attributes["value"] = v |> @js.to_js
  }
  if default_value is Some(dv) {
    new_attributes["defaultValue"] = dv |> @js.to_js
  }
  if type_ is Some(t) {
    new_attributes["type"] = t |> @js.to_js
  }
  if placeholder is Some(p) {
    new_attributes["placeholder"] = p |> @js.to_js
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
    children=[],
  )
}

///|
pub fn main_(
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
    children~,
  )
}

///|
pub fn header(
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
    children~,
  )
}

///|
pub fn footer(
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
    children~,
  )
}

///|
pub fn ul(
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
    children~,
  )
}

///|
pub fn ol(
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
    children~,
  )
}

///|
pub fn article(
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
    children~,
  )
}

///|
pub fn aside(
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
    children~,
  )
}

///|
pub fn section(
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
    children~,
  )
}

///|
#external
pub type FormData

///|
pub extern "js" fn FormData::get(self : FormData, key : String) -> @js.Value =
  #| (formData, key) => formData.get(key)

///|
pub fn form(
  children : Array[&@js.ToJs],

  // xxx
  method_? : String,
  disabled? : Bool,
  name? : String,
  enc_type? : String,
  action? : (FormData) -> Unit,
  on_submit? : (@dom.FormEvent) -> Unit,
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
) -> @react.Element {
  let new_attributes : Map[String, @js.Value] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  if disabled is Some(d) {
    new_attributes["disabled"] = d |> @js.to_js
  }
  if name is Some(n) {
    new_attributes["name"] = n |> @js.to_js
  }
  if method_ is Some(m) {
    new_attributes["method"] = m |> @js.to_js
  }
  if on_submit is Some(f) {
    let fn_value : @js.Value = f |> @js.identity
    new_attributes["onSubmit"] = fn_value
  }
  if action is Some(f) {
    let fn_value : @js.Value = f |> @js.identity
    new_attributes["action"] = fn_value
  }
  if enc_type is Some(e) {
    new_attributes["encType"] = e |> @js.to_js
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
    children~,
  )
}

///|
pub fn select(
  children : Array[&@js.ToJs],

  // xxx
  multiple? : Bool,
  disabled? : Bool,
  name? : String,
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
) -> @react.Element {
  let new_attributes : Map[String, @js.Value] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  if multiple is Some(m) {
    new_attributes["multiple"] = m |> @js.to_js
  }
  if disabled is Some(d) {
    new_attributes["disabled"] = d |> @js.to_js
  }
  if name is Some(n) {
    new_attributes["name"] = n |> @js.to_js
  }
  common_node(
    "select",
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
    children~,
  )
}

///|
pub fn option(
  children : Array[&@js.ToJs],
  value~ : String,
  selected? : Bool,
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
) -> @react.Element {
  let new_attributes : Map[String, @js.Value] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  new_attributes["value"] = value |> @js.to_js
  if selected is Some(s) {
    new_attributes["selected"] = s |> @js.to_js
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
    children~,
  )
}

///|
pub fn label(
  children : Array[&@js.ToJs],
  htmlFor : String,
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
) -> @react.Element {
  let new_attributes : Map[String, @js.Value] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  new_attributes["htmlFor"] = htmlFor |> @js.to_js
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
    children~,
  )
}

///|
pub fn li(
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
    children~,
  )
}

///|
pub fn code(
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
    children~,
  )
}

///|
pub fn details(
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
    children~,
  )
}

///|
pub fn summary(
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
    children~,
  )
}

///|
pub fn a(
  children : Array[&@js.ToJs],

  // a specific
  href~ : String,
  download? : String,
  target? : String,

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
) -> @react.Element {
  let new_attributes : Map[String, @js.Value] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  new_attributes["href"] = href |> @js.to_js
  if download is Some(d) {
    new_attributes["download"] = d |> @js.to_js
  }
  if target is Some(t) {
    new_attributes["target"] = t |> @js.to_js
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
    children~,
  )
}

///|
pub fn iframe(
  children : Array[&@js.ToJs],

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
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  // react
  ref_? : ReactRef[@dom.Element],
  key? : String,
  // event handlers
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> @react.Element {
  let new_attributes : Map[String, @js.Value] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  new_attributes["src"] = src |> @js.to_js
  if width is Some(d) {
    new_attributes["width"] = d |> @js.to_js
  }
  if height is Some(d) {
    new_attributes["height"] = d |> @js.to_js
  }
  if frameborder is Some(d) {
    new_attributes["frameborder"] = d |> @js.to_js
  }
  if sandbox is Some(d) {
    new_attributes["sandbox"] = d |> @js.to_js
  }
  if allowfullscreen is Some(d) {
    new_attributes["allowfullscreen"] = d |> @js.to_js
  }
  if loading is Some(d) {
    new_attributes["loading"] = d |> @js.to_js
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
    children~,
  )
}

///|
pub fn img(
  children : Array[&@js.ToJs],

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
) -> @react.Element {
  let new_attributes : Map[String, @js.Value] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  new_attributes["src"] = src |> @js.to_js
  if alt is Some(d) {
    new_attributes["alt"] = d |> @js.to_js
  }
  if crossorigin is Some(d) {
    new_attributes["crossorigin"] = d |> @js.to_js
  }
  if decoding is Some(d) {
    new_attributes["decoding"] = d |> @js.to_js
  }
  if width is Some(d) {
    new_attributes["width"] = d |> @js.to_js
  }
  if height is Some(d) {
    new_attributes["height"] = d |> @js.to_js
  }
  if fetchpriority is Some(d) {
    new_attributes["fetchpriority"] = d |> @js.to_js
  }
  if loading is Some(d) {
    new_attributes["loading"] = d |> @js.to_js
  }
  if sizes is Some(d) {
    new_attributes["sizes"] = d |> @js.to_js
  }
  if srcset is Some(d) {
    new_attributes["srcset"] = d |> @js.to_js
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
    children~,
  )
}

///|
pub fn video(
  children : Array[&@js.ToJs],

  // a specific
  controls? : Bool,

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
) -> @react.Element {
  let new_attributes : Map[String, @js.Value] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  if controls is Some(c) {
    new_attributes["controls"] = c |> @js.to_js
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
    children~,
  )
}

///|
pub fn source(
  // a specific
  src~ : String,
  type_? : String,

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
) -> @react.Element {
  let new_attributes : Map[String, @js.Value] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  new_attributes["src"] = src |> @js.to_js
  if type_ is Some(t) {
    new_attributes["type"] = t |> @js.to_js
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
    children=[],
  )
}

///|
pub fn hr(
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
    children=[],
  )
}

///|
pub fn h1(
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
    children~,
  )
}

///|
pub fn h2(
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
    children~,
  )
}

///|
pub fn h3(
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
    children~,
  )
}

///|
pub fn button(
  children : Array[&@js.ToJs],
  type_? : String,
  disabled? : Bool,
  attributes? : Map[String, @js.Value],
  id? : String,
  class? : String,
  className? : String,
  style? : Map[String, String],
  tab_index? : Int,
  ref_? : ReactRef[@dom.Element],
  key? : String,
  on_click? : (@dom.MouseEvent) -> Unit,
  on_change? : (@dom.ChangeEvent) -> Unit,
  on_keydown? : (@dom.KeyboardEvent) -> Unit,
  on_keyup? : (@dom.KeyboardEvent) -> Unit,
) -> @react.Element {
  let new_attributes : Map[String, @js.Value] = {}
  if attributes is Some(attrs) {
    for k, v in attrs {
      new_attributes[k] = v
    }
  }
  if type_ is Some(t) {
    new_attributes["type"] = t |> @js.to_js
  }
  if disabled is Some(d) {
    new_attributes["disabled"] = d |> @js.to_js
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
    children~,
  )
}
