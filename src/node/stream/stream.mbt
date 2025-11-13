///|
using @js {js, trait Js, type Val}

///|
using @events {type EventEmitter}

///|
#external
pub type Stream

///|
pub impl Js for Stream with to_js(self) {
  self |> js
}

///|
pub fn Stream::as_event_emitter(self : Self) -> EventEmitter {
  self.to_js().cast()
}
