///|
/// Hono JSX - Server-side JSX for Hono
/// https://hono.dev/docs/guides/jsx

///|
/// JSX Node type
#external
pub type JSXNode

///|
pub impl @js.JsImpl for JSXNode

///|
/// HonoNode trait for JSX children
pub trait HonoNode {
  toHonoNode(Self) -> @js.Any
}

///|
pub impl HonoNode for JSXNode with toHonoNode(self) {
  self |> @js.identity
}

///|
pub impl HonoNode for String with toHonoNode(self) {
  self |> @js.any
}

///|
pub impl HonoNode for Int with toHonoNode(self) {
  self |> @js.any
}

///|
pub impl HonoNode for Double with toHonoNode(self) {
  self |> @js.any
}

///|
pub impl HonoNode for Bool with toHonoNode(self) {
  self |> @js.any
}

///|
pub impl[T : HonoNode] HonoNode for Array[T] with toHonoNode(self) {
  self.map(HonoNode::toHonoNode) |> @js.from_array
}

///|
/// Component function type
pub type FC[T] = (T) -> JSXNode

///|
/// Create a JSX element
pub fn jsx(
  tag : String,
  children : Array[&HonoNode],
  props? : Map[String, @js.Any],
  style? : Map[String, String],
  class? : String,
  id? : String,
  key? : String,
) -> JSXNode {
  let tag = @js.any(tag)
  let children_arr = children.map(_.toHonoNode()) |> @js.from_array
  let val = @js.Object::new()
  if props is Some(props) {
    for k, v in props {
      val.set(k, v)
    }
  }
  if style is Some(style) {
    let style_obj = @js.Object::new()
    for k, v in style {
      style_obj.set(k, v)
    }
    val.set("style", style_obj)
  }
  if class is Some(c) {
    val.set("class", c)
  }
  if id is Some(i) {
    val.set("id", i)
  }
  if key is Some(k) {
    val.set("key", k)
  }
  ffi_jsx(tag, val.to_any(), children_arr) |> @js.identity
}

///|
extern "js" fn ffi_jsx(
  tag : @js.Any,
  props : @js.Any,
  children : @js.Any,
) -> @js.Any =
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
  let tag = @js.identity(tag)
  let children = children.map(_.toHonoNode()) |> @js.from_array
  let val : @js.Any = props |> @js.identity
  if key is Some(k) {
    if @js.is_nullish(val) {
      let obj = @js.Object::new()
      obj.set("key", k)
      obj.set("children", children)
      return ffi_jsx(tag, obj.to_any(), children) |> @js.identity
    }
    val.set("key", k)
  }
  val.set("children", children)
  ffi_jsx(tag, val, children) |> @js.identity
}

///|
/// Fragment - groups elements without extra DOM nodes
pub fn fragment(children : Array[&HonoNode], key? : String) -> JSXNode {
  let children_arr = children.map(_.toHonoNode()) |> @js.from_array
  let val = @js.Object::new()
  if key is Some(k) {
    val.set("key", k)
  }
  ffi_jsx(ffi_get_fragment(), val.to_any(), children_arr) |> @js.identity
}

///|
extern "js" fn ffi_get_fragment() -> @js.Any =
  #|() => {
  #|  const { Fragment } = require('hono/jsx/jsx-runtime');
  #|  return Fragment;
  #|}

///|
/// Render JSX to string
pub fn render_to_string(node : JSXNode) -> String {
  ffi_render_to_string(node |> @js.identity)
}

///|
extern "js" fn ffi_render_to_string(node : @js.Any) -> String =
  #|(node) => {
  #|  if (typeof node === 'string') return node;
  #|  return node.toString();
  #|}

///|
/// Render JSX to ReadableStream (streaming)
pub fn render_to_readable_stream(node : JSXNode) -> @js.Any {
  ffi_render_to_readable_stream(node |> @js.identity)
}

///|
extern "js" fn ffi_render_to_readable_stream(node : @js.Any) -> @js.Any =
  #|(node) => {
  #|  const { renderToReadableStream } = require('hono/jsx/streaming');
  #|  return renderToReadableStream(node);
  #|}

///|
/// Memo - memoize a component
pub fn[T] memo(component : FC[T]) -> FC[T] {
  ffi_memo(component |> @js.identity) |> @js.identity
}

///|
extern "js" fn ffi_memo(component : @js.Any) -> @js.Any =
  #|(component) => {
  #|  const { memo } = require('hono/jsx');
  #|  return memo(component);
  #|}

///|
/// Context type
#external
pub type HonoContext[T]

///|
pub impl[T] @js.JsImpl for HonoContext[T]

///|
/// Create a context
pub fn[T] create_context(defaultValue : T?) -> HonoContext[T] {
  ffi_create_context(defaultValue |> @js.unsafe_any) |> @js.identity
}

///|
extern "js" fn ffi_create_context(defaultValue : @js.Any) -> @js.Any =
  #|(defaultValue) => {
  #|  const { createContext } = require('hono/jsx');
  #|  return createContext(defaultValue);
  #|}

///|
/// Use context value
pub fn[T] use_context(ctx : HonoContext[T]) -> T {
  ffi_use_context(ctx |> @js.identity) |> @js.identity
}

///|
extern "js" fn ffi_use_context(ctx : @js.Any) -> @js.Any =
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
  let children = children.map(_.toHonoNode()) |> @js.from_array
  let props = @js.Object::new()
  props.set("value", value |> @js.identity)
  props.set("children", children)
  ffi_jsx(ffi_get_provider(ctx |> @js.identity), props.to_any(), children)
  |> @js.identity
}

///|
extern "js" fn ffi_get_provider(ctx : @js.Any) -> @js.Any =
  #|(ctx) => ctx.Provider

///|
/// Raw HTML - insert unescaped HTML
pub fn raw(html : String) -> JSXNode {
  ffi_raw(html) |> @js.identity
}

///|
extern "js" fn ffi_raw(html : String) -> @js.Any =
  #|(html) => {
  #|  const { raw } = require('hono/html');
  #|  return raw(html);
  #|}

///|
/// HTML tagged template helper result
#external
pub type HtmlEscapedString

///|
pub impl @js.JsImpl for HtmlEscapedString

///|
pub impl HonoNode for HtmlEscapedString with toHonoNode(self) {
  self |> @js.identity
}

///|
/// Create HTML from template string (escaped)
pub fn html(template : String) -> HtmlEscapedString {
  ffi_html(template) |> @js.identity
}

///|
extern "js" fn ffi_html(template : String) -> @js.Any =
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
  self.call2("html", html_string, status_code).cast()
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
  ffi_stream_response(self |> @js.identity, stream, status_code).wait()
}

///|
extern "js" fn ffi_stream_response(
  ctx : @js.Any,
  stream : @js.Any,
  status : Int,
) -> @js.Promise[@http.Response] =
  #|async (ctx, stream, status) => {
  #|  ctx.status(status);
  #|  ctx.header('Content-Type', 'text/html; charset=UTF-8');
  #|  ctx.header('Transfer-Encoding', 'chunked');
  #|  return new Response(stream);
  #|}
