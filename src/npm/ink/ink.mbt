///| Ink - React for interactive command-line apps
/// Bindings for https://github.com/vadimdemedes/ink

// ============================================================
// FFI - Direct module bindings
// ============================================================

///|
#module("ink")
extern "js" fn ffi_render(
  element : @core.Any,
  options : @core.Any,
) -> @core.Any = "render"

///|
#module("ink")
extern "js" fn ffi_Text() -> @core.Any = "Text"

///|
#module("ink")
extern "js" fn ffi_Box() -> @core.Any = "Box"

///|
#module("ink")
extern "js" fn ffi_Newline() -> @core.Any = "Newline"

///|
#module("ink")
extern "js" fn ffi_Spacer() -> @core.Any = "Spacer"

///|
#module("ink")
extern "js" fn ffi_Static() -> @core.Any = "Static"

///|
#module("ink")
extern "js" fn ffi_Transform() -> @core.Any = "Transform"

///|
#module("ink")
extern "js" fn ffi_useInput(handler : @core.Any, options : @core.Any) -> Unit = "useInput"

///|
#module("ink")
extern "js" fn ffi_useApp() -> @core.Any = "useApp"

///|
#module("ink")
extern "js" fn ffi_useFocus(options : @core.Any) -> @core.Any = "useFocus"

///|
#module("ink")
extern "js" fn ffi_useFocusManager() -> @core.Any = "useFocusManager"

///|
#module("ink")
extern "js" fn ffi_useStdin() -> @core.Any = "useStdin"

///|
#module("ink")
extern "js" fn ffi_useStdout() -> @core.Any = "useStdout"

///|
#module("ink")
extern "js" fn ffi_useStderr() -> @core.Any = "useStderr"

// ============================================================
// Components (exposed as getters for createElement)
// ============================================================

///|
/// Get Text component
pub fn text_component() -> @core.Any {
  ffi_Text()
}

///|
/// Get Box component
pub fn box_component() -> @core.Any {
  ffi_Box()
}

///|
/// Get Newline component
pub fn newline_component() -> @core.Any {
  ffi_Newline()
}

///|
/// Get Spacer component
pub fn spacer_component() -> @core.Any {
  ffi_Spacer()
}

///|
/// Get Static component
pub fn static_component() -> @core.Any {
  ffi_Static()
}

///|
/// Get Transform component
pub fn transform_component() -> @core.Any {
  ffi_Transform()
}

// ============================================================
// Enums for component options
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

// ============================================================
// Component helper functions
// ============================================================

///|
/// Text component for displaying styled text in the terminal
/// Only accepts text nodes and nested <Text> components
pub fn text(
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
  props["children"] = @core.any(children.map(fn(c) { c.to_react_node() }))
  @react.createElementRaw(ffi_Text(), props)
}

///|
/// Box component for layout using Flexbox
pub fn box_(
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
  props["children"] = @core.any(children.map(fn(c) { c.to_react_node() }))
  @react.createElementRaw(ffi_Box(), props)
}

///|
/// Newline component - renders a newline character
pub fn newline(count? : Int) -> @react.Element {
  let props = @core.new_object()
  if count is Some(c) {
    props["count"] = @core.any(c)
  }
  @react.createElementRaw(ffi_Newline(), props)
}

///|
/// Spacer component - fills available space (flex-grow: 1)
pub fn spacer() -> @react.Element {
  @react.createElementRaw(ffi_Spacer(), @core.new_object())
}

///|
/// Static component - renders content that won't update after initial render
pub fn static_(
  children : Array[&@react.ReactNode],
  items? : Array[@core.Any],
) -> @react.Element {
  let props = @core.new_object()
  if items is Some(i) {
    props["items"] = @core.any(i)
  }
  props["children"] = @core.any(children.map(fn(c) { c.to_react_node() }))
  @react.createElementRaw(ffi_Static(), props)
}

///|
extern "js" fn ffi_wrap_transform(f : (String) -> String) -> @core.Any =
  #|(f) => f

///|
/// Transform component - applies transformations to output content
pub fn transform(
  children : Array[&@react.ReactNode],
  transform_fn : (String) -> String,
) -> @react.Element {
  let props = @core.new_object()
  props["transform"] = ffi_wrap_transform(transform_fn)
  props["children"] = @core.any(children.map(fn(c) { c.to_react_node() }))
  @react.createElementRaw(ffi_Transform(), props)
}

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
pub fn render(
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
  ffi_render(element.as_any(), obj).cast()
}

