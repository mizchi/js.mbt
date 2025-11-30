///| Ink UI - Component library for Ink
/// Bindings for https://github.com/vadimdemedes/ink-ui (@inkjs/ui)

// ============================================================
// Dynamic Import
// ============================================================

///|
/// Ink UI module handle
#external
pub type InkUI

///|
pub fn InkUI::as_any(self : InkUI) -> @nostd.Any = "%identity"

///|
/// Dynamic import for @inkjs/ui module (internal)
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_ink_ui_internal() -> @nostd.Promise[InkUI] =
  #| () => import("@inkjs/ui")

///|
/// Dynamic import for @inkjs/ui module
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
pub async fn dynamic_import() -> InkUI {
  import_ink_ui_internal().wait()
}

// ============================================================
// Input Components
// ============================================================

///|
/// TextInput component - Single-line text input
pub fn InkUI::text_input(
  self : InkUI,
  placeholder? : String,
  default_value? : String,
  on_submit? : (String) -> Unit,
  on_change? : (String) -> Unit,
  is_disabled? : Bool,
) -> @react.Element {
  let component = self.as_any()["TextInput"]
  let props = @nostd.Object::new()
  if placeholder is Some(p) {
    props["placeholder"] = @nostd.any(p)
  }
  if default_value is Some(v) {
    props["defaultValue"] = @nostd.any(v)
  }
  if on_submit is Some(f) {
    props["onSubmit"] = ffi_wrap_string_callback(f)
  }
  if on_change is Some(f) {
    props["onChange"] = ffi_wrap_string_callback(f)
  }
  if is_disabled is Some(d) {
    props["isDisabled"] = @nostd.any(d)
  }
  ffi_create_element(component, props, @nostd.undefined()).cast()
}

///|
/// EmailInput component - Email input with domain autocomplete
pub fn InkUI::email_input(
  self : InkUI,
  placeholder? : String,
  default_value? : String,
  domains? : Array[String],
  on_submit? : (String) -> Unit,
  on_change? : (String) -> Unit,
  is_disabled? : Bool,
) -> @react.Element {
  let component = self.as_any()["EmailInput"]
  let props = @nostd.Object::new()
  if placeholder is Some(p) {
    props["placeholder"] = @nostd.any(p)
  }
  if default_value is Some(v) {
    props["defaultValue"] = @nostd.any(v)
  }
  if domains is Some(d) {
    props["domains"] = @nostd.any(d)
  }
  if on_submit is Some(f) {
    props["onSubmit"] = ffi_wrap_string_callback(f)
  }
  if on_change is Some(f) {
    props["onChange"] = ffi_wrap_string_callback(f)
  }
  if is_disabled is Some(d) {
    props["isDisabled"] = @nostd.any(d)
  }
  ffi_create_element(component, props, @nostd.undefined()).cast()
}

///|
/// PasswordInput component - Masked password input
pub fn InkUI::password_input(
  self : InkUI,
  placeholder? : String,
  mask? : String,
  on_submit? : (String) -> Unit,
  on_change? : (String) -> Unit,
  is_disabled? : Bool,
) -> @react.Element {
  let component = self.as_any()["PasswordInput"]
  let props = @nostd.Object::new()
  if placeholder is Some(p) {
    props["placeholder"] = @nostd.any(p)
  }
  if mask is Some(m) {
    props["mask"] = @nostd.any(m)
  }
  if on_submit is Some(f) {
    props["onSubmit"] = ffi_wrap_string_callback(f)
  }
  if on_change is Some(f) {
    props["onChange"] = ffi_wrap_string_callback(f)
  }
  if is_disabled is Some(d) {
    props["isDisabled"] = @nostd.any(d)
  }
  ffi_create_element(component, props, @nostd.undefined()).cast()
}

///|
/// ConfirmInput component - Y/n confirmation prompt
pub fn InkUI::confirm_input(
  self : InkUI,
  on_confirm? : () -> Unit,
  on_cancel? : () -> Unit,
  is_disabled? : Bool,
) -> @react.Element {
  let component = self.as_any()["ConfirmInput"]
  let props = @nostd.Object::new()
  if on_confirm is Some(f) {
    props["onConfirm"] = ffi_wrap_unit_callback(f)
  }
  if on_cancel is Some(f) {
    props["onCancel"] = ffi_wrap_unit_callback(f)
  }
  if is_disabled is Some(d) {
    props["isDisabled"] = @nostd.any(d)
  }
  ffi_create_element(component, props, @nostd.undefined()).cast()
}

// ============================================================
// Selection Components
// ============================================================

