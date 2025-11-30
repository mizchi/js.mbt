///|
extern "js" fn readline_promises_module() -> @js.Any =
  #| () => require("node:readline/promises")

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
  let opts = @js.from_option_map({
    "input": Some(input.as_any().cast()),
    "output": output.map(fn(x) { x.as_any().cast() }),
    "completer": completer.map(fn(x) { @js.from_fn1(x) }),
    "terminator": terminator.map(fn(x) { @js.any(x) }),
    "history": history.map(fn(x) { @js.from_array(x) }),
    "removeHistoryDuplicates": removeHistoryDuplicates.map(fn(x) { @js.any(x) }),
    "prompt": prompt.map(fn(x) { @js.any(x) }),
    "crlfDelay": crlfDelay.map(fn(x) { @js.any(x) }),
    "escapeCodeTimeout": escapeCodeTimeout.map(fn(x) { @js.any(x) }),
    "tabSize": tabSize.map(fn(x) { @js.any(x) }),
    "signal": signal.map(fn(x) { x |> @js.identity }),
  })
  @js.identity(
    readline_promises_module().get("createInterface").call_self([opts]),
  )
}

///|
pub async fn Interface::question(self : Self, query : String) -> String {
  let promise : @js.Promise[String] = self.call("question", [query]).cast()
  promise.wait()
}

///|
pub async fn Interface::commit(self : Self) -> Unit {
  let promise : @js.Promise[Unit] = self.call0("commit").cast()
  promise.wait()
}

///|
pub fn Interface::rollback(self : Self) -> Self {
  self.call0("rollback").cast()
}

///|
#alias(cursor_to)
pub async fn Interface::cursorTo(self : Self, x : Int, y? : Int) -> Unit {
  let promise : @js.Promise[Unit] = self.call2("cursorTo", x, y).cast()
  promise.wait()
}

///|
#alias(move_cursor)
pub async fn Interface::moveCursor(self : Self, dx : Int, dy? : Int) -> Unit {
  let promise : @js.Promise[Unit] = self.call2("moveCursor", dx, dy).cast()
  promise.wait()
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
