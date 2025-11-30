///|
/// Hono JSX - Server-side JSX for Hono
/// https://hono.dev/docs/guides/jsx

///|
/// JSX Node type
#external
pub type JSXNode

///|
pub fn JSXNode::as_any(self : JSXNode) -> @nostd.Any = "%identity"

///|
/// HonoNode trait for JSX children
pub trait HonoNode {
  toHonoNode(Self) -> @nostd.Any
}

///|
pub impl HonoNode for JSXNode with toHonoNode(self) {
  self.as_any()
}

///|
pub impl HonoNode for String with toHonoNode(self) {
  @nostd.any(self)
}

///|
pub impl HonoNode for Int with toHonoNode(self) {
  @nostd.any(self)
}

///|
pub impl HonoNode for Double with toHonoNode(self) {
  @nostd.any(self)
}

///|
pub impl HonoNode for Bool with toHonoNode(self) {
  @nostd.any(self)
}

///|
pub impl[T : HonoNode] HonoNode for Array[T] with toHonoNode(self) {
  @nostd.any(self.map(HonoNode::toHonoNode))
}

///|
/// Component function type
pub type FC[T] = (T) -> JSXNode

///|
/// Create a JSX element
/// class parameter accepts String or CssClass via CssClassName trait
#alias(h)
pub fn jsx(
  tag : String,
  children : Array[&HonoNode],
  props? : Map[String, @nostd.Any],
  style? : Map[String, String],
  class? : &CssClassName,
  id? : String,
  key? : String,
) -> JSXNode {
  let tag = @nostd.any(tag)
  let children_arr = @nostd.any(children.map(_.toHonoNode()))
  let val = @nostd.Object::new()
  if props is Some(props) {
    for k, v in props {
      val[k] = v
    }
  }
  if style is Some(style) {
    let style_obj = @nostd.Object::new()
    for k, v in style {
      style_obj[k] = @nostd.any(v)
    }
    val["style"] = style_obj
  }
  if class is Some(c) {
    val["class"] = c.value()
  }
  if id is Some(i) {
    val["id"] = @nostd.any(i)
  }
  if key is Some(k) {
    val["key"] = @nostd.any(k)
  }
  ffi_jsx(tag, val, children_arr)
}

///|
extern "js" fn ffi_jsx(
  tag : @nostd.Any,
  props : @nostd.Any,
  children : @nostd.Any,
) -> JSXNode =
  #|(tag, props, children) => {
  #|  const { jsxs } = require('hono/jsx/jsx-runtime');
  #|  const childArray = Array.isArray(children) ? children : [children];
  #|  const flatChildren = childArray.length === 1 ? childArray[0] : childArray;
  #|  return jsxs(tag, { ...props, children: flatChildren });
  #|}

///|
/// Create element with component function
pub fn[T] jsx_component(
  tag : FC[T],
  props : T,
  children? : Array[&HonoNode] = [],
  key? : String,
) -> JSXNode {
  let tag : @nostd.Any = @nostd.any(tag)
  let children_any = @nostd.any(children.map(_.toHonoNode()))
  let val : @nostd.Any = @nostd.any(props)
  if key is Some(k) {
    if @nostd.is_nullish(val) {
      let obj = @nostd.Object::new()
      obj["key"] = @nostd.any(k)
      obj["children"] = children_any
      return ffi_jsx(tag, obj, children_any)
    }
    val["key"] = @nostd.any(k)
  }
  val["children"] = children_any
  ffi_jsx(tag, val, children_any)
}

///|
/// Fragment - groups elements without extra DOM nodes
pub fn fragment(children : Array[&HonoNode], key? : String) -> JSXNode {
  let children_arr = @nostd.any(children.map(_.toHonoNode()))
  let val = @nostd.Object::new()
  if key is Some(k) {
    val["key"] = @nostd.any(k)
  }
  ffi_jsx(ffi_get_fragment(), val, children_arr)
}

///|
extern "js" fn ffi_get_fragment() -> @nostd.Any =
  #|() => {
  #|  const { Fragment } = require('hono/jsx/jsx-runtime');
  #|  return Fragment;
  #|}

///|
/// Render JSX to string
pub fn render_to_string(node : JSXNode) -> String {
  ffi_render_to_string(node.as_any())
}

///|
extern "js" fn ffi_render_to_string(node : @nostd.Any) -> String =
  #|(node) => {
  #|  if (typeof node === 'string') return node;
  #|  return node.toString();
  #|}

///|
/// Render JSX to ReadableStream (streaming)
pub fn render_to_readable_stream(node : JSXNode) -> @nostd.Any {
  ffi_render_to_readable_stream(node.as_any())
}