///|
extern "js" fn ffi_call_fn1(fn_ : @core.Any, arg : @core.Any) -> @core.Any =
  #|(fn, a) => fn(a)

///|
extern "js" fn ffi_call_fn0(fn_ : @core.Any) -> @core.Any =
  #|(fn) => fn()

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

// ============================================================
// Hooks
// ============================================================

///|
/// Input handler info
#external
pub type InputInfo

///|
pub fn InputInfo::as_any(self : InputInfo) -> @core.Any = "%identity"

///|
/// useInput hook - handle keyboard input
pub fn useInput(
  handler : (String, InputInfo) -> Unit,
  isActive? : Bool,
) -> Unit {
  let opts = @core.new_object()
  if isActive is Some(a) {
    opts["isActive"] = @core.any(a)
  }
  ffi_useInput(handler |> @core.identity, opts)
}

///|
/// App context returned by useApp
#external
pub type AppContext

///|
pub fn AppContext::as_any(self : AppContext) -> @core.Any = "%identity"

///|
/// Exit the app
pub fn AppContext::exit(self : AppContext, error? : @core.Any) -> Unit {
  match error {
    Some(e) => ffi_call_fn1(self.as_any()["exit"], e) |> ignore
    None => ffi_call_fn0(self.as_any()["exit"]) |> ignore
  }
}

///|
/// useApp hook - access app context
pub fn useApp() -> AppContext {
  ffi_useApp().cast()
}

///|
/// Focus context returned by useFocus
#external
pub type FocusContext

///|
pub fn FocusContext::as_any(self : FocusContext) -> @core.Any = "%identity"

///|
/// Check if focused
pub fn FocusContext::isFocused(self : FocusContext) -> Bool {
  self.as_any()["isFocused"].cast()
}

///|
/// useFocus hook - manage focus
pub fn useFocus(
  autoFocus? : Bool,
  isActive? : Bool,
  id? : String,
) -> FocusContext {
  let opts = @core.new_object()
  if autoFocus is Some(a) {
    opts["autoFocus"] = @core.any(a)
  }
  if isActive is Some(a) {
    opts["isActive"] = @core.any(a)
  }
  if id is Some(i) {
    opts["id"] = @core.any(i)
  }
  ffi_useFocus(opts).cast()
}

///|
/// Focus manager returned by useFocusManager
#external
pub type FocusManager

///|
pub fn FocusManager::as_any(self : FocusManager) -> @core.Any = "%identity"

///|
/// Focus next element
pub fn FocusManager::focusNext(self : FocusManager) -> Unit {
  ffi_call_fn0(self.as_any()["focusNext"]) |> ignore
}

///|
/// Focus previous element
pub fn FocusManager::focusPrevious(self : FocusManager) -> Unit {
  ffi_call_fn0(self.as_any()["focusPrevious"]) |> ignore
}

///|
/// Focus specific element by id
pub fn FocusManager::focus(self : FocusManager, id : String) -> Unit {
  ffi_call_fn1(self.as_any()["focus"], @core.any(id)) |> ignore
}

///|
/// useFocusManager hook - manage focus programmatically
pub fn useFocusManager() -> FocusManager {
  ffi_useFocusManager().cast()
}

///|
/// Stdin context returned by useStdin
#external
pub type StdinContext

///|
pub fn StdinContext::as_any(self : StdinContext) -> @core.Any = "%identity"

///|
/// Get stdin stream
pub fn StdinContext::stdin(self : StdinContext) -> @core.Any {
  self.as_any()["stdin"]
}

///|
/// Check if raw mode is supported
pub fn StdinContext::isRawModeSupported(self : StdinContext) -> Bool {
  self.as_any()["isRawModeSupported"].cast()
}

///|
/// Set raw mode
pub fn StdinContext::setRawMode(self : StdinContext, value : Bool) -> Unit {
  ffi_call_fn1(self.as_any()["setRawMode"], @core.any(value)) |> ignore
}

///|
/// useStdin hook - access stdin
pub fn useStdin() -> StdinContext {
  ffi_useStdin().cast()
}

///|
/// Stdout context returned by useStdout
#external
pub type StdoutContext

///|
pub fn StdoutContext::as_any(self : StdoutContext) -> @core.Any = "%identity"

///|
/// Get stdout stream
pub fn StdoutContext::stdout(self : StdoutContext) -> @core.Any {
  self.as_any()["stdout"]
}

///|
/// Write to stdout
pub fn StdoutContext::write(self : StdoutContext, data : String) -> Unit {
  ffi_call_fn1(self.as_any()["write"], @core.any(data)) |> ignore
}

