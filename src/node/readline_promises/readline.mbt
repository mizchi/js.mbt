///|
extern "js" fn readline_promises_module() -> @core.Any =
  #| () => require("node:readline/promises")

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
  signal? : @js.AbortSignal,
) -> Interface {
  let opts = @mbtconv.from_option_map({
    "input": Some(@core.identity(input.as_any())),
    "output": output.map(fn(x) { @core.identity(x.as_any()) }),
    "completer": completer.map(fn(x) { @core.identity(@js.from_fn1(x)) }),
    "terminator": terminator.map(fn(x) { @core.any(x) }),
    "history": history.map(fn(x) { @core.identity(@core.any(x)) }),
    "removeHistoryDuplicates": removeHistoryDuplicates.map(fn(x) {
      @core.any(x)
    }),
    "prompt": prompt.map(fn(x) { @core.any(x) }),
    "crlfDelay": crlfDelay.map(fn(x) { @core.any(x) }),
    "escapeCodeTimeout": escapeCodeTimeout.map(fn(x) { @core.any(x) }),
    "tabSize": tabSize.map(fn(x) { @core.any(x) }),
    "signal": signal.map(fn(x) { @core.identity(x) }),
  }).cast()
  @core.identity(
    readline_promises_module()._get("createInterface")._invoke([opts]),
  )
}

///|
pub async fn Interface::question(self : Self, query : String) -> String {
  let promise : @js.Promise[String] = self
    .as_any()
    ._call("question", [@core.any(query)])
    .cast()
  promise.wait()
}

///|
pub async fn Interface::commit(self : Self) -> Unit {
  let promise : @js.Promise[Unit] = self.as_any()._call("commit", []).cast()
  promise.wait()
}

///|
pub fn Interface::rollback(self : Self) -> Self {
  self.as_any()._call("rollback", []).cast()
}

///|
#alias(cursor_to)
pub async fn Interface::cursorTo(self : Self, x : Int, y? : Int) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("cursorTo", [@core.any(x), @core.any(y)])
    .cast()
  promise.wait()
}

///|
#alias(move_cursor)
pub async fn Interface::moveCursor(self : Self, dx : Int, dy? : Int) -> Unit {
  let promise : @js.Promise[Unit] = self
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
