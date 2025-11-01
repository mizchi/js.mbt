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
pub impl Js for AbortController with to_js(self) -> Val {
  self |> js
}

///|
pub impl Js for AbortSignal with to_js(self) -> Val {
  self |> js
}

///|
pub fn AbortController::signal(self : Self) -> AbortSignal {
  self.to_js().get("signal").cast()
}
