///|
extern "js" fn readline_promises_module() -> @nostd.Any =
  #| () => require("node:readline/promises")

///|
#external
pub type Interface

///|
pub fn Interface::as_any(self : Interface) -> @nostd.Any = "%identity"

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
  let opts = @mbtconv.from_option_map({
    "input": Some(@nostd.identity(input.as_any())),
    "output": output.map(fn(x) { @nostd.identity(x.as_any()) }),
    "completer": completer.map(fn(x) { @nostd.identity(@js.from_fn1(x)) }),
    "terminator": terminator.map(fn(x) { @nostd.any(x) }),
    "history": history.map(fn(x) { @nostd.identity(@nostd.any(x)) }),
    "removeHistoryDuplicates": removeHistoryDuplicates.map(fn(x) {
      @nostd.any(x)
    }),
    "prompt": prompt.map(fn(x) { @nostd.any(x) }),
    "crlfDelay": crlfDelay.map(fn(x) { @nostd.any(x) }),
    "escapeCodeTimeout": escapeCodeTimeout.map(fn(x) { @nostd.any(x) }),
    "tabSize": tabSize.map(fn(x) { @nostd.any(x) }),
    "signal": signal.map(fn(x) { @nostd.identity(x) }),
  }).cast()
  @nostd.identity(
    readline_promises_module()._get("createInterface").call_self([opts]),
  )
}

///|
pub async fn Interface::question(self : Self, query : String) -> String {
  let promise : @js.Promise[String] = self
    .as_any()
    ._call("question", [@nostd.any(query)])
    .cast()
  promise.wait()
}

///|
pub async fn Interface::commit(self : Self) -> Unit {
  let promise : @js.Promise[Unit] = self.as_any().call0("commit").cast()
  promise.wait()
}

///|
pub fn Interface::rollback(self : Self) -> Self {
  self.as_any().call0("rollback").cast()
}

///|
#alias(cursor_to)
pub async fn Interface::cursorTo(self : Self, x : Int, y? : Int) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    .call2("cursorTo", @nostd.any(x), @nostd.any(y))
    .cast()
  promise.wait()
}

///|
#alias(move_cursor)
pub async fn Interface::moveCursor(self : Self, dx : Int, dy? : Int) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    .call2("moveCursor", @nostd.any(dx), @nostd.any(dy))
    .cast()
  promise.wait()
}

///|
#alias(clear_line)
pub fn Interface::clearLine(self : Self, dir : Int) -> Self {
  self.as_any()._call("clearLine", [@nostd.any(dir)]).cast()
}

///|
#alias(clear_screen_down)
pub fn Interface::clearScreenDown(self : Self, dir : Int) -> Self {
  self.as_any()._call("clearScreenDown", [@nostd.any(dir)]).cast()
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
