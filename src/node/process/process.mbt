///|
using @js {trait Js, js}

///|
using @stream {type Stream}

///|
#external
pub type Process

///|
pub impl Js for Process with to_js(self) {
  self |> js
}

///|
pub fn Process::require() -> Process {
  @node.require("node:process").cast()
}

///|
pub fn Process::args(self : Self) -> Array[String] {
  self.to_js().get("argv").cast()
}

///|
pub fn Process::cwd(self : Self) -> String {
  self.to_js().get("cwd").call([]).cast()
}

///|
pub fn Process::chdir(self : Self, path : String) -> Unit {
  self.to_js().get("chdir").call([path]).cast()
}

///|
pub fn Process::exit(self : Self, code : Int) -> Unit {
  self.to_js().get("exit").call([code]) |> ignore
}

///|
pub fn Process::env() -> Env {
  Process::require().to_js().get("env").cast()
}

///|
pub fn Process::stdio() -> Stream {
  Process::require().to_js().get("stdio").cast()
}

///|
pub fn Process::stdout() -> Stream {
  Process::require().to_js().get("stdout").cast()
}
