/// https://nodejs.org/api/events.html#emittereventnames

///|
extern "js" fn event_emitter_constructor() -> @core.Any =
  #| () => require("events").EventEmitter

///|
/// EventEmitter trait for Node.js event emitter pattern
// pub(open) trait EventEmitterImpl {
//   to_any(Self) -> @core.Any
//   on(Self, String, (@core.Any) -> Unit) -> Unit = _
//   on2(Self, String, (@core.Any?, @core.Any) -> Unit) -> Unit = _
//   once(Self, String, (@core.Any) -> Unit) -> Unit = _
//   eventNames(Self) -> Array[String] = _
//   listenerCount(Self, String) -> Int = _
//   listeners(Self, event? : String) -> Array[(@core.Any) -> Unit] = _
//   off(Self, String, (@core.Any) -> Unit) -> Unit = _
//   removeListener(Self, String, (@core.Any) -> Unit) -> Unit = _
//   removeAllListeners(Self) -> Unit = _
//   emit(Self, String, @core.Any) -> Unit = _
// }

///|
/// Implement EventEmitter trait for EventEmitterClass
pub fn EventEmitter::on(
  self : Self,
  name : String,
  callback : (@core.Any) -> Unit,
) -> Unit {
  self
  .to_any()
  ._call("on", [@core.any(name), @core.any(callback |> @js.from_fn1)])
  .cast()
}

///|
pub fn EventEmitter::on2(
  self : Self,
  name : String,
  callback : (@core.Any?, @core.Any) -> Unit,
) -> Unit {
  self
  .to_any()
  ._call("on", [@core.any(name), @core.any(callback |> @js.from_fn2)])
  .cast()
}

///|
pub fn EventEmitter::once(
  self : Self,
  name : String,
  callback : (@core.Any) -> Unit,
) -> Unit {
  self
  .to_any()
  ._call("once", [@core.any(name), @core.any(callback |> @js.from_fn1)])
  .cast()
}

///|
pub fn EventEmitter::eventNames(self : Self) -> Array[String] {
  self.to_any()._call("eventNames", []).cast()
}

///|
pub fn EventEmitter::listenerCount(self : Self, eventName : String) -> Int {
  self.to_any()._call("listenerCount", [@core.any(eventName)]).cast()
}

///|
pub fn EventEmitter::listeners(
  self : Self,
  event? : String,
) -> Array[(@core.Any) -> Unit] {
  match event {
    Some(name) => self.to_any()._call("listenerCount", [@core.any(name)]).cast()
    None => self.to_any()._call("listenerCount", []).cast()
  }
}

///|
pub fn EventEmitter::off(
  self : Self,
  name : String,
  callback : (@core.Any) -> Unit,
) -> Unit {
  self
  .to_any()
  ._call("off", [@core.any(name), @core.any(callback |> @js.from_fn1)])
  .cast()
}

///|
pub fn EventEmitter::removeListener(
  self : Self,
  name : String,
  callback : (@core.Any) -> Unit,
) -> Unit {
  self
  .to_any()
  ._call("removeListener", [
    @core.any(name),
    @core.any(callback |> @js.from_fn1),
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
  payload : @core.Any,
) -> Unit {
  self.to_any()._call("emit", [@core.any(name), @core.any(payload)]).cast()
}

///|
/// Concrete EventEmitter type for standalone use
#external
pub type EventEmitter

///|
pub fn EventEmitter::as_any(self : EventEmitter) -> @core.Any = "%identity"

///|
pub fn EventEmitter::to_any(self : EventEmitter) -> @core.Any = "%identity"

///|
// impl EventEmitterImpl for EventEmitter with to_any(self) { self.to_any() }

///|
pub fn EventEmitter::new() -> EventEmitter {
  @core.new(event_emitter_constructor(), []).cast()
}
