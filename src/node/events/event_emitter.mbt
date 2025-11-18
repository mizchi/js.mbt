/// https://nodejs.org/api/events.html#emittereventnames

///|
using @js {trait JsImpl, type Js, unsafe_cast}

///|
/// EventEmitter trait for Node.js event emitter pattern
pub(open) trait EventEmitterImpl: JsImpl {
  on(Self, String, (Js) -> Unit) -> Unit = _
  on2(Self, String, (Js?, Js) -> Unit) -> Unit = _
  once(Self, String, (Js) -> Unit) -> Unit = _
  eventNames(Self) -> Array[String] = _
  listenerCount(Self, String) -> Int = _
  listeners(Self, event? : String) -> Array[(Js) -> Unit] = _
  off(Self, String, (Js) -> Unit) -> Unit = _
  removeListener(Self, String, (Js) -> Unit) -> Unit = _
  removeAllListeners(Self) -> Unit = _
  emit(Self, String, Js) -> Unit = _
}

///|
/// Implement EventEmitter trait for EventEmitterClass
impl EventEmitterImpl with on(self, name : String, callback : (Js) -> Unit) -> Unit {
  self.invoke("on", [name, callback |> @js.from_fn1]) |> unsafe_cast
}

///|
impl EventEmitterImpl with on2(
  self,
  name : String,
  callback : (Js?, Js) -> Unit,
) -> Unit {
  self.invoke("on", [name, callback |> @js.from_fn2]) |> unsafe_cast
}

///|
impl EventEmitterImpl with once(self, name : String, callback : (Js) -> Unit) -> Unit {
  self.invoke("once", [name, callback |> @js.from_fn1]) |> unsafe_cast
}

///|
impl EventEmitterImpl with eventNames(self) {
  self.invoke("eventNames", []) |> unsafe_cast
}

///|
impl EventEmitterImpl with listenerCount(self, eventName) {
  self.invoke("listenerCount", [eventName]) |> unsafe_cast
}

///|
impl EventEmitterImpl with listeners(self, event? : String) {
  match event {
    Some(name) => self.invoke("listenerCount", [name]) |> unsafe_cast
    None => self.invoke("listenerCount", []) |> unsafe_cast
  }
}

///|
impl EventEmitterImpl with off(self, name : String, callback : (Js) -> Unit) -> Unit {
  self.invoke("off", [name, callback |> @js.from_fn1]) |> unsafe_cast
}

///|
impl EventEmitterImpl with removeListener(
  self,
  name : String,
  callback : (Js) -> Unit,
) -> Unit {
  self.invoke("removeListener", [name, callback |> unsafe_cast]) |> unsafe_cast
}

///|
/// implement remove_all_listeners
impl EventEmitterImpl with removeAllListeners(self) -> Unit {
  self.invoke("removeAllListeners", []) |> unsafe_cast
}

///|
impl EventEmitterImpl with emit(self, name : String, payload : Js) -> Unit {
  self.invoke("emit", [name, payload]) |> unsafe_cast
}

///|
/// Concrete EventEmitter type for standalone use
#external
pub type EventEmitter

///|
pub impl JsImpl for EventEmitter

///|
pub impl EventEmitterImpl for EventEmitter

///|
pub fn EventEmitter::new() -> EventEmitter {
  let ee = @node.require("events").get("EventEmitter")
  unsafe_cast(@js.new_(ee, []))
}
