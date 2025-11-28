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
pub impl @js.JsImpl for Ink

///|
/// Dynamic import for ink module (internal)
/// NOTE: This uses dynamic import which doesn't support tree-shaking.
/// When MoonBit adds native ESM support, this should be replaced with static imports.
extern "js" fn import_ink_internal() -> @js.Promise[Ink] =
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
  let text_component = self.to_any().get("Text")
  let props = @js.Object::new()
  if color is Some(c) {
    props.set("color", c)
  }
  if background_color is Some(c) {
    props.set("backgroundColor", c)
  }
  if bold is Some(b) {
    props.set("bold", b)
  }
  if italic is Some(i) {
    props.set("italic", i)
  }
  if underline is Some(u) {
    props.set("underline", u)
  }
  if strikethrough is Some(s) {
    props.set("strikethrough", s)
  }
  if inverse is Some(i) {
    props.set("inverse", i)
  }
  if dim_color is Some(d) {
    props.set("dimColor", d)
  }
  if wrap is Some(w) {
    props.set("wrap", w.to_string())
  }
  let children_arr = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  ffi_create_element(text_component, props.to_any(), children_arr)
  |> @js.identity
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
  let box_component = self.to_any().get("Box")
  let props = @js.Object::new()
  // Dimensions
  if width is Some(w) {
    props.set("width", w)
  }
  if height is Some(h) {
    props.set("height", h)
  }
  if min_width is Some(w) {
    props.set("minWidth", w)
  }
  if min_height is Some(h) {
    props.set("minHeight", h)
  }
  // Padding
  if padding is Some(p) {
    props.set("padding", p)
  }
  if padding_x is Some(p) {
    props.set("paddingX", p)
  }
  if padding_y is Some(p) {
    props.set("paddingY", p)
  }
  if padding_top is Some(p) {
    props.set("paddingTop", p)
  }
  if padding_bottom is Some(p) {
    props.set("paddingBottom", p)
  }
  if padding_left is Some(p) {
    props.set("paddingLeft", p)
  }
  if padding_right is Some(p) {
    props.set("paddingRight", p)
  }
  // Margin
  if margin is Some(m) {
    props.set("margin", m)
  }
  if margin_x is Some(m) {
    props.set("marginX", m)
  }
  if margin_y is Some(m) {
    props.set("marginY", m)
  }
  if margin_top is Some(m) {
    props.set("marginTop", m)
  }
  if margin_bottom is Some(m) {
    props.set("marginBottom", m)
  }
  if margin_left is Some(m) {
    props.set("marginLeft", m)
  }
  if margin_right is Some(m) {
    props.set("marginRight", m)
  }
  // Flex
  if flex_direction is Some(d) {
    props.set("flexDirection", d.to_string())
  }
  if flex_grow is Some(g) {
    props.set("flexGrow", g)
  }
  if flex_shrink is Some(s) {
    props.set("flexShrink", s)
  }
  if flex_basis is Some(b) {
    props.set("flexBasis", b)
  }
  if flex_wrap is Some(w) {
    props.set("flexWrap", w.to_string())
  }
  if justify_content is Some(j) {
    props.set("justifyContent", j.to_string())
  }
  if align_items is Some(a) {
    props.set("alignItems", a.to_string())
  }
  if align_self is Some(a) {
    props.set("alignSelf", a.to_string())
  }
  // Border
  if border_style is Some(s) {
    props.set("borderStyle", s.to_string())
  }
  if border_color is Some(c) {
    props.set("borderColor", c)
  }
  if border_top is Some(b) {
    props.set("borderTop", b)
  }
  if border_bottom is Some(b) {
    props.set("borderBottom", b)
  }
  if border_left is Some(b) {
    props.set("borderLeft", b)
  }
  if border_right is Some(b) {
    props.set("borderRight", b)
  }
  if border_top_color is Some(c) {
    props.set("borderTopColor", c)
  }
  if border_bottom_color is Some(c) {
    props.set("borderBottomColor", c)
  }
  if border_left_color is Some(c) {
    props.set("borderLeftColor", c)
  }
  if border_right_color is Some(c) {
    props.set("borderRightColor", c)
  }
  // Other
  if overflow is Some(o) {
    props.set("overflow", o.to_string())
  }
  if display is Some(d) {
    props.set("display", d.to_string())
  }
  if gap is Some(g) {
    props.set("gap", g)
  }
  if column_gap is Some(g) {
    props.set("columnGap", g)
  }
  if row_gap is Some(g) {
    props.set("rowGap", g)
  }
  let children_arr = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  ffi_create_element(box_component, props.to_any(), children_arr)
  |> @js.identity
}

