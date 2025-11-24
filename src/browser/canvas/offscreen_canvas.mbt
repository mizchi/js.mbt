///|
/// OffscreenCanvas
#external
pub type OffscreenCanvas

///|
pub impl @js.JsImpl for OffscreenCanvas

///|
pub impl @worker.Transferable for OffscreenCanvas with to_transferable(self) -> @js.Any {
  self.to_any()
}

///|
extern "js" fn ffi_new_offscreen_canvas(
  width : @js.Any,
  height : @js.Any,
) -> @js.Any =
  #|(width, height) => new OffscreenCanvas(width, height)

///|
pub fn OffscreenCanvas::new(width : Int, height : Int) -> OffscreenCanvas {
  @js.identity(ffi_new_offscreen_canvas(width |> @js.js, height |> @js.js))
}

///|
pub fn OffscreenCanvas::width(self : Self) -> Int {
  self.get("width").cast()
}

///|
pub fn OffscreenCanvas::setWidth(self : Self, value : Int) -> Unit {
  self.set("width", value)
}

///|
pub fn OffscreenCanvas::height(self : Self) -> Int {
  self.get("height").cast()
}

///|
pub fn OffscreenCanvas::setHeight(self : Self, value : Int) -> Unit {
  self.set("height", value)
}

///|
pub fn OffscreenCanvas::getContext(
  self : Self,
  context_type : String,
) -> CanvasRenderingContext2D {
  self.call("getContext", [context_type]).cast()
}

///|
pub fn OffscreenCanvas::convertToBlob(
  self : Self,
  options? : String,
) -> @js.Promise[@blob.Blob] {
  match options {
    Some(opts) => self.call("convertToBlob", [opts]).cast()
    None => self.call0("convertToBlob").cast()
  }
}

///|
pub fn OffscreenCanvas::transferToImageBitmap(self : Self) -> ImageBitmap {
  self.call0("transferToImageBitmap").cast()
}
