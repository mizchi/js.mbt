///|
pub extern "js" fn is_object(v : Any) -> Bool =
  #| (v) => typeof v === "object" && v !== null
