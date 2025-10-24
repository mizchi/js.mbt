///|
pub type Date

///|
pub extern "js" fn Date::now() -> Int =
  #| () => Date.now()

///|
pub extern "js" fn Date::new() -> Date =
  #| () => new Date()
