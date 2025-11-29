///|
/// Server-Side Rendering support for Vue
/// @vue/server-renderer

///|
/// Render a VNode to HTML string (async)
pub async fn renderToString(vnode : VNode) -> String {
  ffi_render_to_string(vnode |> @js.identity).wait()
}

///|
extern "js" fn ffi_render_to_string(vnode : @js.Any) -> @js.Promise[String] =
  #|(v) => globalThis.__VueSSR.renderToString(v)

///|
/// Render a VNode to a readable stream (returns readable stream)
pub fn renderToStream(vnode : VNode) -> @js.Any {
  ffi_render_to_stream(vnode |> @js.identity)
}

///|
extern "js" fn ffi_render_to_stream(vnode : @js.Any) -> @js.Any =
  #|(v) => globalThis.__VueSSR.renderToStream(v)

///|
/// Render to static string (no hydration markers)
pub async fn renderToStaticMarkup(vnode : VNode) -> String {
  ffi_render_to_static_markup(vnode |> @js.identity).wait()
}

///|
extern "js" fn ffi_render_to_static_markup(
  vnode : @js.Any,
) -> @js.Promise[String] =
  #|(v) => globalThis.__VueSSR.renderToStaticMarkup(v)

///|
/// Initialize the Vue SSR API
pub fn init_vue_ssr(ssr : @js.Any) -> Unit {
  if @js.is_nullish(@js.global_this().get("__VueSSR")) {
    @js.global_this().set("__VueSSR", ssr)
  }
}
