/// https://nodejs.org/api/events.html#emittereventnames

///|
extern "js" fn event_emitter_constructor() -> @js.Any =
  #| () => require("events").EventEmitter

///|
/// EventEmitter trait for Node.js event emitter pattern
pub(open) trait EventEmitterImpl: @js.JsImpl {
  on(Self, String, (@js.Any) -> Unit) -> Unit = _
  on2(Self, String, (@js.Any?, @js.Any) -> Unit) -> Unit = _
  once(Self, String, (@js.Any) -> Unit) -> Unit = _
  eventNames(Self) -> Array[String] = _
  listenerCount(Self, String) -> Int = _
  listeners(Self, event? : String) -> Array[(@js.Any) -> Unit] = _
  off(Self, String, (@js.Any) -> Unit) -> Unit = _
  removeListener(Self, String, (@js.Any) -> Unit) -> Unit = _
  removeAllListeners(Self) -> Unit = _
  emit(Self, String, @js.Any) -> Unit = _
}

///|
/// Implement EventEmitter trait for EventEmitterClass
impl EventEmitterImpl with on(self, name : String, callback : (@js.Any) -> Unit) -> Unit {
  self.call2("on", name, callback |> @js.from_fn1).cast()
}

///|
impl EventEmitterImpl with on2(
  self,
  name : String,
  callback : (@js.Any?, @js.Any) -> Unit,
) -> Unit {
  self.call2("on", name, callback |> @js.from_fn2).cast()
}

///|
impl EventEmitterImpl with once(
  self,
  name : String,
  callback : (@js.Any) -> Unit,
) -> Unit {
  self.call2("once", name, callback |> @js.from_fn1).cast()
}

///|
impl EventEmitterImpl with eventNames(self) {
  self.call0("eventNames").cast()
}

///|
impl EventEmitterImpl with listenerCount(self, eventName) {
  self.call("listenerCount", [eventName]).cast()
}

///|
impl EventEmitterImpl with listeners(self, event? : String) {
  match event {
    Some(name) => self.call("listenerCount", [name]).cast()
    None => self.call0("listenerCount").cast()
  }
}

///|
impl EventEmitterImpl with off(
  self,
  name : String,
  callback : (@js.Any) -> Unit,
) -> Unit {
  self.call2("off", name, callback |> @js.from_fn1).cast()
}

///|
impl EventEmitterImpl with removeListener(
  self,
  name : String,
  callback : (@js.Any) -> Unit,
) -> Unit {
  self.call2("removeListener", name, callback |> @js.from_fn1).cast()
}

///|
/// implement remove_all_listeners
impl EventEmitterImpl with removeAllListeners(self) -> Unit {
  self.call0("removeAllListeners").cast()
}

///|
impl EventEmitterImpl with emit(self, name : String, payload : @js.Any) -> Unit {
  self.call2("emit", name, payload).cast()
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
  @js.identity(@js.new_(event_emitter_constructor(), []))
}
