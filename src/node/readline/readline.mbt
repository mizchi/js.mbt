///|
using @js {trait JsImpl, js, type Val, unsafe_cast, type AbortSignal}

///|
using @promise {type Promise}

///|
using @events {trait EventEmitterImpl}

///|
#external
pub type Interface

///|
impl JsImpl for Interface

///|
/// Implement EventEmitter trait for Interface
pub impl EventEmitterImpl for Interface

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
  signal? : AbortSignal,
) -> Interface {
  let opts = @js.Object::new()
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
  unsafe_cast(
    @node.require("node:readline/promises")
    .get("createInterface")
    .invoke_self([opts]),
  )
}

///|
pub fn Interface::question(self : Self, query : String) -> Promise[String] {
  self.invoke("question", [query]) |> unsafe_cast
}

///|
pub fn Interface::commit(self : Self) -> Promise[Unit] {
  self.invoke("commit", []) |> unsafe_cast
}

///|
pub fn Interface::rollback(self : Self) -> Self {
  self.invoke("rollback", []) |> unsafe_cast
}

///|
#alias(cursor_to)
pub fn Interface::cursorTo(self : Self, x : Int, y? : Int) -> Promise[Unit] {
  self.invoke("cursorTo", [x, y]) |> unsafe_cast
}

///|
#alias(move_cursor)
pub fn Interface::moveCursor(self : Self, dx : Int, dy? : Int) -> Promise[Unit] {
  self.invoke("moveCursor", [dx, dy]) |> unsafe_cast
}

///|
#alias(clear_line)
pub fn Interface::clearLine(self : Self, dir : Int) -> Self {
  self.invoke("clearLine", [dir]) |> unsafe_cast
}

///|
#alias(clear_screen_down)
pub fn Interface::clearScreenDown(self : Self, dir : Int) -> Self {
  self.invoke("clearScreenDown", [dir]) |> unsafe_cast
}

///|
/// TODO: impl after async test support
// test "readline promises interface" {
//   let rl = create_interface(
//     input=unsafe_cast(@node.require("node:process").get("stdin")),
//     output=unsafe_cast(@node.require("node:process").get("stdout")),
//   )
//   // let x = rl.question("What is your name? ")
// }
