///|
using @js {trait Js, type Val, unsafe_cast, js}

///|
/// EventEmitter trait for Node.js event emitter pattern
pub(open) trait EventEmitterImpl: Js {
  on(Self, String, (Val) -> Unit) -> Unit = _
  once(Self, String, (Val) -> Unit) -> Unit = _
  off(Self, String, (Val) -> Unit) -> Unit = _
  emit(Self, String, Val) -> Unit = _
}

///|
/// Implement EventEmitter trait for EventEmitterClass
impl EventEmitterImpl with on(self, name : String, callback : (Val) -> Unit) -> Unit {
  self.invoke("on", [name, callback |> js]) |> unsafe_cast
}

///|
impl EventEmitterImpl with once(self, name : String, callback : (Val) -> Unit) -> Unit {
  self.invoke("once", [name, callback |> js]) |> unsafe_cast
}

///|
impl EventEmitterImpl with off(self, name : String, callback : (Val) -> Unit) -> Unit {
  self.invoke("off", [name, callback |> js]) |> unsafe_cast
}

///|
impl EventEmitterImpl with emit(self, name : String, payload : Val) -> Unit {
  self.invoke("emit", [name, payload]) |> unsafe_cast
}

///|
/// Concrete EventEmitter type for standalone use
#external
pub type EventEmitter

///|
pub impl Js for EventEmitter

///|
/// Create a new standalone EventEmitter instance
pub fn new_event_emitter() -> EventEmitter {
  let ee = @node.require("events").get("EventEmitter")
  unsafe_cast(@js.new_(ee, []))
}
