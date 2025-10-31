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
  js(self.to_double())
}

///|
pub impl Js for Bool with to_js(self) -> Val {
  js(self)
}

///|
pub impl Js for Map[String, &Js] with to_js(self) -> Val {
  let obj = new_object()
  for k, v in self {
    obj.set(k, v.to_js())
  }
  obj
}

///|
pub impl Js for Array[&Js] with to_js(self) -> Val {
  let arr = new_array()
  for v in self {
    arr.call_method("push", [Js::to_js(v)]) |> ignore
  }
  arr
}
