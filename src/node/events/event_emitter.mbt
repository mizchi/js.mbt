///|
using @js {trait Js, type Val, unsafe_cast, js}

///|
/// EventEmitter trait for Node.js event emitter pattern
pub(open) trait EventEmitter {
  on(Self, String, () -> Unit) -> Unit
  once(Self, String, () -> Unit) -> Unit
  off(Self, String, () -> Unit) -> Unit
  emit(Self, String, Val) -> Unit
}

///|
/// Concrete EventEmitter type for standalone use
#external
pub type EventEmitterClass

///|
pub impl Js for EventEmitterClass

///|
/// Create a new standalone EventEmitter instance
pub fn new_event_emitter() -> EventEmitterClass {
  let ee = @node.require("events").get("EventEmitter")
  unsafe_cast(@js.new_(ee, []))
}

///|
/// Implement EventEmitter trait for EventEmitterClass
pub impl EventEmitter for EventEmitterClass with on(
  self : EventEmitterClass,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.invoke("on", [name, callback |> js]) |> unsafe_cast
}

///|
pub impl EventEmitter for EventEmitterClass with once(
  self : EventEmitterClass,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.invoke("once", [name, callback |> js]) |> unsafe_cast
}

///|
pub impl EventEmitter for EventEmitterClass with off(
  self : EventEmitterClass,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.invoke("off", [name, callback |> js]) |> unsafe_cast
}

///|
pub impl EventEmitter for EventEmitterClass with emit(
  self : EventEmitterClass,
  name : String,
  payload : Val,
) -> Unit {
  self.invoke("emit", [name, payload]) |> unsafe_cast
}