///|
/// Select option structure
pub(all) struct SelectOption {
  label : String
  value : String
}

///|
fn SelectOption::as_any(self : SelectOption) -> @nostd.Any {
  let obj = @nostd.Object::new()
  obj["label"] = @nostd.any(self.label)
  obj["value"] = @nostd.any(self.value)
  obj
}

///|
/// Select component - Single option selection
pub fn InkUI::select(
  self : InkUI,
  options : Array[SelectOption],
  on_change? : (String) -> Unit,
  default_value? : String,
  visible_option_count? : Int,
  is_disabled? : Bool,
) -> @react.Element {
  let component = self.as_any()["Select"]
  let props = @nostd.Object::new()
  let opts_arr = @nostd.any(options.map(fn(o) { o.as_any() }))
  props["options"] = opts_arr
  if on_change is Some(f) {
    props["onChange"] = ffi_wrap_string_callback(f)
  }
  if default_value is Some(v) {
    props["defaultValue"] = @nostd.any(v)
  }
  if visible_option_count is Some(c) {
    props["visibleOptionCount"] = @nostd.any(c)
  }
  if is_disabled is Some(d) {
    props["isDisabled"] = @nostd.any(d)
  }
  ffi_create_element(component, props, @nostd.undefined()).cast()
}

///|
/// MultiSelect component - Multiple option selection
pub fn InkUI::multi_select(
  self : InkUI,
  options : Array[SelectOption],
  on_change? : (Array[String]) -> Unit,
  default_value? : Array[String],
  visible_option_count? : Int,
  is_disabled? : Bool,
) -> @react.Element {
  let component = self.as_any()["MultiSelect"]
  let props = @nostd.Object::new()
  let opts_arr = @nostd.any(options.map(fn(o) { o.as_any() }))
  props["options"] = opts_arr
  if on_change is Some(f) {
    props["onChange"] = ffi_wrap_string_array_callback(f)
  }
  if default_value is Some(v) {
    props["defaultValue"] = @nostd.any(v)
  }
  if visible_option_count is Some(c) {
    props["visibleOptionCount"] = @nostd.any(c)
  }
  if is_disabled is Some(d) {
    props["isDisabled"] = @nostd.any(d)
  }
  ffi_create_element(component, props, @nostd.undefined()).cast()
}

// ============================================================
// Feedback Components
// ============================================================

///|
/// Spinner component - Loading indicator
pub fn InkUI::spinner(self : InkUI, label? : String) -> @react.Element {
  let component = self.as_any()["Spinner"]
  let props = @nostd.Object::new()
  if label is Some(l) {
    props["label"] = @nostd.any(l)
  }
  ffi_create_element(component, props, @nostd.undefined()).cast()
}

///|
/// ProgressBar component - Progress indicator (0-100)
pub fn InkUI::progress_bar(self : InkUI, value : Int) -> @react.Element {
  let component = self.as_any()["ProgressBar"]
  let props = @nostd.Object::new()
  props["value"] = @nostd.any(value)
  ffi_create_element(component, props, @nostd.undefined()).cast()
}

///|
/// Badge color options
pub(all) enum BadgeColor {
  Green
  Red
  Yellow
  Blue
  Cyan
  Magenta
  White
  Gray
}

///|
pub fn BadgeColor::to_string(self : BadgeColor) -> String {
  match self {
    Green => "green"
    Red => "red"
    Yellow => "yellow"
    Blue => "blue"
    Cyan => "cyan"
    Magenta => "magenta"
    White => "white"
    Gray => "gray"
  }
}

///|
/// Badge component - Status indicator
pub fn InkUI::badge(
  self : InkUI,
  children : Array[&@react.ReactNode],
  color? : BadgeColor,
) -> @react.Element {
  let component = self.as_any()["Badge"]
  let props = @nostd.Object::new()
  if color is Some(c) {
    props["color"] = @nostd.any(c.to_string())
  }
  let children_arr = @nostd.any(children.map(fn(c) { c.to_react_node() }))
  ffi_create_element(component, props, children_arr).cast()
}

///|
/// Status message variant
pub(all) enum StatusVariant {
  Success
  Error
  Warning
  Info
}

///|
pub fn StatusVariant::to_string(self : StatusVariant) -> String {
  match self {
    Success => "success"
    Error => "error"
    Warning => "warning"
    Info => "info"
  }
}

