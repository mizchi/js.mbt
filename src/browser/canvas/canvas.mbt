///|
/// CanvasRenderingContext2D
#external
pub type CanvasRenderingContext2D

///|
pub impl JsImpl for CanvasRenderingContext2D

///|
/// Context properties
pub fn CanvasRenderingContext2D::canvas(self : Self) -> HTMLCanvasElement {
  self.get("canvas") |> unsafe_cast
}

///|
pub fn CanvasRenderingContext2D::fillStyle(self : Self) -> String {
  self.get("fillStyle") |> unsafe_cast
}

///|
pub fn CanvasRenderingContext2D::setFillStyle(
  self : Self,
  value : String,
) -> Unit {
  self.set("fillStyle", value)
}

///|
pub fn CanvasRenderingContext2D::strokeStyle(self : Self) -> String {
  self.get("strokeStyle") |> unsafe_cast
}

///|
pub fn CanvasRenderingContext2D::setStrokeStyle(
  self : Self,
  value : String,
) -> Unit {
  self.set("strokeStyle", value)
}

///|
pub fn CanvasRenderingContext2D::lineWidth(self : Self) -> Double {
  self.get("lineWidth") |> unsafe_cast
}

///|
pub fn CanvasRenderingContext2D::setLineWidth(
  self : Self,
  value : Double,
) -> Unit {
  self.set("lineWidth", value)
}

///|
pub fn CanvasRenderingContext2D::font(self : Self) -> String {
  self.get("font") |> unsafe_cast
}

///|
pub fn CanvasRenderingContext2D::setFont(self : Self, value : String) -> Unit {
  self.set("font", value)
}

///|
pub fn CanvasRenderingContext2D::textAlign(self : Self) -> String {
  self.get("textAlign") |> unsafe_cast
}

///|
pub fn CanvasRenderingContext2D::setTextAlign(
  self : Self,
  value : String,
) -> Unit {
  self.set("textAlign", value)
}

///|
pub fn CanvasRenderingContext2D::textBaseline(self : Self) -> String {
  self.get("textBaseline") |> unsafe_cast
}

///|
pub fn CanvasRenderingContext2D::setTextBaseline(
  self : Self,
  value : String,
) -> Unit {
  self.set("textBaseline", value)
}

///|
pub fn CanvasRenderingContext2D::globalAlpha(self : Self) -> Double {
  self.get("globalAlpha") |> unsafe_cast
}

///|
pub fn CanvasRenderingContext2D::setGlobalAlpha(
  self : Self,
  value : Double,
) -> Unit {
  self.set("globalAlpha", value)
}

