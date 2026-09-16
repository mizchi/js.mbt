// =============================================================================
// GPUCanvasContext - configuring a rendering canvas
// https://developer.mozilla.org/en-US/docs/Web/API/GPUCanvasContext
//
// The context comes from `canvas.getContext("webgpu")`. Canvas elements live
// in `mizchi/js_browser`, which depends on this module rather than the other
// way round, so the context is taken as a raw value through `from_any` and
// this package stays free of a browser dependency. The same applies to
// `OffscreenCanvas` in a worker.
// =============================================================================

///|
/// GPUCanvasContext - the "webgpu" canvas rendering context.
#external
pub type GPUCanvasContext

///|
pub fn GPUCanvasContext::as_any(self : GPUCanvasContext) -> @core.Any = "%identity"

///|
/// Wrap the result of `canvas.getContext("webgpu")`.
///
/// Returns `None` when the canvas could not give a WebGPU context, which is
/// what a browser without WebGPU does.
pub fn GPUCanvasContext::from_any(value : @core.Any) -> GPUCanvasContext? {
  if @core.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// The canvas this context belongs to, as a raw value -- cast it to the
/// element type from `@dom` or `@canvas` if you need one.
pub fn GPUCanvasContext::canvas(self : GPUCanvasContext) -> @core.Any {
  self.as_any()["canvas"]
}

///|
/// Configure the context for rendering.
///
/// `format` should normally come from `GPU::getPreferredCanvasFormat()`.
/// `usage` defaults to `TEXTURE_USAGE_RENDER_ATTACHMENT` when omitted, and
/// `tone_mapping_mode` takes "standard" or "extended" (HDR).
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUCanvasContext/configure
pub fn GPUCanvasContext::configure(
  self : GPUCanvasContext,
  device : GPUDevice,
  format : String,
  usage? : Int,
  view_formats? : Array[String],
  color_space? : String,
  alpha_mode? : String,
  tone_mapping_mode? : String,
) -> Unit {
  let config = @core.new_object()
  config._set("device", device.as_any())
  config._set("format", @core.any(format))
  match usage {
    Some(u) => config._set("usage", @core.any(u))
    None => ()
  }
  match view_formats {
    Some(f) => config._set("viewFormats", @core.any(f))
    None => ()
  }
  match color_space {
    Some(c) => config._set("colorSpace", @core.any(c))
    None => ()
  }
  match alpha_mode {
    Some(a) => config._set("alphaMode", @core.any(a))
    None => ()
  }
  match tone_mapping_mode {
    Some(m) => {
      let tone = @core.new_object()
      tone._set("mode", @core.any(m))
      config._set("toneMapping", tone)
    }
    None => ()
  }
  self.as_any()._call("configure", [config]) |> ignore
}

///|
/// The configuration currently in effect, or `None` if the context has not
/// been configured.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUCanvasContext/getConfiguration
pub fn GPUCanvasContext::getConfiguration(
  self : GPUCanvasContext,
) -> @core.Any? {
  let v = self.as_any()._call("getConfiguration", [])
  if @core.is_nullish(v) {
    None
  } else {
    Some(v)
  }
}

///|
/// The texture to render this frame into. Valid until the end of the current
/// task, so call it once per frame rather than caching it.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUCanvasContext/getCurrentTexture
pub fn GPUCanvasContext::getCurrentTexture(
  self : GPUCanvasContext,
) -> GPUTexture {
  self.as_any()._call("getCurrentTexture", []).cast()
}

///|
/// Remove the context's configuration and destroy any textures it produced.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUCanvasContext/unconfigure
pub fn GPUCanvasContext::unconfigure(self : GPUCanvasContext) -> Unit {
  self.as_any()._call("unconfigure", []) |> ignore
}
