///|
using @js {trait JsImpl, type Js, type Promise, unsafe_cast, type AbortSignal}

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
  let opts = @js.from_entries_option([
    ("input", Some(input.to_js())),
    ("output", output.map(x => x)),
    ("completer", completer.map(x => x |> @js.from_fn1)),
    ("terminator", terminator.map(x => x)),
    ("history", history.map(x => x |> @js.from_array)),
    ("removeHistoryDuplicates", removeHistoryDuplicates.map(x => x)),
    ("prompt", prompt.map(x => x)),
    ("crlfDelay", crlfDelay.map(x => x)),
    ("escapeCodeTimeout", escapeCodeTimeout.map(x => x)),
    ("tabSize", tabSize.map(x => x)),
    ("signal", signal.map(x => x)),
  ])
  unsafe_cast(
    @node.require("node:readline/promises")
    .get("createInterface")
    .call_self([opts]),
  )
}

///|
pub fn Interface::question(self : Self, query : String) -> Promise[String] {
  self.call("question", [query]) |> unsafe_cast
}

///|
pub fn Interface::commit(self : Self) -> Promise[Unit] {
  self.call("commit", []) |> unsafe_cast
}

///|
pub fn Interface::rollback(self : Self) -> Self {
  self.call("rollback", []) |> unsafe_cast
}

///|
#alias(cursor_to)
pub fn Interface::cursorTo(self : Self, x : Int, y? : Int) -> Promise[Unit] {
  self.call("cursorTo", [x, y]) |> unsafe_cast
}

///|
#alias(move_cursor)
pub fn Interface::moveCursor(self : Self, dx : Int, dy? : Int) -> Promise[Unit] {
  self.call("moveCursor", [dx, dy]) |> unsafe_cast
}

///|
#alias(clear_line)
pub fn Interface::clearLine(self : Self, dir : Int) -> Self {
  self.call("clearLine", [dir]) |> unsafe_cast
}

///|
#alias(clear_screen_down)
pub fn Interface::clearScreenDown(self : Self, dir : Int) -> Self {
  self.call("clearScreenDown", [dir]) |> unsafe_cast
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
