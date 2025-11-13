///|
using @js {trait Js, js, type Val}

///|
using @async {type Promise, type AbortSignal}

///|
using @events {type EventEmitter}

///|
#external
pub type Interface

///|
impl Js for Interface with to_js(self) {
  self |> js
}

///|
pub fn Interface::as_event_emitter(self : Self) -> EventEmitter {
  self.to_js().cast()
}

///|
#alias(createInterface)
pub fn create_interface(
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
  signal? : AbortSignal,
) -> Interface {
  let opts = @js.new_empty_object()
  opts.set("input", input.to_js())
  if output is Some(v) {
    opts.set("output", v)
  }
  // opts.set("output", output.to_js())
  if completer is Some(v) {
    opts.set("completer", v |> js)
  }
  if terminator is Some(v) {
    opts.set("terminator", v |> js)
  }
  if history is Some(v) {
    opts.set("history", v |> js)
  }
  if removeHistoryDuplicates is Some(v) {
    opts.set("removeHistoryDuplicates", v |> js)
  }
  if prompt is Some(v) {
    opts.set("prompt", v |> js)
  }
  if crlfDelay is Some(v) {
    opts.set("crlfDelay", v |> js)
  }
  if escapeCodeTimeout is Some(v) {
    opts.set("escapeCodeTimeout", v |> js)
  }
  if tabSize is Some(v) {
    opts.set("tabSize", v |> js)
  }
  if signal is Some(v) {
    opts.set("signal", v)
  }
  @node.require("node:readline/promises")
  .get("createInterface")
  .call([opts])
  .cast()
}

///|
pub fn Interface::question(self : Self, query : String) -> Promise[String] {
  self.to_js().call_method("question", [query]).cast()
}

///|
pub fn Interface::commit(self : Self) -> Promise[Unit] {
  self.to_js().call_method("commit", []).cast()
}

///|
pub fn Interface::rollback(self : Self) -> Self {
  self.to_js().call_method("rollback", []).cast()
}

///|
#alias(cursor_to)
pub fn Interface::cursorTo(self : Self, x : Int, y? : Int) -> Promise[Unit] {
  self.to_js().call_method("cursorTo", [x, y]).cast()
}

///|
#alias(move_cursor)
pub fn Interface::moveCursor(self : Self, dx : Int, dy? : Int) -> Promise[Unit] {
  self.to_js().call_method("moveCursor", [dx, dy]).cast()
}

///|
#alias(clear_line)
pub fn Interface::clearLine(self : Self, dir : Int) -> Self {
  self.to_js().call_method("clearLine", [dir]).cast()
}

///|
#alias(clear_screen_down)
pub fn Interface::clearScreenDown(self : Self, dir : Int) -> Self {
  self.to_js().call_method("clearScreenDown", [dir]).cast()
}

///|
/// TODO: impl after async test support
// test "readline promises interface" {
//   let rl = create_interface(
//     input=@node.require("node:process").get("stdin").cast(),
//     output=@node.require("node:process").get("stdout").cast(),
//   )
//   // let x = rl.question("What is your name? ")
// }
