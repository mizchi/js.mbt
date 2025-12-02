///|
/// Hono JSX - Server-side JSX for Hono
/// https://hono.dev/docs/guides/jsx

///|
/// JSX Node type
#external
pub type JSXNode

///|
pub fn JSXNode::as_any(self : JSXNode) -> @core.Any = "%identity"

///|
/// HonoNode trait for JSX children
pub trait HonoNode {
  toHonoNode(Self) -> @core.Any
}

///|
pub impl HonoNode for JSXNode with toHonoNode(self) {
  self.as_any()
}

///|
pub impl HonoNode for String with toHonoNode(self) {
  @core.any(self)
}

///|
pub impl HonoNode for Int with toHonoNode(self) {
  @core.any(self)
}

///|
pub impl HonoNode for Double with toHonoNode(self) {
  @core.any(self)
}

///|
pub impl HonoNode for Bool with toHonoNode(self) {
  @core.any(self)
}

///|
pub impl[T : HonoNode] HonoNode for Array[T] with toHonoNode(self) {
  @core.any(self.map(HonoNode::toHonoNode))
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
  props? : Map[String, @core.Any],
  style? : Map[String, String],
  class? : &CssClassName,
  id? : String,
  key? : String,
) -> JSXNode {
  let tag = @core.any(tag)
  let children_arr = @core.any(children.map(_.toHonoNode()))
  let val = @core.new_object()
  if props is Some(props) {
    for k, v in props {
      val[k] = v
    }
  }
  if style is Some(style) {
    let style_obj = @core.new_object()
    for k, v in style {
      style_obj[k] = @core.any(v)
    }
    val["style"] = style_obj
  }
  if class is Some(c) {
    val["class"] = c.value()
  }
  if id is Some(i) {
    val["id"] = @core.any(i)
  }
  if key is Some(k) {
    val["key"] = @core.any(k)
  }
  ffi_jsx(tag, val, children_arr)
}

///|
extern "js" fn ffi_jsx(
  tag : @core.Any,
  props : @core.Any,
  children : @core.Any,
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
  let tag : @core.Any = @core.any(tag)
  let children_any = @core.any(children.map(_.toHonoNode()))
  let val : @core.Any = @core.any(props)
  if key is Some(k) {
    if @core.is_nullish(val) {
      let obj = @core.new_object()
      obj["key"] = @core.any(k)
      obj["children"] = children_any
      return ffi_jsx(tag, obj, children_any)
    }
    val["key"] = @core.any(k)
  }
  val["children"] = children_any
  ffi_jsx(tag, val, children_any)
}

///|
/// Fragment - groups elements without extra DOM nodes
pub fn fragment(children : Array[&HonoNode], key? : String) -> JSXNode {
  let children_arr = @core.any(children.map(_.toHonoNode()))
  let val = @core.new_object()
  if key is Some(k) {
    val["key"] = @core.any(k)
  }
  ffi_jsx(ffi_get_fragment(), val, children_arr)
}

///|
extern "js" fn ffi_get_fragment() -> @core.Any =
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
extern "js" fn ffi_render_to_string(node : @core.Any) -> String =
  #|(node) => {
  #|  if (typeof node === 'string') return node;
  #|  return node.toString();
  #|}

///|
/// Render JSX to ReadableStream (streaming)
pub fn render_to_readable_stream(node : JSXNode) -> @core.Any {
  ffi_render_to_readable_stream(node.as_any())
}

///|
extern "js" fn ffi_render_to_readable_stream(node : @core.Any) -> @core.Any =
  #|(node) => {
  #|  const { renderToReadableStream } = require('hono/jsx/streaming');
  #|  return renderToReadableStream(node);
  #|}

///|
/// Memo - memoize a component
pub fn[T] memo(component : FC[T]) -> FC[T] {
  ffi_memo(@core.any(component)).cast()
}

///|
extern "js" fn ffi_memo(component : @core.Any) -> @core.Any =
  #|(component) => {
  #|  const { memo } = require('hono/jsx');
  #|  return memo(component);
  #|}

///|
/// Context type
#external
pub type HonoContext[T]

///|
pub fn[T] HonoContext::as_any(self : HonoContext[T]) -> @core.Any = "%identity"

///|
/// Create a context
pub fn[T] create_context(defaultValue : T?) -> HonoContext[T] {
  ffi_create_context(@core.any(defaultValue)).cast()
}

///|
extern "js" fn ffi_create_context(defaultValue : @core.Any) -> @core.Any =
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
extern "js" fn ffi_use_context(ctx : @core.Any) -> @core.Any =
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
  let children_any = @core.any(children.map(_.toHonoNode()))
  let props = @core.new_object()
  props["value"] = @core.any(value)
  props["children"] = children_any
  ffi_jsx(ffi_get_provider(ctx.as_any()), props, children_any)
}

///|
extern "js" fn ffi_get_provider(ctx : @core.Any) -> @core.Any =
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
pub fn HtmlEscapedString::as_any(self : HtmlEscapedString) -> @core.Any = "%identity"

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
  self
  .as_any()
  ._call("html", [@core.any(html_string), @core.any(status_code)])
  .cast()
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
  ctx : @core.Any,
  stream : @core.Any,
  status : Int,
) -> @core.Promise[@http.Response] =
  #|async (ctx, stream, status) => {
  #|  ctx.status(status);
  #|  ctx.header('Content-Type', 'text/html; charset=UTF-8');
  #|  ctx.header('Transfer-Encoding', 'chunked');
  #|  return new Response(stream);
  #|}
