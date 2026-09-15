///|
/// Node.js Timers API
/// https://nodejs.org/api/timers.html

///|
#external
pub type Immediate

///|
pub fn Immediate::as_any(self : Immediate) -> @core.Any = "%identity"

///|
/// JS: setImmediate(callback)
pub extern "js" fn setImmediate(callback : () -> Unit) -> Immediate =
  #| (callback) => setImmediate(callback)

///|
/// JS: clearImmediate(immediateId)
pub extern "js" fn clearImmediate(immediate : Immediate) -> Unit =
  #| (immediate) => clearImmediate(immediate)
