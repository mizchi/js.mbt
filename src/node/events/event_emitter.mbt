///|
using @js {trait Js, type Val, unsafe_cast, js}

///|
#external
pub type EventEmitter

///|
pub impl Js for EventEmitter with to_js(self) {
  self |> js
}

///|
pub fn EventEmitter::new() -> EventEmitter {
  let ee = @node.require("events").get("EventEmitter")
  @js.new_(ee, []).cast()
}

///|
pub fn EventEmitter::on(
  self : Self,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().call_method("on", [name, callback |> js]).cast()
}

///|
pub fn EventEmitter::once(
  self : Self,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().call_method("once", [name, callback |> js]).cast()
}

///|
pub fn EventEmitter::off(
  self : Self,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().call_method("off", [name, callback |> js]).cast()
}

///|
pub fn EventEmitter::emit(self : Self, name : String, payload : Val) -> Unit {
  self.to_js().call_method("emit", [name, payload]).cast()
}
