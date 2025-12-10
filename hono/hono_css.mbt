///|
/// Hono CSS Helper
/// https://hono.dev/docs/helpers/css

///|
/// CSS class name trait - accepts String or CssClass
/// Used for jsx class attribute
pub trait CssClassName {
  value(Self) -> @core.Any = _
}

///|
impl CssClassName with value(self) -> @core.Any {
  @core.any(self)
}

///|
pub impl CssClassName for String

///|
/// CSS class - wraps the JS css object to preserve callbacks for Style component
#external
pub type CssClass

///|
pub fn CssClass::as_any(self : CssClass) -> @core.Any = "%identity"

///|
pub impl CssClassName for CssClass with value(self) {
  self.as_any()
}

///| FFI

///|
extern "js" fn ffi_import_hono_css() -> @js.Promise[@core.Any] =
  #|() => import("hono/css")

///|
/// jsxs for Style component - uses #module for ESM compatibility
#module("hono/jsx/jsx-runtime")
extern "js" fn ffi_jsxs(component : @core.Any, props : @core.Any) -> @core.Any = "jsxs"

///|
extern "js" fn ffi_css_to_string(c : @core.Any) -> String =
  #|(c) => {
  #|  if (typeof c === 'string') return c;
  #|  const symbols = Object.getOwnPropertySymbols(c);
  #|  for (const s of symbols) {
  #|    const val = c[s];
  #|    if (typeof val === 'string' && val.length > 0) return val;
  #|  }
  #|  return '';
  #|}

///| HonoCss type - initialized instance

///|
#external
pub type HonoCss

///|
extern "js" fn ffi_hono_css_css(
  m : HonoCss,
  template : String,
  args : Array[@core.Any],
) -> @core.Any =
  #|(m, template, args) => {
  #|  const [strings, values] = template.split(/\$\{@(\d+)\}/).reduce(
  #|    ([s, v], x, i) => i % 2 ? [s, [...v, args[+x]]] : [[...s, x], v], [[], []]
  #|  );
  #|  return m.css((strings.raw = strings, strings), ...values);
  #|}

///|
extern "js" fn ffi_hono_css_keyframes(
  m : HonoCss,
  template : String,
  args : Array[@core.Any],
) -> @core.Any =
  #|(m, template, args) => {
  #|  const [strings, values] = template.split(/\$\{@(\d+)\}/).reduce(
  #|    ([s, v], x, i) => i % 2 ? [s, [...v, args[+x]]] : [[...s, x], v], [[], []]
  #|  );
  #|  return m.keyframes((strings.raw = strings, strings), ...values);
  #|}

///|
extern "js" fn ffi_hono_css_cx(m : HonoCss, classes : @core.Any) -> @core.Any =
  #|(m, classes) => m.cx(...classes)

///|
extern "js" fn ffi_hono_css_style(m : HonoCss) -> @core.Any =
  #|(m) => m.Style

///| Public API

///|
/// Import hono/css module
pub async fn import_hono_css() -> HonoCss {
  ffi_import_hono_css().wait().cast()
}

///|
/// Get the class name string from CssClass
pub fn CssClass::to_string(self : CssClass) -> String {
  ffi_css_to_string(self.as_any())
}

///|
/// Create a CSS class using tagged template syntax.
///
/// Template format uses `${@0}`, `${@1}`, etc. as placeholders for interpolation.
/// Returns a CssClass that can be used with jsx class attribute.
///
/// # Example
///
/// ```moonbit
/// // Simple usage without interpolation
/// let cls = hono_css.css("color: red")
///
/// // With interpolation
///
/// let color = "blue"
///
/// let size = 16
///
/// let cls = hono_css.css("color: ${@0}; font-size: ${@1}px", args=[
///   @core.any(color),
///   @core.any(size),
/// ])
/// ```
pub fn HonoCss::css(
  self : HonoCss,
  template : String,
  args? : Array[@core.Any] = [],
) -> CssClass {
  ffi_hono_css_css(self, template, args).cast()
}

///|
/// Create keyframes animation using tagged template syntax.
///
/// Template format uses `${@0}`, `${@1}`, etc. as placeholders for interpolation.
/// Returns a CssClass for the animation.
///
/// # Example
///
/// ```moonbit
/// // Simple usage
/// let anim = hono_css.keyframes("from { opacity: 0 } to { opacity: 1 }")
///
/// // With interpolation
///
/// let start = 0.5
///
/// let end = 1.0
///
/// let anim = hono_css.keyframes(
///   "from { transform: scale(${@0}) } to { transform: scale(${@1}) }",
///   args=[@core.any(start), @core.any(end)],
/// )
/// ```
pub fn HonoCss::keyframes(
  self : HonoCss,
  template : String,
  args? : Array[@core.Any] = [],
) -> CssClass {
  ffi_hono_css_keyframes(self, template, args).cast()
}

///|
/// Combine multiple CSS classes
pub fn HonoCss::cx(self : HonoCss, classes : Array[CssClass]) -> CssClass {
  ffi_hono_css_cx(self, @core.any(classes.map(fn(c) { c.as_any() }))).cast()
}

///|
/// Style component - renders collected CSS in head
/// Must be included in the document head for CSS to work
pub fn HonoCss::style_component(self : HonoCss, nonce? : String) -> JSXNode {
  let props = @core.new_object()
  if nonce is Some(n) {
    props["nonce"] = @core.any(n)
  }
  ffi_jsxs(ffi_hono_css_style(self), props).cast()
}
