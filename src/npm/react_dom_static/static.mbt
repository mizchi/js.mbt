///|
#external
pub type ReactDOMStatic

///|
pub impl @js.JsImpl for ReactDOMStatic

///|
/// Dynamic import for react-dom/static module (internal)
extern "js" fn import_react_dom_static_internal() -> @js.Promise[ReactDOMStatic] =
  #| () => import("react-dom/static")

///|
/// Dynamic import for react-dom/static module
pub async fn dynamic_import() -> ReactDOMStatic {
  import_react_dom_static_internal().wait()
}

///|
/// Result of prerender containing the HTML stream and postponed data
pub struct PrerenderResult {
  /// HTML content as a Web ReadableStream
  prelude : @streams.ReadableStream
  /// Postponed data for resuming, or null if complete
  postponed : @js.Any
}

///|
/// Result of prerenderToNodeStream containing the HTML stream and postponed data
pub struct PrerenderToNodeStreamResult {
  /// HTML content as a Node.js Readable stream
  prelude : @stream.Readable
  /// Postponed data for resuming, or null if complete
  postponed : @js.Any
}

///|
fn build_options(
  bootstrap_script_content? : String,
  bootstrap_scripts? : Array[String],
  bootstrap_modules? : Array[String],
  identifier_prefix? : String,
  namespace_uri? : String,
  on_error? : (@js.JsError) -> Unit,
  progressive_chunk_size? : Int,
  signal? : @js.AbortSignal,
) -> @js.Any {
  let opts = @js.Object::new()
  if bootstrap_script_content is Some(v) {
    opts.set("bootstrapScriptContent", v)
  }
  if bootstrap_scripts is Some(v) {
    opts.set("bootstrapScripts", @js.from_array(v))
  }
  if bootstrap_modules is Some(v) {
    opts.set("bootstrapModules", @js.from_array(v))
  }
  if identifier_prefix is Some(v) {
    opts.set("identifierPrefix", v)
  }
  if namespace_uri is Some(v) {
    opts.set("namespaceURI", v)
  }
  if on_error is Some(v) {
    opts.set("onError", @js.from_fn1(v))
  }
  if progressive_chunk_size is Some(v) {
    opts.set("progressiveChunkSize", v)
  }
  if signal is Some(v) {
    opts.set("signal", @js.unsafe_any(v))
  }
  opts.as_any()
}

///|
/// Prerender a React tree to static HTML using Web Streams.
/// Returns a Promise that resolves to an object with prelude (ReadableStream) and postponed data.
pub async fn ReactDOMStatic::prerender(
  self : ReactDOMStatic,
  react_node : @react.Element,
  bootstrap_script_content? : String,
  bootstrap_scripts? : Array[String],
  bootstrap_modules? : Array[String],
  identifier_prefix? : String,
  namespace_uri? : String,
  on_error? : (@js.JsError) -> Unit,
  progressive_chunk_size? : Int,
  signal? : @js.AbortSignal,
) -> PrerenderResult {
  let opts = build_options(
    bootstrap_script_content?,
    bootstrap_scripts?,
    bootstrap_modules?,
    identifier_prefix?,
    namespace_uri?,
    on_error?,
    progressive_chunk_size?,
    signal?,
  )
  let promise : @js.Promise[@js.Any] = self
    .call2("prerender", react_node, opts)
    .cast()
  let result = promise.wait()
  { prelude: result.get("prelude").cast(), postponed: result.get("postponed") }
}

///|
/// Prerender a React tree to static HTML using Node.js Streams.
/// Returns a Promise that resolves to an object with prelude (Node.js Readable) and postponed data.
#alias(prerender_to_node_stream)
pub async fn ReactDOMStatic::prerenderToNodeStream(
  self : ReactDOMStatic,
  react_node : @react.Element,
  bootstrap_script_content? : String,
  bootstrap_scripts? : Array[String],
  bootstrap_modules? : Array[String],
  identifier_prefix? : String,
  namespace_uri? : String,
  on_error? : (@js.JsError) -> Unit,
  progressive_chunk_size? : Int,
  signal? : @js.AbortSignal,
) -> PrerenderToNodeStreamResult {
  let opts = build_options(
    bootstrap_script_content?,
    bootstrap_scripts?,
    bootstrap_modules?,
    identifier_prefix?,
    namespace_uri?,
    on_error?,
    progressive_chunk_size?,
    signal?,
  )
  let promise : @js.Promise[@js.Any] = self
    .call2("prerenderToNodeStream", react_node, opts)
    .cast()
  let result = promise.wait()
  { prelude: result.get("prelude").cast(), postponed: result.get("postponed") }
}
