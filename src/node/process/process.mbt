///|
extern "js" fn process_module() -> @js.Any =
  #| () => require("node:process")

///|
#external
pub type Process

///|
pub impl @js.JsImpl for Process

///|
pub fn process() -> Process {
  @js.identity(process_module())
}

///|
/// JS: process.env
pub fn env() -> ProcessEnv {
  process_module().get("env").cast()
}

///|
/// JS: process.argv
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn argv() -> Array[String] {
  @js.identity(process().get("argv"))
}

///|
/// JS: process.cwd()
pub fn cwd() -> String {
  process().call0("cwd").cast()
}

///|
/// JS: process.version
pub fn version() -> String {
  @js.identity(process().get("version"))
}

///|
/// JS: process.versions
pub fn versions() -> @js.Object {
  @js.identity(process().get("version"))
}

///|
/// JS: process.isTTY
pub fn isTTY() -> Bool {
  @js.identity(process().get("isTTY"))
}

///|
/// JS: process.chdir(path)
pub fn chdir(path : String) -> Unit {
  @js.identity(process().get("chdir").call_self([path]))
}

///|
/// JS: process.exit(code)
pub fn exit(code : Int) -> Unit {
  process().get("exit").call_self([code]) |> ignore
}

///|
/// JS: process.exitCode
pub fn exitCode() -> Int {
  process().get("exitCode").cast()
}

///|
/// JS: process.stdin
/// Returns tty.ReadStream when connected to a TTY, otherwise stream.Readable
pub fn stdin() -> @tty.ReadStream {
  @js.identity(process().get("stdin"))
}

///|
/// JS: process.stdout
/// Returns tty.WriteStream when connected to a TTY, otherwise stream.Writable
pub fn stdout() -> @tty.WriteStream {
  @js.identity(process().get("stdout"))
}

///|
/// JS: process.stderr
/// Returns tty.WriteStream when connected to a TTY, otherwise stream.Writable
pub fn stderr() -> @tty.WriteStream {
  @js.identity(process().get("stderr"))
}

///|
/// JS: process.on(sig, listener)
pub fn on(sig : String, listener : () -> Unit) -> Unit {
  @js.identity(process().call2("on", sig, @js.from_fn0(listener)))
}

///|
/// JS: process.nextTick(callback)
pub fn nextTick(callback : () -> Unit) -> Unit {
  process().call1("nextTick", @js.from_fn0(callback)) |> ignore
}
