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
pub fn CanvasRenderingContext2D::as_any(
  self : CanvasRenderingContext2D,
) -> @core.Any = "%identity"

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
  self
  .as_any()
  ._call("fillRect", [
    x |> @core.any,
    y |> @core.any,
    width |> @core.any,
    height |> @core.any,
  ])
  |> ignore
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
  self
  .as_any()
  ._call("strokeRect", [
    x |> @core.any,
    y |> @core.any,
    width |> @core.any,
    height |> @core.any,
  ])
  |> ignore
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
  self
  .as_any()
  ._call("clearRect", [
    x |> @core.any,
    y |> @core.any,
    width |> @core.any,
    height |> @core.any,
  ])
  |> ignore
}

///|
/// Drawing paths
#alias(begin_path)
pub fn CanvasRenderingContext2D::beginPath(self : Self) -> Unit {
  self.as_any()._call("beginPath", []) |> ignore
}

///|
#alias(close_path)
pub fn CanvasRenderingContext2D::closePath(self : Self) -> Unit {
  self.as_any()._call("closePath", []) |> ignore
}

///|
#alias(move_to)
pub fn CanvasRenderingContext2D::moveTo(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.as_any()._call("moveTo", [x |> @core.any, y |> @core.any]) |> ignore
}

///|
#alias(line_to)
pub fn CanvasRenderingContext2D::lineTo(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.as_any()._call("lineTo", [x |> @core.any, y |> @core.any]) |> ignore
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
      js._call("arc", [
        x |> @core.any,
        y |> @core.any,
        radius |> @core.any,
        start_angle |> @core.any,
        end_angle |> @core.any,
        ccw |> @core.any,
      ])
      |> ignore
    None =>
      js._call("arc", [
        x |> @core.any,
        y |> @core.any,
        radius |> @core.any,
        start_angle |> @core.any,
        end_angle |> @core.any,
      ])
      |> ignore
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
  self
  .as_any()
  ._call("arcTo", [
    x1 |> @core.any,
    y1 |> @core.any,
    x2 |> @core.any,
    y2 |> @core.any,
    radius |> @core.any,
  ])
  |> ignore
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
  self
  .as_any()
  ._call("bezierCurveTo", [
    cp1x |> @core.any,
    cp1y |> @core.any,
    cp2x |> @core.any,
    cp2y |> @core.any,
    x |> @core.any,
    y |> @core.any,
  ])
  |> ignore
}

///|
pub fn CanvasRenderingContext2D::quadraticCurveTo(
  self : Self,
  cpx : Double,
  cpy : Double,
  x : Double,
  y : Double,
) -> Unit {
  self
  .as_any()
  ._call("quadraticCurveTo", [
    cpx |> @core.any,
    cpy |> @core.any,
    x |> @core.any,
    y |> @core.any,
  ])
  |> ignore
}

///|
pub fn CanvasRenderingContext2D::rect(
  self : Self,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit {
  self
  .as_any()
  ._call("rect", [
    x |> @core.any,
    y |> @core.any,
    width |> @core.any,
    height |> @core.any,
  ])
  |> ignore
}

///|
pub fn CanvasRenderingContext2D::fill(self : Self) -> Unit {
  self.as_any()._call("fill", []) |> ignore
}

///|
pub fn CanvasRenderingContext2D::stroke(self : Self) -> Unit {
  self.as_any()._call("stroke", []) |> ignore
}

///|
pub fn CanvasRenderingContext2D::clip(self : Self) -> Unit {
  self.as_any()._call("clip", []) |> ignore
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
    Some(w) =>
      js._call("fillText", [
        text |> @core.any,
        x |> @core.any,
        y |> @core.any,
        w |> @core.any,
      ])
      |> ignore
    None =>
      js._call("fillText", [text |> @core.any, x |> @core.any, y |> @core.any])
      |> ignore
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
    Some(w) =>
      js._call("strokeText", [
        text |> @core.any,
        x |> @core.any,
        y |> @core.any,
        w |> @core.any,
      ])
      |> ignore
    None =>
      js._call("strokeText", [text |> @core.any, x |> @core.any, y |> @core.any])
      |> ignore
  }
}

///|
pub fn CanvasRenderingContext2D::measureText(
  self : Self,
  text : String,
) -> TextMetrics {
  self.as_any()._call("measureText", [text |> @core.any]).cast()
}

