///|
/// JavaScript Function
#external
pub type Function

///|
pub fn Function::to_any(self : Function) -> @nostd.Any = "%identity"

///|
/// JS: function.toString()
/// Returns a string representing the source code of the function
pub fn Function::to_string(self : Self) -> String {
  self.to_any()._call("toString", []) |> @nostd.identity
}

///|
/// JS: function.name
pub fn Function::name(self : Self) -> String {
  self.to_any()["name"] |> @nostd.identity
}

///|
/// JS: function.apply
pub extern "js" fn Function::apply(
  self : Self,
  caller : @nostd.Any,
  args : Array[@nostd.Any],
) -> @nostd.Any =
  #|(self, args) => self.apply(caller, args)

///|
/// JS: function.bind(caller)
pub extern "js" fn Function::bind(
  self : Self,
  caller : @nostd.Any,
) -> @nostd.Any =
  #|(self, caller) => self.bind(caller)

///|
/// JS: function.length
pub extern "js" fn Function::length(self : Self) -> @nostd.Any =
  #|(self) => self.length
