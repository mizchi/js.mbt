///| Props builder helpers - type-safe prop construction

///|

///|
/// Create empty props
pub fn props() -> Props {
  []
}

///| Common HTML attributes

///|
/// className attribute
pub fn class_name(value : String) -> (String, AttrValue) {
  ("className", AttrValue::Str(value))
}

///|
/// id attribute
pub fn id(value : String) -> (String, AttrValue) {
  ("id", AttrValue::Str(value))
}

///|
/// href attribute (for links)
pub fn href(value : String) -> (String, AttrValue) {
  ("href", AttrValue::Str(value))
}

///|
/// src attribute (for images, scripts)
pub fn src(value : String) -> (String, AttrValue) {
  ("src", AttrValue::Str(value))
}

///|
/// alt attribute (for images)
pub fn alt(value : String) -> (String, AttrValue) {
  ("alt", AttrValue::Str(value))
}

///|
/// title attribute
pub fn title(value : String) -> (String, AttrValue) {
  ("title", AttrValue::Str(value))
}

///|
/// placeholder attribute (for inputs)
pub fn placeholder(value : String) -> (String, AttrValue) {
  ("placeholder", AttrValue::Str(value))
}

///|
/// value attribute (for inputs)
pub fn value(value : String) -> (String, AttrValue) {
  ("value", AttrValue::Str(value))
}

///|
/// type attribute (for inputs)
pub fn type_(value : String) -> (String, AttrValue) {
  ("type", AttrValue::Str(value))
}

///|
/// name attribute (for form elements)
pub fn name(value : String) -> (String, AttrValue) {
  ("name", AttrValue::Str(value))
}

///|
/// for attribute (for labels)
pub fn for_(value : String) -> (String, AttrValue) {
  ("for", AttrValue::Str(value))
}

///|
/// Generic data-* attribute
pub fn data_(key : String, value : String) -> (String, AttrValue) {
  (key, AttrValue::Str(value))
}

///| Boolean attributes

///|
/// disabled attribute
pub fn disabled(value : Bool) -> (String, AttrValue) {
  ("disabled", AttrValue::Bool(value))
}

///|
/// checked attribute (for checkboxes)
pub fn checked(value : Bool) -> (String, AttrValue) {
  ("checked", AttrValue::Bool(value))
}

///|
/// readonly attribute
pub fn readonly_(value : Bool) -> (String, AttrValue) {
  ("readonly", AttrValue::Bool(value))
}

///|
/// required attribute (for form inputs)
pub fn required(value : Bool) -> (String, AttrValue) {
  ("required", AttrValue::Bool(value))
}

///| Numeric attributes

///|
/// tabIndex attribute
pub fn tab_index(value : Int) -> (String, AttrValue) {
  ("tabIndex", AttrValue::Num(value))
}

///|
/// maxLength attribute (for inputs)
pub fn max_length(value : Int) -> (String, AttrValue) {
  ("maxLength", AttrValue::Num(value))
}

///| Event handlers

///|
/// onClick event handler
pub fn on_click(handler : EventHandler) -> (String, AttrValue) {
  ("onClick", AttrValue::Handler(handler))
}

///|
/// onChange event handler
pub fn on_change(handler : EventHandler) -> (String, AttrValue) {
  ("onChange", AttrValue::Handler(handler))
}

///|
/// onInput event handler
pub fn on_input(handler : EventHandler) -> (String, AttrValue) {
  ("onInput", AttrValue::Handler(handler))
}

///|
/// onSubmit event handler
pub fn on_submit(handler : EventHandler) -> (String, AttrValue) {
  ("onSubmit", AttrValue::Handler(handler))
}

///|
/// onFocus event handler
pub fn on_focus(handler : EventHandler) -> (String, AttrValue) {
  ("onFocus", AttrValue::Handler(handler))
}

///|
/// onBlur event handler
pub fn on_blur(handler : EventHandler) -> (String, AttrValue) {
  ("onBlur", AttrValue::Handler(handler))
}

///|
/// onKeyDown event handler
pub fn on_key_down(handler : EventHandler) -> (String, AttrValue) {
  ("onKeyDown", AttrValue::Handler(handler))
}

///|
/// onKeyUp event handler
pub fn on_key_up(handler : EventHandler) -> (String, AttrValue) {
  ("onKeyUp", AttrValue::Handler(handler))
}

///|
/// onMouseEnter event handler
pub fn on_mouse_enter(handler : EventHandler) -> (String, AttrValue) {
  ("onMouseEnter", AttrValue::Handler(handler))
}

///|
/// onMouseLeave event handler
pub fn on_mouse_leave(handler : EventHandler) -> (String, AttrValue) {
  ("onMouseLeave", AttrValue::Handler(handler))
}

///| Style

///|
/// style attribute - takes array of CSS property-value pairs
pub fn style(styles : Array[(String, String)]) -> (String, AttrValue) {
  ("style", AttrValue::StyleObj(styles))
}

///|
/// Custom attribute (for any attribute not covered above)
pub fn attr(key : String, value : String) -> (String, AttrValue) {
  (key, AttrValue::Str(value))
}

///|
/// Custom numeric attribute
pub fn attr_num(key : String, value : Int) -> (String, AttrValue) {
  (key, AttrValue::Num(value))
}

///|
/// Custom boolean attribute
pub fn attr_bool(key : String, value : Bool) -> (String, AttrValue) {
  (key, AttrValue::Bool(value))
}