///|
/// Transformations
pub fn CanvasRenderingContext2D::scale(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.as_any()._call("scale", [x |> @core.any, y |> @core.any]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::rotate(self : Self, angle : Double) -> Unit {
  self.as_any()._call("rotate", [angle |> @core.any]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::translate(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.as_any()._call("translate", [x |> @core.any, y |> @core.any]) |> ignore
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
  self
  .as_any()
  ._call("transform", [
    a |> @core.any,
    b |> @core.any,
    c |> @core.any,
    d |> @core.any,
    e |> @core.any,
    f |> @core.any,
  ])
  |> ignore
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
  self
  .as_any()
  ._call("setTransform", [
    a |> @core.any,
    b |> @core.any,
    c |> @core.any,
    d |> @core.any,
    e |> @core.any,
    f |> @core.any,
  ])
  |> ignore
}

///|
pub fn CanvasRenderingContext2D::resetTransform(self : Self) -> Unit {
  self.as_any()._call("resetTransform", []) |> ignore
}

///|
/// Drawing images
pub fn CanvasRenderingContext2D::drawImage(
  self : Self,
  image : @core.Any,
  dx : Double,
  dy : Double,
) -> Unit {
  self.as_any()._call("drawImage", [image, dx |> @core.any, dy |> @core.any])
  |> ignore
}

///|
pub fn CanvasRenderingContext2D::drawImageScaled(
  self : Self,
  image : @core.Any,
  dx : Double,
  dy : Double,
  d_width : Double,
  d_height : Double,
) -> Unit {
  self
  .as_any()
  ._call("drawImage", [
    image,
    dx |> @core.any,
    dy |> @core.any,
    d_width |> @core.any,
    d_height |> @core.any,
  ])
  |> ignore
}

///|
pub fn CanvasRenderingContext2D::drawImageSub(
  self : Self,
  image : @core.Any,
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
    image,
    sx |> @core.any,
    sy |> @core.any,
    s_width |> @core.any,
    s_height |> @core.any,
    dx |> @core.any,
    dy |> @core.any,
    d_width |> @core.any,
    d_height |> @core.any,
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
  self
  .as_any()
  ._call("getImageData", [
    sx |> @core.any,
    sy |> @core.any,
    sw |> @core.any,
    sh |> @core.any,
  ])
  .cast()
}

///|
pub fn CanvasRenderingContext2D::putImageData(
  self : Self,
  image_data : ImageData,
  dx : Double,
  dy : Double,
) -> Unit {
  self
  .as_any()
  ._call("putImageData", [
    image_data |> @core.any,
    dx |> @core.any,
    dy |> @core.any,
  ])
  |> ignore
}

///|
pub fn CanvasRenderingContext2D::createImageData(
  self : Self,
  width : Int,
  height : Int,
) -> ImageData {
  self
  .as_any()
  ._call("createImageData", [width |> @core.any, height |> @core.any])
  .cast()
}

///|
/// State
pub fn CanvasRenderingContext2D::save(self : Self) -> Unit {
  self.as_any()._call("save", []) |> ignore
}

///|
pub fn CanvasRenderingContext2D::restore(self : Self) -> Unit {
  self.as_any()._call("restore", []) |> ignore
}

///|
/// TextMetrics
pub(all) struct TextMetrics {
  width : Double
}

///|
/// ImageData
pub(all) struct ImageData {
  width : Int
  height : Int
  data : @typedarray.Uint8Array
}

///|
extern "js" fn ffi_new_image_data(
  width : @core.Any,
  height : @core.Any,
) -> @core.Any =
  #|(width, height) => new ImageData(width, height)

///|
extern "js" fn ffi_new_image_data_with_data(
  data : @core.Any,
  width : @core.Any,
  height : @core.Any,
) -> @core.Any =
  #|(data, width, height) => new ImageData(data, width, height)

///|
pub fn ImageData::new(width : Int, height : Int) -> ImageData {
  @core.identity(ffi_new_image_data(width |> @core.any, height |> @core.any))
}

///|
pub fn ImageData::from_data(
  data : @typedarray.Uint8Array,
  width : Int,
  height : Int,
) -> ImageData {
  @core.identity(
    ffi_new_image_data_with_data(
      data |> @core.any,
      width |> @core.any,
      height |> @core.any,
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
pub fn ImageBitmap::as_any(self : ImageBitmap) -> @core.Any = "%identity"

///|
pub impl @worker.Transferable for ImageBitmap with to_transferable(self) -> @core.Any {
  self.as_any()
}

///|
pub fn ImageBitmap::close(self : Self) -> Unit {
  self.as_any()._call("close", []) |> ignore
}

///|
/// createImageBitmap
extern "js" fn ffi_create_image_bitmap(image : @core.Any) -> @core.Any =
  #|(image) => createImageBitmap(image)

///|
extern "js" fn ffi_create_image_bitmap_with_rect(
  image : @core.Any,
  sx : @core.Any,
  sy : @core.Any,
  sw : @core.Any,
  sh : @core.Any,
) -> @core.Any =
  #|(image, sx, sy, sw, sh) => createImageBitmap(image, sx, sy, sw, sh)

///|
#alias(create_image_bitmap)
pub fn createImageBitmap(image : @core.Any) -> ImageBitmap {
  @core.identity(ffi_create_image_bitmap(image))
}

///|
#alias(create_image_bitmap_rect)
pub async fn createImageBitmapRect(
  image : @core.Any,
  sx : Int,
  sy : Int,
  sw : Int,
  sh : Int,
) -> ImageBitmap {
  let promise : @js.Promise[ImageBitmap] = @core.identity(
    ffi_create_image_bitmap_with_rect(
      image,
      sx |> @core.any,
      sy |> @core.any,
      sw |> @core.any,
      sh |> @core.any,
    ),
  )
  promise.wait()
}
