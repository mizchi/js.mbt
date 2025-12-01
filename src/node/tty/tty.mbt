///|

///|
/// TTY ReadStream - represents the readable side of a terminal
/// https://nodejs.org/api/tty.html#class-ttyreadstream
#external
pub type ReadStream

///|
pub fn ReadStream::as_any(self : ReadStream) -> @nostd.Any = "%identity"

///|
pub fn ReadStream::to_any(self : ReadStream) -> @nostd.Any = "%identity"

///|
pub fn ReadStream::as_event_target(self : ReadStream) -> @event.EventTarget = "%identity"

///|
pub impl @event.EventTargetImpl for ReadStream with as_any(self) -> @nostd.Any {
  self.to_any()
}

///|
/// Check if ReadStream is a TTY
pub fn ReadStream::is_tty(self : ReadStream) -> Bool {
  self.to_any()["isTTY"].cast()
}

///|
/// Check if ReadStream is in raw mode
pub fn ReadStream::is_raw(self : ReadStream) -> Bool {
  self.to_any()["isRaw"].cast()
}

///|
/// Set raw mode for the ReadStream
/// In raw mode, input is available character-by-character
pub fn ReadStream::set_raw_mode(self : ReadStream, mode : Bool) -> Unit {
  self.to_any()._call("setRawMode", [@nostd.any(mode)]) |> ignore
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
pub fn WriteStream::to_any(self : WriteStream) -> @nostd.Any = "%identity"

///|
pub fn WriteStream::as_event_target(self : WriteStream) -> @event.EventTarget = "%identity"

///|
pub impl @event.EventTargetImpl for WriteStream with as_any(self) -> @nostd.Any {
  self.to_any()
}

///|
/// Check if WriteStream is a TTY
pub fn WriteStream::is_tty(self : WriteStream) -> Bool {
  self.to_any()["isTTY"].cast()
}

///|
/// Write data to the stream (inherited from stream.Writable)
pub fn WriteStream::write(
  self : WriteStream,
  chunk : @nostd.Any,
  encoding? : String,
  callback? : @nostd.Any,
) -> Bool {
  let enc : @nostd.Any = match encoding {
    Some(e) => @nostd.any(e)
    None => @global.undefined() |> @nostd.any
  }
  let cb : @nostd.Any = match callback {
    Some(c) => c |> @nostd.any
    None => @global.undefined() |> @nostd.any
  }
  self.to_any()._call("write", [chunk, enc, cb]).cast()
}

///|
/// End the stream (inherited from stream.Writable)
pub fn WriteStream::end(
  self : WriteStream,
  chunk? : @nostd.Any,
  encoding? : String,
  callback? : @nostd.Any,
) -> WriteStream {
  let chunk_any : @nostd.Any = match chunk {
    Some(c) => c
    None => @global.undefined() |> @nostd.any
  }
  let enc : @nostd.Any = match encoding {
    Some(e) => @nostd.any(e)
    None => @global.undefined() |> @nostd.any
  }
  let cb : @nostd.Any = match callback {
    Some(c) => c |> @nostd.any
    None => @global.undefined() |> @nostd.any
  }
  self.to_any()._call("end", [chunk_any, enc, cb]) |> @nostd.identity
}

///|
/// Get the number of columns in the terminal
pub fn WriteStream::columns(self : WriteStream) -> Int {
  self.to_any()["columns"].cast()
}

///|
/// Get the number of rows in the terminal
pub fn WriteStream::rows(self : WriteStream) -> Int {
  self.to_any()["rows"].cast()
}

///|
/// Clear the current line
/// dir: -1 (left), 0 (entire line), 1 (right)
pub fn WriteStream::clear_line(
  self : WriteStream,
  dir : Int,
  callback : () -> Unit,
) -> Unit {
  let cb : @nostd.Any = @js.identity(callback) |> @nostd.any
  self.to_any()._call("clearLine", [@nostd.any(dir), cb]) |> ignore
}

///|
/// Clear the screen from cursor position downward
pub fn WriteStream::clear_screen_down(
  self : WriteStream,
  callback : () -> Unit,
) -> Unit {
  let cb : @nostd.Any = @js.identity(callback) |> @nostd.any
  self.to_any()._call("clearScreenDown", [cb]) |> ignore
}

///|
/// Move cursor to absolute position
pub fn WriteStream::cursor_to(
  self : WriteStream,
  x : Int,
  y : Int,
  callback : () -> Unit,
) -> Unit {
  let cb : @nostd.Any = @js.identity(callback) |> @nostd.any
  self.to_any()._call("cursorTo", [@nostd.any(x), @nostd.any(y), cb]) |> ignore
}

///|
/// Move cursor relatively
pub fn WriteStream::move_cursor(
  self : WriteStream,
  dx : Int,
  dy : Int,
  callback : () -> Unit,
) -> Unit {
  let cb : @nostd.Any = @js.identity(callback) |> @nostd.any
  self.to_any()._call("moveCursor", [@nostd.any(dx), @nostd.any(dy), cb])
  |> ignore
}

///|
/// Get the color depth supported by the terminal
/// Returns 1, 4, 8, or 24 bits
pub fn WriteStream::get_color_depth(self : WriteStream) -> Int {
  self.to_any()._call("getColorDepth", []).cast()
}

///|
/// Check if terminal supports the requested color count
pub fn WriteStream::has_colors(self : WriteStream, count : Int) -> Bool {
  self.to_any()._call("hasColors", [@nostd.any(count)]).cast()
}

///|
/// Get window size as [columns, rows]
pub fn WriteStream::get_window_size(self : WriteStream) -> (Int, Int) {
  let arr : @nostd.Any = self.to_any()._call("getWindowSize", [])
  let cols : Int = arr["0"].cast()
  let rows : Int = arr["1"].cast()
  (cols, rows)
}

///|
/// Register resize event handler
pub fn WriteStream::on_resize(
  self : WriteStream,
  callback : () -> Unit,
) -> WriteStream {
  self.addEventListener("resize", fn(_e : @nostd.Any) { callback() })
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
