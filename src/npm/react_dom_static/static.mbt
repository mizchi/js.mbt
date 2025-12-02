///|
#external
pub type ReactDOMStatic

///|
pub fn ReactDOMStatic::as_any(self : ReactDOMStatic) -> @nostd.Any = "%identity"

// Internal helper for calling JS methods

///|
fn ReactDOMStatic::call2(
  self : ReactDOMStatic,
  name : String,
  arg1 : @nostd.Any,
  arg2 : @nostd.Any,
) -> @nostd.Any {
  self.as_any()._call(name, [arg1, arg2])
}

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
  postponed : @nostd.Any
}

///|
/// Result of prerenderToNodeStream containing the HTML stream and postponed data
pub struct PrerenderToNodeStreamResult {
  /// HTML content as a Node.js Readable stream
  prelude : @stream.Readable
  /// Postponed data for resuming, or null if complete
  postponed : @nostd.Any
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
) -> @nostd.Any {
  let opts = @nostd.Object::new()
  if bootstrap_script_content is Some(v) {
    opts._set("bootstrapScriptContent", v |> @nostd.any)
  }
  if bootstrap_scripts is Some(v) {
    opts._set("bootstrapScripts", @nostd.any(v))
  }
  if bootstrap_modules is Some(v) {
    opts._set("bootstrapModules", @nostd.any(v))
  }
  if identifier_prefix is Some(v) {
    opts._set("identifierPrefix", v |> @nostd.any)
  }
  if namespace_uri is Some(v) {
    opts._set("namespaceURI", v |> @nostd.any)
  }
  if on_error is Some(v) {
    opts._set("onError", @js.from_fn1(v))
  }
  if progressive_chunk_size is Some(v) {
    opts._set("progressiveChunkSize", v |> @nostd.any)
  }
  if signal is Some(v) {
    opts._set("signal", @js.any(v))
  }
  opts
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
  let react_node_js : @nostd.Any = react_node.as_any().cast()
  let promise : @js.Promise[@nostd.Any] = self
    .call2("prerender", react_node_js, opts)
    .cast()
  let result = promise.wait()
  {
    prelude: result._get("prelude").cast(),
    postponed: result._get("postponed"),
  }
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
  let react_node_js : @nostd.Any = react_node.as_any().cast()
  let promise : @js.Promise[@nostd.Any] = self
    .call2("prerenderToNodeStream", react_node_js, opts)
    .cast()
  let result = promise.wait()
  {
    prelude: result._get("prelude").cast(),
    postponed: result._get("postponed"),
  }
}
