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

///| HonoJsx - initialized JSX runtime instance

///|
#external
pub type HonoJsx

///|
extern "js" fn ffi_import_hono_jsx_runtime() -> @js.Promise[@core.Any] =
  #|() => import("hono/jsx/jsx-runtime")

///|
extern "js" fn ffi_import_hono_jsx() -> @js.Promise[@core.Any] =
  #|() => import("hono/jsx")

///|
extern "js" fn ffi_import_hono_jsx_streaming() -> @js.Promise[@core.Any] =
  #|() => import("hono/jsx/streaming")

///|
extern "js" fn ffi_import_hono_html() -> @js.Promise[@core.Any] =
  #|() => import("hono/html")

///|
/// Import hono/jsx/jsx-runtime module
pub async fn import_hono_jsx() -> HonoJsx {
  // Import all needed modules
  let runtime = ffi_import_hono_jsx_runtime().wait()
  let jsx_module = ffi_import_hono_jsx().wait()
  let streaming = ffi_import_hono_jsx_streaming().wait()
  let html_module = ffi_import_hono_html().wait()
  // Store in a wrapper object
  let obj = @core.new_object()
  obj["jsxs"] = runtime._get("jsxs")
  obj["Fragment"] = runtime._get("Fragment")
  obj["memo"] = jsx_module._get("memo")
  obj["createContext"] = jsx_module._get("createContext")
  obj["useContext"] = jsx_module._get("useContext")
  obj["renderToReadableStream"] = streaming._get("renderToReadableStream")
  obj["raw"] = html_module._get("raw")
  obj["html"] = html_module._get("html")
  obj.cast()
}

///| FFI for HonoJsx methods

///|
extern "js" fn ffi_hono_jsx_jsxs(
  m : HonoJsx,
  tag : @core.Any,
  props : @core.Any,
) -> JSXNode =
  #|(m, tag, props) => m.jsxs(tag, props)

///|
extern "js" fn ffi_hono_jsx_fragment(m : HonoJsx) -> @core.Any =
  #|(m) => m.Fragment

///|
extern "js" fn ffi_hono_jsx_memo(
  m : HonoJsx,
  component : @core.Any,
) -> @core.Any =
  #|(m, component) => m.memo(component)

///|
extern "js" fn ffi_hono_jsx_create_context(
  m : HonoJsx,
  defaultValue : @core.Any,
) -> @core.Any =
  #|(m, defaultValue) => m.createContext(defaultValue)

///|
extern "js" fn ffi_hono_jsx_use_context(
  m : HonoJsx,
  ctx : @core.Any,
) -> @core.Any =
  #|(m, ctx) => m.useContext(ctx)

///|
extern "js" fn ffi_hono_jsx_render_to_readable_stream(
  m : HonoJsx,
  node : @core.Any,
) -> @core.Any =
  #|(m, node) => m.renderToReadableStream(node)

///|
extern "js" fn ffi_hono_jsx_raw(m : HonoJsx, html : String) -> JSXNode =
  #|(m, html) => m.raw(html)

///|
extern "js" fn ffi_hono_jsx_html(
  m : HonoJsx,
  template : Array[String],
) -> HtmlEscapedString =
  #|(m, template) => m.html(template)

///| HonoJsx methods

///|
/// Create a JSX element using HonoJsx instance
pub fn HonoJsx::jsx(
  self : HonoJsx,
  tag : String,
  children : Array[&HonoNode],
  props? : Map[String, @core.Any],
  style? : Map[String, String],
  class? : &CssClassName,
  id? : String,
  key? : String,
) -> JSXNode {
  let tag = @core.any(tag)
  let children_arr = children.map(_.toHonoNode())
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
  // Flatten children
  let flat_children : @core.Any = if children_arr.length() == 1 {
    children_arr[0]
  } else {
    @core.any(children_arr)
  }
  val["children"] = flat_children
  ffi_hono_jsx_jsxs(self, tag, val)
}

///|
/// Alias for jsx
pub fn HonoJsx::h(
  self : HonoJsx,
  tag : String,
  children : Array[&HonoNode],
  props? : Map[String, @core.Any],
  style? : Map[String, String],
  class? : &CssClassName,
  id? : String,
  key? : String,
) -> JSXNode {
  self.jsx(tag, children, props?, style?, class?, id?, key?)
}

