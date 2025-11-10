///|
pub extern "js" fn get_computed_style(el : Element) -> Val =
  #| (el) => window.getComputedStyle(el)
