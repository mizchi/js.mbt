///|
#external
pub type Env

///|
pub impl Js for Env

///|
pub fn Env::get(self : Self, key : String) -> String? {
  self.to_js().get(key) |> to_option
}

///|
pub fn Env::set(self : Self, key : String, value : String) -> Unit {
  self.to_js().set(key, value) |> ignore
}