///|
/// Create element with component function
pub fn[T] HonoJsx::jsx_component(
  self : HonoJsx,
  tag : FC[T],
  props : T,
  children? : Array[&HonoNode] = [],
  key? : String,
) -> JSXNode {
  let tag : @core.Any = @core.any(tag)
  let children_any = children.map(_.toHonoNode())
  let val : @core.Any = @core.any(props)
  if key is Some(k) {
    if @core.is_nullish(val) {
      let obj = @core.new_object()
      obj["key"] = @core.any(k)
      let flat_children : @core.Any = if children_any.length() == 1 {
        children_any[0]
      } else {
        @core.any(children_any)
      }
      obj["children"] = flat_children
      return ffi_hono_jsx_jsxs(self, tag, obj)
    }
    val["key"] = @core.any(k)
  }
  let flat_children : @core.Any = if children_any.length() == 1 {
    children_any[0]
  } else {
    @core.any(children_any)
  }
  val["children"] = flat_children
  ffi_hono_jsx_jsxs(self, tag, val)
}

///|
/// Fragment - groups elements without extra DOM nodes
pub fn HonoJsx::fragment(
  self : HonoJsx,
  children : Array[&HonoNode],
  key? : String,
) -> JSXNode {
  let children_arr = children.map(_.toHonoNode())
  let val = @core.new_object()
  if key is Some(k) {
    val["key"] = @core.any(k)
  }
  let flat_children : @core.Any = if children_arr.length() == 1 {
    children_arr[0]
  } else {
    @core.any(children_arr)
  }
  val["children"] = flat_children
  ffi_hono_jsx_jsxs(self, ffi_hono_jsx_fragment(self), val)
}

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
pub fn HonoJsx::render_to_readable_stream(
  self : HonoJsx,
  node : JSXNode,
) -> @core.Any {
  ffi_hono_jsx_render_to_readable_stream(self, node.as_any())
}

///|
/// Memo - memoize a component
pub fn[T] HonoJsx::memo(self : HonoJsx, component : FC[T]) -> FC[T] {
  ffi_hono_jsx_memo(self, @core.any(component)).cast()
}

///|
/// Context type
#external
pub type HonoContext[T]

///|
pub fn[T] HonoContext::as_any(self : HonoContext[T]) -> @core.Any = "%identity"

///|
/// Create a context
pub fn[T] HonoJsx::create_context(
  self : HonoJsx,
  defaultValue : T?,
) -> HonoContext[T] {
  ffi_hono_jsx_create_context(self, @core.any(defaultValue)).cast()
}

///|
/// Use context value
pub fn[T] HonoJsx::use_context(self : HonoJsx, ctx : HonoContext[T]) -> T {
  ffi_hono_jsx_use_context(self, ctx.as_any()).cast()
}

///|
/// Context Provider
pub fn[T] HonoJsx::context_provider(
  self : HonoJsx,
  ctx : HonoContext[T],
  children : Array[&HonoNode],
  value~ : T,
) -> JSXNode {
  let children_any = children.map(_.toHonoNode())
  let props = @core.new_object()
  props["value"] = @core.any(value)
  let flat_children : @core.Any = if children_any.length() == 1 {
    children_any[0]
  } else {
    @core.any(children_any)
  }
  props["children"] = flat_children
  ffi_hono_jsx_jsxs(self, ffi_get_provider(ctx.as_any()), props)
}

///|
extern "js" fn ffi_get_provider(ctx : @core.Any) -> @core.Any =
  #|(ctx) => ctx.Provider

///|
/// Raw HTML - insert unescaped HTML
pub fn HonoJsx::raw(self : HonoJsx, html : String) -> JSXNode {
  ffi_hono_jsx_raw(self, html)
}

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
pub fn HonoJsx::html(self : HonoJsx, template : String) -> HtmlEscapedString {
  ffi_hono_jsx_html(self, [template])
}

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
  hono_jsx : HonoJsx,
  node : JSXNode,
  status? : Int,
) -> @http.Response {
  let stream = hono_jsx.render_to_readable_stream(node)
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

///| Legacy API - now uses #module for ESM compatibility
///|
///| TODO: Fragment is a value (not a function), so #module cannot be used.
///| Currently using globalThis initialization pattern. Consider:
///| - Using HonoJsx API instead (recommended for new code)
///| - Finding a better pattern for value exports in MoonBit FFI

///|
/// jsxs function from hono/jsx/jsx-runtime (ESM)
#module("hono/jsx/jsx-runtime")
extern "js" fn ffi_jsxs_esm(tag : @core.Any, props : @core.Any) -> JSXNode = "jsxs"

///|
/// Get Fragment from global (initialized by init_jsx_runtime)
extern "js" fn ffi_get_fragment_global() -> @core.Any =
  #|() => globalThis.__HonoJsxFragment

///|
/// Import and store hono/jsx/jsx-runtime globally
extern "js" fn ffi_init_jsx_runtime() -> @js.Promise[Unit] =
  #|() => import('hono/jsx/jsx-runtime').then(m => { globalThis.__HonoJsxFragment = m.Fragment; })

///|
/// Initialize the JSX runtime (must be called before using legacy jsx/fragment)
/// This must be called before using the legacy `fragment` function in ESM environments.
pub async fn init_jsx_runtime() -> Unit {
  ffi_init_jsx_runtime().wait()
}

///|
/// Create a JSX element (legacy - prefer HonoJsx::jsx)
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
  let children_arr = children.map(_.toHonoNode())
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
  // Flatten children
  let flat_children : @core.Any = if children_arr.length() == 1 {
    children_arr[0]
  } else {
    @core.any(children_arr)
  }
  val["children"] = flat_children
  ffi_jsxs_esm(tag, val)
}

