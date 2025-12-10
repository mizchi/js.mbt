///| npm colorette package FFI bindings
/// https://github.com/jorgebucaran/colorette
/// Lightweight terminal color library with no dependencies

///| Colors (foreground)

///|
/// Black text
#module("colorette")
pub extern "js" fn black(text : String) -> String = "black"

///|
/// Red text
#module("colorette")
pub extern "js" fn red(text : String) -> String = "red"

///|
/// Green text
#module("colorette")
pub extern "js" fn green(text : String) -> String = "green"

///|
/// Yellow text
#module("colorette")
pub extern "js" fn yellow(text : String) -> String = "yellow"

///|
/// Blue text
#module("colorette")
pub extern "js" fn blue(text : String) -> String = "blue"

///|
/// Magenta text
#module("colorette")
pub extern "js" fn magenta(text : String) -> String = "magenta"

///|
/// Cyan text
#module("colorette")
pub extern "js" fn cyan(text : String) -> String = "cyan"

///|
/// White text
#module("colorette")
pub extern "js" fn white(text : String) -> String = "white"

///|
/// Gray text
#module("colorette")
pub extern "js" fn gray(text : String) -> String = "gray"

///| Bright colors

///|
/// Bright black text
#module("colorette")
#alias(black_bright)
pub extern "js" fn blackBright(text : String) -> String = "blackBright"

///|
/// Bright red text
#module("colorette")
#alias(red_bright)
pub extern "js" fn redBright(text : String) -> String = "redBright"

///|
/// Bright green text
#module("colorette")
#alias(green_bright)
pub extern "js" fn greenBright(text : String) -> String = "greenBright"

///|
/// Bright yellow text
#module("colorette")
#alias(yellow_bright)
pub extern "js" fn yellowBright(text : String) -> String = "yellowBright"

///|
/// Bright blue text
#module("colorette")
#alias(blue_bright)
pub extern "js" fn blueBright(text : String) -> String = "blueBright"

///|
/// Bright magenta text
#module("colorette")
#alias(magenta_bright)
pub extern "js" fn magentaBright(text : String) -> String = "magentaBright"

///|
/// Bright cyan text
#module("colorette")
#alias(cyan_bright)
pub extern "js" fn cyanBright(text : String) -> String = "cyanBright"

///|
/// Bright white text
#module("colorette")
#alias(white_bright)
pub extern "js" fn whiteBright(text : String) -> String = "whiteBright"

///| Background colors

///|
/// Black background
#module("colorette")
#alias(bg_black)
pub extern "js" fn bgBlack(text : String) -> String = "bgBlack"

///|
/// Red background
#module("colorette")
#alias(bg_red)
pub extern "js" fn bgRed(text : String) -> String = "bgRed"

///|
/// Green background
#module("colorette")
#alias(bg_green)
pub extern "js" fn bgGreen(text : String) -> String = "bgGreen"

///|
/// Yellow background
#module("colorette")
#alias(bg_yellow)
pub extern "js" fn bgYellow(text : String) -> String = "bgYellow"

///|
/// Blue background
#module("colorette")
#alias(bg_blue)
pub extern "js" fn bgBlue(text : String) -> String = "bgBlue"

///|
/// Magenta background
#module("colorette")
#alias(bg_magenta)
pub extern "js" fn bgMagenta(text : String) -> String = "bgMagenta"

///|
/// Cyan background
#module("colorette")
#alias(bg_cyan)
pub extern "js" fn bgCyan(text : String) -> String = "bgCyan"

///|
/// White background
#module("colorette")
#alias(bg_white)
pub extern "js" fn bgWhite(text : String) -> String = "bgWhite"

///| Bright background colors

///|
/// Bright black background
#module("colorette")
#alias(bg_black_bright)
pub extern "js" fn bgBlackBright(text : String) -> String = "bgBlackBright"

///|
/// Bright red background
#module("colorette")
#alias(bg_red_bright)
pub extern "js" fn bgRedBright(text : String) -> String = "bgRedBright"

///|
/// Bright green background
#module("colorette")
#alias(bg_green_bright)
pub extern "js" fn bgGreenBright(text : String) -> String = "bgGreenBright"

///|
/// Bright yellow background
#module("colorette")
#alias(bg_yellow_bright)
pub extern "js" fn bgYellowBright(text : String) -> String = "bgYellowBright"

///|
/// Bright blue background
#module("colorette")
#alias(bg_blue_bright)
pub extern "js" fn bgBlueBright(text : String) -> String = "bgBlueBright"

///|
/// Bright magenta background
#module("colorette")
#alias(bg_magenta_bright)
pub extern "js" fn bgMagentaBright(text : String) -> String = "bgMagentaBright"

///|
/// Bright cyan background
#module("colorette")
#alias(bg_cyan_bright)
pub extern "js" fn bgCyanBright(text : String) -> String = "bgCyanBright"

///|
/// Bright white background
#module("colorette")
#alias(bg_white_bright)
pub extern "js" fn bgWhiteBright(text : String) -> String = "bgWhiteBright"

///| Text modifiers

///|
/// Bold text
#module("colorette")
pub extern "js" fn bold(text : String) -> String = "bold"

///|
/// Dim text
#module("colorette")
pub extern "js" fn dim(text : String) -> String = "dim"

///|
/// Italic text
#module("colorette")
pub extern "js" fn italic(text : String) -> String = "italic"

///|
/// Underline text
#module("colorette")
pub extern "js" fn underline(text : String) -> String = "underline"

///|
/// Hidden text
#module("colorette")
pub extern "js" fn hidden(text : String) -> String = "hidden"

///|
/// Strikethrough text
#module("colorette")
pub extern "js" fn strikethrough(text : String) -> String = "strikethrough"

///|
/// Reset text styling
#module("colorette")
pub extern "js" fn reset(text : String) -> String = "reset"

///| Utilities

///|
/// Check if terminal supports colors (sync version using require)
extern "js" fn ffi_is_color_supported_sync() -> Bool =
  #| () => {
  #|   const c = require("colorette");
  #|   return c.isColorSupported;
  #| }

///|
/// Check if terminal supports colors
pub fn is_color_supported_sync() -> Bool {
  ffi_is_color_supported_sync()
}
