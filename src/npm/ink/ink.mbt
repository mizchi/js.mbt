///| Ink - React for interactive command-line apps
/// Bindings for https://github.com/vadimdemedes/ink

// ============================================================
// Dynamic Import
// ============================================================

///|
/// Ink module handle
#external
pub type Ink

///|
pub fn Ink::as_any(self : Ink) -> @core.Any = "%identity"

///|
/// Dynamic import for ink module (internal)
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_ink_internal() -> @core.Promise[Ink] =
  #| () => import("ink")

///|
/// Dynamic import for ink module
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
pub async fn dynamic_import() -> Ink {
  import_ink_internal().wait()
}

// ============================================================
// Components
// ============================================================

///|
/// Text wrap options
pub(all) enum TextWrap {
  Wrap
  Truncate
  TruncateStart
  TruncateMiddle
  TruncateEnd
}

///|
pub fn TextWrap::to_string(self : TextWrap) -> String {
  match self {
    Wrap => "wrap"
    Truncate => "truncate"
    TruncateStart => "truncate-start"
    TruncateMiddle => "truncate-middle"
    TruncateEnd => "truncate-end"
  }
}

///|
/// Flex direction options
pub(all) enum FlexDirection {
  Row
  Column
  RowReverse
  ColumnReverse
}

///|
pub fn FlexDirection::to_string(self : FlexDirection) -> String {
  match self {
    Row => "row"
    Column => "column"
    RowReverse => "row-reverse"
    ColumnReverse => "column-reverse"
  }
}

///|
/// Flex wrap options
pub(all) enum FlexWrapMode {
  NoWrap
  Wrap
  WrapReverse
}

///|
pub fn FlexWrapMode::to_string(self : FlexWrapMode) -> String {
  match self {
    NoWrap => "nowrap"
    Wrap => "wrap"
    WrapReverse => "wrap-reverse"
  }
}

///|
/// Justify content options
pub(all) enum JustifyContent {
  FlexStart
  FlexEnd
  Center
  SpaceBetween
  SpaceAround
  SpaceEvenly
}

///|
pub fn JustifyContent::to_string(self : JustifyContent) -> String {
  match self {
    FlexStart => "flex-start"
    FlexEnd => "flex-end"
    Center => "center"
    SpaceBetween => "space-between"
    SpaceAround => "space-around"
    SpaceEvenly => "space-evenly"
  }
}

///|
/// Align items options
pub(all) enum AlignItems {
  FlexStart
  FlexEnd
  Center
  Stretch
}

///|
pub fn AlignItems::to_string(self : AlignItems) -> String {
  match self {
    FlexStart => "flex-start"
    FlexEnd => "flex-end"
    Center => "center"
    Stretch => "stretch"
  }
}

///|
/// Align self options
pub(all) enum AlignSelf {
  Auto
  FlexStart
  FlexEnd
  Center
  Stretch
}

///|
pub fn AlignSelf::to_string(self : AlignSelf) -> String {
  match self {
    Auto => "auto"
    FlexStart => "flex-start"
    FlexEnd => "flex-end"
    Center => "center"
    Stretch => "stretch"
  }
}

///|
/// Border style options
pub(all) enum BorderStyle {
  Single
  Double
  Round
  Bold
  SingleDouble
  DoubleSingle
  Classic
  Arrow
}

///|
pub fn BorderStyle::to_string(self : BorderStyle) -> String {
  match self {
    Single => "single"
    Double => "double"
    Round => "round"
    Bold => "bold"
    SingleDouble => "singleDouble"
    DoubleSingle => "doubleSingle"
    Classic => "classic"
    Arrow => "arrow"
  }
}

///|
/// Overflow options
pub(all) enum Overflow {
  Visible
  Hidden
}

///|
pub fn Overflow::to_string(self : Overflow) -> String {
  match self {
    Visible => "visible"
    Hidden => "hidden"
  }
}

///|
/// Display options
pub(all) enum Display {
  Flex
  None
}

///|
pub fn Display::to_string(self : Display) -> String {
  match self {
    Flex => "flex"
    None => "none"
  }
}

