///|
#external
pub type Navigator

///|
pub extern "js" fn navigator() -> Navigator =
  #| () => navigator

///|
pub extern "js" fn Navigator::user_agent(self : Navigator) -> String =
  #| (nav) => nav.userAgent

///|
pub extern "js" fn Navigator::on_line(self : Navigator) -> Bool =
  #| (nav) => nav.onLine
