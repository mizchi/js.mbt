///| npm sharp package FFI bindings
/// https://github.com/lovell/sharp
/// https://www.npmjs.com/package/sharp
/// High performance Node.js image processing

///|
extern "js" fn sharp_module() -> @core.Any =
  #| () => require("sharp")

///|
/// Sharp instance for chaining operations
#external
pub type Sharp

///|
pub extern "js" fn Sharp::as_any(self : Sharp) -> @core.Any =
  #| (x) => x

///| Constructor

///|
/// Create a Sharp instance from a file path, buffer, or no input
pub fn sharp(input? : @core.Any) -> Sharp {
  match input {
    Some(v) => sharp_module()._invoke([v]).cast()
    None => sharp_module()._invoke([]).cast()
  }
}

///| Resize operations

///|
/// Resize image to width and height
pub fn Sharp::resize(
  self : Sharp,
  width? : Int,
  height? : Int,
  fit? : String,
  position? : String,
  background? : String,
  kernel? : String,
  withoutEnlargement? : Bool,
  withoutReduction? : Bool,
  fastShrinkOnLoad? : Bool,
) -> Sharp {
  let opts = @core.new_object()
  match width {
    Some(v) => opts["width"] = @core.any(v)
    None => ()
  }
  match height {
    Some(v) => opts["height"] = @core.any(v)
    None => ()
  }
  match fit {
    Some(v) => opts["fit"] = @core.any(v)
    None => ()
  }
  match position {
    Some(v) => opts["position"] = @core.any(v)
    None => ()
  }
  match background {
    Some(v) => opts["background"] = @core.any(v)
    None => ()
  }
  match kernel {
    Some(v) => opts["kernel"] = @core.any(v)
    None => ()
  }
  match withoutEnlargement {
    Some(v) => opts["withoutEnlargement"] = @core.any(v)
    None => ()
  }
  match withoutReduction {
    Some(v) => opts["withoutReduction"] = @core.any(v)
    None => ()
  }
  match fastShrinkOnLoad {
    Some(v) => opts["fastShrinkOnLoad"] = @core.any(v)
    None => ()
  }
  self.as_any()._call("resize", [opts]).cast()
}

///|
/// Resize to exact width
#alias(resize_width)
pub fn Sharp::resizeWidth(self : Sharp, width : Int) -> Sharp {
  self.as_any()._call("resize", [@core.any(width)]).cast()
}

///|
/// Resize to exact width and height
#alias(resize_exact)
pub fn Sharp::resizeExact(self : Sharp, width : Int, height : Int) -> Sharp {
  self.as_any()._call("resize", [@core.any(width), @core.any(height)]).cast()
}

///| Format conversion

///|
/// Convert to JPEG
pub fn Sharp::jpeg(self : Sharp, quality? : Int, progressive? : Bool) -> Sharp {
  let opts = @core.new_object()
  match quality {
    Some(v) => opts["quality"] = @core.any(v)
    None => ()
  }
  match progressive {
    Some(v) => opts["progressive"] = @core.any(v)
    None => ()
  }
  self.as_any()._call("jpeg", [opts]).cast()
}

///|
/// Convert to PNG
pub fn Sharp::png(
  self : Sharp,
  compressionLevel? : Int,
  progressive? : Bool,
  quality? : Int,
) -> Sharp {
  let opts = @core.new_object()
  match compressionLevel {
    Some(v) => opts["compressionLevel"] = @core.any(v)
    None => ()
  }
  match progressive {
    Some(v) => opts["progressive"] = @core.any(v)
    None => ()
  }
  match quality {
    Some(v) => opts["quality"] = @core.any(v)
    None => ()
  }
  self.as_any()._call("png", [opts]).cast()
}

///|
/// Convert to WebP
pub fn Sharp::webp(self : Sharp, quality? : Int, lossless? : Bool) -> Sharp {
  let opts = @core.new_object()
  match quality {
    Some(v) => opts["quality"] = @core.any(v)
    None => ()
  }
  match lossless {
    Some(v) => opts["lossless"] = @core.any(v)
    None => ()
  }
  self.as_any()._call("webp", [opts]).cast()
}

///|
/// Convert to AVIF
pub fn Sharp::avif(self : Sharp, quality? : Int, lossless? : Bool) -> Sharp {
  let opts = @core.new_object()
  match quality {
    Some(v) => opts["quality"] = @core.any(v)
    None => ()
  }
  match lossless {
    Some(v) => opts["lossless"] = @core.any(v)
    None => ()
  }
  self.as_any()._call("avif", [opts]).cast()
}

