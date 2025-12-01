/// https://nodejs.org/api/events.html#emittereventnames

///|
extern "js" fn event_emitter_constructor() -> @nostd.Any =
  #| () => require("events").EventEmitter

///|
/// EventEmitter trait for Node.js event emitter pattern
// pub(open) trait EventEmitterImpl {
//   to_any(Self) -> @nostd.Any
//   on(Self, String, (@nostd.Any) -> Unit) -> Unit = _
//   on2(Self, String, (@nostd.Any?, @nostd.Any) -> Unit) -> Unit = _
//   once(Self, String, (@nostd.Any) -> Unit) -> Unit = _
//   eventNames(Self) -> Array[String] = _
//   listenerCount(Self, String) -> Int = _
//   listeners(Self, event? : String) -> Array[(@nostd.Any) -> Unit] = _
//   off(Self, String, (@nostd.Any) -> Unit) -> Unit = _
//   removeListener(Self, String, (@nostd.Any) -> Unit) -> Unit = _
//   removeAllListeners(Self) -> Unit = _
//   emit(Self, String, @nostd.Any) -> Unit = _
// }

///|
/// Implement EventEmitter trait for EventEmitterClass
pub fn EventEmitter::on(
  self : Self,
  name : String,
  callback : (@nostd.Any) -> Unit,
) -> Unit {
  self
  .to_any()
  ._call("on", [@nostd.any(name), @nostd.any(callback |> @js.from_fn1)])
  .cast()
}

///|
pub fn EventEmitter::on2(
  self : Self,
  name : String,
  callback : (@nostd.Any?, @nostd.Any) -> Unit,
) -> Unit {
  self
  .to_any()
  ._call("on", [@nostd.any(name), @nostd.any(callback |> @js.from_fn2)])
  .cast()
}

///|
pub fn EventEmitter::once(
  self : Self,
  name : String,
  callback : (@nostd.Any) -> Unit,
) -> Unit {
  self
  .to_any()
  ._call("once", [@nostd.any(name), @nostd.any(callback |> @js.from_fn1)])
  .cast()
}

///|
pub fn EventEmitter::eventNames(self : Self) -> Array[String] {
  self.to_any()._call("eventNames", []).cast()
}

///|
pub fn EventEmitter::listenerCount(self : Self, eventName : String) -> Int {
  self.to_any()._call("listenerCount", [@nostd.any(eventName)]).cast()
}

///|
pub fn EventEmitter::listeners(
  self : Self,
  event? : String,
) -> Array[(@nostd.Any) -> Unit] {
  match event {
    Some(name) =>
      self.to_any()._call("listenerCount", [@nostd.any(name)]).cast()
    None => self.to_any()._call("listenerCount", []).cast()
  }
}

///|
pub fn EventEmitter::off(
  self : Self,
  name : String,
  callback : (@nostd.Any) -> Unit,
) -> Unit {
  self
  .to_any()
  ._call("off", [@nostd.any(name), @nostd.any(callback |> @js.from_fn1)])
  .cast()
}

///|
pub fn EventEmitter::removeListener(
  self : Self,
  name : String,
  callback : (@nostd.Any) -> Unit,
) -> Unit {
  self
  .to_any()
  ._call("removeListener", [
    @nostd.any(name),
    @nostd.any(callback |> @js.from_fn1),
  ])
  .cast()
}

///|
/// implement remove_all_listeners
pub fn EventEmitter::removeAllListeners(self : Self) -> Unit {
  self.to_any()._call("removeAllListeners", []).cast()
}

///|
pub fn EventEmitter::emit(
  self : Self,
  name : String,
  payload : @nostd.Any,
) -> Unit {
  self.to_any()._call("emit", [@nostd.any(name), @nostd.any(payload)]).cast()
}

///|
/// Concrete EventEmitter type for standalone use
#external
pub type EventEmitter

///|
pub fn EventEmitter::as_any(self : EventEmitter) -> @nostd.Any = "%identity"

///|
pub fn EventEmitter::to_any(self : EventEmitter) -> @nostd.Any = "%identity"

///|
// impl EventEmitterImpl for EventEmitter with to_any(self) { self.to_any() }

///|
pub fn EventEmitter::new() -> EventEmitter {
  @nostd.new(event_emitter_constructor(), []).cast()
}
