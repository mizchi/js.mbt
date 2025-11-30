///|

///|
/// TTY ReadStream - represents the readable side of a terminal
/// https://nodejs.org/api/tty.html#class-ttyreadstream
#external
pub type ReadStream

///|
pub fn ReadStream::as_any(self : ReadStream) -> @nostd.Any = "%identity"

///|
pub fn ReadStream::as_event_target(self : ReadStream) -> @event.EventTarget = "%identity"

///|
pub impl @js.JsImpl for ReadStream

///|
pub impl @event.EventTargetImpl for ReadStream with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// Check if ReadStream is a TTY
pub fn ReadStream::is_tty(self : ReadStream) -> Bool {
  let val : @js.Any = self.get("isTTY")
  @js.identity(val)
}

///|
/// Check if ReadStream is in raw mode
pub fn ReadStream::is_raw(self : ReadStream) -> Bool {
  let val : @js.Any = self.get("isRaw")
  @js.identity(val)
}

///|
/// Set raw mode for the ReadStream
/// In raw mode, input is available character-by-character
pub fn ReadStream::set_raw_mode(self : ReadStream, mode : Bool) -> Unit {
  self.call("setRawMode", [mode]) |> ignore
}

///|
/// TTY WriteStream - represents the writable side of a terminal
/// https://nodejs.org/api/tty.html#class-ttywritestream
/// Extends net.Socket which extends stream.Duplex
#external
pub type WriteStream

///|
pub fn WriteStream::as_any(self : WriteStream) -> @nostd.Any = "%identity"

///|
pub fn WriteStream::as_event_target(self : WriteStream) -> @event.EventTarget = "%identity"

///|
pub impl @js.JsImpl for WriteStream

///|
pub impl @event.EventTargetImpl for WriteStream with as_any(self) -> @nostd.Any {
  self.as_any()
}

///|
/// Check if WriteStream is a TTY
pub fn WriteStream::is_tty(self : WriteStream) -> Bool {
  let val : @js.Any = self.get("isTTY")
  @js.identity(val)
}

///|
/// Write data to the stream (inherited from stream.Writable)
pub fn[T : @js.JsImpl] WriteStream::write(
  self : WriteStream,
  chunk : T,
  encoding? : String,
  callback? : @js.Any,
) -> Bool {
  self.call("write", [chunk.as_any(), encoding, callback]).cast()
}

///|
/// End the stream (inherited from stream.Writable)
pub fn[T : @js.JsImpl] WriteStream::end(
  self : WriteStream,
  chunk? : T,
  encoding? : String,
  callback? : @js.Any,
) -> WriteStream {
  let chunk_any : @js.Any = match chunk {
    Some(c) => c.as_any()
    None => @js.undefined()
  }
  self.call("end", [chunk_any, encoding, callback]).cast()
}

///|
/// Get the number of columns in the terminal
pub fn WriteStream::columns(self : WriteStream) -> Int {
  let val : @js.Any = self.get("columns")
  @js.identity(val)
}

///|
/// Get the number of rows in the terminal
pub fn WriteStream::rows(self : WriteStream) -> Int {
  let val : @js.Any = self.get("rows")
  @js.identity(val)
}

///|
/// Clear the current line
/// dir: -1 (left), 0 (entire line), 1 (right)
pub fn WriteStream::clear_line(
  self : WriteStream,
  dir : Int,
  callback : () -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call2("clearLine", dir, cb) |> ignore
}

///|
/// Clear the screen from cursor position downward
pub fn WriteStream::clear_screen_down(
  self : WriteStream,
  callback : () -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call("clearScreenDown", [cb]) |> ignore
}

///|
/// Move cursor to absolute position
pub fn WriteStream::cursor_to(
  self : WriteStream,
  x : Int,
  y : Int,
  callback : () -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call("cursorTo", [x, y, cb]) |> ignore
}

///|
/// Move cursor relatively
pub fn WriteStream::move_cursor(
  self : WriteStream,
  dx : Int,
  dy : Int,
  callback : () -> Unit,
) -> Unit {
  let cb : @js.Any = @js.identity(callback)
  self.call("moveCursor", [dx, dy, cb]) |> ignore
}

///|
/// Get the color depth supported by the terminal
/// Returns 1, 4, 8, or 24 bits
pub fn WriteStream::get_color_depth(self : WriteStream) -> Int {
  let val : @js.Any = self.call0("getColorDepth")
  @js.identity(val)
}

///|
/// Check if terminal supports the requested color count
pub fn WriteStream::has_colors(self : WriteStream, count : Int) -> Bool {
  let val : @js.Any = self.call("hasColors", [count])
  @js.identity(val)
}

///|
/// Get window size as [columns, rows]
pub fn WriteStream::get_window_size(self : WriteStream) -> (Int, Int) {
  let val : @js.Any = self.call0("getWindowSize")
  let arr : @js.JsArray = @js.identity(val)
  let cols : Int = @js.identity(arr.get(0))
  let rows : Int = @js.identity(arr.get(1))
  (cols, rows)
}

///|
/// Register resize event handler
pub fn WriteStream::on_resize(
  self : WriteStream,
  callback : () -> Unit,
) -> WriteStream {
  self.addEventListener("resize", fn(_e : @js.Any) { callback() })
  self
}

///|
extern "js" fn ffi_isatty(fd : Int) -> Bool =
  #| (fd) => {
  #|   const tty = require('tty');
  #|   return tty.isatty(fd);
  #| }

///|
/// Check if a file descriptor is associated with a TTY
pub fn isatty(fd : Int) -> Bool {
  ffi_isatty(fd)
}
