///|
/// Server-Side Rendering support for Preact
/// preact-render-to-string

///|
/// Render a VNode to HTML string (synchronous)
pub fn renderToString(vnode : VNode) -> String {
  ffi_render_to_string(vnode.as_any())
}

///|
#module("preact-render-to-string")
extern "js" fn ffi_render_to_string(vnode : @core.Any) -> String = "renderToString"

///|
/// Render a VNode to HTML string (async, supports Suspense)
pub async fn renderToStringAsync(vnode : VNode) -> String {
  ffi_render_to_string_async(vnode.as_any()).wait()
}

///|
#module("preact-render-to-string")
extern "js" fn ffi_render_to_string_async(
  vnode : @core.Any,
) -> @core.Promise[String] = "renderToStringAsync"

///|
/// Initialize the Preact SSR API
/// @deprecated No longer needed with ESM imports
pub fn init_preact_ssr(ssr : @core.Any) -> Unit {
  ignore(ssr)
}
