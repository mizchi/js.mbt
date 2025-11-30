///|
/// Server-Side Rendering support for Preact
/// preact-render-to-string

///|
/// Render a VNode to HTML string (synchronous)
pub fn renderToString(vnode : VNode) -> String {
  ffi_render_to_string(vnode.as_any())
}

///|
extern "js" fn ffi_render_to_string(vnode : @nostd.Any) -> String =
  #|(v) => globalThis.__PreactSSR.renderToString(v)

///|
/// Render a VNode to HTML string (async, supports Suspense)
pub async fn renderToStringAsync(vnode : VNode) -> String {
  ffi_render_to_string_async(vnode.as_any()).wait()
}

///|
extern "js" fn ffi_render_to_string_async(
  vnode : @nostd.Any,
) -> @nostd.Promise[String] =
  #|(v) => globalThis.__PreactSSR.renderToStringAsync(v)

///|
/// Initialize the Preact SSR API
pub fn init_preact_ssr(ssr : @nostd.Any) -> Unit {
  if @nostd.is_nullish(@nostd.global_this()["__PreactSSR"]) {
    @nostd.global_this()["__PreactSSR"] = ssr
  }
}
