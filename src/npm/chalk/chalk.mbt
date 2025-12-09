///| npm chalk package FFI bindings
/// https://github.com/chalk/chalk

///|
/// Dynamic import for chalk module
extern "js" fn import_chalk() -> @core.Promise[@core.Any] =
  #|() => import("chalk")

///|
extern "js" fn get_chalk_global() -> @core.Any =
  #|() => globalThis.__chalk

///|
extern "js" fn set_chalk_global(chalk : @core.Any) -> Unit =
  #|(chalk) => { globalThis.__chalk = chalk; }

///|
/// Initialize chalk globals asynchronously (recommended for ESM)
pub async fn init_global() -> Unit {
  if @core.is_nullish(get_chalk_global()) {
    let mod = import_chalk().wait()
    let c = mod._get("default")
    set_chalk_global(if @core.is_nullish(c) { mod } else { c })
  }
}

///|
/// Initialize chalk globals synchronously (for testing with require)
pub fn init_chalk(chalk_module : @core.Any) -> Unit {
  let c = chalk_module._get("default")
  set_chalk_global(if @core.is_nullish(c) { chalk_module } else { c })
}

///|
fn chalk() -> @core.Any {
  get_chalk_global()
}

///|
/// ChalkInstance for chaining styles
#external
pub type ChalkInstance

///|
pub extern "js" fn ChalkInstance::as_any(self : ChalkInstance) -> @core.Any =
  #| (x) => x

///| Basic colors (foreground)

///|
/// Black text
pub fn black(text : String) -> String {
  chalk()._call("black", [@core.any(text)]).cast()
}

///|
/// Red text
pub fn red(text : String) -> String {
  chalk()._call("red", [@core.any(text)]).cast()
}

///|
/// Green text
pub fn green(text : String) -> String {
  chalk()._call("green", [@core.any(text)]).cast()
}

///|
/// Yellow text
pub fn yellow(text : String) -> String {
  chalk()._call("yellow", [@core.any(text)]).cast()
}

///|
/// Blue text
pub fn blue(text : String) -> String {
  chalk()._call("blue", [@core.any(text)]).cast()
}

///|
/// Magenta text
pub fn magenta(text : String) -> String {
  chalk()._call("magenta", [@core.any(text)]).cast()
}

///|
/// Cyan text
pub fn cyan(text : String) -> String {
  chalk()._call("cyan", [@core.any(text)]).cast()
}

///|
/// White text
pub fn white(text : String) -> String {
  chalk()._call("white", [@core.any(text)]).cast()
}

///|
/// Gray text
pub fn gray(text : String) -> String {
  chalk()._call("gray", [@core.any(text)]).cast()
}

///|
/// Grey text (alias)
pub fn grey(text : String) -> String {
  chalk()._call("grey", [@core.any(text)]).cast()
}

///| Bright colors

///|
/// Bright red text
#alias(red_bright)
pub fn redBright(text : String) -> String {
  chalk()._call("redBright", [@core.any(text)]).cast()
}

///|
/// Bright green text
#alias(green_bright)
pub fn greenBright(text : String) -> String {
  chalk()._call("greenBright", [@core.any(text)]).cast()
}

///|
/// Bright yellow text
#alias(yellow_bright)
pub fn yellowBright(text : String) -> String {
  chalk()._call("yellowBright", [@core.any(text)]).cast()
}

///|
/// Bright blue text
#alias(blue_bright)
pub fn blueBright(text : String) -> String {
  chalk()._call("blueBright", [@core.any(text)]).cast()
}

///|
/// Bright magenta text
#alias(magenta_bright)
pub fn magentaBright(text : String) -> String {
  chalk()._call("magentaBright", [@core.any(text)]).cast()
}

///|
/// Bright cyan text
#alias(cyan_bright)
pub fn cyanBright(text : String) -> String {
  chalk()._call("cyanBright", [@core.any(text)]).cast()
}

///|
/// Bright white text
#alias(white_bright)
pub fn whiteBright(text : String) -> String {
  chalk()._call("whiteBright", [@core.any(text)]).cast()
}

///| Background colors

///|
/// Black background
#alias(bg_black)
pub fn bgBlack(text : String) -> String {
  chalk()._call("bgBlack", [@core.any(text)]).cast()
}

///|
/// Red background
#alias(bg_red)
pub fn bgRed(text : String) -> String {
  chalk()._call("bgRed", [@core.any(text)]).cast()
}

///|
/// Green background
#alias(bg_green)
pub fn bgGreen(text : String) -> String {
  chalk()._call("bgGreen", [@core.any(text)]).cast()
}

///|
/// Yellow background
#alias(bg_yellow)
pub fn bgYellow(text : String) -> String {
  chalk()._call("bgYellow", [@core.any(text)]).cast()
}

///|
/// Blue background
#alias(bg_blue)
pub fn bgBlue(text : String) -> String {
  chalk()._call("bgBlue", [@core.any(text)]).cast()
}

