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
  self.to_js().invoke("on", [name, callback |> js]).cast()
}

///|
pub impl EventEmitter for Stream with once(
  self : Stream,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().invoke("once", [name, callback |> js]).cast()
}

///|
pub impl EventEmitter for Stream with off(
  self : Stream,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().invoke("off", [name, callback |> js]).cast()
}

///|
pub impl EventEmitter for Stream with emit(
  self : Stream,
  name : String,
  payload : Val,
) -> Unit {
  self.to_js().invoke("emit", [name, payload]).cast()
}
