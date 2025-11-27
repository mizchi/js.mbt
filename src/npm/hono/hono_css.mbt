///|
/// Hono CSS Helper
/// https://hono.dev/docs/helpers/css

///|
/// CSS class name trait - accepts String or CssClass
/// Used for jsx class attribute
pub trait CssClassName {
  value(Self) -> @js.Any = _
}

///|
impl CssClassName with value(self) -> @js.Any {
  self |> @js.identity
}

///|
pub impl CssClassName for String

///|
/// CSS class - wraps the JS css object to preserve callbacks for Style component
#external
pub type CssClass

///|
pub impl @js.JsImpl for CssClass

///|
pub impl CssClassName for CssClass

///|
/// Get the class name string from CssClass
pub fn CssClass::to_string(self : CssClass) -> String {
  ffi_css_to_string(self |> @js.identity)
}

///|
extern "js" fn ffi_css_to_string(c : @js.Any) -> String =
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
  ffi_css(styles) |> @js.identity
}

///|
extern "js" fn ffi_css(styles : String) -> @js.Any =
  #|(styles) => {
  #|  const { css } = require('hono/css');
  #|  return css([styles]);
  #|}

///|
/// Create keyframes animation
/// Returns a CssClass for the animation
pub fn keyframes(animation : String) -> CssClass {
  ffi_keyframes(animation) |> @js.identity
}

///|
extern "js" fn ffi_keyframes(animation : String) -> @js.Any =
  #|(animation) => {
  #|  const { keyframes } = require('hono/css');
  #|  return keyframes([animation]);
  #|}

///|
/// Combine multiple CSS classes
pub fn cx(classes : Array[CssClass]) -> CssClass {
  ffi_cx(classes.map(fn(c) -> @js.Any { c |> @js.identity }) |> @js.from_array)
  |> @js.identity
}

///|
extern "js" fn ffi_cx(classes : @js.Any) -> @js.Any =
  #|(classes) => {
  #|  const { cx } = require('hono/css');
  #|  return cx(...classes);
  #|}

///|
/// Style component - renders collected CSS in head
/// Must be included in the document head for CSS to work
pub fn style_component(nonce? : String) -> JSXNode {
  match nonce {
    Some(n) => ffi_style_with_nonce(n) |> @js.identity
    None => ffi_style() |> @js.identity
  }
}

///|
extern "js" fn ffi_style() -> @js.Any =
  #|() => {
  #|  const { jsxs } = require('hono/jsx/jsx-runtime');
  #|  const { Style } = require('hono/css');
  #|  return jsxs(Style, {});
  #|}

///|
extern "js" fn ffi_style_with_nonce(nonce : String) -> @js.Any =
  #|(nonce) => {
  #|  const { jsxs } = require('hono/jsx/jsx-runtime');
  #|  const { Style } = require('hono/css');
  #|  return jsxs(Style, { nonce });
  #|}
