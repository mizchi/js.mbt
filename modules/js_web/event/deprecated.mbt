// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `Event(..)` constructor.
#deprecated("use `Event(..)` instead")
pub fn Event::new(
  event_type : String,
  bubbles? : Bool,
  cancelable? : Bool,
) -> Event {
  Event(event_type, bubbles?, cancelable?)
}

///|
/// Deprecated alias for the `EventSource(..)` constructor.
#deprecated("use `EventSource(..)` instead")
pub fn EventSource::new(url : String, withCredentials? : Bool) -> EventSource {
  EventSource(url, withCredentials?)
}
