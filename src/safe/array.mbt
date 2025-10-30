#external
pub type SafeArray[T]

pub impl[T] ToJs for SafeArray[T] with to_js(self) -> Value {
  self |> @js.to_js
}

pub fn[T] SafeArray::new() -> SafeArray[T] {
  @js.new_array() |> identity
}

pub fn[T] SafeArray::push(self : SafeArray[T], v : T) -> Unit {
  self.to_js().get("push").safe_call([v |> to_js]) |> ignore
}

pub fn[T] SafeArray::unshift(self : SafeArray[T], v : T) -> Unit {
  self.to_js().get("unshift").safe_call([v |> to_js]) |> ignore
}