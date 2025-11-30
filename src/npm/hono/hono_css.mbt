///|
/// Hono CSS Helper
/// https://hono.dev/docs/helpers/css

///|
/// CSS class name trait - accepts String or CssClass
/// Used for jsx class attribute
pub trait CssClassName {
  value(Self) -> @nostd.Any = _
}

///|
impl CssClassName with value(self) -> @nostd.Any {
  @nostd.any(self)
}

///|
pub impl CssClassName for String

///|
/// CSS class - wraps the JS css object to preserve callbacks for Style component
#external
pub type CssClass

///|
pub fn CssClass::as_any(self : CssClass) -> @nostd.Any = "%identity"

///|
pub impl CssClassName for CssClass with value(self) {
  self.as_any()
}

///|
/// Get the class name string from CssClass
pub fn CssClass::to_string(self : CssClass) -> String {
  ffi_css_to_string(self.as_any())
}

///|
extern "js" fn ffi_css_to_string(c : @nostd.Any) -> String =
  #|(c) => {
  #|  if (typeof c === 'string') return c;
  #|  const symbols = Object.getOwnPropertySymbols(c);
  #|  for (const s of symbols) {
  #|    const val = c[s];
  #|    if (typeof val === 'string' && val.length > 0) return val;
  #|  }
  #|  return '';
  #|}

///|
/// Create a CSS class from a style string
/// Returns a CssClass that can be used with jsx class attribute
pub fn css(styles : String) -> CssClass {
  ffi_css(styles).cast()
}

///|
extern "js" fn ffi_css(styles : String) -> @nostd.Any =
  #|(styles) => {
  #|  const { css } = require('hono/css');
  #|  return css([styles]);
  #|}

///|
/// Create keyframes animation
/// Returns a CssClass for the animation
pub fn keyframes(animation : String) -> CssClass {
  ffi_keyframes(animation).cast()
}

///|
extern "js" fn ffi_keyframes(animation : String) -> @nostd.Any =
  #|(animation) => {
  #|  const { keyframes } = require('hono/css');
  #|  return keyframes([animation]);
  #|}

///|
/// Combine multiple CSS classes
pub fn cx(classes : Array[CssClass]) -> CssClass {
  ffi_cx(@nostd.any(classes.map(fn(c) { c.as_any() }))).cast()
}

///|
extern "js" fn ffi_cx(classes : @nostd.Any) -> @nostd.Any =
  #|(classes) => {
  #|  const { cx } = require('hono/css');
  #|  return cx(...classes);
  #|}

///|
/// Style component - renders collected CSS in head
/// Must be included in the document head for CSS to work
pub fn style_component(nonce? : String) -> JSXNode {
  match nonce {
    Some(n) => ffi_style_with_nonce(n).cast()
    None => ffi_style().cast()
  }
}

///|
extern "js" fn ffi_style() -> @nostd.Any =
  #|() => {
  #|  const { jsxs } = require('hono/jsx/jsx-runtime');
  #|  const { Style } = require('hono/css');
  #|  return jsxs(Style, {});
  #|}

///|
extern "js" fn ffi_style_with_nonce(nonce : String) -> @nostd.Any =
  #|(nonce) => {
  #|  const { jsxs } = require('hono/jsx/jsx-runtime');
  #|  const { Style } = require('hono/css');
  #|  return jsxs(Style, { nonce });
  #|}
