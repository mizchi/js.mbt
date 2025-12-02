///|
/// OffscreenCanvas
#external
pub type OffscreenCanvas

///|
pub fn OffscreenCanvas::as_any(self : OffscreenCanvas) -> @nostd.Any = "%identity"

///|
pub impl @worker.Transferable for OffscreenCanvas with to_transferable(self) -> @nostd.Any = "%identity"

///|
extern "js" fn ffi_new_offscreen_canvas(
  width : @nostd.Any,
  height : @nostd.Any,
) -> @nostd.Any =
  #|(width, height) => new OffscreenCanvas(width, height)

///|
pub fn OffscreenCanvas::new(width : Int, height : Int) -> OffscreenCanvas {
  @nostd.identity(ffi_new_offscreen_canvas(width |> @js.any, height |> @js.any))
}

///|
pub fn OffscreenCanvas::width(self : Self) -> Int {
  self.as_any()._get("width").cast()
}

///|
pub fn OffscreenCanvas::setWidth(self : Self, value : Int) -> Unit {
  self.as_any()._set("width", value |> @nostd.any)
}

///|
pub fn OffscreenCanvas::height(self : Self) -> Int {
  self.as_any()._get("height").cast()
}

///|
pub fn OffscreenCanvas::setHeight(self : Self, value : Int) -> Unit {
  self.as_any()._set("height", value |> @nostd.any)
}

///|
pub fn OffscreenCanvas::getContext(
  self : Self,
  context_type : String,
) -> CanvasRenderingContext2D {
  self.as_any()._call("getContext", [context_type |> @nostd.any]).cast()
}

///|
pub async fn OffscreenCanvas::convertToBlob(
  self : Self,
  options? : String,
) -> @blob.Blob {
  let promise : @js.Promise[@blob.Blob] = match options {
    Some(opts) =>
      self.as_any()._call("convertToBlob", [opts |> @nostd.any]).cast()
    None => self.as_any()._call("convertToBlob", []).cast()
  }
  promise.wait()
}

///|
pub fn OffscreenCanvas::transferToImageBitmap(self : Self) -> ImageBitmap {
  self.as_any()._call("transferToImageBitmap", []).cast()
}
