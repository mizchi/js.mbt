///|
using @js {js, trait Js, type Val, unsafe_cast}

///|
using @events {trait EventEmitter}

///|
#external
pub type Stream

///|
pub impl Js for Stream

///|
/// Implement EventEmitter trait for Stream
pub impl EventEmitter for Stream with on(
  self : Stream,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.invoke("on", [name, callback |> js]) |> unsafe_cast
}

///|
pub impl EventEmitter for Stream with once(
  self : Stream,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.invoke("once", [name, callback |> js]) |> unsafe_cast
}

///|
pub impl EventEmitter for Stream with off(
  self : Stream,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.invoke("off", [name, callback |> js]) |> unsafe_cast
}

///|
pub impl EventEmitter for Stream with emit(
  self : Stream,
  name : String,
  payload : Val,
) -> Unit {
  self.invoke("emit", [name, payload]) |> unsafe_cast
}