///|
/// StatusMessage component - Status display with icon
pub fn InkUI::status_message(
  self : InkUI,
  children : Array[&@react.ReactNode],
  variant : StatusVariant,
) -> @react.Element {
  let component = self.as_any()["StatusMessage"]
  let props = @nostd.Object::new()
  props["variant"] = @nostd.any(variant.to_string())
  let children_arr = @nostd.any(children.map(fn(c) { c.to_react_node() }))
  ffi_create_element(component, props, children_arr).cast()
}

///|
/// Alert component - High-attention message
pub fn InkUI::alert(
  self : InkUI,
  children : Array[&@react.ReactNode],
  variant : StatusVariant,
  title? : String,
) -> @react.Element {
  let component = self.as_any()["Alert"]
  let props = @nostd.Object::new()
  props["variant"] = @nostd.any(variant.to_string())
  if title is Some(t) {
    props["title"] = @nostd.any(t)
  }
  let children_arr = @nostd.any(children.map(fn(c) { c.to_react_node() }))
  ffi_create_element(component, props, children_arr).cast()
}

// ============================================================
// List Components
// ============================================================

///|
/// UnorderedList component - Bulleted list
pub fn InkUI::unordered_list(
  self : InkUI,
  children : Array[&@react.ReactNode],
) -> @react.Element {
  let component = self.as_any()["UnorderedList"]
  let props = @nostd.Object::new()
  let children_arr = @nostd.any(children.map(fn(c) { c.to_react_node() }))
  ffi_create_element(component, props, children_arr).cast()
}

///|
/// UnorderedList.Item component
pub fn InkUI::unordered_list_item(
  self : InkUI,
  children : Array[&@react.ReactNode],
) -> @react.Element {
  let component = self.as_any()["UnorderedList"]["Item"]
  let props = @nostd.Object::new()
  let children_arr = @nostd.any(children.map(fn(c) { c.to_react_node() }))
  ffi_create_element(component, props, children_arr).cast()
}

///|
/// OrderedList component - Numbered list
pub fn InkUI::ordered_list(
  self : InkUI,
  children : Array[&@react.ReactNode],
) -> @react.Element {
  let component = self.as_any()["OrderedList"]
  let props = @nostd.Object::new()
  let children_arr = @nostd.any(children.map(fn(c) { c.to_react_node() }))
  ffi_create_element(component, props, children_arr).cast()
}

///|
/// OrderedList.Item component
pub fn InkUI::ordered_list_item(
  self : InkUI,
  children : Array[&@react.ReactNode],
) -> @react.Element {
  let component = self.as_any()["OrderedList"]["Item"]
  let props = @nostd.Object::new()
  let children_arr = @nostd.any(children.map(fn(c) { c.to_react_node() }))
  ffi_create_element(component, props, children_arr).cast()
}

// ============================================================
// Theming
// ============================================================

///|
/// Theme type
#external
pub type Theme

///|
pub fn Theme::as_any(self : Theme) -> @nostd.Any = "%identity"

///|
/// Get the default theme
pub fn InkUI::default_theme(self : InkUI) -> Theme {
  self.as_any()["defaultTheme"].cast()
}

///|
/// ThemeProvider component - Provides theme to children
pub fn InkUI::theme_provider(
  self : InkUI,
  children : Array[&@react.ReactNode],
  theme : Theme,
) -> @react.Element {
  let component = self.as_any()["ThemeProvider"]
  let props = @nostd.Object::new()
  props["theme"] = theme.as_any()
  let children_arr = @nostd.any(children.map(fn(c) { c.to_react_node() }))
  ffi_create_element(component, props, children_arr).cast()
}

///|
/// Extend the default theme with custom values
pub fn InkUI::extend_theme(self : InkUI, extension : @nostd.Any) -> Theme {
  let extend_fn = self.as_any()["extendTheme"]
  extend_fn._invoke([extension]).cast()
}

// ============================================================
// FFI Helpers
// ============================================================

///|
extern "js" fn ffi_create_element(
  tag : @nostd.Any,
  props : @nostd.Any,
  children : @nostd.Any,
) -> @nostd.Any =
  #|(tag, props, children) => {
  #|  const React = require('react');
  #|  if (children === undefined) {
  #|    return React.createElement(tag, props);
  #|  }
  #|  return React.createElement(tag, props, ...children);
  #|}

///|
extern "js" fn ffi_wrap_string_callback(f : (String) -> Unit) -> @nostd.Any =
  #|(f) => f

///|
extern "js" fn ffi_wrap_unit_callback(f : () -> Unit) -> @nostd.Any =
  #|(f) => f

///|
extern "js" fn ffi_wrap_string_array_callback(
  f : (Array[String]) -> Unit,
) -> @nostd.Any =
  #|(f) => (arr) => f(Array.from(arr))
