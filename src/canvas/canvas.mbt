///|
/// CanvasRenderingContext2D
#external
pub type CanvasRenderingContext2D

///|
pub impl Js for CanvasRenderingContext2D

///|
/// Context properties
pub fn CanvasRenderingContext2D::canvas(self : Self) -> HTMLCanvasElement {
  unsafe_cast(self.get("canvas"))
}

///|
pub fn CanvasRenderingContext2D::fill_style(self : Self) -> String {
  unsafe_cast(self.get("fillStyle"))
}

///|
pub fn CanvasRenderingContext2D::set_fill_style(
  self : Self,
  value : String,
) -> Unit {
  self.set("fillStyle", value)
}

///|
pub fn CanvasRenderingContext2D::stroke_style(self : Self) -> String {
  unsafe_cast(self.get("strokeStyle"))
}

///|
pub fn CanvasRenderingContext2D::set_stroke_style(
  self : Self,
  value : String,
) -> Unit {
  self.set("strokeStyle", value)
}

///|
pub fn CanvasRenderingContext2D::line_width(self : Self) -> Double {
  unsafe_cast(self.get("lineWidth"))
}

///|
pub fn CanvasRenderingContext2D::set_line_width(
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
pub fn CanvasRenderingContext2D::set_font(self : Self, value : String) -> Unit {
  self.set("font", value)
}

///|
pub fn CanvasRenderingContext2D::text_align(self : Self) -> String {
  unsafe_cast(self.get("textAlign"))
}

///|
pub fn CanvasRenderingContext2D::set_text_align(
  self : Self,
  value : String,
) -> Unit {
  self.set("textAlign", value)
}

///|
pub fn CanvasRenderingContext2D::text_baseline(self : Self) -> String {
  unsafe_cast(self.get("textBaseline"))
}

///|
pub fn CanvasRenderingContext2D::set_text_baseline(
  self : Self,
  value : String,
) -> Unit {
  self.set("textBaseline", value)
}

///|
pub fn CanvasRenderingContext2D::global_alpha(self : Self) -> Double {
  unsafe_cast(self.to_js().get("globalAlpha"))
}

///|
pub fn CanvasRenderingContext2D::set_global_alpha(
  self : Self,
  value : Double,
) -> Unit {
  self.to_js().set("globalAlpha", value)
}

///|
/// Drawing rectangles
pub fn CanvasRenderingContext2D::fill_rect(
  self : Self,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit {
  self.invoke("fillRect", [x, y, width, height]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::stroke_rect(
  self : Self,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit {
  self.invoke("strokeRect", [x, y, width, height]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::clear_rect(
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
pub fn CanvasRenderingContext2D::begin_path(self : Self) -> Unit {
  self.invoke("beginPath", []) |> ignore
}

///|
pub fn CanvasRenderingContext2D::close_path(self : Self) -> Unit {
  self.invoke("closePath", []) |> ignore
}

///|
pub fn CanvasRenderingContext2D::move_to(
  self : Self,
  x : Double,
  y : Double,
) -> Unit {
  self.invoke("moveTo", [x, y]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::line_to(
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
pub fn CanvasRenderingContext2D::arc_to(
  self : Self,
  x1 : Double,
  y1 : Double,
  x2 : Double,
  y2 : Double,
  radius : Double,
) -> Unit {
  self.invoke("arcTo", [x1 |> js, y1 |> js, x2 |> js, y2 |> js, radius])
  |> ignore
}

///|
pub fn CanvasRenderingContext2D::bezier_curve_to(
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
pub fn CanvasRenderingContext2D::quadratic_curve_to(
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
pub fn CanvasRenderingContext2D::fill_text(
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
pub fn CanvasRenderingContext2D::stroke_text(
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
pub fn CanvasRenderingContext2D::measure_text(
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
pub fn CanvasRenderingContext2D::set_transform(
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
pub fn CanvasRenderingContext2D::reset_transform(self : Self) -> Unit {
  self.invoke("resetTransform", []) |> ignore
}

///|
/// Drawing images
pub fn CanvasRenderingContext2D::draw_image(
  self : Self,
  image : &Js,
  dx : Double,
  dy : Double,
) -> Unit {
  self.invoke("drawImage", [image.to_js(), dx, dy]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::draw_image_scaled(
  self : Self,
  image : &Js,
  dx : Double,
  dy : Double,
  d_width : Double,
  d_height : Double,
) -> Unit {
  self.invoke("drawImage", [image.to_js(), dx, dy, d_width, d_height]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::draw_image_sub(
  self : Self,
  image : &Js,
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
pub fn CanvasRenderingContext2D::get_image_data(
  self : Self,
  sx : Double,
  sy : Double,
  sw : Double,
  sh : Double,
) -> ImageData {
  self.invoke("getImageData", [sx, sy, sw, sh]) |> unsafe_cast
}

///|
pub fn CanvasRenderingContext2D::put_image_data(
  self : Self,
  image_data : ImageData,
  dx : Double,
  dy : Double,
) -> Unit {
  self.invoke("putImageData", [image_data.to_js(), dx, dy]) |> ignore
}

///|
pub fn CanvasRenderingContext2D::create_image_data(
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
pub impl Js for TextMetrics

///|
pub fn TextMetrics::width(self : Self) -> Double {
  unsafe_cast(self.to_js().get("width"))
}

///|
/// ImageData
#external
pub type ImageData

///|
pub impl Js for ImageData

///|
extern "js" fn ffi_new_image_data(width : Val, height : Val) -> Val =
  #|(width, height) => new ImageData(width, height)

///|
extern "js" fn ffi_new_image_data_with_data(
  data : Val,
  width : Val,
  height : Val,
) -> Val =
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
pub impl Js for ImageBitmap

///|
pub impl Transferable for ImageBitmap with to_transferable(self) -> Val {
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
extern "js" fn ffi_create_image_bitmap(image : Val) -> Val =
  #|(image) => createImageBitmap(image)

///|
extern "js" fn ffi_create_image_bitmap_with_rect(
  image : Val,
  sx : Val,
  sy : Val,
  sw : Val,
  sh : Val,
) -> Val =
  #|(image, sx, sy, sw, sh) => createImageBitmap(image, sx, sy, sw, sh)

///|
pub fn create_image_bitmap(image : &Js) -> Promise[ImageBitmap] {
  unsafe_cast(ffi_create_image_bitmap(image.to_js()))
}

///|
pub fn create_image_bitmap_rect(
  image : &Js,
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

///|
/// OffscreenCanvas
#external
pub type OffscreenCanvas

///|
pub impl Js for OffscreenCanvas

///|
pub impl Transferable for OffscreenCanvas with to_transferable(self) -> Val {
  self.to_js()
}

///|
extern "js" fn ffi_new_offscreen_canvas(width : Val, height : Val) -> Val =
  #|(width, height) => new OffscreenCanvas(width, height)

///|
pub fn OffscreenCanvas::new(width : Int, height : Int) -> OffscreenCanvas {
  unsafe_cast(ffi_new_offscreen_canvas(width |> js, height |> js))
}

///|
pub fn OffscreenCanvas::width(self : Self) -> Int {
  unsafe_cast(self.to_js().get("width"))
}

///|
pub fn OffscreenCanvas::set_width(self : Self, value : Int) -> Unit {
  self.to_js().set("width", value)
}

///|
pub fn OffscreenCanvas::height(self : Self) -> Int {
  unsafe_cast(self.to_js().get("height"))
}

///|
pub fn OffscreenCanvas::set_height(self : Self, value : Int) -> Unit {
  self.to_js().set("height", value)
}

///|
pub fn OffscreenCanvas::get_context(
  self : Self,
  context_type : String,
) -> CanvasRenderingContext2D {
  self.invoke("getContext", [context_type]) |> unsafe_cast
}

///|
pub fn OffscreenCanvas::convert_to_blob(
  self : Self,
  options? : String,
) -> Promise[Blob] {
  match options {
    Some(opts) => self.invoke("convertToBlob", [opts]) |> unsafe_cast
    None => self.invoke("convertToBlob", []) |> unsafe_cast
  }
}

///|
pub fn OffscreenCanvas::transfer_to_image_bitmap(self : Self) -> ImageBitmap {
  self.invoke("transferToImageBitmap", []) |> unsafe_cast
}