///|
extern "js" fn ffi_render_to_readable_stream(node : @nostd.Any) -> @nostd.Any =
  #|(node) => {
  #|  const { renderToReadableStream } = require('hono/jsx/streaming');
  #|  return renderToReadableStream(node);
  #|}

///|
/// Memo - memoize a component
pub fn[T] memo(component : FC[T]) -> FC[T] {
  ffi_memo(@nostd.any(component)).cast()
}

///|
extern "js" fn ffi_memo(component : @nostd.Any) -> @nostd.Any =
  #|(component) => {
  #|  const { memo } = require('hono/jsx');
  #|  return memo(component);
  #|}

///|
/// Context type
#external
pub type HonoContext[T]

///|
pub fn[T] HonoContext::as_any(self : HonoContext[T]) -> @nostd.Any = "%identity"

///|
/// Create a context
pub fn[T] create_context(defaultValue : T?) -> HonoContext[T] {
  ffi_create_context(@nostd.any(defaultValue)).cast()
}

///|
extern "js" fn ffi_create_context(defaultValue : @nostd.Any) -> @nostd.Any =
  #|(defaultValue) => {
  #|  const { createContext } = require('hono/jsx');
  #|  return createContext(defaultValue);
  #|}

///|
/// Use context value
pub fn[T] use_context(ctx : HonoContext[T]) -> T {
  ffi_use_context(ctx.as_any()).cast()
}

///|
extern "js" fn ffi_use_context(ctx : @nostd.Any) -> @nostd.Any =
  #|(ctx) => {
  #|  const { useContext } = require('hono/jsx');
  #|  return useContext(ctx);
  #|}

///|
/// Context Provider
pub fn[T] context_provider(
  ctx : HonoContext[T],
  children : Array[&HonoNode],
  value~ : T,
) -> JSXNode {
  let children_any = @nostd.any(children.map(_.toHonoNode()))
  let props = @nostd.Object::new()
  props["value"] = @nostd.any(value)
  props["children"] = children_any
  ffi_jsx(ffi_get_provider(ctx.as_any()), props, children_any)
}

///|
extern "js" fn ffi_get_provider(ctx : @nostd.Any) -> @nostd.Any =
  #|(ctx) => ctx.Provider

///|
/// Raw HTML - insert unescaped HTML
pub fn raw(html : String) -> JSXNode {
  ffi_raw(html)
}

///|
extern "js" fn ffi_raw(html : String) -> JSXNode =
  #|(html) => {
  #|  const { raw } = require('hono/html');
  #|  return raw(html);
  #|}

///|
/// HTML tagged template helper result
#external
pub type HtmlEscapedString

///|
pub fn HtmlEscapedString::as_any(self : HtmlEscapedString) -> @nostd.Any =
  "%identity"

///|
pub impl HonoNode for HtmlEscapedString with toHonoNode(self) {
  self.as_any()
}

///|
/// Create HTML from template string (escaped)
pub fn html(template : String) -> HtmlEscapedString {
  ffi_html(template)
}

///|
extern "js" fn ffi_html(template : String) -> HtmlEscapedString =
  #|(template) => {
  #|  const { html } = require('hono/html');
  #|  return html([template]);
  #|}

///|
/// Extend Context with JSX html method
pub fn[Env, ExecutionContext] Context::html_jsx(
  self : Context[Env, ExecutionContext],
  node : JSXNode,
  status? : Int,
) -> @http.Response {
  let html_string = render_to_string(node)
  let status_code = match status {
    Some(s) => s
    None => 200
  }
  self.as_any()._call("html", [@nostd.any(html_string), @nostd.any(status_code)]).cast()
}

///|
/// Extend Context with streaming JSX response
pub async fn[Env, ExecutionContext] Context::stream_jsx(
  self : Context[Env, ExecutionContext],
  node : JSXNode,
  status? : Int,
) -> @http.Response {
  let stream = render_to_readable_stream(node)
  let status_code = match status {
    Some(s) => s
    None => 200
  }
  ffi_stream_response(self.as_any(), stream, status_code).wait()
}

///|
extern "js" fn ffi_stream_response(
  ctx : @nostd.Any,
  stream : @nostd.Any,
  status : Int,
) -> @nostd.Promise[@http.Response] =
  #|async (ctx, stream, status) => {
  #|  ctx.status(status);
  #|  ctx.header('Content-Type', 'text/html; charset=UTF-8');
  #|  ctx.header('Transfer-Encoding', 'chunked');
  #|  return new Response(stream);
  #|}
