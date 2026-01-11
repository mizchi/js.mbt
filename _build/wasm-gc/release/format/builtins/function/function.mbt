///|
/// JavaScript Function
#external
pub type Function

///|
pub fn Function::to_any(self : Function) -> @core.Any = "%identity"

///|
/// JS: function.toString()
/// Returns a string representing the source code of the function
pub fn Function::to_string(self : Self) -> String {
  self.to_any()._call("toString", []) |> @core.identity
}

///|
/// JS: function.name
pub fn Function::name(self : Self) -> String {
  self.to_any()["name"] |> @core.identity
}

///|
/// JS: function.apply
pub extern "js" fn Function::apply(
  self : Self,
  caller : @core.Any,
  args : Array[@core.Any],
) -> @core.Any =
  #|(self, args) => self.apply(caller, args)

///|
/// JS: function.bind(caller)
pub extern "js" fn Function::bind(self : Self, caller : @core.Any) -> @core.Any =
  #|(self, caller) => self.bind(caller)

///|
/// JS: function.length
pub extern "js" fn Function::length(self : Self) -> @core.Any =
  #|(self) => self.length
