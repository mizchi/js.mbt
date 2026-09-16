// =============================================================================
// GPUExternalTexture and external image copies
// https://developer.mozilla.org/en-US/docs/Web/API/GPUExternalTexture
//
// An external texture wraps a video frame so a shader can sample it without a
// copy. The source is an `HTMLVideoElement` or `VideoFrame`, which live
// outside this module, so it is taken as a raw value.
// =============================================================================

///|
/// A video frame usable as a shader binding.
///
/// Note that these expire: once the frame it wraps is gone the texture becomes
/// unusable, so import one per frame rather than caching it.
#external
pub type GPUExternalTexture

///|
pub fn GPUExternalTexture::as_any(self : GPUExternalTexture) -> @core.Any = "%identity"

///|
pub fn GPUExternalTexture::label(self : GPUExternalTexture) -> String {
  self.as_any()["label"].cast()
}

///|
/// Import a video frame as a sampleable texture.
///
/// `source` is an `HTMLVideoElement` or a `VideoFrame`; `color_space` takes
/// "srgb" or "display-p3".
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/importExternalTexture
pub fn GPUDevice::importExternalTexture(
  self : GPUDevice,
  source : @core.Any,
  color_space? : String,
  label? : String,
) -> GPUExternalTexture {
  let descriptor = @core.new_object()
  descriptor._set("source", source)
  match color_space {
    Some(c) => descriptor._set("colorSpace", @core.any(c))
    None => ()
  }
  match label {
    Some(l) => descriptor._set("label", @core.any(l))
    None => ()
  }
  self.as_any()._call("importExternalTexture", [descriptor]).cast()
}

///|
/// Copy from an image source straight into a texture.
///
/// `source` is a `GPUCopyExternalImageSourceInfo` -- an object whose `source`
/// is an `ImageBitmap`, `HTMLCanvasElement`, `HTMLVideoElement`,
/// `OffscreenCanvas`, `VideoFrame` or `HTMLImageElement`, optionally with
/// `origin` and `flipY`. `destination` is a `GPUCopyExternalImageDestInfo`,
/// i.e. at least `{ texture }`, optionally with `mipLevel`, `origin`,
/// `aspect`, `colorSpace` and `premultipliedAlpha`.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUQueue/copyExternalImageToTexture
pub fn GPUQueue::copyExternalImageToTexture(
  self : GPUQueue,
  source : @core.Any,
  destination : @core.Any,
  copy_size : GPUExtent3D,
) -> Unit {
  self
  .as_any()
  ._call("copyExternalImageToTexture", [source, destination, copy_size.as_any()])
  |> ignore
}
