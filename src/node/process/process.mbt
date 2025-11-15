///|
#external
pub type Process

///|
pub impl Js for Process

///|
pub fn Process::require() -> Process {
  unsafe_cast(@node.require("node:process"))
}

///|
pub fn Process::args(self : Self) -> Array[String] {
  unsafe_cast(self.get("argv"))
}

///|
pub fn Process::cwd(self : Self) -> String {
  unsafe_cast(self.get("cwd").invoke_self([]))
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
  unsafe_cast(Process::require().to_js().get("env"))
}

///|
pub fn Process::stdio() -> Stream {
  unsafe_cast(Process::require().to_js().get("stdio"))
}

///|
pub fn Process::stdout() -> Stream {
  unsafe_cast(Process::require().to_js().get("stdout"))
}