///|
/// Drawing rectangles
#alias(fill_rect)
pub fn CanvasRenderingContext2D::fillRect(
  self : Self,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit {
  self.call("fillRect", [x, y, width, height]) |> ignore
}

///|
#alias(stroke_rect)
pub fn CanvasRenderingContext2D::strokeRect(
  self : Self,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit {
  self.call("strokeRect", [x, y, width, height]) |> ignore
}

///|
#alias(clear_rect)
pub fn CanvasRenderingContext2D::clearRect(
  self : Self,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit {
  self.call("clearRect", [x, y, width, height]) |> ignore
}

///|
/// Drawing paths
#alias(begin_path)
pub fn CanvasRenderingContext2D::beginPath(self : Self) -> Unit {
  self.call0("beginPath") |> ignore
}

///|
#alias(close_path)
pub fn CanvasRenderingContext2D::closePath(self : Self) -> Unit {
  self.call0("closePath") |> ignore
}

///|
#alias(move_to)
pub fn CanvasRenderingContext2D::moveTo(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.call2("moveTo", x, y) |> ignore
}

///|
#alias(line_to)
pub fn CanvasRenderingContext2D::lineTo(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.call2("lineTo", x, y) |> ignore
}

///|
pub fn CanvasRenderingContext2D::arc(
  self : Self,
  x : Double,
  y : Double,
  radius : Double,
  start_angle : Double,
  end_angle : Double,
  counterclockwise? : Bool,
) -> Unit {
  match counterclockwise {
    Some(ccw) =>
      self.call("arc", [x, y, radius, start_angle, end_angle, ccw]) |> ignore
    None => self.call("arc", [x, y, radius, start_angle, end_angle]) |> ignore
  }
}

///|
pub fn CanvasRenderingContext2D::arcTo(
  self : Self,
  x1 : Double,
  y1 : Double,
  x2 : Double,
  y2 : Double,
  radius : Double,
) -> Unit {
  self.call("arcTo", [x1, y1, x2, y2, radius]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::bezierCurveTo(
  self : Self,
  cp1x : Double,
  cp1y : Double,
  cp2x : Double,
  cp2y : Double,
  x : Double,
  y : Double,
) -> Unit {
  self.call("bezierCurveTo", [cp1x, cp1y, cp2x, cp2y, x, y]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::quadraticCurveTo(
  self : Self,
  cpx : Double,
  cpy : Double,
  x : Double,
  y : Double,
) -> Unit {
  self.call("quadraticCurveTo", [cpx, cpy, x, y]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::rect(
  self : Self,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit {
  self.call("rect", [x, y, width, height]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::fill(self : Self) -> Unit {
  self.call0("fill") |> ignore
}

///|
pub fn CanvasRenderingContext2D::stroke(self : Self) -> Unit {
  self.call0("stroke") |> ignore
}

///|
pub fn CanvasRenderingContext2D::clip(self : Self) -> Unit {
  self.call0("clip") |> ignore
}

///|
/// Drawing text
pub fn CanvasRenderingContext2D::fillText(
  self : Self,
  text : String,
  x : Double,
  y : Double,
  max_width? : Double,
) -> Unit {
  match max_width {
    Some(w) => self.call("fillText", [text, x, y, w]) |> ignore
    None => self.call("fillText", [text, x, y]) |> ignore
  }
}

///|
pub fn CanvasRenderingContext2D::strokeText(
  self : Self,
  text : String,
  x : Double,
  y : Double,
  max_width? : Double,
) -> Unit {
  match max_width {
    Some(w) => self.call("strokeText", [text, x, y, w]) |> ignore
    None => self.call("strokeText", [text, x, y]) |> ignore
  }
}

///|
pub fn CanvasRenderingContext2D::measureText(
  self : Self,
  text : String,
) -> TextMetrics {
  self.call("measureText", [text]) |> unsafe_cast
}

///|
/// Transformations
pub fn CanvasRenderingContext2D::scale(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.call2("scale", x, y) |> ignore
}

///|
pub fn CanvasRenderingContext2D::rotate(self : Self, angle : Double) -> Unit {
  self.call("rotate", [angle]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::translate(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.call2("translate", x, y) |> ignore
}

///|
pub fn CanvasRenderingContext2D::transform(
  self : Self,
  a : Double,
  b : Double,
  c : Double,
  d : Double,
  e : Double,
  f : Double,
) -> Unit {
  self.call("transform", [a, b, c, d, e, f]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::setTransform(
  self : Self,
  a : Double,
  b : Double,
  c : Double,
  d : Double,
  e : Double,
  f : Double,
) -> Unit {
  self.call("setTransform", [a, b, c, d, e, f]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::resetTransform(self : Self) -> Unit {
  self.call0("resetTransform") |> ignore
}

///|
/// Drawing images
pub fn CanvasRenderingContext2D::drawImage(
  self : Self,
  image : &JsImpl,
  dx : Double,
  dy : Double,
) -> Unit {
  self.call("drawImage", [image.to_js(), dx, dy]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::drawImageScaled(
  self : Self,
  image : &JsImpl,
  dx : Double,
  dy : Double,
  d_width : Double,
  d_height : Double,
) -> Unit {
  self.call("drawImage", [image.to_js(), dx, dy, d_width, d_height]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::drawImageSub(
  self : Self,
  image : &JsImpl,
  sx : Double,
  sy : Double,
  s_width : Double,
  s_height : Double,
  dx : Double,
  dy : Double,
  d_width : Double,
  d_height : Double,
) -> Unit {
  self
  .to_js()
  .call("drawImage", [
    image.to_js(),
    sx,
    sy,
    s_width,
    s_height,
    dx,
    dy,
    d_width,
    d_height,
  ])
  |> ignore
}

///|
/// Pixel manipulation
pub fn CanvasRenderingContext2D::getImageData(
  self : Self,
  sx : Double,
  sy : Double,
  sw : Double,
  sh : Double,
) -> ImageData {
  self.call("getImageData", [sx, sy, sw, sh]) |> unsafe_cast
}

///|
pub fn CanvasRenderingContext2D::putImageData(
  self : Self,
  image_data : ImageData,
  dx : Double,
  dy : Double,
) -> Unit {
  self.call("putImageData", [image_data.to_js(), dx, dy]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::createImageData(
  self : Self,
  width : Int,
  height : Int,
) -> ImageData {
  self.call2("createImageData", width, height) |> unsafe_cast
}

///|
/// State
pub fn CanvasRenderingContext2D::save(self : Self) -> Unit {
  self.call0("save") |> ignore
}

///|
pub fn CanvasRenderingContext2D::restore(self : Self) -> Unit {
  self.call0("restore") |> ignore
}

///|
/// TextMetrics
#external
pub type TextMetrics

///|
pub impl JsImpl for TextMetrics

///|
pub fn TextMetrics::width(self : Self) -> Double {
  self.get("width") |> unsafe_cast
}

///|
/// ImageData
#external
pub type ImageData

///|
pub impl JsImpl for ImageData

///|
extern "js" fn ffi_new_image_data(width : Js, height : Js) -> Js =
  #|(width, height) => new ImageData(width, height)

///|
extern "js" fn ffi_new_image_data_with_data(
  data : Js,
  width : Js,
  height : Js,
) -> Js =
  #|(data, width, height) => new ImageData(data, width, height)

///|
pub fn ImageData::new(width : Int, height : Int) -> ImageData {
  unsafe_cast(ffi_new_image_data(width |> js, height |> js))
}

///|
pub fn ImageData::from_data(
  data : Uint8Array,
  width : Int,
  height : Int,
) -> ImageData {
  unsafe_cast(
    ffi_new_image_data_with_data(data.to_js(), width |> js, height |> js),
  )
}

///|
pub fn ImageData::width(self : Self) -> Int {
  self.get("width") |> unsafe_cast
}

///|
pub fn ImageData::height(self : Self) -> Int {
  self.get("height") |> unsafe_cast
}

///|
pub fn ImageData::data(self : Self) -> Uint8Array {
  self.get("data") |> unsafe_cast
}

///|
/// ImageBitmap
#external
pub type ImageBitmap

///|
pub impl JsImpl for ImageBitmap

///|
pub impl Transferable for ImageBitmap with to_transferable(self) -> Js {
  self.to_js()
}

///|
pub fn ImageBitmap::width(self : Self) -> Int {
  self.get("width") |> unsafe_cast
}

///|
pub fn ImageBitmap::height(self : Self) -> Int {
  self.get("height") |> unsafe_cast
}

///|
pub fn ImageBitmap::close(self : Self) -> Unit {
  self.call0("close") |> ignore
}

///|
/// createImageBitmap
extern "js" fn ffi_create_image_bitmap(image : Js) -> Js =
  #|(image) => createImageBitmap(image)

///|
extern "js" fn ffi_create_image_bitmap_with_rect(
  image : Js,
  sx : Js,
  sy : Js,
  sw : Js,
  sh : Js,
) -> Js =
  #|(image, sx, sy, sw, sh) => createImageBitmap(image, sx, sy, sw, sh)

///|
#alias(create_image_bitmap)
pub fn createImageBitmap(image : &JsImpl) -> ImageBitmap {
  unsafe_cast(ffi_create_image_bitmap(image.to_js()))
}

///|
#alias(create_image_bitmap_rect)
pub fn createImageBitmapRect(
  image : &JsImpl,
  sx : Int,
  sy : Int,
  sw : Int,
  sh : Int,
) -> Promise[ImageBitmap] {
  unsafe_cast(
    ffi_create_image_bitmap_with_rect(
      image.to_js(),
      sx |> js,
      sy |> js,
      sw |> js,
      sh |> js,
    ),
  )
}