///|
/// Newline component - renders a newline character
pub fn Ink::newline(self : Ink, count? : Int) -> @react.Element {
  let newline_component = self.to_any().get("Newline")
  let props = @js.Object::new()
  if count is Some(c) {
    props.set("count", c)
  }
  ffi_create_element(newline_component, props.to_any(), @js.undefined())
  |> @js.identity
}

///|
/// Spacer component - fills available space (flex-grow: 1)
pub fn Ink::spacer(self : Ink) -> @react.Element {
  let spacer_component = self.to_any().get("Spacer")
  ffi_create_element(
    spacer_component,
    @js.Object::new().to_any(),
    @js.undefined(),
  )
  |> @js.identity
}

///|
/// Static component - renders content that won't update after initial render
pub fn Ink::static_(
  self : Ink,
  children : Array[&@react.ReactNode],
  items? : Array[@js.Any],
) -> @react.Element {
  let static_component = self.to_any().get("Static")
  let props = @js.Object::new()
  if items is Some(i) {
    props.set("items", i |> @js.from_array)
  }
  let children_arr = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  ffi_create_element(static_component, props.to_any(), children_arr)
  |> @js.identity
}

///|
/// Transform component - applies transformations to output content
pub fn Ink::transform(
  self : Ink,
  children : Array[&@react.ReactNode],
  transform_fn : (String) -> String,
) -> @react.Element {
  let transform_component = self.to_any().get("Transform")
  let props = @js.Object::new()
  let wrapped_fn = ffi_wrap_transform(transform_fn)
  props.set("transform", wrapped_fn)
  let children_arr = children.map(fn(c) { c.to_react_node() }) |> @js.from_array
  ffi_create_element(transform_component, props.to_any(), children_arr)
  |> @js.identity
}

// ============================================================
// FFI
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
extern "js" fn ffi_wrap_transform(f : (String) -> String) -> @js.Any =
  #|(f) => f

// ============================================================
// Render function
// ============================================================

///|
/// Ink instance returned by render
#external
pub type InkInstance

///|
pub impl @js.JsImpl for InkInstance

///|
/// Render a React element to the terminal
pub fn Ink::render(
  self : Ink,
  element : @react.Element,
  stdout? : @js.Any,
  stdin? : @js.Any,
  stderr? : @js.Any,
  debug? : Bool,
  exitOnCtrlC? : Bool,
  patchConsole? : Bool,
  incrementalRendering? : Bool,
  maxFps? : Int,
  onRender? : () -> Unit,
) -> InkInstance {
  let render_fn = self.to_any().get("render")
  let obj = @js.Object::new()
  if stdout is Some(s) {
    obj.set("stdout", s)
  }
  if stdin is Some(s) {
    obj.set("stdin", s)
  }
  if stderr is Some(s) {
    obj.set("stderr", s)
  }
  if debug is Some(d) {
    obj.set("debug", d)
  }
  if exitOnCtrlC is Some(e) {
    obj.set("exitOnCtrlC", e)
  }
  if patchConsole is Some(p) {
    obj.set("patchConsole", p)
  }
  if incrementalRendering is Some(i) {
    obj.set("incrementalRendering", i)
  }
  if maxFps is Some(f) {
    obj.set("maxFps", f)
  }
  if onRender is Some(callback) {
    obj.set("onRender", @js.from_fn0(callback))
  }
  render_fn.call_self([element.to_any(), obj.to_any()]) |> @js.identity
}

///|
/// Rerender with a new element
pub fn InkInstance::rerender(
  self : InkInstance,
  element : @react.Element,
) -> Unit {
  self.to_any().get("rerender").call_self([element.to_any()]) |> ignore
}

///|
/// Unmount the ink instance
pub fn InkInstance::unmount(self : InkInstance) -> Unit {
  self.to_any().get("unmount").call_self([]) |> ignore
}

///|
/// Wait for the instance to finish
pub async fn InkInstance::waitUntilExit(self : InkInstance) -> Unit {
  let promise : @js.Promise[Unit] = self
    .to_any()
    .get("waitUntilExit")
    .call_self([])
    |> @js.identity
  promise.wait()
}

///|
/// Clear the output
pub fn InkInstance::clear(self : InkInstance) -> Unit {
  self.to_any().get("clear").call_self([]) |> ignore
}
