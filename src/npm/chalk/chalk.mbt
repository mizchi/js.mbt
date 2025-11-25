///| npm chalk package FFI bindings
/// https://github.com/chalk/chalk

///|
fn chalk() -> @js.Any {
  let c = @node.require("chalk")
  // Handle both default and non-default exports
  let default_ = c.get("default")
  if @js.is_undefined(default_) {
    c
  } else {
    default_
  }
}

///|
/// ChalkInstance for chaining styles
#external
pub type ChalkInstance

///|
pub impl @js.JsImpl for ChalkInstance

///| Basic colors (foreground)

///|
/// Black text
pub fn black(text : String) -> String {
  chalk().call1("black", text).cast()
}

///|
/// Red text
pub fn red(text : String) -> String {
  chalk().call1("red", text).cast()
}

///|
/// Green text
pub fn green(text : String) -> String {
  chalk().call1("green", text).cast()
}

///|
/// Yellow text
pub fn yellow(text : String) -> String {
  chalk().call1("yellow", text).cast()
}

///|
/// Blue text
pub fn blue(text : String) -> String {
  chalk().call1("blue", text).cast()
}

///|
/// Magenta text
pub fn magenta(text : String) -> String {
  chalk().call1("magenta", text).cast()
}

///|
/// Cyan text
pub fn cyan(text : String) -> String {
  chalk().call1("cyan", text).cast()
}

///|
/// White text
pub fn white(text : String) -> String {
  chalk().call1("white", text).cast()
}

///|
/// Gray text
pub fn gray(text : String) -> String {
  chalk().call1("gray", text).cast()
}

///|
/// Grey text (alias)
pub fn grey(text : String) -> String {
  chalk().call1("grey", text).cast()
}

///| Bright colors

///|
/// Bright red text
#alias(red_bright)
pub fn redBright(text : String) -> String {
  chalk().call1("redBright", text).cast()
}

///|
/// Bright green text
#alias(green_bright)
pub fn greenBright(text : String) -> String {
  chalk().call1("greenBright", text).cast()
}

///|
/// Bright yellow text
#alias(yellow_bright)
pub fn yellowBright(text : String) -> String {
  chalk().call1("yellowBright", text).cast()
}

///|
/// Bright blue text
#alias(blue_bright)
pub fn blueBright(text : String) -> String {
  chalk().call1("blueBright", text).cast()
}

///|
/// Bright magenta text
#alias(magenta_bright)
pub fn magentaBright(text : String) -> String {
  chalk().call1("magentaBright", text).cast()
}

///|
/// Bright cyan text
#alias(cyan_bright)
pub fn cyanBright(text : String) -> String {
  chalk().call1("cyanBright", text).cast()
}

///|
/// Bright white text
#alias(white_bright)
pub fn whiteBright(text : String) -> String {
  chalk().call1("whiteBright", text).cast()
}

///| Background colors

///|
/// Black background
#alias(bg_black)
pub fn bgBlack(text : String) -> String {
  chalk().call1("bgBlack", text).cast()
}

///|
/// Red background
#alias(bg_red)
pub fn bgRed(text : String) -> String {
  chalk().call1("bgRed", text).cast()
}

///|
/// Green background
#alias(bg_green)
pub fn bgGreen(text : String) -> String {
  chalk().call1("bgGreen", text).cast()
}

///|
/// Yellow background
#alias(bg_yellow)
pub fn bgYellow(text : String) -> String {
  chalk().call1("bgYellow", text).cast()
}

///|
/// Blue background
#alias(bg_blue)
pub fn bgBlue(text : String) -> String {
  chalk().call1("bgBlue", text).cast()
}

///|
/// Magenta background
#alias(bg_magenta)
pub fn bgMagenta(text : String) -> String {
  chalk().call1("bgMagenta", text).cast()
}

///|
/// Cyan background
#alias(bg_cyan)
pub fn bgCyan(text : String) -> String {
  chalk().call1("bgCyan", text).cast()
}

///|
/// White background
#alias(bg_white)
pub fn bgWhite(text : String) -> String {
  chalk().call1("bgWhite", text).cast()
}

///| Text modifiers

///|
/// Bold text
pub fn bold(text : String) -> String {
  chalk().call1("bold", text).cast()
}

///|
/// Dim text
pub fn dim(text : String) -> String {
  chalk().call1("dim", text).cast()
}

///|
/// Italic text
pub fn italic(text : String) -> String {
  chalk().call1("italic", text).cast()
}

///|
/// Underline text
pub fn underline(text : String) -> String {
  chalk().call1("underline", text).cast()
}

///|
/// Strikethrough text
pub fn strikethrough(text : String) -> String {
  chalk().call1("strikethrough", text).cast()
}

///|
/// Inverse colors
pub fn inverse(text : String) -> String {
  chalk().call1("inverse", text).cast()
}

