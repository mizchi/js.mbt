///|
#module("node:readline/promises")
extern "js" fn ffi_create_interface(opts : @core.Any) -> Interface = "createInterface"

///|
#external
pub type Interface

///|
pub fn Interface::as_any(self : Interface) -> @core.Any = "%identity"

///|
#alias(create_interface)
pub fn createInterface(
  input~ : @stream.Stream,
  output? : @stream.Stream,
  completer? : (String) -> Array[String],
  terminator? : String,
  history? : Array[String],
  removeHistoryDuplicates? : Bool,
  prompt? : String,
  crlfDelay? : Int,
  escapeCodeTimeout? : Int,
  tabSize? : Int,
  signal? : @js_async.AbortSignal,
) -> Interface {
  let entries : Array[(String, @core.Any)] = []
  entries.push(("input", @core.identity(input.as_any())))
  if output is Some(v) {
    entries.push(("output", @core.identity(v.as_any())))
  }
  if completer is Some(v) {
    entries.push(("completer", @core.identity(@core.from_fn1(v))))
  }
  if terminator is Some(v) {
    entries.push(("terminator", @core.any(v)))
  }
  if history is Some(v) {
    entries.push(("history", @core.identity(@core.any(v))))
  }
  if removeHistoryDuplicates is Some(v) {
    entries.push(("removeHistoryDuplicates", @core.any(v)))
  }
  if prompt is Some(v) {
    entries.push(("prompt", @core.any(v)))
  }
  if crlfDelay is Some(v) {
    entries.push(("crlfDelay", @core.any(v)))
  }
  if escapeCodeTimeout is Some(v) {
    entries.push(("escapeCodeTimeout", @core.any(v)))
  }
  if tabSize is Some(v) {
    entries.push(("tabSize", @core.any(v)))
  }
  if signal is Some(v) {
    entries.push(("signal", @core.identity(v)))
  }
  let opts = @core.from_entries(entries)
  ffi_create_interface(opts)
}

///|
pub async fn Interface::question(self : Self, query : String) -> String {
  let promise : @core.Promise[String] = self
    .as_any()
    ._call("question", [@core.any(query)])
    .cast()
  promise.wait()
}

///|
pub async fn Interface::commit(self : Self) -> Unit {
  let promise : @core.Promise[Unit] = self.as_any()._call("commit", []).cast()
  promise.wait()
}

///|
pub fn Interface::rollback(self : Self) -> Self {
  self.as_any()._call("rollback", []).cast()
}

///|
#alias(cursor_to)
pub async fn Interface::cursorTo(self : Self, x : Int, y? : Int) -> Unit {
  let promise : @core.Promise[Unit] = self
    .as_any()
    ._call("cursorTo", [@core.any(x), @core.any(y)])
    .cast()
  promise.wait()
}

///|
#alias(move_cursor)
pub async fn Interface::moveCursor(self : Self, dx : Int, dy? : Int) -> Unit {
  let promise : @core.Promise[Unit] = self
    .as_any()
    ._call("moveCursor", [@core.any(dx), @core.any(dy)])
    .cast()
  promise.wait()
}

///|
#alias(clear_line)
pub fn Interface::clearLine(self : Self, dir : Int) -> Self {
  self.as_any()._call("clearLine", [@core.any(dir)]).cast()
}

///|
#alias(clear_screen_down)
pub fn Interface::clearScreenDown(self : Self, dir : Int) -> Self {
  self.as_any()._call("clearScreenDown", [@core.any(dir)]).cast()
}

///|
/// TODO: impl after async test support
// test "readline promises interface" {
//   let rl = create_interface(
//     input=identity(@node.require("node:process")._get("stdin")),
//     output=identity(@node.require("node:process")._get("stdout")),
//   )
//   // let x = rl.question("What is your name? ")
// }