///|
/// Text component for displaying styled text in the terminal
/// Only accepts text nodes and nested <Text> components
pub fn Ink::text(
  self : Ink,
  children : Array[&@react.ReactNode],
  color? : String,
  background_color? : String,
  bold? : Bool,
  italic? : Bool,
  underline? : Bool,
  strikethrough? : Bool,
  inverse? : Bool,
  dim_color? : Bool,
  wrap? : TextWrap,
) -> @react.Element {
  let text_component = self.as_any()["Text"]
  let props = @core.new_object()
  if color is Some(c) {
    props["color"] = @core.any(c)
  }
  if background_color is Some(c) {
    props["backgroundColor"] = @core.any(c)
  }
  if bold is Some(b) {
    props["bold"] = @core.any(b)
  }
  if italic is Some(i) {
    props["italic"] = @core.any(i)
  }
  if underline is Some(u) {
    props["underline"] = @core.any(u)
  }
  if strikethrough is Some(s) {
    props["strikethrough"] = @core.any(s)
  }
  if inverse is Some(i) {
    props["inverse"] = @core.any(i)
  }
  if dim_color is Some(d) {
    props["dimColor"] = @core.any(d)
  }
  if wrap is Some(w) {
    props["wrap"] = @core.any(w.to_string())
  }
  let children_arr = @core.any(children.map(fn(c) { c.to_react_node() }))
  ffi_create_element(text_component, props, children_arr).cast()
}