///|
/// Hidden text
pub fn hidden(text : String) -> String {
  chalk().call1("hidden", text).cast()
}

///|
/// Visible text
pub fn visible(text : String) -> String {
  chalk().call1("visible", text).cast()
}

///| Chainable API

///|
/// Get a chainable chalk instance
pub fn instance() -> ChalkInstance {
  chalk().cast()
}

///|
/// Apply the style to text
pub fn ChalkInstance::apply(self : ChalkInstance, text : String) -> String {
  let fn_ : @js.Any = self.to_any()
  fn_.call1("call", text).cast()
}

///| Chainable color methods

///|
pub fn ChalkInstance::black(self : ChalkInstance) -> ChalkInstance {
  self.get("black").cast()
}

///|
pub fn ChalkInstance::red(self : ChalkInstance) -> ChalkInstance {
  self.get("red").cast()
}

///|
pub fn ChalkInstance::green(self : ChalkInstance) -> ChalkInstance {
  self.get("green").cast()
}

///|
pub fn ChalkInstance::yellow(self : ChalkInstance) -> ChalkInstance {
  self.get("yellow").cast()
}

///|
pub fn ChalkInstance::blue(self : ChalkInstance) -> ChalkInstance {
  self.get("blue").cast()
}

///|
pub fn ChalkInstance::magenta(self : ChalkInstance) -> ChalkInstance {
  self.get("magenta").cast()
}

///|
pub fn ChalkInstance::cyan(self : ChalkInstance) -> ChalkInstance {
  self.get("cyan").cast()
}

///|
pub fn ChalkInstance::white(self : ChalkInstance) -> ChalkInstance {
  self.get("white").cast()
}

///|
pub fn ChalkInstance::gray(self : ChalkInstance) -> ChalkInstance {
  self.get("gray").cast()
}

///| Chainable background colors

///|
#alias(bg_black)
pub fn ChalkInstance::bgBlack(self : ChalkInstance) -> ChalkInstance {
  self.get("bgBlack").cast()
}

///|
#alias(bg_red)
pub fn ChalkInstance::bgRed(self : ChalkInstance) -> ChalkInstance {
  self.get("bgRed").cast()
}

///|
#alias(bg_green)
pub fn ChalkInstance::bgGreen(self : ChalkInstance) -> ChalkInstance {
  self.get("bgGreen").cast()
}

///|
#alias(bg_yellow)
pub fn ChalkInstance::bgYellow(self : ChalkInstance) -> ChalkInstance {
  self.get("bgYellow").cast()
}

///|
#alias(bg_blue)
pub fn ChalkInstance::bgBlue(self : ChalkInstance) -> ChalkInstance {
  self.get("bgBlue").cast()
}

///|
#alias(bg_magenta)
pub fn ChalkInstance::bgMagenta(self : ChalkInstance) -> ChalkInstance {
  self.get("bgMagenta").cast()
}

///|
#alias(bg_cyan)
pub fn ChalkInstance::bgCyan(self : ChalkInstance) -> ChalkInstance {
  self.get("bgCyan").cast()
}

///|
#alias(bg_white)
pub fn ChalkInstance::bgWhite(self : ChalkInstance) -> ChalkInstance {
  self.get("bgWhite").cast()
}

///| Chainable modifiers

///|
pub fn ChalkInstance::bold(self : ChalkInstance) -> ChalkInstance {
  self.get("bold").cast()
}

///|
pub fn ChalkInstance::dim(self : ChalkInstance) -> ChalkInstance {
  self.get("dim").cast()
}

///|
pub fn ChalkInstance::italic(self : ChalkInstance) -> ChalkInstance {
  self.get("italic").cast()
}

///|
pub fn ChalkInstance::underline(self : ChalkInstance) -> ChalkInstance {
  self.get("underline").cast()
}

///|
pub fn ChalkInstance::strikethrough(self : ChalkInstance) -> ChalkInstance {
  self.get("strikethrough").cast()
}

///|
pub fn ChalkInstance::inverse(self : ChalkInstance) -> ChalkInstance {
  self.get("inverse").cast()
}

///| RGB and Hex colors

///|
/// RGB foreground color
pub fn rgb(r : Int, g : Int, b : Int) -> ChalkInstance {
  chalk().call("rgb", [r, g, b]).cast()
}

///|
/// RGB background color
#alias(bg_rgb)
pub fn bgRgb(r : Int, g : Int, b : Int) -> ChalkInstance {
  chalk().call("bgRgb", [r, g, b]).cast()
}

///|
/// Hex foreground color
pub fn hex(color : String) -> ChalkInstance {
  chalk().call1("hex", color).cast()
}

///|
/// Hex background color
#alias(bg_hex)
pub fn bgHex(color : String) -> ChalkInstance {
  chalk().call1("bgHex", color).cast()
}
