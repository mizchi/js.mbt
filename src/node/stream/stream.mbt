///|
using @js {js, trait Js, type Val}

///|
using @events {trait EventEmitter}

///|
#external
pub type Stream

///|
pub impl Js for Stream with to_js(self) {
  self |> js
}

///|
/// Implement EventEmitter trait for Stream
pub impl EventEmitter for Stream with on(
  self : Stream,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().call_method("on", [name, callback |> js]).cast()
}

///|
pub impl EventEmitter for Stream with once(
  self : Stream,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().call_method("once", [name, callback |> js]).cast()
}

///|
pub impl EventEmitter for Stream with off(
  self : Stream,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().call_method("off", [name, callback |> js]).cast()
}

///|
pub impl EventEmitter for Stream with emit(
  self : Stream,
  name : String,
  payload : Val,
) -> Unit {
  self.to_js().call_method("emit", [name, payload]).cast()
}