///|
/// Box component for layout using Flexbox
pub fn Ink::box_(
  self : Ink,
  children : Array[&@react.ReactNode],
  // Dimensions
  width? : Int,
  height? : Int,
  min_width? : Int,
  min_height? : Int,
  // Padding
  padding? : Int,
  padding_x? : Int,
  padding_y? : Int,
  padding_top? : Int,
  padding_bottom? : Int,
  padding_left? : Int,
  padding_right? : Int,
  // Margin
  margin? : Int,
  margin_x? : Int,
  margin_y? : Int,
  margin_top? : Int,
  margin_bottom? : Int,
  margin_left? : Int,
  margin_right? : Int,
  // Flex
  flex_direction? : FlexDirection,
  flex_grow? : Int,
  flex_shrink? : Int,
  flex_basis? : Int,
  flex_wrap? : FlexWrapMode,
  justify_content? : JustifyContent,
  align_items? : AlignItems,
  align_self? : AlignSelf,
  // Border
  border_style? : BorderStyle,
  border_color? : String,
  border_top? : Bool,
  border_bottom? : Bool,
  border_left? : Bool,
  border_right? : Bool,
  border_top_color? : String,
  border_bottom_color? : String,
  border_left_color? : String,
  border_right_color? : String,
  // Other
  overflow? : Overflow,
  display? : Display,
  gap? : Int,
  column_gap? : Int,
  row_gap? : Int,
) -> @react.Element {
  let box_component = self.as_any()["Box"]
  let props = @core.new_object()
  // Dimensions
  if width is Some(w) {
    props["width"] = @core.any(w)
  }
  if height is Some(h) {
    props["height"] = @core.any(h)
  }
  if min_width is Some(w) {
    props["minWidth"] = @core.any(w)
  }
  if min_height is Some(h) {
    props["minHeight"] = @core.any(h)
  }
  // Padding
  if padding is Some(p) {
    props["padding"] = @core.any(p)
  }
  if padding_x is Some(p) {
    props["paddingX"] = @core.any(p)
  }
  if padding_y is Some(p) {
    props["paddingY"] = @core.any(p)
  }
  if padding_top is Some(p) {
    props["paddingTop"] = @core.any(p)
  }
  if padding_bottom is Some(p) {
    props["paddingBottom"] = @core.any(p)
  }
  if padding_left is Some(p) {
    props["paddingLeft"] = @core.any(p)
  }
  if padding_right is Some(p) {
    props["paddingRight"] = @core.any(p)
  }
  // Margin
  if margin is Some(m) {
    props["margin"] = @core.any(m)
  }
  if margin_x is Some(m) {
    props["marginX"] = @core.any(m)
  }
  if margin_y is Some(m) {
    props["marginY"] = @core.any(m)
  }
  if margin_top is Some(m) {
    props["marginTop"] = @core.any(m)
  }
  if margin_bottom is Some(m) {
    props["marginBottom"] = @core.any(m)
  }
  if margin_left is Some(m) {
    props["marginLeft"] = @core.any(m)
  }
  if margin_right is Some(m) {
    props["marginRight"] = @core.any(m)
  }
  // Flex
  if flex_direction is Some(d) {
    props["flexDirection"] = @core.any(d.to_string())
  }
  if flex_grow is Some(g) {
    props["flexGrow"] = @core.any(g)
  }
  if flex_shrink is Some(s) {
    props["flexShrink"] = @core.any(s)
  }
  if flex_basis is Some(b) {
    props["flexBasis"] = @core.any(b)
  }
  if flex_wrap is Some(w) {
    props["flexWrap"] = @core.any(w.to_string())
  }
  if justify_content is Some(j) {
    props["justifyContent"] = @core.any(j.to_string())
  }
  if align_items is Some(a) {
    props["alignItems"] = @core.any(a.to_string())
  }
  if align_self is Some(a) {
    props["alignSelf"] = @core.any(a.to_string())
  }
  // Border
  if border_style is Some(s) {
    props["borderStyle"] = @core.any(s.to_string())
  }
  if border_color is Some(c) {
    props["borderColor"] = @core.any(c)
  }
  if border_top is Some(b) {
    props["borderTop"] = @core.any(b)
  }
  if border_bottom is Some(b) {
    props["borderBottom"] = @core.any(b)
  }
  if border_left is Some(b) {
    props["borderLeft"] = @core.any(b)
  }
  if border_right is Some(b) {
    props["borderRight"] = @core.any(b)
  }
  if border_top_color is Some(c) {
    props["borderTopColor"] = @core.any(c)
  }
  if border_bottom_color is Some(c) {
    props["borderBottomColor"] = @core.any(c)
  }
  if border_left_color is Some(c) {
    props["borderLeftColor"] = @core.any(c)
  }
  if border_right_color is Some(c) {
    props["borderRightColor"] = @core.any(c)
  }
  // Other
  if overflow is Some(o) {
    props["overflow"] = @core.any(o.to_string())
  }
  if display is Some(d) {
    props["display"] = @core.any(d.to_string())
  }
  if gap is Some(g) {
    props["gap"] = @core.any(g)
  }
  if column_gap is Some(g) {
    props["columnGap"] = @core.any(g)
  }
  if row_gap is Some(g) {
    props["rowGap"] = @core.any(g)
  }
  let children_arr = @core.any(children.map(fn(c) { c.to_react_node() }))
  ffi_create_element(box_component, props, children_arr).cast()
}

///|
/// Newline component - renders a newline character
pub fn Ink::newline(self : Ink, count? : Int) -> @react.Element {
  let newline_component = self.as_any()["Newline"]
  let props = @core.new_object()
  if count is Some(c) {
    props["count"] = @core.any(c)
  }
  ffi_create_element(newline_component, props, @core.undefined()).cast()
}

///|
/// Spacer component - fills available space (flex-grow: 1)
pub fn Ink::spacer(self : Ink) -> @react.Element {
  let spacer_component = self.as_any()["Spacer"]
  ffi_create_element(spacer_component, @core.new_object(), @core.undefined()).cast()
}

///|
/// Static component - renders content that won't update after initial render
pub fn Ink::static_(
  self : Ink,
  children : Array[&@react.ReactNode],
  items? : Array[@core.Any],
) -> @react.Element {
  let static_component = self.as_any()["Static"]
  let props = @core.new_object()
  if items is Some(i) {
    props["items"] = @core.any(i)
  }
  let children_arr = @core.any(children.map(fn(c) { c.to_react_node() }))
  ffi_create_element(static_component, props, children_arr).cast()
}

