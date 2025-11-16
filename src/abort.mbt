///|
#external
pub type AbortController

///|
pub impl Js for AbortController

///|
pub extern "js" fn AbortController::new() -> AbortController =
  #| () => new AbortController()

///|
#external
pub type AbortSignal

///|
pub impl Js for AbortSignal

///|
pub fn AbortController::signal(self : Self) -> AbortSignal {
  self.get("signal") |> unsafe_cast
}
