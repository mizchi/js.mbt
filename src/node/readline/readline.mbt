///| Node.js Readline Module

///| https://nodejs.org/api/readline.html

///|
/// Readline Interface
pub type Interface

///|
/// Wrap MoonBit completer function to JavaScript function
extern "js" fn wrap_completer(
  f : (String) -> (Array[String], String),
) -> @js.Any =
  #|(f) => (line) => {
  #|  const result = f(line);
  #|  return result;
  #|}

///|
extern "js" fn create_interface_impl(options : @js.Any) -> Interface =
  #|(options) => {
  #|  const readline = require('node:readline');
  #|  return readline.createInterface(options);
  #|}

///|
/// Create a readline interface
#alias(create_interface)
pub fn createInterface(
  input : @stream.Readable,
  output? : @stream.Writable,
  completer? : (String) -> (Array[String], String),
  terminal? : Bool,
  history_size? : Int,
  prompt? : String,
  cr_lf_delay? : Int,
  remove_history_duplicates? : Bool,
  escape_code_timeout? : Int,
  tab_size? : Int,
) -> Interface {
  let obj = @js.Object::new()
  obj.set("input", input)
  if output is Some(o) {
    obj.set("output", o)
  }
  if completer is Some(c) {
    obj.set("completer", wrap_completer(c))
  }
  if terminal is Some(t) {
    obj.set("terminal", t)
  }
  if history_size is Some(h) {
    obj.set("historySize", h)
  }
  if prompt is Some(p) {
    obj.set("prompt", p)
  }
  if cr_lf_delay is Some(d) {
    obj.set("crlfDelay", d)
  }
  if remove_history_duplicates is Some(r) {
    obj.set("removeHistoryDuplicates", r)
  }
  if escape_code_timeout is Some(e) {
    obj.set("escapeCodeTimeout", e)
  }
  if tab_size is Some(t) {
    obj.set("tabSize", t)
  }
  create_interface_impl(obj)
}

///|
/// Set the prompt
pub extern "js" fn Interface::set_prompt(
  self : Interface,
  prompt : String,
) -> Unit =
  #|(self, prompt) => self.setPrompt(prompt)

///|
/// Display the prompt
pub extern "js" fn Interface::prompt(
  self : Interface,
  preserve_cursor : Bool,
) -> Unit =
  #|(self, preserve_cursor) => self.prompt(preserve_cursor)

///|
/// Write to output
pub extern "js" fn Interface::write(
  self : Interface,
  data : String,
  key : @js.Object?,
) -> Unit =
  #|(self, data, key) => self.write(data, key)

///|
/// Pause the input stream
pub extern "js" fn Interface::pause(self : Interface) -> Unit =
  #|(self) => self.pause()

///|
/// Resume the input stream
pub extern "js" fn Interface::resume_(self : Interface) -> Unit =
  #|(self) => self.resume()

///|
/// Close the interface
pub extern "js" fn Interface::close(self : Interface) -> Unit =
  #|(self) => self.close()

///|
/// Add a line to history
pub extern "js" fn Interface::add_to_history(
  self : Interface,
  line : String,
) -> Unit =
  #|(self, line) => {
  #|  if (self.history) {
  #|    self.history.unshift(line);
  #|  }
  #|}

///|
/// Get the current cursor position
pub extern "js" fn Interface::get_cursor_pos(self : Interface) -> (Int, Int) =
  #|(self) => {
  #|  return [self.cursor, self.line.length];
  #|}

///|
/// Add event listener for 'line' event
pub extern "js" fn Interface::on_line(
  self : Interface,
  callback : (String) -> Unit,
) -> Interface =
  #|(self, callback) => {
  #|  self.on('line', callback);
  #|  return self;
  #|}

///|
/// Add event listener for 'close' event
pub extern "js" fn Interface::on_close(
  self : Interface,
  callback : () -> Unit,
) -> Interface =
  #|(self, callback) => {
  #|  self.on('close', callback);
  #|  return self;
  #|}

///|
/// Add event listener for 'pause' event
pub extern "js" fn Interface::on_pause(
  self : Interface,
  callback : () -> Unit,
) -> Interface =
  #|(self, callback) => {
  #|  self.on('pause', callback);
  #|  return self;
  #|}

///|
/// Add event listener for 'resume' event
pub extern "js" fn Interface::on_resume(
  self : Interface,
  callback : () -> Unit,
) -> Interface =
  #|(self, callback) => {
  #|  self.on('resume', callback);
  #|  return self;
  #|}

///|
/// Add event listener for 'SIGINT' event
pub extern "js" fn Interface::on_sigint(
  self : Interface,
  callback : () -> Unit,
) -> Interface =
  #|(self, callback) => {
  #|  self.on('SIGINT', callback);
  #|  return self;
  #|}

///|
/// Add event listener for 'SIGTSTP' event
pub extern "js" fn Interface::on_sigtstp(
  self : Interface,
  callback : () -> Unit,
) -> Interface =
  #|(self, callback) => {
  #|  self.on('SIGTSTP', callback);
  #|  return self;
  #|}

///|
/// Add event listener for 'SIGCONT' event
pub extern "js" fn Interface::on_sigcont(
  self : Interface,
  callback : () -> Unit,
) -> Interface =
  #|(self, callback) => {
  #|  self.on('SIGCONT', callback);
  #|  return self;
  #|}

///|
/// Add event listener for 'history' event
pub extern "js" fn Interface::on_history(
  self : Interface,
  callback : (Array[String]) -> Unit,
) -> Interface =
  #|(self, callback) => {
  #|  self.on('history', callback);
  #|  return self;
  #|}

///|
/// Clear the current line
pub extern "js" fn clear_line(stream : @stream.Writable, dir : Int) -> Bool =
  #|(stream, dir) => {
  #|  const readline = require('node:readline');
  #|  return readline.clearLine(stream, dir);
  #|}

///|
/// Clear the screen from cursor down
pub extern "js" fn clear_screen_down(stream : @stream.Writable) -> Bool =
  #|(stream) => {
  #|  const readline = require('node:readline');
  #|  return readline.clearScreenDown(stream);
  #|}

///|
/// Move cursor to specified position
pub extern "js" fn cursor_to(
  stream : @stream.Writable,
  x : Int,
  y : Int?,
) -> Bool =
  #|(stream, x, y) => {
  #|  const readline = require('node:readline');
  #|  return readline.cursorTo(stream, x, y);
  #|}

///|
/// Move cursor relative to current position
pub extern "js" fn move_cursor(
  stream : @stream.Writable,
  dx : Int,
  dy : Int,
) -> Bool =
  #|(stream, dx, dy) => {
  #|  const readline = require('node:readline');
  #|  return readline.moveCursor(stream, dx, dy);
  #|}

///|
/// Emit a keypress event
pub extern "js" fn emit_keypress_events(
  stream : @stream.Readable,
  interface_ : Interface?,
) -> Unit =
  #|(stream, interface_) => {
  #|  const readline = require('node:readline');
  #|  readline.emitKeypressEvents(stream, interface_);
  #|}
