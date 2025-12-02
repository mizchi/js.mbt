///|
/// Server-Side Rendering support for Vue
/// @vue/server-renderer

///|
/// Render a VNode to HTML string (async)
pub async fn renderToString(vnode : VNode) -> String {
  ffi_render_to_string(vnode |> @nostd.identity).wait()
}

///|
extern "js" fn ffi_render_to_string(vnode : @nostd.Any) -> @js.Promise[String] =
  #|(v) => globalThis.__VueSSR.renderToString(v)

///|
/// Render a VNode to a readable stream (returns readable stream)
pub fn renderToStream(vnode : VNode) -> @nostd.Any {
  ffi_render_to_stream(vnode |> @nostd.identity)
}

///|
extern "js" fn ffi_render_to_stream(vnode : @nostd.Any) -> @nostd.Any =
  #|(v) => globalThis.__VueSSR.renderToStream(v)

///|
/// Render to static string (no hydration markers)
pub async fn renderToStaticMarkup(vnode : VNode) -> String {
  ffi_render_to_static_markup(vnode |> @nostd.identity).wait()
}

///|
extern "js" fn ffi_render_to_static_markup(
  vnode : @nostd.Any,
) -> @js.Promise[String] =
  #|(v) => globalThis.__VueSSR.renderToStaticMarkup(v)

///|
/// Initialize the Vue SSR API
pub fn init_vue_ssr(ssr : @nostd.Any) -> Unit {
  if @nostd.is_nullish(@global.global_this()._get("__VueSSR")) {
    @global.global_this()._set("__VueSSR", ssr)
  }
}