///| Image operations

///|
/// Rotate image
pub fn Sharp::rotate(self : Sharp, angle? : Int) -> Sharp {
  match angle {
    Some(v) => self.as_any()._call("rotate", [@core.any(v)]).cast()
    None => self.as_any()._call("rotate", []).cast()
  }
}

///|
/// Flip image vertically
pub fn Sharp::flip(self : Sharp) -> Sharp {
  self.as_any()._call("flip", []).cast()
}

///|
/// Flop image horizontally
pub fn Sharp::flop(self : Sharp) -> Sharp {
  self.as_any()._call("flop", []).cast()
}

///|
/// Sharpen image
pub fn Sharp::sharpen(
  self : Sharp,
  sigma? : Double,
  m1? : Double,
  m2? : Double,
) -> Sharp {
  match sigma {
    Some(s) =>
      match (m1, m2) {
        (Some(m1_val), Some(m2_val)) =>
          self
          .as_any()
          ._call("sharpen", [@core.any(s), @core.any(m1_val), @core.any(m2_val)])
          .cast()
        _ => self.as_any()._call("sharpen", [@core.any(s)]).cast()
      }
    None => self.as_any()._call("sharpen", []).cast()
  }
}

///|
/// Blur image
pub fn Sharp::blur(self : Sharp, sigma? : Double) -> Sharp {
  match sigma {
    Some(v) => self.as_any()._call("blur", [@core.any(v)]).cast()
    None => self.as_any()._call("blur", []).cast()
  }
}

///|
/// Convert to grayscale
pub fn Sharp::grayscale(self : Sharp) -> Sharp {
  self.as_any()._call("grayscale", []).cast()
}

///|
/// Convert to grayscale (alias)
pub fn Sharp::greyscale(self : Sharp) -> Sharp {
  self.as_any()._call("greyscale", []).cast()
}

///|
/// Negate image
pub fn Sharp::negate(self : Sharp) -> Sharp {
  self.as_any()._call("negate", []).cast()
}

///|
/// Normalize image
pub fn Sharp::normalize(self : Sharp) -> Sharp {
  self.as_any()._call("normalize", []).cast()
}

///| Output operations

///|
/// Convert to buffer (returns Promise)
pub fn Sharp::toBuffer(self : Sharp) -> @core.Promise[@core.Any] {
  @core.identity(self.as_any()._call("toBuffer", []))
}

///|
/// Save to file (returns Promise)
pub fn Sharp::toFile(self : Sharp, path : String) -> @core.Promise[@core.Any] {
  @core.identity(self.as_any()._call("toFile", [@core.any(path)]))
}

///| Metadata

///|
/// Metadata structure
pub struct Metadata {
  format : String?
  width : Int?
  height : Int?
  space : String?
  channels : Int?
  depth : String?
  density : Int?
  hasProfile : Bool?
  hasAlpha : Bool?
}

///|
/// Get image metadata (returns Promise)
pub fn Sharp::metadata(self : Sharp) -> @core.Promise[@core.Any] {
  @core.identity(self.as_any()._call("metadata", []))
}

///|
/// Parse metadata from Any
pub fn parseMetadata(data : @core.Any) -> Metadata {
  let format = if @core.is_undefined(data["format"]) {
    None
  } else {
    Some(data["format"].cast())
  }
  let width = if @core.is_undefined(data["width"]) {
    None
  } else {
    Some(data["width"].cast())
  }
  let height = if @core.is_undefined(data["height"]) {
    None
  } else {
    Some(data["height"].cast())
  }
  let space = if @core.is_undefined(data["space"]) {
    None
  } else {
    Some(data["space"].cast())
  }
  let channels = if @core.is_undefined(data["channels"]) {
    None
  } else {
    Some(data["channels"].cast())
  }
  let depth = if @core.is_undefined(data["depth"]) {
    None
  } else {
    Some(data["depth"].cast())
  }
  let density = if @core.is_undefined(data["density"]) {
    None
  } else {
    Some(data["density"].cast())
  }
  let hasProfile = if @core.is_undefined(data["hasProfile"]) {
    None
  } else {
    Some(data["hasProfile"].cast())
  }
  let hasAlpha = if @core.is_undefined(data["hasAlpha"]) {
    None
  } else {
    Some(data["hasAlpha"].cast())
  }
  {
    format,
    width,
    height,
    space,
    channels,
    depth,
    density,
    hasProfile,
    hasAlpha,
  }
}
