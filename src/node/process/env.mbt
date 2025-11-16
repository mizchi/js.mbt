///|
#external
pub type Env

///|
pub impl Js for Env

///|
pub fn Env::get_(self : Self, key : String) -> String? {
  self.get(key) |> to_option
}

///|
pub fn Env::set_(self : Self, key : String, value : String) -> Unit {
  self.set(key, value) |> ignore
}
