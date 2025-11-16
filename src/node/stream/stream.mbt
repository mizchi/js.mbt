///|
using @js {js, trait Js, type Val, unsafe_cast}

///|
using @events {trait EventEmitterImpl}

///|
#external
pub type Stream

///|
pub impl Js for Stream

///|
/// Implement EventEmitter trait for Stream
pub impl EventEmitterImpl for Stream
