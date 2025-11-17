///|
using @js {trait Js, type Val, unsafe_cast, js}

///|
/// EventEmitter trait for Node.js event emitter pattern
pub(open) trait EventEmitterImpl: Js {
  on(Self, String, (Val) -> Unit) -> Unit = _
  on2(Self, String, (Val, Val) -> Unit) -> Unit = _
  once(Self, String, (Val) -> Unit) -> Unit = _
  off(Self, String, (Val) -> Unit) -> Unit = _
  removeListener(Self, String, (Val) -> Unit) -> Unit = _
  removeAllListeners(Self, String?) -> Unit = _
  emit(Self, String, Val) -> Unit = _
}

///|
/// Implement EventEmitter trait for EventEmitterClass
impl EventEmitterImpl with on(self, name : String, callback : (Val) -> Unit) -> Unit {
  self.invoke("on", [name, callback |> js]) |> unsafe_cast
}

///|
impl EventEmitterImpl with on2(
  self,
  name : String,
  callback : (Val, Val) -> Unit,
) -> Unit {
  self.invoke("on", [name, callback |> js]) |> unsafe_cast
}

///|
impl EventEmitterImpl with once(self, name : String, callback : (Val) -> Unit) -> Unit {
  self.invoke("once", [name, callback |> js]) |> unsafe_cast
}

///|
impl EventEmitterImpl with off(self, name : String, callback : (Val) -> Unit) -> Unit {
  self.invoke("off", [name, callback |> @js.from_fn1]) |> unsafe_cast
}

///|
impl EventEmitterImpl with removeListener(
  self,
  name : String,
  callback : (Val) -> Unit,
) -> Unit {
  self.invoke("removeListener", [name, callback |> unsafe_cast]) |> unsafe_cast
}

///|
/// implement remove_all_listeners
impl EventEmitterImpl with removeAllListeners(self, name : String?) -> Unit {
  match name {
    Some(n) => self.invoke("removeAllListeners", [n]) |> unsafe_cast
    None => self.invoke("removeAllListeners", []) |> unsafe_cast
  }
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

pub fn EventEmitter::new() -> EventEmitter {
  let ee = @node.require("events").get("EventEmitter")
  unsafe_cast(@js.new_(ee, []))
}
