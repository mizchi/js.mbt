///|
#external
pub type Interface

///|
impl @js.JsImpl for Interface

///|
/// Implement EventEmitter trait for Interface
pub impl @events.EventEmitterImpl for Interface

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
  signal? : @js.AbortSignal,
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
  @js.identity(
    @node.require("node:readline/promises")
    .get("createInterface")
    .call_self([opts]),
  )
}

///|
pub fn Interface::question(self : Self, query : String) -> @js.Promise[String] {
  self.call("question", [query]).cast()
}

///|
pub fn Interface::commit(self : Self) -> @js.Promise[Unit] {
  self.call0("commit").cast()
}

///|
pub fn Interface::rollback(self : Self) -> Self {
  self.call0("rollback").cast()
}

///|
#alias(cursor_to)
pub fn Interface::cursorTo(self : Self, x : Int, y? : Int) -> @js.Promise[Unit] {
  self.call2("cursorTo", x, y).cast()
}

///|
#alias(move_cursor)
pub fn Interface::moveCursor(
  self : Self,
  dx : Int,
  dy? : Int,
) -> @js.Promise[Unit] {
  self.call2("moveCursor", dx, dy).cast()
}

///|
#alias(clear_line)
pub fn Interface::clearLine(self : Self, dir : Int) -> Self {
  self.call("clearLine", [dir]).cast()
}

///|
#alias(clear_screen_down)
pub fn Interface::clearScreenDown(self : Self, dir : Int) -> Self {
  self.call("clearScreenDown", [dir]).cast()
}

///|
/// TODO: impl after async test support
// test "readline promises interface" {
//   let rl = create_interface(
//     input=identity(@node.require("node:process").get("stdin")),
//     output=identity(@node.require("node:process").get("stdout")),
//   )
//   // let x = rl.question("What is your name? ")
// }
