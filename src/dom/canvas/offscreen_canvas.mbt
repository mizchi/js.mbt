///|
/// OffscreenCanvas
#external
pub type OffscreenCanvas

///|
pub impl JsImpl for OffscreenCanvas

///|
pub impl Transferable for OffscreenCanvas with to_transferable(self) -> Js {
  self.to_js()
}

///|
extern "js" fn ffi_new_offscreen_canvas(width : Js, height : Js) -> Js =
  #|(width, height) => new OffscreenCanvas(width, height)

///|
pub fn OffscreenCanvas::new(width : Int, height : Int) -> OffscreenCanvas {
  unsafe_cast(ffi_new_offscreen_canvas(width |> js, height |> js))
}

///|
pub fn OffscreenCanvas::width(self : Self) -> Int {
  self.get("width") |> unsafe_cast
}

///|
pub fn OffscreenCanvas::setWidth(self : Self, value : Int) -> Unit {
  self.set("width", value)
}

///|
pub fn OffscreenCanvas::height(self : Self) -> Int {
  self.get("height") |> unsafe_cast
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
  self.call("getContext", [context_type]) |> unsafe_cast
}

///|
pub fn OffscreenCanvas::convertToBlob(
  self : Self,
  options? : String,
) -> Promise[Blob] {
  match options {
    Some(opts) => self.call("convertToBlob", [opts]) |> unsafe_cast
    None => self.call0("convertToBlob") |> unsafe_cast
  }
}

///|
pub fn OffscreenCanvas::transferToImage_bitmap(self : Self) -> ImageBitmap {
  self.call0("transferToImageBitmap") |> unsafe_cast
}
