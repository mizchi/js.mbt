///|
#external
pub type Navigator

///|
pub impl Js for Navigator with to_js(self) {
  self |> js
}

///|
pub extern "js" fn navigator() -> Navigator =
  #| () => navigator

///|
pub extern "js" fn Navigator::user_agent(self : Self) -> String =
  #| (nav) => nav.userAgent

///|
pub extern "js" fn Navigator::on_line(self : Self) -> Bool =
  #| (nav) => nav.onLine
