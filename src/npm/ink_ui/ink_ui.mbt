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
pub impl @js.JsImpl for InkUI

///|
/// Dynamic import for @inkjs/ui module (internal)
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_ink_ui_internal() -> @js.Promise[InkUI] =
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
  let component = self.as_any().get("TextInput")
  let props = @js.Object::new()
  if placeholder is Some(p) {
    props.set("placeholder", p)
  }
  if default_value is Some(v) {
    props.set("defaultValue", v)
  }
  if on_submit is Some(f) {
    props.set("onSubmit", ffi_wrap_string_callback(f))
  }
  if on_change is Some(f) {
    props.set("onChange", ffi_wrap_string_callback(f))
  }
  if is_disabled is Some(d) {
    props.set("isDisabled", d)
  }
  ffi_create_element(component, props.as_any(), @js.undefined()) |> @js.identity
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
  let component = self.as_any().get("EmailInput")
  let props = @js.Object::new()
  if placeholder is Some(p) {
    props.set("placeholder", p)
  }
  if default_value is Some(v) {
    props.set("defaultValue", v)
  }
  if domains is Some(d) {
    props.set("domains", d |> @js.from_array)
  }
  if on_submit is Some(f) {
    props.set("onSubmit", ffi_wrap_string_callback(f))
  }
  if on_change is Some(f) {
    props.set("onChange", ffi_wrap_string_callback(f))
  }
  if is_disabled is Some(d) {
    props.set("isDisabled", d)
  }
  ffi_create_element(component, props.as_any(), @js.undefined()) |> @js.identity
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
  let component = self.as_any().get("PasswordInput")
  let props = @js.Object::new()
  if placeholder is Some(p) {
    props.set("placeholder", p)
  }
  if mask is Some(m) {
    props.set("mask", m)
  }
  if on_submit is Some(f) {
    props.set("onSubmit", ffi_wrap_string_callback(f))
  }
  if on_change is Some(f) {
    props.set("onChange", ffi_wrap_string_callback(f))
  }
  if is_disabled is Some(d) {
    props.set("isDisabled", d)
  }
  ffi_create_element(component, props.as_any(), @js.undefined()) |> @js.identity
}

