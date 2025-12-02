///|
/// Server-Side Rendering support for Vue
/// @vue/server-renderer

///|
/// Render a VNode to HTML string (async)
pub async fn renderToString(vnode : VNode) -> String {
  ffi_render_to_string(vnode |> @core.identity).wait()
}

///|
extern "js" fn ffi_render_to_string(vnode : @core.Any) -> @js.Promise[String] =
  #|(v) => globalThis.__VueSSR.renderToString(v)

///|
/// Render a VNode to a readable stream (returns readable stream)
pub fn renderToStream(vnode : VNode) -> @core.Any {
  ffi_render_to_stream(vnode |> @core.identity)
}

///|
extern "js" fn ffi_render_to_stream(vnode : @core.Any) -> @core.Any =
  #|(v) => globalThis.__VueSSR.renderToStream(v)

///|
/// Render to static string (no hydration markers)
pub async fn renderToStaticMarkup(vnode : VNode) -> String {
  ffi_render_to_static_markup(vnode |> @core.identity).wait()
}

///|
extern "js" fn ffi_render_to_static_markup(
  vnode : @core.Any,
) -> @js.Promise[String] =
  #|(v) => globalThis.__VueSSR.renderToStaticMarkup(v)

///|
/// Initialize the Vue SSR API
pub fn init_vue_ssr(ssr : @core.Any) -> Unit {
  if @core.is_nullish(@global.global_this()._get("__VueSSR")) {
    @global.global_this()._set("__VueSSR", ssr)
  }
}
