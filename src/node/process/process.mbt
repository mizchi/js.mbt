///|
extern "js" fn process_module() -> @core.Any =
  #| () => require("node:process")

///|
#external
pub type Process

///|
pub fn Process::as_any(self : Process) -> @core.Any = "%identity"

///|
pub fn process() -> Process {
  @core.identity(process_module())
}

///|
fn process_any() -> @core.Any {
  @core.any(process_module())
}

///|
/// JS: process.env
pub fn env() -> ProcessEnv {
  process_any()["env"].cast()
}

///|
/// JS: process.argv
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn argv() -> Array[String] {
  process_any()["argv"].cast()
}

///|
/// JS: process.cwd()
pub fn cwd() -> String {
  process_any()._call("cwd", []).cast()
}

///|
/// JS: process.version
pub fn version() -> String {
  process_any()["version"].cast()
}

///|
/// JS: process.versions
pub fn versions() -> @core.Any {
  process_any()["version"].cast()
}

///|
/// JS: process.isTTY
pub fn isTTY() -> Bool {
  process_any()["isTTY"].cast()
}

///|
/// JS: process.chdir(path)
pub fn chdir(path : String) -> Unit {
  process_any()["chdir"]._invoke([@core.any(path)]) |> ignore
}

///|
/// JS: process.exit(code)
pub fn exit(code : Int) -> Unit {
  process_any()["exit"]._invoke([@core.any(code)]) |> ignore
}

///|
/// JS: process.exitCode
pub fn exitCode() -> Int {
  process_any()["exitCode"].cast()
}

///|
/// JS: process.stdin
/// Returns tty.ReadStream when connected to a TTY, otherwise stream.Readable
pub fn stdin() -> @tty.ReadStream {
  process_any()["stdin"].cast()
}

///|
/// JS: process.stdout
/// Returns tty.WriteStream when connected to a TTY, otherwise stream.Writable
pub fn stdout() -> @tty.WriteStream {
  process_any()["stdout"].cast()
}

///|
/// JS: process.stderr
/// Returns tty.WriteStream when connected to a TTY, otherwise stream.Writable
pub fn stderr() -> @tty.WriteStream {
  process_any()["stderr"].cast()
}

///|
/// JS: process.on(sig, listener)
pub fn on(sig : String, listener : () -> Unit) -> Unit {
  process_any()._call("on", [
    @core.any(sig),
    @core.any(@core.from_fn0(listener)),
  ])
  |> ignore
}

///|
/// JS: process.nextTick(callback)
pub fn nextTick(callback : () -> Unit) -> Unit {
  process_any()._call("nextTick", [@core.any(@core.from_fn0(callback))])
  |> ignore
}
