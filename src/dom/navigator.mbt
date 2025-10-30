///|
#external
pub type Navigator
pub impl @js.ToJs for Navigator with to_js(self) -> @js.Value {
  self |> @js.to_js
}

///|
pub extern "js" fn navigator() -> Navigator =
  #| () => navigator

///|
pub extern "js" fn Navigator::user_agent(self : Navigator) -> String =
  #| (nav) => nav.userAgent

///|
pub extern "js" fn Navigator::on_line(self : Navigator) -> Bool =
  #| (nav) => nav.onLine
