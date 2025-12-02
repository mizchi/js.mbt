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
) -> @nostd.Any = "%identity"

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
    x |> @nostd.any,
    y |> @nostd.any,
    width |> @nostd.any,
    height |> @nostd.any,
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
    x |> @nostd.any,
    y |> @nostd.any,
    width |> @nostd.any,
    height |> @nostd.any,
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
    x |> @nostd.any,
    y |> @nostd.any,
    width |> @nostd.any,
    height |> @nostd.any,
  ])
  |> ignore
}

///|
/// Drawing paths
#alias(begin_path)
pub fn CanvasRenderingContext2D::beginPath(self : Self) -> Unit {
  self.as_any().call0("beginPath") |> ignore
}

///|
#alias(close_path)
pub fn CanvasRenderingContext2D::closePath(self : Self) -> Unit {
  self.as_any().call0("closePath") |> ignore
}

///|
#alias(move_to)
pub fn CanvasRenderingContext2D::moveTo(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.as_any()._call("moveTo", [x |> @nostd.any, y |> @nostd.any]) |> ignore
}

///|
#alias(line_to)
pub fn CanvasRenderingContext2D::lineTo(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.as_any()._call("lineTo", [x |> @nostd.any, y |> @nostd.any]) |> ignore
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
        x |> @nostd.any,
        y |> @nostd.any,
        radius |> @nostd.any,
        start_angle |> @nostd.any,
        end_angle |> @nostd.any,
        ccw |> @nostd.any,
      ])
      |> ignore
    None =>
      js._call("arc", [
        x |> @nostd.any,
        y |> @nostd.any,
        radius |> @nostd.any,
        start_angle |> @nostd.any,
        end_angle |> @nostd.any,
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
    x1 |> @nostd.any,
    y1 |> @nostd.any,
    x2 |> @nostd.any,
    y2 |> @nostd.any,
    radius |> @nostd.any,
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
    cp1x |> @nostd.any,
    cp1y |> @nostd.any,
    cp2x |> @nostd.any,
    cp2y |> @nostd.any,
    x |> @nostd.any,
    y |> @nostd.any,
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
    cpx |> @nostd.any,
    cpy |> @nostd.any,
    x |> @nostd.any,
    y |> @nostd.any,
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
    x |> @nostd.any,
    y |> @nostd.any,
    width |> @nostd.any,
    height |> @nostd.any,
  ])
  |> ignore
}

///|
pub fn CanvasRenderingContext2D::fill(self : Self) -> Unit {
  self.as_any().call0("fill") |> ignore
}

///|
pub fn CanvasRenderingContext2D::stroke(self : Self) -> Unit {
  self.as_any().call0("stroke") |> ignore
}

///|
pub fn CanvasRenderingContext2D::clip(self : Self) -> Unit {
  self.as_any().call0("clip") |> ignore
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
        text |> @nostd.any,
        x |> @nostd.any,
        y |> @nostd.any,
        w |> @nostd.any,
      ])
      |> ignore
    None =>
      js._call("fillText", [
        text |> @nostd.any,
        x |> @nostd.any,
        y |> @nostd.any,
      ])
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
        text |> @nostd.any,
        x |> @nostd.any,
        y |> @nostd.any,
        w |> @nostd.any,
      ])
      |> ignore
    None =>
      js._call("strokeText", [
        text |> @nostd.any,
        x |> @nostd.any,
        y |> @nostd.any,
      ])
      |> ignore
  }
}

///|
pub fn CanvasRenderingContext2D::measureText(
  self : Self,
  text : String,
) -> TextMetrics {
  self.as_any()._call("measureText", [text |> @nostd.any]).cast()
}

///|
/// Transformations
pub fn CanvasRenderingContext2D::scale(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.as_any()._call("scale", [x |> @nostd.any, y |> @nostd.any]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::rotate(self : Self, angle : Double) -> Unit {
  self.as_any()._call("rotate", [angle |> @nostd.any]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::translate(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.as_any()._call("translate", [x |> @nostd.any, y |> @nostd.any]) |> ignore
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
    a |> @nostd.any,
    b |> @nostd.any,
    c |> @nostd.any,
    d |> @nostd.any,
    e |> @nostd.any,
    f |> @nostd.any,
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
    a |> @nostd.any,
    b |> @nostd.any,
    c |> @nostd.any,
    d |> @nostd.any,
    e |> @nostd.any,
    f |> @nostd.any,
  ])
  |> ignore
}

///|
pub fn CanvasRenderingContext2D::resetTransform(self : Self) -> Unit {
  self.as_any().call0("resetTransform") |> ignore
}

///|
/// Drawing images
pub fn CanvasRenderingContext2D::drawImage(
  self : Self,
  image : @nostd.Any,
  dx : Double,
  dy : Double,
) -> Unit {
  self.as_any()._call("drawImage", [image, dx |> @nostd.any, dy |> @nostd.any])
  |> ignore
}

///|
pub fn CanvasRenderingContext2D::drawImageScaled(
  self : Self,
  image : @nostd.Any,
  dx : Double,
  dy : Double,
  d_width : Double,
  d_height : Double,
) -> Unit {
  self
  .as_any()
  ._call("drawImage", [
    image,
    dx |> @nostd.any,
    dy |> @nostd.any,
    d_width |> @nostd.any,
    d_height |> @nostd.any,
  ])
  |> ignore
}

///|
pub fn CanvasRenderingContext2D::drawImageSub(
  self : Self,
  image : @nostd.Any,
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
    sx |> @nostd.any,
    sy |> @nostd.any,
    s_width |> @nostd.any,
    s_height |> @nostd.any,
    dx |> @nostd.any,
    dy |> @nostd.any,
    d_width |> @nostd.any,
    d_height |> @nostd.any,
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
    sx |> @nostd.any,
    sy |> @nostd.any,
    sw |> @nostd.any,
    sh |> @nostd.any,
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
    image_data |> @nostd.any,
    dx |> @nostd.any,
    dy |> @nostd.any,
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
  ._call("createImageData", [width |> @nostd.any, height |> @nostd.any])
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
  @nostd.identity(ffi_new_image_data(width |> @nostd.any, height |> @nostd.any))
}

///|
pub fn ImageData::from_data(
  data : @typedarray.Uint8Array,
  width : Int,
  height : Int,
) -> ImageData {
  @nostd.identity(
    ffi_new_image_data_with_data(
      data |> @nostd.any,
      width |> @nostd.any,
      height |> @nostd.any,
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
pub fn ImageBitmap::as_any(self : ImageBitmap) -> @nostd.Any = "%identity"

///|
pub impl @worker.Transferable for ImageBitmap with to_transferable(self) -> @nostd.Any {
  self.as_any()
}

///|
pub fn ImageBitmap::close(self : Self) -> Unit {
  self.as_any()._call("close", []) |> ignore
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
pub fn createImageBitmap(image : @nostd.Any) -> ImageBitmap {
  @nostd.identity(ffi_create_image_bitmap(image))
}

///|
#alias(create_image_bitmap_rect)
pub async fn createImageBitmapRect(
  image : @nostd.Any,
  sx : Int,
  sy : Int,
  sw : Int,
  sh : Int,
) -> ImageBitmap {
  let promise : @js.Promise[ImageBitmap] = @nostd.identity(
    ffi_create_image_bitmap_with_rect(
      image,
      sx |> @nostd.any,
      sy |> @nostd.any,
      sw |> @nostd.any,
      sh |> @nostd.any,
    ),
  )
  promise.wait()
}
