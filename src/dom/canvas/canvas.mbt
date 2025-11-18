///|
/// CanvasRenderingContext2D
#external
pub type CanvasRenderingContext2D

///|
pub impl JsImpl for CanvasRenderingContext2D

///|
/// Context properties
pub fn CanvasRenderingContext2D::canvas(self : Self) -> HTMLCanvasElement {
  unsafe_cast(self.get("canvas"))
}

///|
pub fn CanvasRenderingContext2D::fillStyle(self : Self) -> String {
  unsafe_cast(self.get("fillStyle"))
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
  unsafe_cast(self.get("strokeStyle"))
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
  unsafe_cast(self.get("lineWidth"))
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
  unsafe_cast(self.get("font"))
}

///|
pub fn CanvasRenderingContext2D::setFont(self : Self, value : String) -> Unit {
  self.set("font", value)
}

///|
pub fn CanvasRenderingContext2D::textAlign(self : Self) -> String {
  unsafe_cast(self.get("textAlign"))
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
  unsafe_cast(self.get("textBaseline"))
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
  unsafe_cast(self.get("globalAlpha"))
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
  self.invoke("fillRect", [x, y, width, height]) |> ignore
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
  self.invoke("strokeRect", [x, y, width, height]) |> ignore
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
  self.invoke("clearRect", [x, y, width, height]) |> ignore
}

///|
/// Drawing paths
#alias(begin_path)
pub fn CanvasRenderingContext2D::beginPath(self : Self) -> Unit {
  self.invoke("beginPath", []) |> ignore
}

///|
#alias(close_path)
pub fn CanvasRenderingContext2D::closePath(self : Self) -> Unit {
  self.invoke("closePath", []) |> ignore
}

///|
#alias(move_to)
pub fn CanvasRenderingContext2D::moveTo(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.invoke("moveTo", [x, y]) |> ignore
}

///|
#alias(line_to)
pub fn CanvasRenderingContext2D::lineTo(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.invoke("lineTo", [x, y]) |> ignore
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
      self.invoke("arc", [x, y, radius, start_angle, end_angle, ccw]) |> ignore
    None => self.invoke("arc", [x, y, radius, start_angle, end_angle]) |> ignore
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
  self.invoke("arcTo", [x1, y1, x2, y2, radius]) |> ignore
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
  self.invoke("bezierCurveTo", [cp1x, cp1y, cp2x, cp2y, x, y]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::quadraticCurveTo(
  self : Self,
  cpx : Double,
  cpy : Double,
  x : Double,
  y : Double,
) -> Unit {
  self.invoke("quadraticCurveTo", [cpx, cpy, x, y]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::rect(
  self : Self,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit {
  self.invoke("rect", [x, y, width, height]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::fill(self : Self) -> Unit {
  self.invoke("fill", []) |> ignore
}

///|
pub fn CanvasRenderingContext2D::stroke(self : Self) -> Unit {
  self.invoke("stroke", []) |> ignore
}

///|
pub fn CanvasRenderingContext2D::clip(self : Self) -> Unit {
  self.invoke("clip", []) |> ignore
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
    Some(w) => self.invoke("fillText", [text, x, y, w]) |> ignore
    None => self.invoke("fillText", [text, x, y]) |> ignore
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
    Some(w) => self.invoke("strokeText", [text, x, y, w]) |> ignore
    None => self.invoke("strokeText", [text, x, y]) |> ignore
  }
}

///|
pub fn CanvasRenderingContext2D::measureText(
  self : Self,
  text : String,
) -> TextMetrics {
  self.invoke("measureText", [text]) |> unsafe_cast
}

///|
/// Transformations
pub fn CanvasRenderingContext2D::scale(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.invoke("scale", [x, y]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::rotate(self : Self, angle : Double) -> Unit {
  self.invoke("rotate", [angle]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::translate(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.invoke("translate", [x, y]) |> ignore
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
  self.invoke("transform", [a, b, c, d, e, f]) |> ignore
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
  self.invoke("setTransform", [a, b, c, d, e, f]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::resetTransform(self : Self) -> Unit {
  self.invoke("resetTransform", []) |> ignore
}

///|
/// Drawing images
pub fn CanvasRenderingContext2D::drawImage(
  self : Self,
  image : &JsImpl,
  dx : Double,
  dy : Double,
) -> Unit {
  self.invoke("drawImage", [image.to_js(), dx, dy]) |> ignore
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
  self.invoke("drawImage", [image.to_js(), dx, dy, d_width, d_height]) |> ignore
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
  .invoke("drawImage", [
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
  self.invoke("getImageData", [sx, sy, sw, sh]) |> unsafe_cast
}

///|
pub fn CanvasRenderingContext2D::putImageData(
  self : Self,
  image_data : ImageData,
  dx : Double,
  dy : Double,
) -> Unit {
  self.invoke("putImageData", [image_data.to_js(), dx, dy]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::createImageData(
  self : Self,
  width : Int,
  height : Int,
) -> ImageData {
  self.invoke("createImageData", [width, height]) |> unsafe_cast
}

///|
/// State
pub fn CanvasRenderingContext2D::save(self : Self) -> Unit {
  self.invoke("save", []) |> ignore
}

///|
pub fn CanvasRenderingContext2D::restore(self : Self) -> Unit {
  self.invoke("restore", []) |> ignore
}

///|
/// TextMetrics
#external
pub type TextMetrics

///|
pub impl JsImpl for TextMetrics

///|
pub fn TextMetrics::width(self : Self) -> Double {
  unsafe_cast(self.get("width"))
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
  unsafe_cast(ffi_new_image_data(width |> safe_js, height |> safe_js))
}

///|
pub fn ImageData::from_data(
  data : Uint8Array,
  width : Int,
  height : Int,
) -> ImageData {
  unsafe_cast(
    ffi_new_image_data_with_data(
      data.to_js(),
      width |> safe_js,
      height |> safe_js,
    ),
  )
}

///|
pub fn ImageData::width(self : Self) -> Int {
  unsafe_cast(self.get("width"))
}

///|
pub fn ImageData::height(self : Self) -> Int {
  unsafe_cast(self.get("height"))
}

///|
pub fn ImageData::data(self : Self) -> Uint8Array {
  unsafe_cast(self.get("data"))
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
  unsafe_cast(self.get("width"))
}

///|
pub fn ImageBitmap::height(self : Self) -> Int {
  unsafe_cast(self.get("height"))
}

///|
pub fn ImageBitmap::close(self : Self) -> Unit {
  self.invoke("close", []) |> ignore
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
      sx |> safe_js,
      sy |> safe_js,
      sw |> safe_js,
      sh |> safe_js,
    ),
  )
}
