// https://nodejs.org/api/child_process.html

///|
using @js {js, unsafe_cast, type Val, trait Js}

///|
using @async {type AbortSignal}

///|
#external
pub type ChildProcess

///|
pub impl Js for ChildProcess with to_js(self) -> Val {
  self |> js
}

///|
pub fn ChildProcess::require() -> ChildProcess {
  @node.require("node:child_process") |> unsafe_cast()
}

///|
pub fn ChildProcess::exec_sync(
  self : Self,
  command : String,
  cwd? : String,
  signal? : AbortSignal,
) -> SubProcess {
  let options = @js.new_empty_object()
  if cwd is Some(cwd) {
    options.set("cwd", cwd)
  }
  if signal is Some(signal) {
    options.set("signal", signal.to_js())
  }
  self.to_js().get("exec_sync").call([command, options]).cast()
}

///|
pub fn ChildProcess::exec(
  self : Self,
  command : String,
  args : Array[String],
  callback : (Val, String, String) -> Unit noraise,
  cwd? : String,
  signal? : AbortSignal,
) -> Unit {
  let options = @js.new_empty_object()
  if cwd is Some(cwd) {
    options.set("cwd", cwd)
  }
  if signal is Some(signal) {
    options.set("signal", signal.to_js())
  }
  self
  .to_js()
  .get("exec")
  .call([command, args |> js, options, unsafe_cast(callback)])
  .cast()
}

///|
pub fn ChildProcess::spawn(
  self : Self,
  command : String,
  args : Array[String],
  cwd? : String,
  signal? : AbortSignal,
) -> SubProcess {
  let options = @js.new_empty_object()
  if cwd is Some(cwd) {
    options.set("cwd", cwd)
  }
  if signal is Some(signal) {
    options.set("signal", signal.to_js())
  }
  self.to_js().get("spawn").call([command, args |> js, options]).cast()
}

///|
#external
pub type SubProcess

///|
impl Js for SubProcess with to_js(self) -> Val {
  self |> js
}

///|
pub fn SubProcess::on(
  self : Self,
  event : String,
  callback : (Val) -> Unit noraise,
) -> Unit {
  self.to_js().call_method("on", [event, unsafe_cast(callback)]) |> ignore
}

///|
pub fn SubProcess::off(
  self : Self,
  event : String,
  callback : (Val) -> Unit noraise,
) -> Unit {
  self.to_js().call_method("off", [event, unsafe_cast(callback)]) |> ignore
}