///|
/// Magenta background
#alias(bg_magenta)
pub fn bgMagenta(text : String) -> String {
  chalk()._call("bgMagenta", [@core.any(text)]).cast()
}

///|
/// Cyan background
#alias(bg_cyan)
pub fn bgCyan(text : String) -> String {
  chalk()._call("bgCyan", [@core.any(text)]).cast()
}

///|
/// White background
#alias(bg_white)
pub fn bgWhite(text : String) -> String {
  chalk()._call("bgWhite", [@core.any(text)]).cast()
}

///| Text modifiers

///|
/// Bold text
pub fn bold(text : String) -> String {
  chalk()._call("bold", [@core.any(text)]).cast()
}

///|
/// Dim text
pub fn dim(text : String) -> String {
  chalk()._call("dim", [@core.any(text)]).cast()
}

///|
/// Italic text
pub fn italic(text : String) -> String {
  chalk()._call("italic", [@core.any(text)]).cast()
}

///|
/// Underline text
pub fn underline(text : String) -> String {
  chalk()._call("underline", [@core.any(text)]).cast()
}

///|
/// Strikethrough text
pub fn strikethrough(text : String) -> String {
  chalk()._call("strikethrough", [@core.any(text)]).cast()
}

///|
/// Inverse colors
pub fn inverse(text : String) -> String {
  chalk()._call("inverse", [@core.any(text)]).cast()
}

///|
/// Hidden text
pub fn hidden(text : String) -> String {
  chalk()._call("hidden", [@core.any(text)]).cast()
}

///|
/// Visible text
pub fn visible(text : String) -> String {
  chalk()._call("visible", [@core.any(text)]).cast()
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
  self.as_any()._invoke([@core.any(text)]).cast()
}

///| Chainable color methods

///|
pub fn ChalkInstance::black(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["black"].cast()
}

///|
pub fn ChalkInstance::red(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["red"].cast()
}

///|
pub fn ChalkInstance::green(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["green"].cast()
}

///|
pub fn ChalkInstance::yellow(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["yellow"].cast()
}

///|
pub fn ChalkInstance::blue(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["blue"].cast()
}

///|
pub fn ChalkInstance::magenta(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["magenta"].cast()
}

///|
pub fn ChalkInstance::cyan(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["cyan"].cast()
}

///|
pub fn ChalkInstance::white(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["white"].cast()
}

///|
pub fn ChalkInstance::gray(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["gray"].cast()
}

///| Chainable background colors

///|
#alias(bg_black)
pub fn ChalkInstance::bgBlack(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["bgBlack"].cast()
}

///|
#alias(bg_red)
pub fn ChalkInstance::bgRed(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["bgRed"].cast()
}

///|
#alias(bg_green)
pub fn ChalkInstance::bgGreen(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["bgGreen"].cast()
}

///|
#alias(bg_yellow)
pub fn ChalkInstance::bgYellow(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["bgYellow"].cast()
}

///|
#alias(bg_blue)
pub fn ChalkInstance::bgBlue(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["bgBlue"].cast()
}

///|
#alias(bg_magenta)
pub fn ChalkInstance::bgMagenta(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["bgMagenta"].cast()
}

///|
#alias(bg_cyan)
pub fn ChalkInstance::bgCyan(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["bgCyan"].cast()
}

///|
#alias(bg_white)
pub fn ChalkInstance::bgWhite(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["bgWhite"].cast()
}

///| Chainable modifiers

///|
pub fn ChalkInstance::bold(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["bold"].cast()
}

///|
pub fn ChalkInstance::dim(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["dim"].cast()
}

///|
pub fn ChalkInstance::italic(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["italic"].cast()
}

///|
pub fn ChalkInstance::underline(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["underline"].cast()
}

///|
pub fn ChalkInstance::strikethrough(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["strikethrough"].cast()
}

///|
pub fn ChalkInstance::inverse(self : ChalkInstance) -> ChalkInstance {
  self.as_any()["inverse"].cast()
}

///| RGB and Hex colors

///|
/// RGB foreground color
pub fn rgb(r : Int, g : Int, b : Int) -> ChalkInstance {
  chalk()._call("rgb", [@core.any(r), @core.any(g), @core.any(b)]).cast()
}

///|
/// RGB background color
#alias(bg_rgb)
pub fn bgRgb(r : Int, g : Int, b : Int) -> ChalkInstance {
  chalk()._call("bgRgb", [@core.any(r), @core.any(g), @core.any(b)]).cast()
}

///|
/// Hex foreground color
pub fn hex(color : String) -> ChalkInstance {
  chalk()._call("hex", [@core.any(color)]).cast()
}

///|
/// Hex background color
#alias(bg_hex)
pub fn bgHex(color : String) -> ChalkInstance {
  chalk()._call("bgHex", [@core.any(color)]).cast()
}
