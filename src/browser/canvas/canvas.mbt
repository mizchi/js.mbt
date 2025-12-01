///|
/// CanvasRenderingContext2D
pub(all) struct CanvasRenderingContext2D {
  canvas : @dom.HTMLCanvasElement
  mut fillStyle : String
  mut strokeStyle : String
  mut lineWidth : Double
  mut font : String
  mut textAlign : String
  mut textBaseline : String
  mut globalAlpha : Double
}

///|
pub impl @js.JsImpl for CanvasRenderingContext2D

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
  self._call("fillRect", [x, y, width, height]) |> ignore
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
  self._call("strokeRect", [x, y, width, height]) |> ignore
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
  self._call("clearRect", [x, y, width, height]) |> ignore
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
  let js = self.as_any()
  match counterclockwise {
    Some(ccw) =>
      js._call("arc", [x, y, radius, start_angle, end_angle, ccw]) |> ignore
    None => js._call("arc", [x, y, radius, start_angle, end_angle]) |> ignore
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
  self._call("arcTo", [x1, y1, x2, y2, radius]) |> ignore
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
  self._call("bezierCurveTo", [cp1x, cp1y, cp2x, cp2y, x, y]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::quadraticCurveTo(
  self : Self,
  cpx : Double,
  cpy : Double,
  x : Double,
  y : Double,
) -> Unit {
  self._call("quadraticCurveTo", [cpx, cpy, x, y]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::rect(
  self : Self,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit {
  self._call("rect", [x, y, width, height]) |> ignore
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
  let js = self.as_any()
  match max_width {
    Some(w) => js._call("fillText", [text, x, y, w]) |> ignore
    None => js._call("fillText", [text, x, y]) |> ignore
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
  let js = self.as_any()
  match max_width {
    Some(w) => js._call("strokeText", [text, x, y, w]) |> ignore
    None => js._call("strokeText", [text, x, y]) |> ignore
  }
}

///|
pub fn CanvasRenderingContext2D::measureText(
  self : Self,
  text : String,
) -> TextMetrics {
  self._call("measureText", [text]).cast()
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
  self._call("rotate", [angle]) |> ignore
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
  self._call("transform", [a, b, c, d, e, f]) |> ignore
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
  self._call("setTransform", [a, b, c, d, e, f]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::resetTransform(self : Self) -> Unit {
  self.call0("resetTransform") |> ignore
}

///|
/// Drawing images
pub fn CanvasRenderingContext2D::drawImage(
  self : Self,
  image : &@js.JsImpl,
  dx : Double,
  dy : Double,
) -> Unit {
  self._call("drawImage", [image.as_any(), dx, dy]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::drawImageScaled(
  self : Self,
  image : &@js.JsImpl,
  dx : Double,
  dy : Double,
  d_width : Double,
  d_height : Double,
) -> Unit {
  self._call("drawImage", [image.as_any(), dx, dy, d_width, d_height]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::drawImageSub(
  self : Self,
  image : &@js.JsImpl,
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
  .as_any()
  ._call("drawImage", [
    image.as_any(),
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
  self._call("getImageData", [sx, sy, sw, sh]).cast()
}

///|
pub fn CanvasRenderingContext2D::putImageData(
  self : Self,
  image_data : ImageData,
  dx : Double,
  dy : Double,
) -> Unit {
  self._call("putImageData", [image_data.as_any(), dx, dy]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::createImageData(
  self : Self,
  width : Int,
  height : Int,
) -> ImageData {
  self.call2("createImageData", width, height).cast()
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
pub(all) struct TextMetrics {
  width : Double
}

///|
pub impl @js.JsImpl for TextMetrics

///|
/// ImageData
pub(all) struct ImageData {
  width : Int
  height : Int
  data : @typedarray.Uint8Array
}

///|
pub impl @js.JsImpl for ImageData

///|
extern "js" fn ffi_new_image_data(
  width : @nostd.Any,
  height : @nostd.Any,
) -> @nostd.Any =
  #|(width, height) => new ImageData(width, height)

///|
extern "js" fn ffi_new_image_data_with_data(
  data : @nostd.Any,
  width : @nostd.Any,
  height : @nostd.Any,
) -> @nostd.Any =
  #|(data, width, height) => new ImageData(data, width, height)

///|
pub fn ImageData::new(width : Int, height : Int) -> ImageData {
  @js.identity(ffi_new_image_data(width |> @js.any, height |> @js.any))
}

///|
pub fn ImageData::from_data(
  data : @typedarray.Uint8Array,
  width : Int,
  height : Int,
) -> ImageData {
  @js.identity(
    ffi_new_image_data_with_data(
      data.as_any(),
      width |> @js.any,
      height |> @js.any,
    ),
  )
}

///|
/// ImageBitmap
pub(all) struct ImageBitmap {
  width : Int
  height : Int
}

///|
pub impl @js.JsImpl for ImageBitmap

///|
pub impl @worker.Transferable for ImageBitmap with to_transferable(self) -> @nostd.Any {
  self.as_any()
}

///|
pub fn ImageBitmap::close(self : Self) -> Unit {
  self.call0("close") |> ignore
}

///|
/// createImageBitmap
extern "js" fn ffi_create_image_bitmap(image : @nostd.Any) -> @nostd.Any =
  #|(image) => createImageBitmap(image)

///|
extern "js" fn ffi_create_image_bitmap_with_rect(
  image : @nostd.Any,
  sx : @nostd.Any,
  sy : @nostd.Any,
  sw : @nostd.Any,
  sh : @nostd.Any,
) -> @nostd.Any =
  #|(image, sx, sy, sw, sh) => createImageBitmap(image, sx, sy, sw, sh)

///|
#alias(create_image_bitmap)
pub fn createImageBitmap(image : &@js.JsImpl) -> ImageBitmap {
  @js.identity(ffi_create_image_bitmap(image.as_any()))
}

///|
#alias(create_image_bitmap_rect)
pub async fn createImageBitmapRect(
  image : &@js.JsImpl,
  sx : Int,
  sy : Int,
  sw : Int,
  sh : Int,
) -> ImageBitmap {
  let promise : @js.Promise[ImageBitmap] = @js.identity(
    ffi_create_image_bitmap_with_rect(
      image.as_any(),
      sx |> @js.any,
      sy |> @js.any,
      sw |> @js.any,
      sh |> @js.any,
    ),
  )
  promise.wait()
}
