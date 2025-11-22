///|
/// CanvasRenderingContext2D
pub(all) struct CanvasRenderingContext2D {
  canvas : HTMLCanvasElement
  mut fillStyle : String
  mut strokeStyle : String
  mut lineWidth : Double
  mut font : String
  mut textAlign : String
  mut textBaseline : String
  mut globalAlpha : Double
}

///|
pub impl JsImpl for CanvasRenderingContext2D

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
  self.to_js().call("fillRect", [x, y, width, height]) |> ignore
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
  self.to_js().call("strokeRect", [x, y, width, height]) |> ignore
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
  self.to_js().call("clearRect", [x, y, width, height]) |> ignore
}

///|
/// Drawing paths
#alias(begin_path)
pub fn CanvasRenderingContext2D::beginPath(self : Self) -> Unit {
  self.to_js().call0("beginPath") |> ignore
}

///|
#alias(close_path)
pub fn CanvasRenderingContext2D::closePath(self : Self) -> Unit {
  self.to_js().call0("closePath") |> ignore
}

///|
#alias(move_to)
pub fn CanvasRenderingContext2D::moveTo(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.to_js().call2("moveTo", x, y) |> ignore
}

///|
#alias(line_to)
pub fn CanvasRenderingContext2D::lineTo(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.to_js().call2("lineTo", x, y) |> ignore
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
  let js = self.to_js()
  match counterclockwise {
    Some(ccw) =>
      js.call("arc", [x, y, radius, start_angle, end_angle, ccw]) |> ignore
    None => js.call("arc", [x, y, radius, start_angle, end_angle]) |> ignore
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
  self.to_js().call("arcTo", [x1, y1, x2, y2, radius]) |> ignore
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
  self.to_js().call("bezierCurveTo", [cp1x, cp1y, cp2x, cp2y, x, y]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::quadraticCurveTo(
  self : Self,
  cpx : Double,
  cpy : Double,
  x : Double,
  y : Double,
) -> Unit {
  self.to_js().call("quadraticCurveTo", [cpx, cpy, x, y]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::rect(
  self : Self,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit {
  self.to_js().call("rect", [x, y, width, height]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::fill(self : Self) -> Unit {
  self.to_js().call0("fill") |> ignore
}

///|
pub fn CanvasRenderingContext2D::stroke(self : Self) -> Unit {
  self.to_js().call0("stroke") |> ignore
}

///|
pub fn CanvasRenderingContext2D::clip(self : Self) -> Unit {
  self.to_js().call0("clip") |> ignore
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
  let js = self.to_js()
  match max_width {
    Some(w) => js.call("fillText", [text, x, y, w]) |> ignore
    None => js.call("fillText", [text, x, y]) |> ignore
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
  let js = self.to_js()
  match max_width {
    Some(w) => js.call("strokeText", [text, x, y, w]) |> ignore
    None => js.call("strokeText", [text, x, y]) |> ignore
  }
}

///|
pub fn CanvasRenderingContext2D::measureText(
  self : Self,
  text : String,
) -> TextMetrics {
  self.to_js().call("measureText", [text]) |> unsafe_cast
}

///|
/// Transformations
pub fn CanvasRenderingContext2D::scale(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.to_js().call2("scale", x, y) |> ignore
}

///|
pub fn CanvasRenderingContext2D::rotate(self : Self, angle : Double) -> Unit {
  self.to_js().call("rotate", [angle]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::translate(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.to_js().call2("translate", x, y) |> ignore
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
  self.to_js().call("transform", [a, b, c, d, e, f]) |> ignore
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
  self.to_js().call("setTransform", [a, b, c, d, e, f]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::resetTransform(self : Self) -> Unit {
  self.to_js().call0("resetTransform") |> ignore
}

///|
/// Drawing images
pub fn CanvasRenderingContext2D::drawImage(
  self : Self,
  image : &JsImpl,
  dx : Double,
  dy : Double,
) -> Unit {
  self.to_js().call("drawImage", [image.to_js(), dx, dy]) |> ignore
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
  self.to_js().call("drawImage", [image.to_js(), dx, dy, d_width, d_height])
  |> ignore
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
  self.to_js().call("getImageData", [sx, sy, sw, sh]) |> unsafe_cast
}

///|
pub fn CanvasRenderingContext2D::putImageData(
  self : Self,
  image_data : ImageData,
  dx : Double,
  dy : Double,
) -> Unit {
  self.to_js().call("putImageData", [image_data.to_js(), dx, dy]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::createImageData(
  self : Self,
  width : Int,
  height : Int,
) -> ImageData {
  self.to_js().call2("createImageData", width, height) |> unsafe_cast
}

///|
/// State
pub fn CanvasRenderingContext2D::save(self : Self) -> Unit {
  self.to_js().call0("save") |> ignore
}

///|
pub fn CanvasRenderingContext2D::restore(self : Self) -> Unit {
  self.to_js().call0("restore") |> ignore
}

///|
/// TextMetrics
pub(all) struct TextMetrics {
  width : Double
}

///|
pub impl JsImpl for TextMetrics

///|
/// ImageData
pub(all) struct ImageData {
  width : Int
  height : Int
  data : Uint8Array
}

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
/// ImageBitmap
pub(all) struct ImageBitmap {
  width : Int
  height : Int
}

///|
pub impl JsImpl for ImageBitmap

///|
pub impl Transferable for ImageBitmap with to_transferable(self) -> Js {
  self.to_js()
}

///|
pub fn ImageBitmap::close(self : Self) -> Unit {
  self.to_js().call0("close") |> ignore
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
