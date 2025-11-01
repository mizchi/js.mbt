///|
using @js {type Val, trait Js, js}

///|
#external
pub type Date

///|
pub impl Js for Date with to_js(self) -> Val {
  self |> js
}

///|
pub extern "js" fn Date::now() -> Int =
  #| () => Date.now()

///|
pub extern "js" fn Date::new() -> Date =
  #| () => new Date()
