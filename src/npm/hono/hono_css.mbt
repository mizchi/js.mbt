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
/// Get the class name string from CssClass
pub fn CssClass::to_string(self : CssClass) -> String {
  ffi_css_to_string(self.as_any())
}

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

///|
/// Note: css() uses tagged template literal syntax internally
extern "js" fn ffi_css(styles : String) -> @core.Any =
  #|(styles) => require("hono/css").css([styles])

///|
/// Note: keyframes() uses tagged template literal syntax internally
extern "js" fn ffi_keyframes(animation : String) -> @core.Any =
  #|(animation) => require("hono/css").keyframes([animation])

///|
/// Note: cx() uses variadic args, need spread
extern "js" fn ffi_cx(classes : @core.Any) -> @core.Any =
  #|(classes) => require("hono/css").cx(...classes)

///|
/// Note: Style is a component
extern "js" fn ffi_style() -> @core.Any =
  #|() => require("hono/jsx/jsx-runtime").jsxs(require("hono/css").Style, {})

///|
extern "js" fn ffi_style_with_nonce(nonce : String) -> @core.Any =
  #|(nonce) => require("hono/jsx/jsx-runtime").jsxs(require("hono/css").Style, { nonce })

///| Public API

///|
/// Create a CSS class from a style string
/// Returns a CssClass that can be used with jsx class attribute
pub fn css(styles : String) -> CssClass {
  ffi_css(styles).cast()
}

///|
/// Create keyframes animation
/// Returns a CssClass for the animation
pub fn keyframes(animation : String) -> CssClass {
  ffi_keyframes(animation).cast()
}

///|
/// Combine multiple CSS classes
pub fn cx(classes : Array[CssClass]) -> CssClass {
  ffi_cx(@core.any(classes.map(fn(c) { c.as_any() }))).cast()
}

///|
/// Style component - renders collected CSS in head
/// Must be included in the document head for CSS to work
pub fn style_component(nonce? : String) -> JSXNode {
  match nonce {
    Some(n) => ffi_style_with_nonce(n).cast()
    None => ffi_style().cast()
  }
}
