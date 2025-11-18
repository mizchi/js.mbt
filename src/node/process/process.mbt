///|
#external
pub type Process

///|
pub impl Js for Process

///|
pub fn process() -> Process {
  unsafe_cast(@node.require("node:process"))
}

///|
/// JS: process.env
pub fn env() -> ProcessEnv {
  @node.require("node:process").get("env") |> unsafe_cast
}

///|
/// JS: process.argv
pub fn argv() -> Array[String] {
  unsafe_cast(process().get("argv"))
}

///|
/// JS: process.cwd()
pub fn cwd() -> String {
  unsafe_cast(process().get("cwd").invoke_self([]))
}

///|
/// JS: process.version
pub fn version() -> String {
  unsafe_cast(process().get("version"))
}

///|
/// JS: process.versions
pub fn versions() -> @js.Object {
  unsafe_cast(process().get("version"))
}

///|
/// JS: process.isTTY
pub fn isTTY() -> Bool {
  unsafe_cast(process().get("isTTY"))
}

///|
/// JS: process.chdir(path)
pub fn chdir(path : String) -> Unit {
  unsafe_cast(process().get("chdir").invoke_self([path]))
}

///|
/// JS: process.exit(code)
pub fn exit(code : Int) -> Unit {
  process().get("exit").invoke_self([code]) |> ignore
}

///|
/// JS: process.exitCode
pub fn exitCode() -> Int {
  process().get("exitCode") |> unsafe_cast
}

///|
pub fn stdin() -> @stream.Stream {
  unsafe_cast(process().get("stdin"))
}

///|
pub fn stdout() -> @stream.Stream {
  unsafe_cast(process().get("stdout"))
}

///|
pub fn stderr() -> @stream.Stream {
  unsafe_cast(process().get("stderr"))
}

///|
/// JS: process.on(sig, listener)
pub fn on(sig : String, listener : () -> Unit) -> Unit {
  unsafe_cast(process().invoke("on", [sig, @js.from_fn0(listener)]))
}