///|
/// Create element with component function (legacy)
pub fn[T] jsx_component(
  tag : FC[T],
  props : T,
  children? : Array[&HonoNode] = [],
  key? : String,
) -> JSXNode {
  let tag : @core.Any = @core.any(tag)
  let children_any = children.map(_.toHonoNode())
  let val : @core.Any = @core.any(props)
  if key is Some(k) {
    if @core.is_nullish(val) {
      let obj = @core.new_object()
      obj["key"] = @core.any(k)
      let flat_children : @core.Any = if children_any.length() == 1 {
        children_any[0]
      } else {
        @core.any(children_any)
      }
      obj["children"] = flat_children
      return ffi_jsxs_esm(tag, obj)
    }
    val["key"] = @core.any(k)
  }
  let flat_children : @core.Any = if children_any.length() == 1 {
    children_any[0]
  } else {
    @core.any(children_any)
  }
  val["children"] = flat_children
  ffi_jsxs_esm(tag, val)
}

///|
/// Fragment (legacy - prefer HonoJsx::fragment)
/// Note: Requires init_jsx_runtime() to be called first
pub fn fragment(children : Array[&HonoNode], key? : String) -> JSXNode {
  let children_arr = children.map(_.toHonoNode())
  let val = @core.new_object()
  if key is Some(k) {
    val["key"] = @core.any(k)
  }
  let flat_children : @core.Any = if children_arr.length() == 1 {
    children_arr[0]
  } else {
    @core.any(children_arr)
  }
  val["children"] = flat_children
  ffi_jsxs_esm(ffi_get_fragment_global(), val)
}

///|
/// Raw HTML (legacy - prefer HonoJsx::raw)
#module("hono/html")
extern "js" fn ffi_raw_esm(html : String) -> JSXNode = "raw"

///|
pub fn raw(html : String) -> JSXNode {
  ffi_raw_esm(html)
}

///|
/// Create HTML from template string (legacy - prefer HonoJsx::html)
#module("hono/html")
extern "js" fn ffi_html_esm(template : Array[String]) -> HtmlEscapedString = "html"

///|
pub fn html(template : String) -> HtmlEscapedString {
  ffi_html_esm([template])
}

///|
/// Memo (legacy - prefer HonoJsx::memo)
#module("hono/jsx")
extern "js" fn ffi_memo_esm(component : @core.Any) -> @core.Any = "memo"

///|
pub fn[T] memo(component : FC[T]) -> FC[T] {
  ffi_memo_esm(@core.any(component)).cast()
}

///|
/// Create a context (legacy - prefer HonoJsx::create_context)
#module("hono/jsx")
extern "js" fn ffi_create_context_esm(defaultValue : @core.Any) -> @core.Any = "createContext"

///|
pub fn[T] create_context(defaultValue : T?) -> HonoContext[T] {
  ffi_create_context_esm(@core.any(defaultValue)).cast()
}

///|
/// Use context value (legacy - prefer HonoJsx::use_context)
#module("hono/jsx")
extern "js" fn ffi_use_context_esm(ctx : @core.Any) -> @core.Any = "useContext"

///|
pub fn[T] use_context(ctx : HonoContext[T]) -> T {
  ffi_use_context_esm(ctx.as_any()).cast()
}

///|
/// Context Provider (legacy - prefer HonoJsx::context_provider)
pub fn[T] context_provider(
  ctx : HonoContext[T],
  children : Array[&HonoNode],
  value~ : T,
) -> JSXNode {
  let children_any = children.map(_.toHonoNode())
  let props = @core.new_object()
  props["value"] = @core.any(value)
  let flat_children : @core.Any = if children_any.length() == 1 {
    children_any[0]
  } else {
    @core.any(children_any)
  }
  props["children"] = flat_children
  ffi_jsxs_esm(ffi_get_provider(ctx.as_any()), props)
}

///|
/// Render JSX to ReadableStream (legacy - prefer HonoJsx::render_to_readable_stream)
#module("hono/jsx/streaming")
extern "js" fn ffi_render_to_readable_stream_esm(node : @core.Any) -> @core.Any = "renderToReadableStream"

///|
pub fn render_to_readable_stream(node : JSXNode) -> @core.Any {
  ffi_render_to_readable_stream_esm(node.as_any())
}
