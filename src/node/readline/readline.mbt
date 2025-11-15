///|
using @js {trait Js, js, type Val}

///|
using @async {type Promise, type AbortSignal}

///|
using @events {trait EventEmitter}

///|
#external
pub type Interface

///|
impl Js for Interface with to_js(self) {
  self |> js
}

///|
/// Implement EventEmitter trait for Interface
pub impl EventEmitter for Interface with on(
  self : Interface,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().invoke("on", [name, callback |> js]).cast()
}

///|
pub impl EventEmitter for Interface with once(
  self : Interface,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().invoke("once", [name, callback |> js]).cast()
}

///|
pub impl EventEmitter for Interface with off(
  self : Interface,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().invoke("off", [name, callback |> js]).cast()
}

///|
pub impl EventEmitter for Interface with emit(
  self : Interface,
  name : String,
  payload : Val,
) -> Unit {
  self.to_js().invoke("emit", [name, payload]).cast()
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
  .invoke_self([opts])
  .cast()
}

///|
pub fn Interface::question(self : Self, query : String) -> Promise[String] {
  self.to_js().invoke("question", [query]).cast()
}

///|
pub fn Interface::commit(self : Self) -> Promise[Unit] {
  self.to_js().invoke("commit", []).cast()
}

///|
pub fn Interface::rollback(self : Self) -> Self {
  self.to_js().invoke("rollback", []).cast()
}

///|
#alias(cursor_to)
pub fn Interface::cursorTo(self : Self, x : Int, y? : Int) -> Promise[Unit] {
  self.to_js().invoke("cursorTo", [x, y]).cast()
}

///|
#alias(move_cursor)
pub fn Interface::moveCursor(self : Self, dx : Int, dy? : Int) -> Promise[Unit] {
  self.to_js().invoke("moveCursor", [dx, dy]).cast()
}

///|
#alias(clear_line)
pub fn Interface::clearLine(self : Self, dir : Int) -> Self {
  self.to_js().invoke("clearLine", [dir]).cast()
}

///|
#alias(clear_screen_down)
pub fn Interface::clearScreenDown(self : Self, dir : Int) -> Self {
  self.to_js().invoke("clearScreenDown", [dir]).cast()
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
