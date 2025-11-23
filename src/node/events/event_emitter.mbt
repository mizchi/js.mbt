/// https://nodejs.org/api/events.html#emittereventnames

///|

///|
/// EventEmitter trait for Node.js event emitter pattern
pub(open) trait EventEmitterImpl: @js.JsImpl {
  on(Self, String, (@js.Js) -> Unit) -> Unit = _
  on2(Self, String, (@js.Js?, @js.Js) -> Unit) -> Unit = _
  once(Self, String, (@js.Js) -> Unit) -> Unit = _
  eventNames(Self) -> Array[String] = _
  listenerCount(Self, String) -> Int = _
  listeners(Self, event? : String) -> Array[(@js.Js) -> Unit] = _
  off(Self, String, (@js.Js) -> Unit) -> Unit = _
  removeListener(Self, String, (@js.Js) -> Unit) -> Unit = _
  removeAllListeners(Self) -> Unit = _
  emit(Self, String, @js.Js) -> Unit = _
}

///|
/// Implement EventEmitter trait for EventEmitterClass
impl EventEmitterImpl with on(self, name : String, callback : (@js.Js) -> Unit) -> Unit {
  self.call2("on", name, callback |> @js.from_fn1) |> @js.unsafe_cast
}

///|
impl EventEmitterImpl with on2(
  self,
  name : String,
  callback : (@js.Js?, @js.Js) -> Unit,
) -> Unit {
  self.call2("on", name, callback |> @js.from_fn2) |> @js.unsafe_cast
}

///|
impl EventEmitterImpl with once(
  self,
  name : String,
  callback : (@js.Js) -> Unit,
) -> Unit {
  self.call2("once", name, callback |> @js.from_fn1) |> @js.unsafe_cast
}

///|
impl EventEmitterImpl with eventNames(self) {
  self.call0("eventNames") |> @js.unsafe_cast
}

///|
impl EventEmitterImpl with listenerCount(self, eventName) {
  self.call("listenerCount", [eventName]) |> @js.unsafe_cast
}

///|
impl EventEmitterImpl with listeners(self, event? : String) {
  match event {
    Some(name) => self.call("listenerCount", [name]) |> @js.unsafe_cast
    None => self.call0("listenerCount") |> @js.unsafe_cast
  }
}

///|
impl EventEmitterImpl with off(self, name : String, callback : (@js.Js) -> Unit) -> Unit {
  self.call2("off", name, callback |> @js.from_fn1) |> @js.unsafe_cast
}

///|
impl EventEmitterImpl with removeListener(
  self,
  name : String,
  callback : (@js.Js) -> Unit,
) -> Unit {
  self.call2("removeListener", name, callback |> @js.unsafe_cast)
  |> @js.unsafe_cast
}

///|
/// implement remove_all_listeners
impl EventEmitterImpl with removeAllListeners(self) -> Unit {
  self.call0("removeAllListeners") |> @js.unsafe_cast
}

///|
impl EventEmitterImpl with emit(self, name : String, payload : @js.Js) -> Unit {
  self.call2("emit", name, payload) |> @js.unsafe_cast
}

///|
/// Concrete EventEmitter type for standalone use
#external
pub type EventEmitter

///|
pub impl @js.JsImpl for EventEmitter

///|
pub impl EventEmitterImpl for EventEmitter

///|
pub fn EventEmitter::new() -> EventEmitter {
  let ee = @node.require("events").get("EventEmitter")
  @js.unsafe_cast(@js.new_(ee, []))
}
