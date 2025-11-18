///|
#external
pub type Process

///|
pub impl Js for Process

///|
pub fn node_process() -> Process {
  unsafe_cast(@node.require("node:process"))
}

///|
pub fn Process::argv(self : Self) -> Array[String] {
  unsafe_cast(self.get("argv"))
}

///|
pub fn Process::cwd(self : Self) -> String {
  unsafe_cast(self.get("cwd").invoke_self([]))
}

///|
pub fn Process::isTTY(self : Self) -> Bool {
  unsafe_cast(self.get("isTTY"))
}

///|
pub fn Process::chdir(self : Self, path : String) -> Unit {
  unsafe_cast(self.get("chdir").invoke_self([path]))
}

///|
pub fn Process::exit(self : Self, code : Int) -> Unit {
  self.get("exit").invoke_self([code]) |> ignore
}

///|
pub fn Process::env() -> Env {
  unsafe_cast(node_process().get("env"))
}

///|
pub fn stdio() -> @stream.Stream {
  unsafe_cast(node_process().get("stdio"))
}

///|
pub fn stdout() -> @stream.Stream {
  unsafe_cast(node_process().get("stdout"))
}