///|
/// Transform component - applies transformations to output content
pub fn Ink::transform(
  self : Ink,
  children : Array[&@react.ReactNode],
  transform_fn : (String) -> String,
) -> @react.Element {
  let transform_component = self.as_any()["Transform"]
  let props = @core.new_object()
  let wrapped_fn = ffi_wrap_transform(transform_fn)
  props["transform"] = wrapped_fn
  let children_arr = @core.any(children.map(fn(c) { c.to_react_node() }))
  ffi_create_element(transform_component, props, children_arr).cast()
}

// ============================================================
// FFI
// ============================================================

///|
extern "js" fn ffi_create_element(
  tag : @core.Any,
  props : @core.Any,
  children : @core.Any,
) -> @core.Any =
  #|(tag, props, children) => {
  #|  const React = require('react');
  #|  if (children === undefined) {
  #|    return React.createElement(tag, props);
  #|  }
  #|  return React.createElement(tag, props, ...children);
  #|}

///|
extern "js" fn ffi_wrap_transform(f : (String) -> String) -> @core.Any =
  #|(f) => f

///|
extern "js" fn ffi_call_fn2(
  fn_ : @core.Any,
  arg1 : @core.Any,
  arg2 : @core.Any,
) -> @core.Any =
  #|(fn, a1, a2) => fn(a1, a2)

///|
extern "js" fn ffi_call_fn1(fn_ : @core.Any, arg : @core.Any) -> @core.Any =
  #|(fn, a) => fn(a)

///|
extern "js" fn ffi_call_fn0(fn_ : @core.Any) -> @core.Any =
  #|(fn) => fn()

// ============================================================
// Render function
// ============================================================

///|
/// Ink instance returned by render
#external
pub type InkInstance

///|
pub fn InkInstance::as_any(self : InkInstance) -> @core.Any = "%identity"

///|
/// Render a React element to the terminal
pub fn Ink::render(
  self : Ink,
  element : @react.Element,
  stdout? : @core.Any,
  stdin? : @core.Any,
  stderr? : @core.Any,
  debug? : Bool,
  exitOnCtrlC? : Bool,
  patchConsole? : Bool,
  incrementalRendering? : Bool,
  maxFps? : Int,
  onRender? : () -> Unit,
) -> InkInstance {
  let render_fn = self.as_any()["render"]
  let obj = @core.new_object()
  if stdout is Some(s) {
    obj["stdout"] = s
  }
  if stdin is Some(s) {
    obj["stdin"] = s
  }
  if stderr is Some(s) {
    obj["stderr"] = s
  }
  if debug is Some(d) {
    obj["debug"] = @core.any(d)
  }
  if exitOnCtrlC is Some(e) {
    obj["exitOnCtrlC"] = @core.any(e)
  }
  if patchConsole is Some(p) {
    obj["patchConsole"] = @core.any(p)
  }
  if incrementalRendering is Some(i) {
    obj["incrementalRendering"] = @core.any(i)
  }
  if maxFps is Some(f) {
    obj["maxFps"] = @core.any(f)
  }
  if onRender is Some(callback) {
    obj["onRender"] = @core.any(callback)
  }
  ffi_call_fn2(render_fn, element.as_any(), obj).cast()
}

///|
/// Rerender with a new element
pub fn InkInstance::rerender(
  self : InkInstance,
  element : @react.Element,
) -> Unit {
  ffi_call_fn1(self.as_any()["rerender"], element.as_any()) |> ignore
}

///|
/// Unmount the ink instance
pub fn InkInstance::unmount(self : InkInstance) -> Unit {
  ffi_call_fn0(self.as_any()["unmount"]) |> ignore
}

///|
/// Wait for the instance to finish
pub async fn InkInstance::waitUntilExit(self : InkInstance) -> Unit {
  let promise : @core.Promise[Unit] = ffi_call_fn0(
    self.as_any()["waitUntilExit"],
  ).cast()
  promise.wait()
}

///|
/// Clear the output
pub fn InkInstance::clear(self : InkInstance) -> Unit {
  ffi_call_fn0(self.as_any()["clear"]) |> ignore
}
