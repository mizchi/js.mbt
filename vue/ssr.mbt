///|
/// Server-Side Rendering support for Vue
/// @vue/server-renderer

///|
/// Render a VNode to HTML string (async)
pub async fn renderToString(vnode : VNode) -> String {
  ffi_render_to_string(vnode |> @core.identity).wait()
}

///|
#module("@vue/server-renderer")
extern "js" fn ffi_render_to_string(vnode : @core.Any) -> @js.Promise[String] = "renderToString"

///|
/// Render a VNode to a readable stream (returns readable stream)
pub fn renderToStream(vnode : VNode) -> @core.Any {
  ffi_render_to_stream(vnode |> @core.identity)
}

///|
#module("@vue/server-renderer")
extern "js" fn ffi_render_to_stream(vnode : @core.Any) -> @core.Any = "renderToNodeStream"

///|
/// Render to static string (no hydration markers)
pub async fn renderToStaticMarkup(vnode : VNode) -> String {
  ffi_render_to_static_markup(vnode |> @core.identity).wait()
}

///|
#module("@vue/server-renderer")
extern "js" fn ffi_render_to_static_markup(
  vnode : @core.Any,
) -> @js.Promise[String] = "renderToStaticMarkup"

///|
/// Initialize the Vue SSR API (deprecated - no longer needed)
#deprecated("Use ESM imports instead")
pub fn init_vue_ssr(ssr : @core.Any) -> Unit {
  ignore(ssr)
}