///|
/// useStdout hook - access stdout
pub fn useStdout() -> StdoutContext {
  ffi_useStdout().cast()
}

///|
/// Stderr context returned by useStderr
#external
pub type StderrContext

///|
pub fn StderrContext::as_any(self : StderrContext) -> @core.Any = "%identity"

///|
/// Get stderr stream
pub fn StderrContext::stderr(self : StderrContext) -> @core.Any {
  self.as_any()["stderr"]
}

///|
/// Write to stderr
pub fn StderrContext::write(self : StderrContext, data : String) -> Unit {
  ffi_call_fn1(self.as_any()["write"], @core.any(data)) |> ignore
}

///|
/// useStderr hook - access stderr
pub fn useStderr() -> StderrContext {
  ffi_useStderr().cast()
}

// ============================================================
// Deprecated - for backwards compatibility
// ============================================================

///|
/// @deprecated Use direct functions instead (text, box_, etc.)
#external
pub type Ink

///|
/// @deprecated No longer needed
pub fn Ink::as_any(self : Ink) -> @core.Any = "%identity"

///|
/// @deprecated Use direct functions instead
pub async fn dynamic_import() -> Ink {
  @core.undefined().cast()
}

///|
/// @deprecated Use text() directly
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
  let _ = self
  text(
    children,
    color?,
    background_color?,
    bold?,
    italic?,
    underline?,
    strikethrough?,
    inverse?,
    dim_color?,
    wrap?,
  )
}

///|
/// @deprecated Use box_() directly
pub fn Ink::box_(
  self : Ink,
  children : Array[&@react.ReactNode],
  width? : Int,
  height? : Int,
  min_width? : Int,
  min_height? : Int,
  padding? : Int,
  padding_x? : Int,
  padding_y? : Int,
  padding_top? : Int,
  padding_bottom? : Int,
  padding_left? : Int,
  padding_right? : Int,
  margin? : Int,
  margin_x? : Int,
  margin_y? : Int,
  margin_top? : Int,
  margin_bottom? : Int,
  margin_left? : Int,
  margin_right? : Int,
  flex_direction? : FlexDirection,
  flex_grow? : Int,
  flex_shrink? : Int,
  flex_basis? : Int,
  flex_wrap? : FlexWrapMode,
  justify_content? : JustifyContent,
  align_items? : AlignItems,
  align_self? : AlignSelf,
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
  overflow? : Overflow,
  display? : Display,
  gap? : Int,
  column_gap? : Int,
  row_gap? : Int,
) -> @react.Element {
  let _ = self
  box_(
    children,
    width?,
    height?,
    min_width?,
    min_height?,
    padding?,
    padding_x?,
    padding_y?,
    padding_top?,
    padding_bottom?,
    padding_left?,
    padding_right?,
    margin?,
    margin_x?,
    margin_y?,
    margin_top?,
    margin_bottom?,
    margin_left?,
    margin_right?,
    flex_direction?,
    flex_grow?,
    flex_shrink?,
    flex_basis?,
    flex_wrap?,
    justify_content?,
    align_items?,
    align_self?,
    border_style?,
    border_color?,
    border_top?,
    border_bottom?,
    border_left?,
    border_right?,
    border_top_color?,
    border_bottom_color?,
    border_left_color?,
    border_right_color?,
    overflow?,
    display?,
    gap?,
    column_gap?,
    row_gap?,
  )
}

///|
/// @deprecated Use newline() directly
pub fn Ink::newline(self : Ink, count? : Int) -> @react.Element {
  let _ = self
  newline(count?)
}

///|
/// @deprecated Use spacer() directly
pub fn Ink::spacer(self : Ink) -> @react.Element {
  let _ = self
  spacer()
}

///|
/// @deprecated Use static_() directly
pub fn Ink::static_(
  self : Ink,
  children : Array[&@react.ReactNode],
  items? : Array[@core.Any],
) -> @react.Element {
  let _ = self
  static_(children, items?)
}

///|
/// @deprecated Use transform() directly
pub fn Ink::transform(
  self : Ink,
  children : Array[&@react.ReactNode],
  transform_fn : (String) -> String,
) -> @react.Element {
  let _ = self
  transform(children, transform_fn)
}

///|
/// @deprecated Use render() directly
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
  let _ = self
  render(
    element,
    stdout?,
    stdin?,
    stderr?,
    debug?,
    exitOnCtrlC?,
    patchConsole?,
    incrementalRendering?,
    maxFps?,
    onRender?,
  )
}
