///|
#external
pub type Process

///|
pub impl @js.JsImpl for Process

///|
pub fn process() -> Process {
  @js.unsafe_cast(@node.require("node:process"))
}

///|
/// JS: process.env
pub fn env() -> ProcessEnv {
  @node.require("node:process").get("env") |> @js.unsafe_cast
}

///|
/// JS: process.argv
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn argv() -> Array[String] {
  @js.unsafe_cast(process().get("argv"))
}

///|
/// JS: process.cwd()
pub fn cwd() -> String {
  @js.unsafe_cast(process().get("cwd").call_self([]))
}

///|
/// JS: process.version
pub fn version() -> String {
  @js.unsafe_cast(process().get("version"))
}

///|
/// JS: process.versions
pub fn versions() -> @js.Object {
  @js.unsafe_cast(process().get("version"))
}

///|
/// JS: process.isTTY
pub fn isTTY() -> Bool {
  @js.unsafe_cast(process().get("isTTY"))
}

///|
/// JS: process.chdir(path)
pub fn chdir(path : String) -> Unit {
  @js.unsafe_cast(process().get("chdir").call_self([path]))
}

///|
/// JS: process.exit(code)
pub fn exit(code : Int) -> Unit {
  process().get("exit").call_self([code]) |> ignore
}

///|
/// JS: process.exitCode
pub fn exitCode() -> Int {
  process().get("exitCode") |> @js.unsafe_cast
}

///|
pub fn stdin() -> @stream.Stream {
  @js.unsafe_cast(process().get("stdin"))
}

///|
pub fn stdout() -> @stream.Stream {
  @js.unsafe_cast(process().get("stdout"))
}

///|
pub fn stderr() -> @stream.Stream {
  @js.unsafe_cast(process().get("stderr"))
}

///|
/// JS: process.on(sig, listener)
pub fn on(sig : String, listener : () -> Unit) -> Unit {
  @js.unsafe_cast(process().call2("on", sig, @js.from_fn0(listener)))
}

///|
/// JS: process.nextTick(callback)
pub fn nextTick(callback : () -> Unit) -> Unit {
  process().call1("nextTick", @js.from_fn0(callback)) |> ignore
}
