///|
#external
pub type ReactDOMStatic

///|
pub fn ReactDOMStatic::as_any(self : ReactDOMStatic) -> @core.Any = "%identity"

// Internal helper for calling JS methods

///|
fn ReactDOMStatic::call2(
  self : ReactDOMStatic,
  name : String,
  arg1 : @core.Any,
  arg2 : @core.Any,
) -> @core.Any {
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
  postponed : @core.Any
}

///|
/// Result of prerenderToNodeStream containing the HTML stream and postponed data
pub struct PrerenderToNodeStreamResult {
  /// HTML content as a Node.js Readable stream
  prelude : @stream.Readable
  /// Postponed data for resuming, or null if complete
  postponed : @core.Any
}

///|
fn build_options(
  bootstrapScriptContent? : String,
  bootstrapScripts? : Array[String],
  bootstrapModules? : Array[String],
  identifierPrefix? : String,
  namespaceURI? : String,
  onError? : (@error.JsError) -> Unit,
  progressiveChunkSize? : Int,
  signal? : @js.AbortSignal,
) -> @core.Any {
  let opts = @core.new_object()
  if bootstrapScriptContent is Some(v) {
    opts._set("bootstrapScriptContent", v |> @core.any)
  }
  if bootstrapScripts is Some(v) {
    opts._set("bootstrapScripts", @core.any(v))
  }
  if bootstrapModules is Some(v) {
    opts._set("bootstrapModules", @core.any(v))
  }
  if identifierPrefix is Some(v) {
    opts._set("identifierPrefix", v |> @core.any)
  }
  if namespaceURI is Some(v) {
    opts._set("namespaceURI", v |> @core.any)
  }
  if onError is Some(v) {
    opts._set("onError", @js.from_fn1(v))
  }
  if progressiveChunkSize is Some(v) {
    opts._set("progressiveChunkSize", v |> @core.any)
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
  bootstrapScriptContent? : String,
  bootstrapScripts? : Array[String],
  bootstrapModules? : Array[String],
  identifierPrefix? : String,
  namespaceURI? : String,
  onError? : (@error.JsError) -> Unit,
  progressiveChunkSize? : Int,
  signal? : @js.AbortSignal,
) -> PrerenderResult {
  let opts = build_options(
    bootstrapScriptContent?,
    bootstrapScripts?,
    bootstrapModules?,
    identifierPrefix?,
    namespaceURI?,
    onError?,
    progressiveChunkSize?,
    signal?,
  )
  let react_node_js : @core.Any = react_node.as_any().cast()
  let promise : @js.Promise[@core.Any] = self
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
  bootstrapScriptContent? : String,
  bootstrapScripts? : Array[String],
  bootstrapModules? : Array[String],
  identifierPrefix? : String,
  namespaceURI? : String,
  onError? : (@error.JsError) -> Unit,
  progressiveChunkSize? : Int,
  signal? : @js.AbortSignal,
) -> PrerenderToNodeStreamResult {
  let opts = build_options(
    bootstrapScriptContent?,
    bootstrapScripts?,
    bootstrapModules?,
    identifierPrefix?,
    namespaceURI?,
    onError?,
    progressiveChunkSize?,
    signal?,
  )
  let react_node_js : @core.Any = react_node.as_any().cast()
  let promise : @js.Promise[@core.Any] = self
    .call2("prerenderToNodeStream", react_node_js, opts)
    .cast()
  let result = promise.wait()
  {
    prelude: result._get("prelude").cast(),
    postponed: result._get("postponed"),
  }
}
