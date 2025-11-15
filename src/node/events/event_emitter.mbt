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
pub impl Js for EventEmitterClass with to_js(self) {
  self |> js
}

///|
/// Create a new standalone EventEmitter instance
pub fn new_event_emitter() -> EventEmitterClass {
  let ee = @node.require("events").get("EventEmitter")
  @js.new_(ee, []).cast()
}

///|
/// Implement EventEmitter trait for EventEmitterClass
pub impl EventEmitter for EventEmitterClass with on(
  self : EventEmitterClass,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().invoke("on", [name, callback |> js]).cast()
}

///|
pub impl EventEmitter for EventEmitterClass with once(
  self : EventEmitterClass,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().invoke("once", [name, callback |> js]).cast()
}

///|
pub impl EventEmitter for EventEmitterClass with off(
  self : EventEmitterClass,
  name : String,
  callback : () -> Unit,
) -> Unit {
  self.to_js().invoke("off", [name, callback |> js]).cast()
}

///|
pub impl EventEmitter for EventEmitterClass with emit(
  self : EventEmitterClass,
  name : String,
  payload : Val,
) -> Unit {
  self.to_js().invoke("emit", [name, payload]).cast()
}