///|
/// ConfirmInput component - Y/n confirmation prompt
pub fn InkUI::confirm_input(
  self : InkUI,
  on_confirm? : () -> Unit,
  on_cancel? : () -> Unit,
  is_disabled? : Bool,
) -> @react.Element {
  let component = self.as_any().get("ConfirmInput")
  let props = @js.Object::new()
  if on_confirm is Some(f) {
    props.set("onConfirm", ffi_wrap_unit_callback(f))
  }
  if on_cancel is Some(f) {
    props.set("onCancel", ffi_wrap_unit_callback(f))
  }
  if is_disabled is Some(d) {
    props.set("isDisabled", d)
  }
  ffi_create_element(component, props.as_any(), @js.undefined()) |> @js.identity
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
fn SelectOption::as_any(self : SelectOption) -> @js.Any {
  let obj = @js.Object::new()
  obj.set("label", self.label)
  obj.set("value", self.value)
  obj.as_any()
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
  let component = self.as_any().get("Select")
  let props = @js.Object::new()
  let opts_arr = options.map(fn(o) { o.as_any() }) |> @js.from_array
  props.set("options", opts_arr)
  if on_change is Some(f) {
    props.set("onChange", ffi_wrap_string_callback(f))
  }
  if default_value is Some(v) {
    props.set("defaultValue", v)
  }
  if visible_option_count is Some(c) {
    props.set("visibleOptionCount", c)
  }
  if is_disabled is Some(d) {
    props.set("isDisabled", d)
  }
  ffi_create_element(component, props.as_any(), @js.undefined()) |> @js.identity
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
  let component = self.as_any().get("MultiSelect")
  let props = @js.Object::new()
  let opts_arr = options.map(fn(o) { o.as_any() }) |> @js.from_array
  props.set("options", opts_arr)
  if on_change is Some(f) {
    props.set("onChange", ffi_wrap_string_array_callback(f))
  }
  if default_value is Some(v) {
    props.set("defaultValue", v |> @js.from_array)
  }
  if visible_option_count is Some(c) {
    props.set("visibleOptionCount", c)
  }
  if is_disabled is Some(d) {
    props.set("isDisabled", d)
  }
  ffi_create_element(component, props.as_any(), @js.undefined()) |> @js.identity
}

// ============================================================
// Feedback Components
// ============================================================

///|
/// Spinner component - Loading indicator
pub fn InkUI::spinner(self : InkUI, label? : String) -> @react.Element {
  let component = self.as_any().get("Spinner")
  let props = @js.Object::new()
  if label is Some(l) {
    props.set("label", l)
  }
  ffi_create_element(component, props.as_any(), @js.undefined()) |> @js.identity
}

///|
/// ProgressBar component - Progress indicator (0-100)
pub fn InkUI::progress_bar(self : InkUI, value : Int) -> @react.Element {
  let component = self.as_any().get("ProgressBar")
  let props = @js.Object::new()
  props.set("value", value)
  ffi_create_element(component, props.as_any(), @js.undefined()) |> @js.identity
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
  let component = self.as_any().get("Badge")
  let props = @js.Object::new()
  if color is Some(c) {
    props.set("color", c.to_string())
  }
  let children_arr = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  ffi_create_element(component, props.as_any(), children_arr) |> @js.identity
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
  let component = self.as_any().get("StatusMessage")
  let props = @js.Object::new()
  props.set("variant", variant.to_string())
  let children_arr = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  ffi_create_element(component, props.as_any(), children_arr) |> @js.identity
}

///|
/// Alert component - High-attention message
pub fn InkUI::alert(
  self : InkUI,
  children : Array[&@react.ReactNode],
  variant : StatusVariant,
  title? : String,
) -> @react.Element {
  let component = self.as_any().get("Alert")
  let props = @js.Object::new()
  props.set("variant", variant.to_string())
  if title is Some(t) {
    props.set("title", t)
  }
  let children_arr = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  ffi_create_element(component, props.as_any(), children_arr) |> @js.identity
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
  let component = self.as_any().get("UnorderedList")
  let props = @js.Object::new()
  let children_arr = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  ffi_create_element(component, props.as_any(), children_arr) |> @js.identity
}

///|
/// UnorderedList.Item component
pub fn InkUI::unordered_list_item(
  self : InkUI,
  children : Array[&@react.ReactNode],
) -> @react.Element {
  let component = self.as_any().get("UnorderedList").get("Item")
  let props = @js.Object::new()
  let children_arr = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  ffi_create_element(component, props.as_any(), children_arr) |> @js.identity
}

///|
/// OrderedList component - Numbered list
pub fn InkUI::ordered_list(
  self : InkUI,
  children : Array[&@react.ReactNode],
) -> @react.Element {
  let component = self.as_any().get("OrderedList")
  let props = @js.Object::new()
  let children_arr = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  ffi_create_element(component, props.as_any(), children_arr) |> @js.identity
}

///|
/// OrderedList.Item component
pub fn InkUI::ordered_list_item(
  self : InkUI,
  children : Array[&@react.ReactNode],
) -> @react.Element {
  let component = self.as_any().get("OrderedList").get("Item")
  let props = @js.Object::new()
  let children_arr = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  ffi_create_element(component, props.as_any(), children_arr) |> @js.identity
}

// ============================================================
// Theming
// ============================================================

///|
/// Theme type
#external
pub type Theme

///|
pub impl @js.JsImpl for Theme

///|
/// Get the default theme
pub fn InkUI::default_theme(self : InkUI) -> Theme {
  self.as_any().get("defaultTheme") |> @js.identity
}

///|
/// ThemeProvider component - Provides theme to children
pub fn InkUI::theme_provider(
  self : InkUI,
  children : Array[&@react.ReactNode],
  theme : Theme,
) -> @react.Element {
  let component = self.as_any().get("ThemeProvider")
  let props = @js.Object::new()
  props.set("theme", theme.as_any())
  let children_arr = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  ffi_create_element(component, props.as_any(), children_arr) |> @js.identity
}

///|
/// Extend the default theme with custom values
pub fn InkUI::extend_theme(self : InkUI, extension : @js.Any) -> Theme {
  let extend_fn = self.as_any().get("extendTheme")
  extend_fn.call_self([extension]) |> @js.identity
}

// ============================================================
// FFI Helpers
// ============================================================

///|
extern "js" fn ffi_create_element(
  tag : @js.Any,
  props : @js.Any,
  children : @js.Any,
) -> @js.Any =
  #|(tag, props, children) => {
  #|  const React = require('react');
  #|  if (children === undefined) {
  #|    return React.createElement(tag, props);
  #|  }
  #|  return React.createElement(tag, props, ...children);
  #|}

///|
extern "js" fn ffi_wrap_string_callback(f : (String) -> Unit) -> @js.Any =
  #|(f) => f

///|
extern "js" fn ffi_wrap_unit_callback(f : () -> Unit) -> @js.Any =
  #|(f) => f

///|
extern "js" fn ffi_wrap_string_array_callback(
  f : (Array[String]) -> Unit,
) -> @js.Any =
  #|(f) => (arr) => f(Array.from(arr))
