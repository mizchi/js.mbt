///|
pub(open) trait Js {
  to_js(Self) -> Val
}

///|
pub impl Js for Val with to_js(self) -> Val {
  self
}

///|
pub impl Js for String with to_js(self) -> Val {
  js(self)
}

///|
pub impl Js for Double with to_js(self) -> Val {
  js(self)
}

///|
pub impl Js for Float with to_js(self) -> Val {
  js(self.to_double())
}

///|
pub impl Js for Int with to_js(self) -> Val {
  js(self)
}

///|
pub impl Js for Bool with to_js(self) -> Val {
  js(self)
}

pub impl Js for Array[&Js] with to_js(self) -> Val {
  js(self.map(_.to_js()))
}

