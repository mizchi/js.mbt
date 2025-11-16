///|
#external
pub type AbortController

///|
#external
pub type AbortSignal

///|
pub extern "js" fn AbortController::new() -> AbortController =
  #| () => new AbortController()

///|
pub impl Js for AbortController

///|
pub impl Js for AbortSignal

///|
pub fn AbortController::signal(self : Self) -> AbortSignal {
  unsafe_cast(self.get("signal"))
}
