///|
using @js {trait Js, js}

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
pub fn Process::exit(self : Self, code : Int) -> Unit {
  self.to_js().get("exit").call([code]) |> ignore
}

///|
pub fn Process::env() -> Env {
  Process::require().to_js().get("env").cast()
}
